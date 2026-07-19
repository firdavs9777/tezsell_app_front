import 'dart:async';
import 'dart:io';

import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';

/// Telegram-style voice mic button with hold-to-record, slide-left-to-cancel,
/// drag-up-to-lock, and a live waveform sampled from the `record` package's
/// amplitude stream.
///
/// Task 17: extracted out of `chat_room.dart`'s private `_VoiceMicButton` so
/// it can grow the amplitude-driven waveform without further bloating the
/// screen file. Behavior (hold/lock/cancel/discard-under-1s) is unchanged
/// from the original Task 9 implementation; only the waveform capture and
/// the localized hint text are new.
///
/// Uses a [GlobalKey] at the call site (see `chat_room.dart`) so the SAME
/// widget/state instance survives being moved between the compact
/// mic-in-input-row location and the full-width recording-bar location —
/// those two spots are mutually exclusive (`_isRecording` gates which one is
/// in the tree), so Flutter's global-key reparenting carries the in-flight
/// recorder/timers/waveform state across that layout swap seamlessly.
class VoiceMicButton extends StatefulWidget {
  /// [waveform] is up to the last 100 amplitude samples (ints 0..100),
  /// sampled roughly every 80ms over the whole recording.
  final void Function(File audioFile, int duration, List<int> waveform)
  onRecordingComplete;
  final VoidCallback? onRecordingStarted;
  final VoidCallback? onRecordingCancelled;

  const VoiceMicButton({
    super.key,
    required this.onRecordingComplete,
    this.onRecordingStarted,
    this.onRecordingCancelled,
  });

  @override
  State<VoiceMicButton> createState() => VoiceMicButtonState();
}

