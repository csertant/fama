import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import 'custom_icon.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const CustomIcon(iconPath: CustomIcons.feed),
            label: localizations.navigationLabelFeed,
          ),
          NavigationDestination(
            icon: const CustomIcon(iconPath: CustomIcons.sources),
            label: localizations.navigationLabelSources,
          ),
          NavigationDestination(
            icon: const CustomIcon(iconPath: CustomIcons.saved),
            label: localizations.navigationLabelSaved,
          ),
          NavigationDestination(
            icon: const CustomIcon(iconPath: CustomIcons.settings),
            label: localizations.navigationLabelSettings,
          ),
        ],
      ),
    );
  }
}
