import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading; 

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.h1),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 5,
      leading: leading,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 3,
          color: Theme.of(context).colorScheme.stroke, // culoarea stroke-ului
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
