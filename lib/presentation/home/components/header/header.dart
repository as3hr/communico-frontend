import 'dart:ui' as ui;

import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/auth/password_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_html/html.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/widgets/animated_banner.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import 'header_content.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  static final cubit = getIt<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: context.screenWidth < 1780
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: HeaderContent(
                            currentQuote: state.currentQuote,
                            logOut: () {
                              Navigator.pop(context);
                              cubit.closeStates();
                              window.localStorage['authToken'] = "";
                            },
                            userName: cubit.user!.username,
                            updatePassword: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return BackdropFilter(
                                    filter: ui.ImageFilter.blur(
                                        sigmaX: 8, sigmaY: 8),
                                    child: const AnimatedBanner(
                                      content: PasswordBanner(),
                                    ),
                                  );
                                },
                              );
                            },
                          ))
                      : HeaderContent(
                          currentQuote: state.currentQuote,
                          logOut: () {
                            Navigator.pop(context);
                            cubit.closeStates();
                            window.localStorage['authToken'] = "";
                          },
                          userName: cubit.user!.username,
                          updatePassword: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return BackdropFilter(
                                  filter:
                                      ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: const AnimatedBanner(
                                    content: PasswordBanner(),
                                  ),
                                );
                              },
                            );
                          },
                        )),
            ),
          ],
        );
      },
    );
  }
}
