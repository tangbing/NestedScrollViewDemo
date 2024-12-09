import 'package:first_project/app_color.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Widget gmImage(
  String? url, {
  String? localPath,
  double? width,
  double? height,
  BoxFit? fit = BoxFit.contain,
  BorderRadius? borderRadius,
}) {
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(0), // 设置圆角
    child: url == null || url.isEmpty
        ? (localPath == null
            ? SizedBox.shrink()
            : Image.asset(
                localPath!,
                width: width,
                height: height,
                fit: fit,
              ))
        : CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) => Container(
              color: GlobalColor.colorF6,
            ),
            errorWidget: (context, url, error) => localPath == null
                ? SizedBox.shrink()
                : Image.asset(
                    localPath!,
                    width: width,
                    height: height,
                    fit: fit,
                  ),
          ),
  );
}
