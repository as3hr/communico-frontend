import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_button.dart';

class LinkBanner extends StatelessWidget {
  const LinkBanner({super.key, required this.link});
  final String link;

  static final isCopiedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: link));
                      isCopiedNotifier.value = true;
                      Future.delayed(const Duration(seconds: 2), () {
                        isCopiedNotifier.value = false;
                      });
                    },
                    child: Icon(
                      Icons.link,
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      link,
                      style: TextStyle(
                        color: context.colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<bool>(
            valueListenable: isCopiedNotifier,
            builder: (context, value, _) {
              return AppButton(
                title: value ? "Copied!" : "Copy Link",
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: link));
                  isCopiedNotifier.value = true;
                  Future.delayed(const Duration(seconds: 2), () {
                    isCopiedNotifier.value = false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
