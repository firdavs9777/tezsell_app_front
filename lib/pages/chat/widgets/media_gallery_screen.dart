import 'dart:async';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/pages/chat/widgets/voice_bubble.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔥 NEW: Task 18 — shared media gallery for the currently-open chat room
/// (reached via the room's app-bar overflow menu). Images/Voice tabs, built
/// from whatever messages are already loaded in [chatProvider] for this room
/// — v1 pagination is simply "whatever's loaded" (matches the in-room
/// search's own loaded-only navigation), no separate fetch.
class MediaGalleryScreen extends ConsumerStatefulWidget {
  const MediaGalleryScreen({super.key});

  @override
  ConsumerState<MediaGalleryScreen> createState() =>
      _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends ConsumerState<MediaGalleryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingId;
  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription<PlayerState>? _stateSub;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _stateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _playerState = state;
        if (state == PlayerState.stopped || state == PlayerState.completed) {
          _playingId = null;
        }
      });
    });
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleVoice(ChatMessage message) async {
    if (message.fileUrl == null || message.id == null) return;

    final isSame = _playingId == message.id;
    if (isSame && _playerState == PlayerState.playing) {
      await _audioPlayer.pause();
      return;
    }
    if (isSame && _playerState == PlayerState.paused) {
      await _audioPlayer.resume();
      return;
    }
    if (_playingId != null) {
      await _audioPlayer.stop();
    }
    if (mounted) setState(() => _playingId = message.id);
    await _audioPlayer.play(UrlSource(message.fileUrl!));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final messages = ref.watch(chatProvider).messages;

    final images = messages
        .where((m) => m.messageType == MessageType.image && !m.isDeleted)
        .toList()
        .reversed
        .toList();
    final voices = messages
        .where((m) => m.messageType == MessageType.voice && !m.isDeleted)
        .toList()
        .reversed
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.chatMediaGallery),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l.images),
            Tab(text: l.voice),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          images.isEmpty
              ? _EmptyState(icon: Icons.image_outlined, theme: theme)
              : GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final message = images[index];
                    final imageUrl = message.fileUrl ?? message.file;
                    if (imageUrl == null || imageUrl.isEmpty) {
                      return Container(color: theme.colorScheme.surfaceContainerHighest);
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageViewer(imageUrl: imageUrl),
                          ),
                        );
                      },
                      child: CachedNetworkImageWidget(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
          voices.isEmpty
              ? _EmptyState(icon: Icons.mic_none, theme: theme)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: voices.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final message = voices[index];
                    final isPlaying = _playingId == message.id &&
                        _playerState == PlayerState.playing;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: VoiceBubble(
                        message: message,
                        isOwnMessage: false,
                        isPlaying: isPlaying,
                        onTap: () => _toggleVoice(message),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final ThemeData theme;

  const _EmptyState({required this.icon, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        icon,
        size: 48,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
