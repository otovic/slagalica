import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  CircularImage({super.key, this.image, this.size = 90});
  final String? image;
  double? size = 90;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueAccent.shade700,
          width: 2,
        ),
        shape: BoxShape.circle,
        image: image != null && image!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(image!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('images/user.png'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
