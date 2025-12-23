import 'package:app/providers/provider_models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class ServiceDetailsSection extends StatefulWidget {
  const ServiceDetailsSection({
    super.key,
    required this.service,
    this.onChatPressed,
  });

  final Services service;
  final VoidCallback? onChatPressed;

  @override
  State<ServiceDetailsSection> createState() => _ServiceDetailsSectionState();
}

class _ServiceDetailsSectionState extends State<ServiceDetailsSection> {
  String _maskedLocation(String region, String district) {
    // Show only first part safely, e.g. "Seoul, ****"
    return '$region, ****';
  }


  String getCategoryName() {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'uz':
        return widget.service.category?.nameUz ?? '';
      case 'ru':
        return widget.service.category?.nameRu ?? '';
      case 'en':
      default:
        return widget.service.category?.nameEn ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.category_rounded,
                  size: 16,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  getCategoryName().isNotEmpty
                      ? getCategoryName()
                      : (localizations?.newProductCategory ?? 'No Category'),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Service Title
          Text(
            widget.service.name!,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),

          // Service Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.description_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localizations?.newProductDescription ?? 'Description',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.service.description!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface.withOpacity(0.8),
                    height: 1.6,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Service Provider Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Provider',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Avatar with border
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Provider Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username
                          Text(
                            widget.service.userName.username ?? 'Service Provider',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Location with icon
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _maskedLocation(
                                    widget.service.userName.location.region,
                                    widget.service.userName.location.district,
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Chat Button
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: widget.onChatPressed ??
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Opening chat...'),
                                    backgroundColor: colorScheme.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: colorScheme.onPrimaryContainer,
                            size: 24,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
