import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              width: context.screenWidth * .6,
              height: context.screenHeight * .5,
              child: SvgPicture.asset(
                'assets/svgs/Reading glasses-bro.svg',
                width: context.screenWidth * .6,
                height: context.screenHeight * .5,
              ),
            ),
            Text(title),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
