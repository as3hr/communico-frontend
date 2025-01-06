import 'dart:async';
import 'dart:ui';

import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../domain/model/paginate.dart';
import 'styles/styles.dart';
import 'widgets/animated_banner.dart';

List<T> parseList<T>(
  data,
  T Function(Map<String, dynamic>) fromJson,
) {
  final parsedData = (data as List?)?.cast<Map<String, dynamic>>();
  return parsedData?.map(fromJson).toList().cast<T>() ?? [];
}

Future<bool> showConfirmationDialog(String title) async {
  final context = AppNavigation.context;
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.all(0),
            backgroundColor: context.colorScheme.primary,
            title: Text(title,
                style: Styles.semiBoldStyle(
                  fontSize: 16,
                  color: context.colorScheme.onPrimary,
                  family: FontFamily.montserrat,
                )),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: Styles.mediumStyle(
                      fontSize: 14,
                      color: context.colorScheme.onPrimary,
                      family: FontFamily.montserrat,
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes',
                    style: Styles.mediumStyle(
                        family: FontFamily.montserrat,
                        fontSize: 14,
                        color: context.colorScheme.onPrimary)),
              ),
            ],
          );
        },
      ) ??
      false;
}

Future<void> showToast(String message, {Color? backgroundColor}) async {
  if (AppNavigation.context.mounted) {
    showDialog(
      context: AppNavigation.context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) {
        Timer.periodic(const Duration(milliseconds: 1200), (timer) {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          timer.cancel();
        });

        return Dialog(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.red,
          surfaceTintColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetPadding: const EdgeInsets.all(8),
          insetAnimationDuration: const Duration(milliseconds: 500),
          elevation: 0,
          alignment: Alignment.topRight,
          child: Container(
            constraints: BoxConstraints(maxWidth: 0.2.sw, maxHeight: 0.1.sh),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    message,
                    style: Styles.lightStyle(
                      fontSize: 15,
                      color: AppColor.white,
                      family: FontFamily.kanit,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

showAppDialog(BuildContext context, Widget content) {
  showDialog(
    context: context,
    builder: (_) {
      return
          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          //   child:
          AnimatedBanner(
        content: content,
        // ),
      );
    },
  );
}

String formatDate(DateTime date) {
  return DateFormat('hh:mm a').format(date);
}

// if next is true then only ill hit pagination call in UI lAYER!
Paginate<T> updatedPagination<T>({
  required Paginate<T> previousData,
  required Map<String, dynamic> data,
  required Function(Map<String, dynamic>) dataFromJson,
}) {
  Paginate<T> pagination = Paginate<T>.fromJson(data, dataFromJson);
  final updatedResults = previousData.data.isEmpty
      ? pagination.data
      : [...previousData.data, ...pagination.data];
  final skip = pagination.data.length < 25 ? 0 : previousData.skip + 25;
  final next = pagination.data.isNotEmpty && pagination.data.length == 25;
  pagination =
      pagination.copyWith(data: updatedResults, skip: skip, next: next);
  return pagination;
}

FocusNode getFieldFocusNode(void Function() callBack) {
  return FocusNode(
    onKeyEvent: (node, evt) {
      if (!HardwareKeyboard.instance.isShiftPressed &&
          HardwareKeyboard.instance
              .isLogicalKeyPressed(LogicalKeyboardKey.enter)) {
        if (evt is KeyDownEvent) {
          callBack.call();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );
}

List<String> quotes = [
  "Live with purpose.",
  "Dream big daily.",
  "Joy is a choice.",
  "Simplify your life.",
  "Hustle and grow.",
  "Cherish small moments.",
  "Stay curious always.",
  "Learn, adapt, thrive.",
  "Kindness is power.",
  "Create your legacy.",
];
