import 'dart:io';

import 'package:flutter/material.dart';

class ServiceEditImageList extends StatelessWidget {
  const ServiceEditImageList.network({
    super.key,
    required List<String> urls,
    required this.onRemoveAt,
  })  : _urls = urls,
        _files = null;

  const ServiceEditImageList.files({
    super.key,
    required List<File> files,
    required this.onRemoveAt,
  })  : _urls = null,
        _files = files;

  final List<String>? _urls;
  final List<File>? _files;
  final ValueChanged<int> onRemoveAt;

  int get _length => _urls?.length ?? _files!.length;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _urls != null
                      ? Image.network(
                          _urls[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.error),
                            );
                          },
                        )
                      : Image.file(
                          _files![index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onRemoveAt(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: colorScheme.onError,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ServiceEditEmptyImageState extends StatelessWidget {
  const ServiceEditEmptyImageState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            color: colorScheme.onSurface.withOpacity(0.5),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
