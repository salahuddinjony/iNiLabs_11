import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Custom avatar widget with caching
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  
  const UserAvatar({
    super.key,
    this.imageUrl,
    this.size = 40,
  });
  
  @override
  Widget build(BuildContext context) {
    // Debug print
    debugPrint('UserAvatar: Loading image from: $imageUrl');
    
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallbackAvatar(context);
    }
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: SizedBox(
              width: size * 0.5,
              height: size * 0.5,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            debugPrint('Error loading avatar: $error for URL: $url');
            return _buildFallbackAvatar(context);
          },
        ),
      ),
    );
  }
  
  Widget _buildFallbackAvatar(BuildContext context) {
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
}
