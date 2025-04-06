import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/show_confiramtion_dialog.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DeleteReportButton extends StatelessWidget {
  final String reportId;

  const DeleteReportButton({
    super.key,
    required this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return ElevatedButton(
      onPressed: () => _handleDelete(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        minimumSize: const Size(248, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        tr.deleteButton,
        style: AppTextStyles.h4(context).copyWith(color: Theme.of(context).colorScheme.onError),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final tr = AppLocalizations.of(context)!;
    final confirmed = await showConfirmationDialog(
        context: context,
        title: tr.confirmationTitle,
        message: tr.confirmationMessage,
        confirmText: tr.deleteButton);

    if (!context.mounted || !confirmed) return;

    final reportProvider = context.read<SessionReportProvider>();
    await reportProvider.deleteReport(reportId);

    if (!context.mounted) return;

    context.pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tr.removed,
          style: AppTextStyles.subtitle,
        ),
        duration: const Duration(seconds: 2),
        elevation: 3,
      ),
    );
  }
}
