import 'package:flutter/material.dart';

/// Simple network image widget with fallback
class NetworkImageAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  
  const NetworkImageAvatar({
    super.key,
    this.imageUrl,
    this.size = 40,
  });
  
  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.person,
          size: size * 0.6,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      );
    }
    
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundImage: NetworkImage(imageUrl!),
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint('Error loading image: $exception');
      },
      child: null,
    );
  }
}
