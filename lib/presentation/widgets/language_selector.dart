import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String value) {
        context.read<SettingsProvider>().updateLanguageCode(value);
      },
      itemBuilder: (BuildContext context) => const [
        PopupMenuItem(
          value: 'en',
          child: Text('English'),
        ),
        PopupMenuItem(
          value: 'ro',
          child: Text('Română'),
        ),
        PopupMenuItem(
          value: 'ru',
          child: Text('Русский'),
        ),
      ],
    );
  }
}
