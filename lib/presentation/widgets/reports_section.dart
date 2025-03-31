import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/arrow_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsSection extends StatelessWidget{
  const ReportsSection({super.key});


  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.reports, style: AppTextStyles.h2 ),
        AppSpaceses.verticalMedium,
        ArrowButton(title: tr.viewReports, onPressed: ()=>context.push('/reports'))
      ],
    );
  }

}