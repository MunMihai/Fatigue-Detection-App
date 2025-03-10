import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/arrow_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsSection extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reports', style: AppTextStyles.h2 ),
        AppSpaceses.verticalMedium,
        ArrowButton(title: 'View driving session reports', onPressed: ()=>context.go('/reports'))
      ],
    );
  }

}