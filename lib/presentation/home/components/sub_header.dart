import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/styles/app_colors.dart';
import '../../../helpers/widgets/theme_switch.dart';

class SubHeader extends StatelessWidget {
  const SubHeader({
    super.key,
    required this.tabController,
  });
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColor.black1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                      indicatorColor: Colors.transparent,
                      indicatorPadding: const EdgeInsets.all(0),
                      unselectedLabelStyle:
                          const TextStyle(fontSize: 12, color: AppColor.grey),
                      labelStyle:
                          const TextStyle(fontSize: 12, color: AppColor.white),
                      labelPadding:
                          const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      onTap: (index) {},
                      controller: tabController,
                      tabs: const [
                        Text("Direct Messages"),
                        Text("Group Messages"),
                      ]),
                ),
                const Spacer(),
                const ThemeSwitch(),
                10.horizontalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
