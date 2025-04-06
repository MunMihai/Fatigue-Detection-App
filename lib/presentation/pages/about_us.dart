import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/theme/color_scheme_extensions.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: 'Driver Guard'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpaceses.mediumSpace),
        children: [
          _buildInfoCard(
            context,
            title: tr.aboutAppTitle,
            content: tr.aboutAppContent,
          ),
          AppSpaceses.verticalLarge,
          _buildInfoCard(
            context,
            title: tr.aboutAuthorTitle,
            content: tr.aboutAuthorContent,
          ),
          AppSpaceses.verticalLarge,
          _buildInfoCard(
            context,
            title: tr.contactUs,
            content: tr.contactContent,
          ),
          AppSpaceses.verticalExtraLarge,
          Divider(color: Theme.of(context).colorScheme.stroke),
          AppSpaceses.verticalSmall,
          Text(
            '© 2025 Driver Guard — ${tr.allRightsReserved}',
            textAlign: TextAlign.center,
            style: AppTextStyles.medium_12(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor:
          Theme.of(context).colorScheme.primaryButton.withValues(alpha: 0.2),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpaceses.mediumSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.h3(context),
            ),
            AppSpaceses.verticalMedium,
            Text(
              content,
              style: AppTextStyles.medium_12(context).copyWith(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
