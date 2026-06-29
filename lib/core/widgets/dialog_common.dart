import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/custom_loading.dart';

class AppDialog {
  static Future<void> showInfoDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final theme = context.theme;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Assets.newicons.termsInfo.image(
                //   width: 60,
                //   height: 60,
                //   color: theme.primaryColor,
                // ),
                Icon(Icons.telegram_outlined), //* delete
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Text(
                      message,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("موافق"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showFieldDialog(
    BuildContext context, {
    required String title,
    required String content,
    required Future<void> Function(String value) onPress,
  }) async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: context.theme.colorScheme.onPrimary,
          title: Row(
            children: [
              Icon(
                Icons.telegram_outlined,
                color: context.theme.colorScheme.surface,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: context.theme.colorScheme.surface,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: context.theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: controller,

                decoration: const InputDecoration(
                  labelText: 'الرمز',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'الغاء',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await onPress(controller.text);
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 55, 119, 57),
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: const Text('تأكيد', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    required Future<void> Function() onPress,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              // Assets.newicons.triangleWarning
              //     .image(color: Colors.orange.shade600, width: 20, height: 20),
              Icon(Icons.telegram_outlined), //* delete

              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.theme.colorScheme.surface,
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: context.theme.colorScheme.surface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'لا',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await onPress();
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: context.theme.scaffoldBackgroundColor,
              ),
              child: const Text('نعم', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoadingDialog(
    BuildContext context, {
    String? message,
  }) async {
    final theme = context.theme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomLoading(),
              if (message != null) ...[
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
