import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/utils/share.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:intl/intl.dart';

void showInterviewInfoDialog(BuildContext context, DialogueModel interview) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _InterviewInfoSheet(interview: interview),
  );
}

class _InterviewInfoSheet extends StatelessWidget {
  final DialogueModel interview;

  const _InterviewInfoSheet({required this.interview});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onPrimaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: interview.image.isNotEmpty
                          ? CustomCacheImage(
                              imageUrl: "${Api.baseImageUrl}${interview.image}",
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppColor.primaryBlue.withOpacity(0.1),
                              child: Center(
                                child: Assets.icons.circleMicrophoneLines.image(
                                  width: 60,
                                  height: 60,
                                  color: AppColor.primaryBlue.withOpacity(0.5),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    interview.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.theme.brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1E293B),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info chips
                  Row(
                    children: [
                      _buildInfoChip(
                        context: context,
                        icon: Assets.icons.circleMicrophoneLines.path,
                        label: interview.interviewer,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        context: context,
                        icon: Assets.icons.calendar.path,
                        label: _formatDate(interview.date),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Divider accent
                  Container(
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Excerpt
                  if (interview.excerpt.isNotEmpty)
                    Text(
                      interview.excerpt,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: context.theme.brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          icon: Assets.icons.shareSquare.path,
                          label: 'مشاركة',
                          color: AppColor.primaryOrange,
                          onTap: () {
                            ShareHelper.shareContent(
                              title: interview.interviewer,
                              content: interview.title,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required String icon,
    required String label,
    required BuildContext context,
  }) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: context.theme.brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              color: context.theme.brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
              width: 10,
              height: 10,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: context.theme.brightness == Brightness.dark
                      ? Colors.grey.shade300
                      : Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Image.asset(icon, color: color, width: 20, height: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final date = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        final formatter = DateFormat('dd MMMM yyyy', 'ar');
        return formatter.format(date);
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }
}
