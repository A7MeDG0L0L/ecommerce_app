import 'package:ecommerce/config/theme/app_color.dart';
import 'package:ecommerce/core/helpers/string_helper.dart';
import 'package:ecommerce/core/widgets/icon_text.dart';
import 'package:ecommerce/core/widgets/read_more_text_widget.dart';
import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemInfoDetails extends StatelessWidget {
  const ItemInfoDetails({
    super.key,
    required this.productItem,
  });
  final Product productItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Directionality(
            textDirection: StringHelper.textDirection(
              text: productItem.title ,
              isDeviceArabic: false,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    productItem.title,
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          ReadMoreText(
            text: productItem.description ?? '',
            textStyle: Theme.of(context).textTheme.bodyMedium,
          ),

        ],
      ),
    );
  }

}
