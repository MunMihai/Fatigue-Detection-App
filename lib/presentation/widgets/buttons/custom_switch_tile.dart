import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/theme/color_scheme_extensions.dart';
import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value; 
  final ValueChanged<bool> onChanged;

  const CustomSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value, 
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.h4(context),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.6, 
              child: Text(
                subtitle,
                style: AppTextStyles.helper,
                softWrap: true,
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          activeColor: Theme.of(context).colorScheme.primaryButton,
          thumbColor: const WidgetStatePropertyAll<Color>(Colors.white),
          inactiveTrackColor: Theme.of(context).colorScheme.primary,
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
