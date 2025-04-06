import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsMenuButton extends StatelessWidget {
  const SettingsMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (String value) {
        if (value == 'language') {
          _openLanguageSelector(context);
        } else if (value == 'theme') {
          _toggleTheme(context);
        } else if (value == 'faq') {
          _openFaqPage(context);
        } else if (value == 'about us') {
          _openContactPage(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'language', // <-- adăugăm value
          child: ListTile(
            leading: const Icon(Icons.language),
            title: Text(tr.language),
          ),
        ),
        PopupMenuItem<String>(
          value: 'theme', // <-- adăugăm value
          child: ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(tr.theme),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'faq',
          child: ListTile(
            leading: Icon(Icons.help_outline),
            title: Text(tr.faqs),
          ),
        ),
        PopupMenuItem<String>(
          value: 'about us',
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(tr.aboutUs),
          ),
        ),
      ],
    );
  }

  static void _openLanguageSelector(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width - 0, 0, 
        0,
        0,
      ),
      items: const [
        PopupMenuItem<String>(
          value: 'en',
          child: Text('English'),
        ),
        PopupMenuItem<String>(
          value: 'ro',
          child: Text('Română'),
        ),
        PopupMenuItem<String>(
          value: 'ru',
          child: Text('Русский'),
        ),
      ],
    ).then((selectedValue) {
      if (!context.mounted) return;
      if (selectedValue != null) {
        context.read<SettingsProvider>().updateLanguageCode(selectedValue);
      }
    });
  }

  static void _toggleTheme(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    showMenu<ThemeMode>(
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width - 0, 0, 
        0,
        0,
      ),
      items: [
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          child: ListTile(
            leading: Icon(Icons.light_mode),
            title: Text(tr.lightTheme),
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          child: ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text(tr.darkTheme),
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.system,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text(tr.systemDefaultTheme),
          ),
        ),
      ],
    ).then((selectedTheme) {
      if (!context.mounted) return;
      if (selectedTheme != null) {
        context.read<SettingsProvider>().updateThemeMode(selectedTheme);
      }
    });
  }

  static void _openFaqPage(BuildContext context) {
    context.push('/faqs');
  }

  static void _openContactPage(BuildContext context) {
    context.push('/aboutUs');
  }
}
