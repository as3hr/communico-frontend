import 'dart:async';

import 'package:communico_frontend/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../domain/model/paginate.dart';

List<T> parseList<T>(
  data,
  T Function(Map<String, dynamic>) fromJson,
) {
  final parsedData = (data as List?)?.cast<Map<String, dynamic>>();
  return parsedData?.map(fromJson).toList().cast<T>() ?? [];
}

Future<void> showToast(String message) async {
  if (AppNavigation.context.mounted) {
    showDialog(
      context: AppNavigation.context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) {
        Timer.periodic(const Duration(seconds: 2), (timer) {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          timer.cancel();
        });

        return Dialog(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          elevation: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
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
