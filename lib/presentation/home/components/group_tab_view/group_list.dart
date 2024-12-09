import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/styles/app_colors.dart';
import '../../../../helpers/widgets/input_field.dart';
import '../../home_state.dart';

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  static final cubit = getIt<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        final groups = state.groupPagination.data;
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {},
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
                  child: InputField(
                    hintText: "Search ...",
                    onChanged: (val) {
                      cubit.searchInGroups(val);
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
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          final message = group.messages.last;
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
                                  subtitle: Text(message.text),
                                  trailing: Text(formatDate(message.timeStamp)),
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
