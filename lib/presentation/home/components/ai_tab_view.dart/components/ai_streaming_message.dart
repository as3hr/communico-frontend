import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:typewritertext/typewritertext.dart';

import '../../../../../di/service_locator.dart';
import '../../loading_message.dart';
import '../ai_cubit.dart';
import '../ai_state.dart';

class AiStreamingMessage extends StatelessWidget {
  const AiStreamingMessage({
    super.key,
  });

  static final cubit = getIt<AiCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiCubit, AiState>(
      bloc: cubit,
      builder: (context, state) {
        return state.isLoading
            ? const Align(
                alignment: Alignment.bottomLeft,
                child: LoadingMessage(),
              )
            :
            // StreamBuilder<String>(
            //     stream: state.controller.stream,
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const SizedBox();
            //       } else if (snapshot.hasError) {
            //         return const SizedBox();
            //       } else if (snapshot.hasData) {
            // return
            Padding(
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
                          child: TypeWriter(
                              controller: TypeWriterController.fromStream(
                                  state.controller.stream),
                              builder: (context, value) {
                                return Text(
                                  value.text,
                                  maxLines: 2,
                                );
                              }),
                        )),
                    const Spacer(),
                  ],
                ),
              );
        //     ;
        //   } else {
        //     return const Text('No response');
        //   }
        // });
      },
    );
  }
}
