import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_svg/svg.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({super.key, this.onTap});
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svgs/wifi-exclamation.svg',
          width: 70,
          height: 70,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
        ),
        context.gap(10),
        const Text('تعذر الاتصال بالانترنت، يرجى التحقق من إعدادات الشبكة !'),
        context.gap(10),
        if (onTap != null)
          ElevatedButton(onPressed: onTap, child: const Text('اعادة المحاولة')),
      ],
    );
  }
}
