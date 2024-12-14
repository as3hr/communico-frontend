import 'dart:ui';

import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../helpers/styles/app_colors.dart';
import '../../../../../helpers/widgets/animated_banner.dart';
import '../../../../../helpers/widgets/input_form_field.dart';
import '../group_cubit.dart';
import 'group_creation.dart/group_creation.dart';
import 'group_creation.dart/group_creation_cubit.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  final cubit = getIt<GroupCubit>();

  @override
  void initState() {
    super.initState();
    final scrollController = cubit.state.groupPagination.scrollController;
    scrollController.addListener(() {
      final threshold = scrollController.position.maxScrollExtent * 0.2;
      if (scrollController.position.pixels >= threshold) {
        cubit.getGroups();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      bloc: cubit,
      builder: (context, state) {
        final groups = state.groupPagination.data;
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                getIt<GroupCreationCubit>().fetchUsers();
                showDialog(
                  context: context,
                  builder: (_) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: const AnimatedBanner(
                        content: GroupCreationForm(),
                      ),
                    );
                  },
                );
              },
              backgroundColor: AppColor.violet,
              child: const Icon(
                Icons.add,
                color: AppColor.white,
              ),
            ),
          ),
          body: SizedBox(
            height: 0.8.sh,
            child: Column(
              children: [
                Container(
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
                  child: InputFormField(
                    hintText: "Search ...",
                    onChanged: (val) {
                      cubit.searchInGroupsList(val);
                    },
                    showBorder: false,
                  ),
                ),
                1.verticalSpace,
                Expanded(
                  child: Container(
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
                    child: ListView.builder(
                        controller: state.groupPagination.scrollController,
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          final message = group.messages.isNotEmpty
                              ? group.messages.last
                              : null;
                          final isSelected = group.id == state.currentGroup.id;
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                cubit.updateCurrentGroup(group);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? context.colorScheme.secondary
                                      : context.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: ListTile(
                                  title: Text(group.name),
                                  subtitle: Text(message?.text ?? ""),
                                  trailing: Text(formatDate(
                                      message?.timeStamp ?? DateTime.now())),
                                ),
                              ),
                            ),
                          );
                        }),
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
