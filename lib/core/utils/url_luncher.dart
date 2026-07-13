import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/snackbar_common.dart';
import 'package:url_launcher/url_launcher.dart';

class LunchUrlService {
  static Future<void> videoOpener(
    BuildContext context,
    String youtubeId,
  ) async {
    if (youtubeId.isEmpty) return;
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$youtubeId');
    try {
      if (!await launchUrl(url)) {
        if (context.mounted) {
          AppSnackBar.error(context, "لا يمكن فتح الرابط");
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, "خطأ في فتح الرابط");
      }
    }
  }

  static Future<void> urlOpener(BuildContext context, String url) async {
    if (url.isEmpty) {
      if (context.mounted) {
        AppSnackBar.error(context, "الرابط غير موجود");
      }
      return;
    }
    final Uri uri = Uri.parse(url);

    try {
      if (!await launchUrl(uri)) {
        if (context.mounted) {
          AppSnackBar.error(context, "لا يمكن فتح الرابط");
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, "خطأ في فتح الرابط");
      }
    }
  }
}
