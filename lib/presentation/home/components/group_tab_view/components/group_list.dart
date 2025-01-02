import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../domain/entities/message_entity.dart';
import '../../../../../helpers/styles/app_colors.dart';
import '../../../../../helpers/styles/styles.dart';
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
  final cubit = sl<GroupCubit>();

  @override
  void initState() {
    super.initState();
    final scrollController = cubit.state.groupPagination.scrollController;
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        final threshold = scrollController.position.maxScrollExtent * 0.2;
        if (scrollController.position.pixels >= threshold) {
          cubit.scrollAndCallGroup();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      bloc: cubit,
      builder: (context, state) {
        final groups = state.isSearching
            ? state.groupSearchList
            : state.groupPagination.data;
        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                sl<GroupCreationCubit>().fetchUsers();
                showAppDialog(context, const GroupCreationForm());
              },
              backgroundColor: AppColor.styleColor,
              child: const Icon(
                Icons.add,
                color: AppColor.white,
              ),
            ),
          ),
          body: SizedBox(
            height: 0.9.sh,
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
                3.verticalSpace,
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
                    child: groups.isEmpty
                        ? const Center(
                            child: Text("NO GROUPS FOUND!"),
                          )
                        : ListView.separated(
                            controller: state.groupPagination.scrollController,
                            itemCount: groups.length,
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Divider(
                                  thickness: 0.5,
                                  color: context.colorScheme.secondary,
                                ),
                              );
                            },
                            itemBuilder: (context, index) {
                              final group = groups[index];
                              final groupName = state.groupPagination.data
                                  .firstWhere(
                                      (element) => element.id == group.id)
                                  .name;
                              List<MessageEntity> messages = state
                                  .groupPagination.data
                                  .firstWhere(
                                      (element) => element.id == group.id)
                                  .messagePagination
                                  .data;
                              messages =
                                  messages.isEmpty ? group.messages : messages;
                              final message =
                                  messages.isNotEmpty ? messages.first : null;

                              return IconButton(
                                style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                        const StadiumBorder())),
                                onPressed: () {
                                  cubit.updateCurrentGroup(group);
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            groupName,
                                            style: Styles.mediumStyle(
                                              fontSize: 15,
                                              color:
                                                  context.colorScheme.onPrimary,
                                              family: FontFamily.kanit,
                                            ),
                                          ),
                                          const Spacer(),
                                          2.horizontalSpace,
                                          Text(
                                            formatDate(message?.timeStamp ??
                                                DateTime.now().toLocal()),
                                            style: Styles.mediumStyle(
                                              fontSize: 13,
                                              color:
                                                  context.colorScheme.onPrimary,
                                              family: FontFamily.montserrat,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (message?.text.isNotEmpty ??
                                          false) ...[
                                        1.verticalSpace,
                                        Text(
                                          message?.text ?? "",
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 15,
                                            color:
                                                context.colorScheme.onPrimary,
                                            fontFamily: "Montserrat",
                                          ),
                                        ),
                                      ],
                                    ],
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
