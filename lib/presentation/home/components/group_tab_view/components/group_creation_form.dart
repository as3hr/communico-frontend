import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_cubit.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../helpers/widgets/app_button.dart';
import '../../../../../helpers/widgets/input_field.dart';

class GroupCreationForm extends StatelessWidget {
  const GroupCreationForm({super.key});

  static final cubit = getIt<GroupCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      bloc: cubit,
      builder: (context, state) {
        final length =
            state.filteredUsers.length > 4 ? 4 : state.filteredUsers.length;
        return Column(
          children: [
            InputField(
              hintText: "search people",
              onChanged: (val) {
                cubit.searchMembers(val);
              },
              onSubmitted: (val) {},
              prefixIcon: Icons.public,
            ),
            if (state.filteredUsers.any((user) => user.isSelected))
              Container(
                color: AppColor.violet,
                child: Row(
                  children: state.filteredUsers
                      .where((user) => user.isSelected)
                      .map((user) {
                    return Text(user.username);
                  }).toList(),
                ),
              ),
            if (state.filteredUsers.isNotEmpty)
              Container(
                color: context.colorScheme.secondary,
                child: Column(
                  children: state.filteredUsers.sublist(0, length).map((user) {
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
            const Spacer(),
            AppButton(
              title: "Start Group",
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
