import 'dart:ui';

import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/widgets/app_button.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../helpers/styles/app_colors.dart';
import '../../../../../helpers/styles/styles.dart';
import '../../../../../helpers/widgets/animated_banner.dart';
import '../../../../../helpers/widgets/input_field.dart';
import '../group_cubit.dart';

class GroupRoomDetail extends StatelessWidget {
  const GroupRoomDetail({super.key});

  static final cubit = sl<GroupCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      bloc: cubit,
      builder: (context, state) {
        final currentGroup = state.currentGroup;
        return Container(
          width: 0.3.sw,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          height: 0.9.sh,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: currentGroup.name),
                        enabled: state.groupFieldEnabled,
                        decoration: InputDecoration(
                          border: state.groupFieldEnabled
                              ? const UnderlineInputBorder()
                              : InputBorder.none,
                        ),
                        style: Styles.boldStyle(
                          fontSize: 15,
                          color: AppColor.white,
                          family: FontFamily.kanit,
                        ),
                        onChanged: (val) {
                          state.groupNameField = val;
                        },
                        onSubmitted: (val) {
                          if (state.groupNameField.isNotEmpty) {
                            final group = GroupEntity(
                                members: currentGroup.members,
                                name: state.groupNameField);
                            cubit.updateGroup(group);
                          }
                        },
                      ),
                    ),
                    if (!state.groupFieldEnabled)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          cubit.toggleGroupField(groupFieldEnabled: true);
                        },
                      ),
                    if (state.groupFieldEnabled)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              if (state.groupNameField.isNotEmpty) {
                                final group = GroupEntity(
                                    members: currentGroup.members,
                                    name: state.groupNameField);
                                cubit.updateGroup(group);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              cubit.onCloseIconTap();
                            },
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Members:",
                  style: Styles.boldStyle(
                    fontSize: 12,
                    color: AppColor.white,
                    family: FontFamily.kanit,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 0.5,
                    ),
                    itemCount: state.currentGroup.members.length,
                    itemBuilder: (context, index) {
                      final member = state.currentGroup.members[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: context.colorScheme.secondary,
                          child: Text(
                            (member.user?.username ?? "?").substring(0, 1),
                            style: Styles.mediumStyle(
                              fontSize: 12,
                              color: AppColor.white,
                              family: FontFamily.montserrat,
                            ),
                          ),
                        ),
                        title: Text(
                          member.user?.username ?? "Unknown",
                          style: Styles.mediumStyle(
                            fontSize: 12,
                            color: AppColor.white,
                            family: FontFamily.montserrat,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AppButton(
                  title: "Update Members",
                  onTap: () {
                    Scaffold.of(context).closeEndDrawer();
                    cubit.fetchMembers();
                    showDialog(
                      context: context,
                      builder: (_) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: AnimatedBanner(
                            content: GroupUpdationMemberSelection(
                              previousUsers: cubit.previousUsers,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GroupUpdationMemberSelection extends StatelessWidget {
  const GroupUpdationMemberSelection({super.key, required this.previousUsers});
  final List<UserEntity> previousUsers;

  static final cubit = sl<GroupCubit>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        cubit.closeDialog();
      },
      child: Container(
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
        height: 0.6.sh,
        child: BlocBuilder<GroupCubit, GroupState>(
          bloc: cubit,
          builder: (context, state) {
            final allUsers = [...previousUsers, ...state.filteredUsers];
            final selectedUsers =
                allUsers.where((user) => user.isSelected).toList();
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
                      constraints: BoxConstraints(maxHeight: 0.3.sh),
                      color: context.colorScheme.secondary,
                      child: SingleChildScrollView(
                        child: Column(
                          children: state.filteredUsers.map((user) {
                            return InkWell(
                              onTap: () {
                                cubit.selectGroupUser(
                                    user, state.filteredUsers);
                              },
                              child: ListTile(
                                leading: Text(user.username),
                                trailing: CupertinoCheckbox(
                                    value: user.isSelected,
                                    onChanged: (val) {
                                      cubit.selectGroupUser(
                                          user, state.filteredUsers);
                                    }),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (selectedUsers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: selectedUsers.map((user) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
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
                                deleteIconColor: AppColor.red,
                                onDeleted: () {
                                  cubit.selectGroupUser(user, allUsers);
                                },
                                deleteIcon: const Icon(Icons.cancel_outlined),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  2.verticalSpace,
                  AppButton(
                    title: "Update Selected Members",
                    backgroundColor: selectedUsers.isNotEmpty
                        ? AppColor.styleColor
                        : AppColor.black3,
                    onTap: selectedUsers.isNotEmpty
                        ? () {
                            cubit.finalizeGroupMembers(selectedUsers);
                            Navigator.pop(context);
                          }
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
