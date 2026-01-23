import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:app/providers/provider_models/offer_model.dart';

/// Button to make an offer on a listing
class MakeOfferButton extends StatelessWidget {
  final double currentPrice;
  final int minimumPercent;
  final bool acceptsOffers;
  final VoidCallback onPressed;

  const MakeOfferButton({
    super.key,
    required this.currentPrice,
    this.minimumPercent = 70,
    this.acceptsOffers = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!acceptsOffers) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.local_offer_rounded, size: 18),
      label: const Text('Make Offer'),
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }
}

/// Dialog for making an offer
class MakeOfferDialog extends StatefulWidget {
  final String itemTitle;
  final double currentPrice;
  final int minimumPercent;
  final Function(double amount, String? message) onSubmit;

  const MakeOfferDialog({
    super.key,
    required this.itemTitle,
    required this.currentPrice,
    this.minimumPercent = 70,
    required this.onSubmit,
  });

  @override
  State<MakeOfferDialog> createState() => _MakeOfferDialogState();
}

class _MakeOfferDialogState extends State<MakeOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  double _offerAmount = 0;

  double get _minimumAmount => widget.currentPrice * widget.minimumPercent / 100;
  double get _discountPercent =>
      _offerAmount > 0 ? ((widget.currentPrice - _offerAmount) / widget.currentPrice * 100) : 0;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    setState(() {
      _offerAmount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatter = NumberFormat('#,###');

    return AlertDialog(
      title: const Text('Make an Offer'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.itemTitle,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Asking price: ${formatter.format(widget.currentPrice)} UZS',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Your offer (UZS)',
                  hintText: 'Enter amount',
                  prefixIcon: const Icon(Icons.attach_money),
                  helperText: 'Minimum: ${formatter.format(_minimumAmount)} UZS',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value) ?? 0;
                  if (amount < _minimumAmount) {
                    return 'Minimum offer is ${widget.minimumPercent}% of asking price';
                  }
                  if (amount >= widget.currentPrice) {
                    return 'Offer should be less than asking price';
                  }
                  return null;
                },
              ),
              if (_offerAmount > 0 && _offerAmount < widget.currentPrice) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.savings, size: 16, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'You save ${_discountPercent.toStringAsFixed(1)}% (${formatter.format(widget.currentPrice - _offerAmount)} UZS)',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message (optional)',
                  hintText: 'Add a note to the seller',
                  prefixIcon: Icon(Icons.message_outlined),
                ),
                maxLines: 2,
                maxLength: 200,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                _offerAmount,
                _messageController.text.isNotEmpty ? _messageController.text : null,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Send Offer'),
        ),
      ],
    );
  }
}

/// Card displaying an offer
class OfferCard extends StatelessWidget {
  final Offer offer;
  final bool isOwner; // Is current user the seller?
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final Function(double amount, String? message)? onCounter;
  final VoidCallback? onAcceptCounter;
  final VoidCallback? onCancel;
  final VoidCallback? onTap;

  const OfferCard({
    super.key,
    required this.offer,
    this.isOwner = false,
    this.onAccept,
    this.onDecline,
    this.onCounter,
    this.onAcceptCounter,
    this.onCancel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatter = NumberFormat('#,###');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with item info
              Row(
                children: [
                  if (offer.itemImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        offer.itemImage!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.itemTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isOwner
                              ? 'From: ${offer.buyerName}'
                              : 'To: ${offer.sellerName}',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OfferStatusBadge(status: offer.status),
                ],
              ),
              const SizedBox(height: 16),
              // Price info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Offer',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${formatter.format(offer.offerAmount)} UZS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (offer.counterAmount != null) ...[
                    const Icon(Icons.arrow_forward, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Counter',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${formatter.format(offer.counterAmount)} UZS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Original',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${formatter.format(offer.originalPrice)} UZS',
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Message
              if (offer.message != null && offer.message!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.format_quote,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          offer.message!,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Counter message
              if (offer.counterMessage != null && offer.counterMessage!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.reply,
                        size: 16,
                        color: colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          offer.counterMessage!,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Action buttons
              if (offer.status.isActive) ...[
                const SizedBox(height: 16),
                _buildActionButtons(context),
              ],
              // Expiration info
              if (offer.status == OfferStatus.pending || offer.status == OfferStatus.countered) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Expires in ${_formatDuration(offer.timeRemaining)}',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isOwner && offer.status == OfferStatus.pending) {
      // Seller actions
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onDecline,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
              ),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showCounterDialog(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.tertiary,
                side: BorderSide(color: colorScheme.tertiary),
              ),
              child: const Text('Counter'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(
              onPressed: onAccept,
              child: const Text('Accept'),
            ),
          ),
        ],
      );
    } else if (!isOwner && offer.status == OfferStatus.countered) {
      // Buyer actions for counter offer
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(
              onPressed: onAcceptCounter,
              child: const Text('Accept Counter'),
            ),
          ),
        ],
      );
    } else if (!isOwner && offer.status == OfferStatus.pending) {
      // Buyer can cancel pending offer
      return OutlinedButton(
        onPressed: onCancel,
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,
        ),
        child: const Text('Cancel Offer'),
      );
    }

    return const SizedBox.shrink();
  }

  void _showCounterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CounterOfferDialog(
        originalOffer: offer.offerAmount,
        askingPrice: offer.originalPrice,
        onSubmit: (amount, message) {
          onCounter?.call(amount, message);
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return 'Expired';
    if (duration.inHours >= 24) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    }
    if (duration.inHours >= 1) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }
}

/// Status badge for offers
class OfferStatusBadge extends StatelessWidget {
  final OfferStatus status;

  const OfferStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color(status.colorCode).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: Color(status.colorCode),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Dialog for counter offer
class CounterOfferDialog extends StatefulWidget {
  final double originalOffer;
  final double askingPrice;
  final Function(double amount, String? message) onSubmit;

  const CounterOfferDialog({
    super.key,
    required this.originalOffer,
    required this.askingPrice,
    required this.onSubmit,
  });

  @override
  State<CounterOfferDialog> createState() => _CounterOfferDialogState();
}

class _CounterOfferDialogState extends State<CounterOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return AlertDialog(
      title: const Text('Counter Offer'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buyer offered: ${formatter.format(widget.originalOffer)} UZS'),
              Text('Asking price: ${formatter.format(widget.askingPrice)} UZS'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Your counter offer (UZS)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value) ?? 0;
                  if (amount <= widget.originalOffer) {
                    return 'Counter should be higher than the offer';
                  }
                  if (amount > widget.askingPrice) {
                    return 'Counter cannot exceed asking price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message (optional)',
                  prefixIcon: Icon(Icons.message_outlined),
                ),
                maxLines: 2,
                maxLength: 200,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final amount = double.tryParse(_amountController.text) ?? 0;
              widget.onSubmit(
                amount,
                _messageController.text.isNotEmpty ? _messageController.text : null,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Send Counter'),
        ),
      ],
    );
  }
}
