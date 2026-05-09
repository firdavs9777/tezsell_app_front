import 'dart:io';

import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:flutter/material.dart';

class ProductEditImageGrid extends StatelessWidget {
  const ProductEditImageGrid.network({
    super.key,
    required List<String> urls,
    required this.onRemove,
  })  : _urls = urls,
        _files = null;

  const ProductEditImageGrid.files({
    super.key,
    required List<File> files,
    required this.onRemove,
  })  : _urls = null,
        _files = files;

  final List<String>? _urls;
  final List<File>? _files;
  final ValueChanged<int> onRemove;

  int get _itemCount => _urls?.length ?? _files!.length;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _urls != null
                  ? CachedNetworkImageWidget(
                      imageUrl: _urls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    )
                  : Image.file(
                      _files![index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close,
                      color: Colors.white, size: 16),
                  onPressed: () => onRemove(index),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
