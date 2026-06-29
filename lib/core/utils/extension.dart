import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

extension ContextX on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  Gap gap(double space) {
    return Gap(space);
  }

  MaxGap gapSafe(double space) {
    return MaxGap(space);
  }
}

extension DateExtension on String {
  String toRelativeTime() {
    try {
      final DateTime parsedDate = DateTime.parse(this);
      final now = DateTime.now();
      final difference = now.difference(parsedDate);

      if (difference.inDays > 30) {
        return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
      } else if (difference.inDays > 0) {
        return 'قبل ${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return 'قبل ${difference.inHours} ساعة';
      } else if (difference.inMinutes > 0) {
        return 'قبل ${difference.inMinutes} دقيقة';
      } else {
        return 'الآن';
      }
    } catch (e) {
      return substring(0, length > 10 ? 10 : length);
    }
  }
}

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final LinearGradient scaffoldGradient;
  final Color cardBackgroundColor;

  const AppThemeExtension({
    required this.scaffoldGradient,
    required this.cardBackgroundColor,
  });

  @override
  AppThemeExtension copyWith({
    LinearGradient? scaffoldGradient,
    Color? cardBackgroundColor,
  }) {
    return AppThemeExtension(
      scaffoldGradient: scaffoldGradient ?? this.scaffoldGradient,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      scaffoldGradient: LinearGradient.lerp(
        scaffoldGradient,
        other.scaffoldGradient,
        t,
      )!,
      cardBackgroundColor: Color.lerp(
        cardBackgroundColor,
        other.cardBackgroundColor,
        t,
      )!,
    );
  }
}
