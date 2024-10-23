import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/config/theme/app_color.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:ecommerce/features/products/domain/entities/products.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_cubit.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/item_info_details.dart';

class ProductItemDetailsScreen extends StatefulWidget {
  const ProductItemDetailsScreen({
    super.key,
    required this.productItem,
  });
  final Product productItem;

  @override
  State<ProductItemDetailsScreen> createState() =>
      _ProductItemDetailsScreenState();
}

class _ProductItemDetailsScreenState extends State<ProductItemDetailsScreen> {
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    isFavorite = widget.productItem.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 0.6.sh,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: widget.productItem.image != null
                              ? CachedNetworkImage(
                                  imageUrl: widget.productItem.image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  progressIndicatorBuilder: (_, __, progress) =>
                                      Center(
                                    child: CircularProgressIndicator(
                                        value: progress.progress),
                                  ),
                                  errorWidget: (_, __, ___) =>
                                      const Icon(Icons.error),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 56.sp,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: ItemInfoDetails(
                        productItem: widget.productItem,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCircularButtonIcon(
                        onPressed: () => context.pop(),
                        padding: EdgeInsets.only(right: 4.w),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 24.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      FavouriteButtonSizeColorAnimation(
                        isFavourite: isFavorite,
                        changeUi: true,
                        iconSize: 24.sp,
                        onTap: () async {
                          context.read<ProductsCubit>().
                                toggleFavorite(
                                  widget.productItem
                                      .copyWith(isFavourite: isFavorite),
                                );
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
