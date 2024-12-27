import 'dart:developer';

import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_typewriter_text/stream_typewriter_text.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../helpers/styles/app_colors.dart';
import '../../../../../helpers/styles/styles.dart';
import '../ai_cubit.dart';
import '../ai_state.dart';

class AiStreamingMessage extends StatelessWidget {
  const AiStreamingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomLeft,
      child: StreamingMessageWidget(),
    );
  }
}

class StreamingMessageWidget extends StatelessWidget {
  const StreamingMessageWidget({super.key});

  static final cubit = getIt<AiCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiCubit, AiState>(
      bloc: cubit,
      builder: (context, state) {
        return StreamBuilder<String>(
          stream: state.controller.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("WAITING....");
            } else if (snapshot.hasError) {
              return Text("Unable To generate response: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 0.55.sw,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.colorScheme.secondary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: StreamTypewriterAnimatedText(
                          onFinished: () {
                            log("FINISHED");
                            cubit.endStream();
                          },
                          text: snapshot.data!,
                          speed: const Duration(milliseconds: 5),
                          cursor: "",
                          style: Styles.mediumStyle(
                            fontSize: 14,
                            color: AppColor.white,
                            family: FontFamily.montserrat,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            } else {
              return const Text('No response');
            }
          },
        );
      },
    );
  }
}