class VoiceMicButtonState extends State<VoiceMicButton>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _isLocked = false;
  String? _recordingPath;
  Timer? _durationTimer;
  int _recordingDuration = 0;

  // Gesture tracking
  double _dragOffsetX = 0;
  double _dragOffsetY = 0;
  static const double _cancelThreshold = -80;
  static const double _lockThreshold = -60;

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // 🔥 NEW: Task 17 — live waveform from the amplitude stream. Sampled
  // ~80ms, capped to the last 100 samples for the upload payload; the UI
  // only renders a recent window of these for the live bars.
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  final List<int> _waveformSamples = [];
  static const int _maxWaveformSamples = 100;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _amplitudeSubscription?.cancel();
    _pulseController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;

    final hasPerm = await _audioRecorder.hasPermission();
    if (!hasPerm) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l?.microphone_permission_denied ?? 'Microphone permission denied'),
          ),
        );
      }
      return;
    }

    HapticFeedback.mediumImpact();

    _recordingPath =
        '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _audioRecorder.start(const RecordConfig(), path: _recordingPath!);

    setState(() {
      _isRecording = true;
      _isLocked = false;
      _recordingDuration = 0;
      _dragOffsetX = 0;
      _dragOffsetY = 0;
      _waveformSamples.clear();
    });

    widget.onRecordingStarted?.call();
    _pulseController.repeat(reverse: true);

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isRecording) {
        setState(() => _recordingDuration++);
      }
    });

    // 🔥 NEW: Task 17 — live amplitude capture. `record` 6.x reports dB,
    // roughly -160 (silence) to 0 (max) on most platforms; a typical voice
    // recording rarely reaches above -10dB, so normalize against a
    // practical -45..0 range to keep the bars visibly reactive to speech
    // rather than pinned near zero.
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 80))
        .listen((amp) {
          if (!mounted) return;
          final normalized = ((amp.current + 45) / 45).clamp(0.0, 1.0);
          final sample = (normalized * 100).round();
          setState(() {
            _waveformSamples.add(sample);
            if (_waveformSamples.length > _maxWaveformSamples) {
              _waveformSamples.removeAt(0);
            }
          });
        });
  }

  Future<void> _stopRecording({bool send = true}) async {
    if (!_isRecording) return;

    _durationTimer?.cancel();
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    _pulseController.stop();
    _pulseController.reset();

    final path = await _audioRecorder.stop();
    final duration = _recordingDuration;
    final waveform = List<int>.from(_waveformSamples);

    // Discard silently: cancelled explicitly, or too short to be a real
    // message (accidental tap/hold under 1s).
    final wasCancelled = !send || duration < 1;

    setState(() {
      _isRecording = false;
      _isLocked = false;
      _dragOffsetX = 0;
      _dragOffsetY = 0;
    });

    if (!wasCancelled && path != null) {
      HapticFeedback.lightImpact();
      widget.onRecordingComplete(File(path), duration, waveform);
    } else {
      if (path != null) {
        try {
          await File(path).delete();
        } catch (_) {}
      }
      widget.onRecordingCancelled?.call();
    }
  }

  void _cancelRecording() {
    HapticFeedback.heavyImpact();
    _stopRecording(send: false);
  }

  void _lockRecording() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isLocked = true;
      _dragOffsetY = 0;
    });
  }

  /// Returns the most recent [count] waveform samples (0..100), zero-padded
  /// on the left when fewer than [count] have been captured yet, so the live
  /// bar row has a stable width from the very first frame of recording.
  List<int> _recentSamples(int count) {
    if (_waveformSamples.length >= count) {
      return _waveformSamples.sublist(_waveformSamples.length - count);
    }
    return [
      ...List.filled(count - _waveformSamples.length, 0),
      ..._waveformSamples,
    ];
  }

  Widget _buildLiveWaveform({
    required int count,
    double barWidth = 2.5,
    double maxHeight = 20,
    required Color color,
  }) {
    final samples = _recentSamples(count);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: samples.map((sample) {
        final height = 4.0 + (sample / 100) * (maxHeight - 4.0);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: barWidth,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: barWidth * 0.4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(barWidth * 0.6),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRecording) {
      return _buildMicButton();
    } else if (_isLocked) {
      return _buildLockedUI();
    } else {
      return _buildRecordingUI();
    }
  }

  Widget _buildMicButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        await _startRecording();
        if (mounted && _isRecording) _lockRecording();
      },
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) {
        if (!_isLocked && _isRecording) {
          _stopRecording(send: true);
        }
      },
      onLongPressMoveUpdate: (details) {
        if (!_isRecording) return;

        setState(() {
          _dragOffsetX = details.offsetFromOrigin.dx;
          _dragOffsetY = details.offsetFromOrigin.dy;
        });

        if (_dragOffsetX < _cancelThreshold) {
          _cancelRecording();
        } else if (_dragOffsetY < _lockThreshold && !_isLocked) {
          _lockRecording();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Icon(
          Icons.mic,
          color: colorScheme.onSurfaceVariant,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildRecordingUI() {
    final l = AppLocalizations.of(context);
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 4),
          // Pulsing red dot
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          // Timer
          Text(
            _formatDuration(_recordingDuration),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(width: 8),
          // 🔥 NEW: Task 17 — live waveform from the amplitude stream.
          _buildLiveWaveform(
            count: 14,
            barWidth: 2.5,
            maxHeight: 22,
            color: Theme.of(context).colorScheme.error.withOpacity(0.7),
          ),
          const Spacer(),
          // Slide to cancel — moves left with drag
          Transform.translate(
            offset: Offset(_dragOffsetX.clamp(-50.0, 0.0) * 0.5, 0),
            child: Opacity(
              opacity: _dragOffsetX < -20
                  ? (1.0 - ((-_dragOffsetX - 20) / 60)).clamp(0.2, 1.0)
                  : 1.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  Text(
                    l?.chatRecordingHint ?? 'Release to send, slide to cancel',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Lock indicator (appears when dragging up)
          if (_dragOffsetY < -20)
            Icon(
              Icons.lock_outline,
              color: _dragOffsetY < _lockThreshold
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              size: 18,
            ),
          const SizedBox(width: 4),
          // Animated mic button (moves with finger)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  _dragOffsetX.clamp(-40, 0),
                  _dragOffsetY.clamp(-40, 0),
                ),
                child: Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mic,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 22,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLockedUI() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Cancel button
          IconButton(
            onPressed: _cancelRecording,
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          // Recording indicator
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 6),
          // Timer
          Text(
            _formatDuration(_recordingDuration),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          // 🔥 NEW: Task 17 — live waveform (was a fake deterministic
          // pattern; now driven by the amplitude stream).
          _buildLiveWaveform(
            count: 12,
            barWidth: 2.5,
            maxHeight: 26,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          // Send button
          GestureDetector(
            onTap: () => _stopRecording(send: true),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
