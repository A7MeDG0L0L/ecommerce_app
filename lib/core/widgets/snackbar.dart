import 'package:ecommerce/config/routes/route_configurations.dart';
import 'package:ecommerce/config/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'count_down_widget.dart';


/*
! in Material App 
!   navigatorKey: rootNavigatorKey,
? define rootNavigatorKey as Global variable
?   GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
 */
class CustomSnackBar {
  static errorSnackBar(
    String text, {
    BuildContext? context,
  }) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.maybeOf(context ??
                RouteConfigurations.parentNavigatorKey.currentState!.context)!
            .showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(RouteConfigurations
                            .parentNavigatorKey.currentState!.context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.primaryDarker),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static warningSnackBar(
    String text, {
    BuildContext? context,
  }) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context ??
              RouteConfigurations.parentNavigatorKey.currentState!.context)
          .showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(
                Icons.warning,
                color: Colors.yellow,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(RouteConfigurations
                          .parentNavigatorKey.currentState!.context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.primaryDarker),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  static primarySnackBar(
    String text, {
    BuildContext? context,
  }) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context ??
                RouteConfigurations.parentNavigatorKey.currentState!.context)
            .showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_outlined,
                  color: Colors.green,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(RouteConfigurations
                            .parentNavigatorKey.currentState!.context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.primaryDarker),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static customSnackBar({
    required String text,
    required Color color,
    Color? textColor,
    BuildContext? context,
  }) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context ??
                RouteConfigurations.parentNavigatorKey.currentState!.context)
            .showSnackBar(
          SnackBar(
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            content: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(RouteConfigurations
                      .parentNavigatorKey.currentState!.context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: textColor),
            ),
          ),
        );
      },
    );
  }

  static void showUndoSnackBar({
    required VoidCallback onUndo,
    required String text,
    required Color color,
    Duration duration = const Duration(seconds: 5),
    BuildContext? context,
    Color? textColor,
    Color? undoTextColor,
    Color? circularColor,
    Color? counterTextColor,
  }) {
    // Capture the context safely
    final scaffoldMessenger = ScaffoldMessenger.of(context ??
        RouteConfigurations.parentNavigatorKey.currentState!.context);

    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            duration: duration,
            action: SnackBarAction(
              label: 'Undo',
              textColor: undoTextColor ?? Colors.white,
              onPressed: () {
                onUndo();
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CountDownWidget(
                  duration: duration,
                  circularColor: circularColor,
                  counterTextColor: counterTextColor,
                ),
                SizedBox(width: 8.w),
                Text(
                  text,
                  style: Theme.of(RouteConfigurations
                          .parentNavigatorKey.currentState!.context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: textColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
