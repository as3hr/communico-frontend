import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../di/service_locator.dart';
import '../group_cubit.dart';

class GroupRoomDetail extends StatelessWidget {
  const GroupRoomDetail({super.key});

  static final cubit = getIt<GroupCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      bloc: cubit,
      builder: (context, state) {
        final currentGroup = state.currentGroup;
        return Container(
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    currentGroup.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              16.verticalSpace,
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Members",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: ListView.separated(
                  itemCount: currentGroup.members.length,
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    final member = currentGroup.members[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: context.colorScheme.secondary,
                        child: Text(
                          (member.user?.username ?? "?").substring(0, 1),
                          style: TextStyle(
                            color: context.colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        member.user?.username ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
