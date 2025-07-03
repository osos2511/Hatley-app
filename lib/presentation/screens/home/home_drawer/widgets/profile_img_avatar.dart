import 'package:flutter/material.dart';

class ProfileImgAvatar extends StatelessWidget {
  final String imageUrl;
  final double size; // تحكم في الحجم هنا

  const ProfileImgAvatar({super.key, required this.imageUrl, this.size = 120});

  // دالة تصحيح الرابط لو كانت ناقصة شرطة
  String get fixedImageUrl {
    if (imageUrl.startsWith('https:/') && !imageUrl.startsWith('https://')) {
      return imageUrl.replaceFirst('https:/', 'https://');
    }
    if (imageUrl.startsWith('http:/') && !imageUrl.startsWith('http://')) {
      return imageUrl.replaceFirst('http:/', 'http://');
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage =
        fixedImageUrl.startsWith('http://') ||
        fixedImageUrl.startsWith('https://');

    return Stack(
      children: [
        ClipOval(
          child: SizedBox(
            width: size,
            height: size,
            child:
                isNetworkImage
                    ? Image.network(
                      fixedImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Image.asset(
                            'assets/person.png',
                            fit: BoxFit.cover,
                          ),
                    )
                    : Image.asset(imageUrl, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change Profile Picture')),
              );
            },
            child: CircleAvatar(
              radius: size * 0.17, // حجم زر الكاميرا نسبة للـ avatar
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
