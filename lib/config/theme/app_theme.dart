
import 'package:ecommerce/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';



class AppTheme {
  static lightTheme() => ThemeData(
        useMaterial3: false,
        colorScheme: const ColorScheme.light().copyWith(
          primary: AppColors.primary,
          surface: Colors.white,
        ),
        fontFamily: FontFamily.abhayaLibreExtraBold,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            color: AppColors.primary,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          iconTheme: IconThemeData(color: AppColors.primary),
          backgroundColor: Colors.white24,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 18.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontSize: 16.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            fontSize: 14.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.sp,
            color: AppColors.mainTxt,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.sp,
            color: AppColors.mainTxt,
          ),
          bodySmall: TextStyle(
            fontSize: 12.sp,
            color: AppColors.mainTxt,
          ),
          labelLarge: TextStyle(
            fontSize: 16.sp,
            color: AppColors.mainTxt,
          ),
          labelMedium: TextStyle(
            fontSize: 14.sp,
            color: AppColors.mainTxt,
          ),
          labelSmall: TextStyle(
            fontSize: 12.sp,
            color: AppColors.mainTxt,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: Colors.black54),
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor:
              WidgetStateColor.resolveWith((states) => AppColors.primary),
        ),
      );
}
