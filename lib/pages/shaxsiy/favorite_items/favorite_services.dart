import 'package:app/constants/constants.dart';
import 'package:app/pages/service/details/service_detail.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteServices extends ConsumerStatefulWidget {
  final List<Services> services;

  const FavoriteServices({super.key, required this.services});

  @override
  ConsumerState<FavoriteServices> createState() => _FavoriteServicesState();
}

class _FavoriteServicesState extends ConsumerState<FavoriteServices> {
  late List<Services> _services;

  @override
  void initState() {
    super.initState();
    _services = List.from(widget.services);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(localizations?.favoriteServicesTitle ?? 'Favorite Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _services.length,
          itemBuilder: (context, index) {
            final service = _services[index];
            // final formattedPrice =
            //     NumberFormat('#,##0', 'en_US').format(int.parse(service.price));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  // Navigate to ProductDetail page

                  final Services singleService = await ref
                      .watch(serviceMainProvider)
                      .getSingleService(serviceId: service.id.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ServiceDetail(service: singleService),
                    ),
                  ).then((_) => ref.refresh(servicesProvider));
                },
                child: Container(
                  key: ValueKey(service.id),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 4,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: service.images.isNotEmpty
                            ? Image.network(
                                '${baseUrl}/services${service.images[0].image}',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/logo/logo_no_background.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 12.0),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              service.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14.0,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  '${service.location.region}, ${service.location.district.substring(0, 7)}...',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.comment,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${service.comments.length} ',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                // Add a placeholder for likes or ratings if available
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_outline_outlined,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      service.likeCount
                                          .toString(), // Replace with actual data
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // Price and Actions
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
