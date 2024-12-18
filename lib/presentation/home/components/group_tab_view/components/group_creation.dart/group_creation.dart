import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../di/service_locator.dart';
import '../../../../../../helpers/styles/styles.dart';
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
              physics: const NeverScrollableScrollPhysics(),
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
              if (state.selectedUsers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.selectedUsers.map((user) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: GestureDetector(
                            onTap: () {
                              cubit.selectGroupUser(user);
                            },
                            child: Chip(
                              backgroundColor: context.colorScheme.primary,
                              label: Text(
                                user.username,
                                style: Styles.boldStyle(
                                  fontSize: 12,
                                  color: context.colorScheme.onPrimary,
                                  family: FontFamily.montserrat,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              2.verticalSpace,
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      state.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  Expanded(
                    child: InputField(
                      hintText: "Enter group name",
                      onChanged: (val) {
                        cubit.onGroupNameChanged(val);
                      },
                      onSubmitted: (_) {
                        if (state.name.isNotEmpty) {
                          cubit.createGroup();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (state.selectedUsers.isNotEmpty) ...[
                const Text(
                  "Members",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.white54, thickness: 0.5),
                const SizedBox(height: 10),
                Container(
                  constraints: BoxConstraints(maxHeight: 0.1.sh),
                  child: SingleChildScrollView(
                    child: Column(
                      children: state.selectedUsers.map((user) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                child: Text(
                                  user.username[0].toUpperCase(),
                                  style: Styles.lightStyle(
                                    fontSize: 12,
                                    color: AppColor.white,
                                    family: FontFamily.montserrat,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                user.username,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.white,
                                    fontFamily: "Montserrat",
                                    overflow: TextOverflow.ellipsis),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  cubit.selectGroupUser(user);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Spacer(),
              AppButton(
                title: "Create Group",
                backgroundColor:
                    state.name.isNotEmpty ? AppColor.violet : AppColor.black3,
                onTap: state.name.isNotEmpty
                    ? () {
                        cubit.createGroup();
                        Navigator.pop(context);
                      }
                    : null,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
