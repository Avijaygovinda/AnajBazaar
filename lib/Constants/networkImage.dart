import 'package:anaj_bazar/Constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(
      {Key? key,
      this.borderRadius,
      required this.image,
      this.height,
      this.width,
      this.fit,
      this.alignment,
      this.color})
      : super(key: key);
  final BorderRadius? borderRadius;
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
          ),
        ),
      ),
      // placeholder: (context, url) =>
      //     const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        width: width,
        child: const Icon(Icons.error),
        decoration: BoxDecoration(border: Border.all(color: tButtonColor)),
      ),
    );
  }
}
