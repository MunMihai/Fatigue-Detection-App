import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/theme/color_scheme_extensions.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading; 
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.h1(context)),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 5,
      leading: leading,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 3,
          color: Theme.of(context).colorScheme.stroke, 
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
