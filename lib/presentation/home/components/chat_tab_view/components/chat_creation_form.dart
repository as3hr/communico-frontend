import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../helpers/widgets/app_button.dart';
import '../../../../../helpers/widgets/input_field.dart';

class ChatCreationForm extends StatelessWidget {
  const ChatCreationForm({super.key});

  static final cubit = getIt<ChatCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
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
            if (state.filteredUsers.isNotEmpty)
              Container(
                color: context.colorScheme.secondary,
                child: Column(
                  children: state.filteredUsers.sublist(0, length).map((user) {
                    return InkWell(
                      onTap: () {
                        cubit.selectChatUser(user);
                      },
                      child: ListTile(
                        leading: Text(user.username),
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
            const Spacer(),
            AppButton(
              title: "Start Chat",
              onTap: () {
                cubit.createChat();
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
