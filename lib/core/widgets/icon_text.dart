import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconText extends StatelessWidget {
  const IconText({
    super.key,
    this.icon,
    this.iconSvg,
    required this.iconColor,
    required this.title,
    this.iconSize,
  });

  final IconData? icon;
  final String? iconSvg;
  final Color iconColor;
  final String title;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon == null
            ? SvgPicture.asset(
                iconSvg!,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                width: iconSize,
                height: iconSize,
              )
            : Icon(
                icon,
                color: iconColor,
                size: iconSize ?? 32.sp,
              ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 22.sp,
                color: iconColor,
              ),
        ),
      ],
    );
  }
}
