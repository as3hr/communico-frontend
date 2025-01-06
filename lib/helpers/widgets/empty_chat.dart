import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../di/service_locator.dart';
import '../../presentation/home/home_cubit.dart';
import '../../presentation/home/home_state.dart';
import '../styles/app_colors.dart';
import '../styles/styles.dart';
import 'background_image.dart';

class EmptyChat extends StatelessWidget {
  const EmptyChat({
    super.key,
    required this.onTap,
    required this.text,
  });
  final String text;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
              bloc: sl<HomeCubit>(),
              builder: (context, homeState) {
                if (homeState.currentBackground?.image.isNotEmpty ?? false) {
                  return Positioned.fill(
                    child: BackgroundImage(
                      image: homeState.currentBackground!.image,
                    ),
                  );
                }
                return const SizedBox();
              }),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  text,
                  style: Styles.boldStyle(
                    fontSize: 20,
                    color: AppColor.white,
                    family: FontFamily.kanit,
                  ),
                ),
              ),
              5.verticalSpace,
              Center(
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: onTap,
                  backgroundColor: AppColor.styleColor,
                  child: const Icon(
                    Icons.add,
                    color: AppColor.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
