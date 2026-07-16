import 'dart:async';

import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info, custom }

class SnackBarConfig {
  final Duration duration;
  final EdgeInsets margin;
  final double borderRadius;
  final SnackBarBehavior behavior;
  final bool showCloseButton;
  final bool withAnimation;

  const SnackBarConfig({
    this.duration = const Duration(seconds: 3),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 16,
    this.behavior = SnackBarBehavior.floating,
    this.showCloseButton = true,
    this.withAnimation = true,
  });

  static const SnackBarConfig quick = SnackBarConfig(
    duration: Duration(seconds: 2),
  );
  static const SnackBarConfig long = SnackBarConfig(
    duration: Duration(seconds: 5),
  );
  static const SnackBarConfig noClose = SnackBarConfig(showCloseButton: false);
}

class AppSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    SnackBarConfig? config,
    VoidCallback? onAction,
    String? actionLabel,
    Color? customColor,
    IconData? customIcon,
  }) {
    final finalConfig = config ?? SnackBarConfig();
    final (color, icon) = _getTypeProperties(type, customColor, customIcon);

    _showModernSnackBar(
      context: context,
      message: message,
      color: color,
      icon: icon,
      config: finalConfig,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  static void success(
    BuildContext context,
    String message, {
    SnackBarConfig? config,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      config: config,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    SnackBarConfig? config,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      config: config,
    );
  }

  static void warning(
    BuildContext context,
    String message, {
    SnackBarConfig? config,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      config: config,
    );
  }

  static void info(
    BuildContext context,
    String message, {
    SnackBarConfig? config,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      config: config,
    );
  }

  static Future<void> showFuture({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    SnackBarConfig? config,
  }) async {
    final completer = Completer<void>();

    final finalConfig = config ?? SnackBarConfig();
    final (color, icon) = _getTypeProperties(type, null, null);

    final snackBar = _buildModernSnackBar(
      message: message,
      color: color,
      icon: icon,
      config: finalConfig,
      context: context, 
      onDismiss: () => completer.complete(),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return completer.future;
  }

  static void showCustom({
    required BuildContext context,
    required Widget content,
    Color backgroundColor = const Color(0xFF1E293B),
    SnackBarConfig? config,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final finalConfig = config ?? SnackBarConfig();

    final snackBar = SnackBar(
      content: content,
      backgroundColor: backgroundColor,
      behavior: finalConfig.behavior,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(finalConfig.borderRadius),
      ),
      duration: finalConfig.duration,
      margin: finalConfig.margin,
      elevation: 8,
      padding: finalConfig.showCloseButton
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
          : const EdgeInsets.all(16),
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
              textColor: Colors.white,
            )
          : null,
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void clearAll(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  static (Color, IconData) _getTypeProperties(
    SnackBarType type,
    Color? customColor,
    IconData? customIcon,
  ) {
    if (type == SnackBarType.custom &&
        customColor != null &&
        customIcon != null) {
      return (customColor, customIcon);
    }

    switch (type) {
      case SnackBarType.success:
        return (const Color(0xFF10B981), Icons.check_circle_rounded);
      case SnackBarType.error:
        return (const Color(0xFFEF4444), Icons.error_rounded);
      case SnackBarType.warning:
        return (const Color(0xFFF59E0B), Icons.warning_amber_rounded);
      case SnackBarType.info:
        return (const Color(0xFF3B82F6), Icons.info_rounded);
      case SnackBarType.custom:
        return (
          customColor ?? const Color(0xFF6366F1),
          customIcon ?? Icons.notifications_rounded,
        );
    }
  }

  static void _showModernSnackBar({
    required BuildContext context,
    required String message,
    required Color color,
    required IconData icon,
    required SnackBarConfig config,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final snackBar = _buildModernSnackBar(
      message: message,
      color: color,
      icon: icon,
      config: config,
      context: context,
      onAction: onAction,
      actionLabel: actionLabel,
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static SnackBar _buildModernSnackBar({
    required String message,
    required Color color,
    required IconData icon,
    required SnackBarConfig config,
    required BuildContext context,
    VoidCallback? onAction,
    String? actionLabel,
    VoidCallback? onDismiss,
  }) {
    return SnackBar(
      content: config.withAnimation
          ? _AnimatedSnackBarContent(
              message: message,
              icon: icon,
              primaryBlue: color,
              showCloseButton: config.showCloseButton,
              onClose: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onDismiss?.call();
              },
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
                if (config.showCloseButton && onDismiss == null)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
              ],
            ),
      backgroundColor: color,
      behavior: config.behavior,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
      ),
      duration: config.duration,
      margin: config.margin,
      elevation: 6,
      padding: config.showCloseButton
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
          : const EdgeInsets.all(16),
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
              textColor: Colors.white.withOpacity(0.9),
            )
          : null,
    );
  }
}

class _AnimatedSnackBarContent extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color primaryBlue;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const _AnimatedSnackBarContent({
    required this.message,
    required this.icon,
    required this.primaryBlue,
    this.showCloseButton = true,
    this.onClose,
  });

  @override
  State<_AnimatedSnackBarContent> createState() =>
      _AnimatedSnackBarContentState();
}

class _AnimatedSnackBarContentState extends State<_AnimatedSnackBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.4,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            if (widget.showCloseButton)
              GestureDetector(
                onTap: widget.onClose, 
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension AppSnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message, {SnackBarConfig? config}) {
    AppSnackBar.success(this, message, config: config);
  }

  void showErrorSnackBar(String message, {SnackBarConfig? config}) {
    AppSnackBar.error(this, message, config: config);
  }

  void showWarningSnackBar(String message, {SnackBarConfig? config}) {
    AppSnackBar.warning(this, message, config: config);
  }

  void showInfoSnackBar(String message, {SnackBarConfig? config}) {
    AppSnackBar.info(this, message, config: config);
  }

  void showCustomSnackBar({
    required String message,
    required Color color,
    required IconData icon,
    SnackBarConfig? config,
  }) {
    AppSnackBar.show(
      context: this,
      message: message,
      type: SnackBarType.custom,
      customColor: color,
      customIcon: icon,
      config: config,
    );
  }

  void clearAllSnackBars() {
    AppSnackBar.clearAll(this);
  }
}
