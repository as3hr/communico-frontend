import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/helpers/styles/styles.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/components/chat_creation_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/components/chat_creation_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../helpers/widgets/app_button.dart';
import '../../../../../helpers/widgets/input_field.dart';
import '../../../../../helpers/widgets/jumping_dots.dart';

class ChatCreationForm extends StatelessWidget {
  const ChatCreationForm({super.key});

  static final cubit = sl<ChatCreationCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCreationCubit, ChatCreationState>(
      bloc: cubit,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colorScheme.primary,
                context.colorScheme.secondary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          width: 0.5.sw,
          height: 0.5.sh,
          child: PopScope(
            onPopInvokedWithResult: (_, __) {
              cubit.closeDialog();
            },
            child: state.isLoading
                ? Center(
                    child: JumpingDots(
                      color: AppColor.white,
                      numberOfDots: 3,
                    ),
                  )
                : PageView.builder(
                    controller: state.pageController,
                    itemCount: state.formPages.length,
                    itemBuilder: (context, index) {
                      return state.formPages[index];
                    },
                  ),
          ),
        );
      },
    );
  }
}

class ChatCreationMemberSelection extends StatelessWidget {
  const ChatCreationMemberSelection({super.key});

  static final cubit = sl<ChatCreationCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCreationCubit, ChatCreationState>(
      bloc: cubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              2.verticalSpace,
              InputField(
                hintText: "search by username",
                onChanged: (val) {
                  cubit.searchMembers(val);
                },
                onSubmitted: (val) {},
                prefixIcon: Icons.public,
              ),
              if (state.filteredUsers.isNotEmpty)
                Container(
                  constraints: BoxConstraints(maxHeight: 0.2.sh),
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: state.filteredUsers.map((user) {
                        return InkWell(
                          onTap: () {
                            cubit.selectChatUser(user);
                          },
                          child: ListTile(
                            leading: Text(
                              user.username,
                              style: Styles.mediumStyle(
                                fontSize: 14,
                                color: const Color(0xffE3E9EC),
                                family: FontFamily.montserrat,
                              ),
                            ),
                            trailing: CupertinoCheckbox(
                                value: user.isSelected,
                                onChanged: (val) {
                                  cubit.selectChatUser(user);
                                }),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              const Spacer(),
              AppButton(
                title: "Next",
                backgroundColor: state.selectedUser.id != 0
                    ? AppColor.styleColor
                    : AppColor.black3,
                onTap: state.selectedUser.id != 0
                    ? () {
                        state.pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class MessageCreation extends StatelessWidget {
  const MessageCreation({super.key});

  static final cubit = sl<ChatCreationCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCreationCubit, ChatCreationState>(
      bloc: cubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              2.verticalSpace,
              Row(
                children: [
                  2.horizontalSpace,
                  InkWell(
                    onTap: () {
                      state.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(
                    child: InputField(
                      hintText:
                          "send a message to ${state.selectedUser.username}",
                      onChanged: (val) {
                        cubit.onMessageChanged(val);
                      },
                      onSubmitted: (val) {
                        if (state.message.isNotEmpty) {
                          cubit.createChat();
                          Navigator.pop(context);
                        }
                      },
                      prefixIcon: Icons.public,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AppButton(
                title: "Start Chat",
                onTap: state.message.isNotEmpty
                    ? () {
                        cubit.createChat();
                        Navigator.pop(context);
                      }
                    : null,
                backgroundColor: state.message.isNotEmpty
                    ? AppColor.styleColor
                    : AppColor.black3,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
