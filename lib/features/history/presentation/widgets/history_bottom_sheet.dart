import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/history/logic/cubit/history_cubit.dart';
import 'package:flutter_application_1/features/history/logic/cubit/history_state.dart';
import 'package:flutter_application_1/features/history/presentation/widgets/history_item_tile.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showHistoryBottomSheet(BuildContext context) {
  context.read<HistoryCubit>().loadHistory();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<HistoryCubit>(),
      child: const _HistoryBottomSheetContent(),
    ),
  );
}

class _HistoryBottomSheetContent extends StatelessWidget {
  const _HistoryBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.75),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Assets.icons.timePast.image(
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المفتوحة مؤخراً',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A1F36),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'آخر العناصر التي قمت بفتحها',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade500
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            height: 1,
          ),

          // Content
          Flexible(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoaded) {
                  if (state.items.isEmpty) {
                    return const _HistoryEmptyState();
                  }
                  return _HistoryList(items: state);
                }
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),

          // Clear History button
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoaded && state.items.isNotEmpty) {
                return _ClearHistoryButton(isDark: isDark);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final HistoryLoaded items;

  const _HistoryList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,
          endIndent: 20.w,
          indent: 20.w,
          thickness: 0.5,
        );
      },
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.items.length,
      itemBuilder: (context, index) {
        return HistoryItemTile(item: items.items[index]);
      },
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child:
          Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryBlue.withValues(alpha: 0.08),
                      border: Border.all(
                        color: AppColor.primaryBlue.withValues(alpha: 0.15),
                        width: 2,
                      ),
                    ),
                    child: Assets.icons.timePast.image(
                      width: 35,
                      height: 35,
                      color: AppColor.primaryBlue.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'لا توجد عناصر مفتوحة مؤخراً',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ستظهر هنا العناصر التي تفتحها',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: 400.ms,
              ),
    );
  }
}

class _ClearHistoryButton extends StatelessWidget {
  final bool isDark;

  const _ClearHistoryButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => _showClearConfirmation(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
              ),
              backgroundColor: Colors.red.withValues(alpha: 0.05),
            ),
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 18,
              color: Colors.red.shade400,
            ),
            label: Text(
              'مسح السجل',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        title: Text(
          'مسح السجل',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1F36),
          ),
        ),
        content: Text(
          'هل أنت متأكد من مسح جميع العناصر المفتوحة مؤخراً؟',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<HistoryCubit>().clearHistory();
              Navigator.pop(dialogContext);
            },
            child: Text(
              'مسح',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
