import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/config/theme/app_color.dart';
import 'package:ecommerce/core/helpers/string_helper.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:ecommerce/core/widgets/shadow_widget.dart';
import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCard extends StatelessWidget {
   ProductCard({
    super.key,
    required this.onTap,
    required this.onFavouriteTap,
    required this.onAddToCartTap,
    required this.item,
    this.height,
    this.haveUndoFavourite = false,
  });

  final Product item;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback onAddToCartTap;
  final double? height;
  final bool haveUndoFavourite;


  final Random _random = Random();

  // Function to generate a random color
  Color _getRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),  // Red value
      _random.nextInt(256),  // Green value
      _random.nextInt(256),  // Blue value
      1.0,                   // Opacity
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShadowWidget(
      offset: Offset.zero,
      radius: 32.r,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.all(8.h),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: item.image != null
                              ? CachedNetworkImage(
                                  imageUrl: item.image,
                                  height: height,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (_, url, progress) =>
                                      Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Skeleton.replace(
                                    height: height,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 42.sp,
                                    ),
                                  ),
                                ),
                        ),
                        FavouriteButtonScaleAnimation(
                          size: 32.sp,
                          iconSize: 32.sp,
                          isFavourite: item.isFavourite,
                          onTap: onFavouriteTap,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: StringHelper.mainAxisAlignment(
                        text: item.title ?? "No Name",
                        isDeviceArabic: false,
                      ),
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.w500,
                              color: AppColors.primary
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      mainAxisAlignment: StringHelper.mainAxisAlignment(
                        text: item.description,
                        isDeviceArabic: false,
                      ),
                      children: [
                        Expanded(
                          child: Text(
                            item.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w300,
                                color: AppColors.gray
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 4.h,
                    ),
                    Text("${item.price} \$",
                      style:  Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        color: AppColors.primary,
                      ),

                    ),
                    SizedBox(height: 6.h,),
                                RatingBar.builder(
                                initialRating: item.rating,
                                direction: Axis.horizontal,
                                itemSize: 20,
                                ignoreGestures: true,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                  ],
                ),
              ),
              InkWell(
                onTap: onAddToCartTap,
                child: Container(
                  padding: EdgeInsets.all(5.h),
                  decoration: BoxDecoration(
                    color: item.isCart ? AppColors.red :  _getRandomColor(),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular
                      (8.r),bottomRight: Radius.circular(8.r)),
                  ),
                  width: double.infinity,
                  child: Center(child: Text(item.isCart ? 'Remove from Cart' :
                  'Add to Cart',
                    style: Theme.of
                    (context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
