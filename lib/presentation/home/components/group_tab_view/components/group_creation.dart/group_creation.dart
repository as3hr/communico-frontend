import 'dart:developer';

import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../di/service_locator.dart';
import '../../../../../../helpers/widgets/app_button.dart';
import '../../../../../../helpers/widgets/input_field.dart';
import 'group_creation_cubit.dart';
import 'group_creation_state.dart';

class GroupCreationForm extends StatelessWidget {
  const GroupCreationForm({super.key});

  static final cubit = getIt<GroupCreationCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreationCubit, GroupCreationState>(
      bloc: cubit,
      builder: (context, state) {
        return SizedBox(
          width: 0.3.sw,
          height: 0.4.sh,
          child: PopScope(
            onPopInvokedWithResult: (_, __) {
              cubit.closeDialog();
            },
            child: PageView.builder(
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

class GroupCreationMemberSelection extends StatelessWidget {
  const GroupCreationMemberSelection({super.key});

  static final cubit = getIt<GroupCreationCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreationCubit, GroupCreationState>(
      bloc: cubit,
      builder: (context, state) {
        log(state.selectedUsers.length.toString());
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              InputField(
                hintText: "search by username",
                onChanged: (val) {
                  cubit.searchMembers(val);
                },
                onSubmitted: (val) {},
                prefixIcon: Icons.public,
              ),
              if (state.selectedUsers.isNotEmpty)
                Container(
                  color: AppColor.violet,
                  child: Row(
                    children: state.selectedUsers.map((user) {
                      return Text(user.username);
                    }).toList(),
                  ),
                ),
              if (state.filteredUsers.isNotEmpty)
                Container(
                  constraints: BoxConstraints(maxHeight: 0.2.sh),
                  color: context.colorScheme.secondary,
                  child: SingleChildScrollView(
                    child: Column(
                      children: state.filteredUsers.map((user) {
                        return InkWell(
                          onTap: () {
                            cubit.selectGroupUser(user);
                          },
                          child: ListTile(
                            leading: Text(user.username),
                            trailing: CupertinoCheckbox(
                                value: user.isSelected,
                                onChanged: (val) {
                                  cubit.selectGroupUser(user);
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
                backgroundColor: state.selectedUsers.isNotEmpty
                    ? AppColor.violet
                    : AppColor.black3,
                onTap: state.selectedUsers.isNotEmpty
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

class GroupCreationNaming extends StatelessWidget {
  const GroupCreationNaming({super.key});

  static final cubit = getIt<GroupCreationCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreationCubit, GroupCreationState>(
      bloc: cubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  1.horizontalSpace,
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
                      hintText: "enter group name",
                      onChanged: (val) {
                        cubit.onGroupNameChanged(val);
                      },
                      onSubmitted: (val) {},
                    ),
                  ),
                ],
              ),
              if (state.selectedUsers.isNotEmpty)
                Column(
                  children: [
                    const Text("Members"),
                    1.verticalSpace,
                    const Divider(
                      color: AppColor.white,
                      thickness: 0.3,
                    ),
                    1.verticalSpace,
                    Container(
                      constraints: BoxConstraints(maxHeight: 0.2.sh),
                      color: context.colorScheme.secondary,
                      child: SingleChildScrollView(
                        child: Column(
                          children: state.selectedUsers.map((user) {
                            return Text(user.username);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              const Spacer(),
              AppButton(
                title: "Create Group",
                backgroundColor:
                    state.name.isNotEmpty ? AppColor.violet : AppColor.black3,
                onTap: state.name.isNotEmpty
                    ? () {
                        cubit.createGroup();
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
