import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../core/widgets/widgets.dart';
import 'saved_viewmodel.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.viewModel});

  final SavedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.savedTitle,
        actions: [
          CustomIconButton.normal(icon: CustomIcons.filter, onTap: () {}),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, child) {
          if (viewModel.load.completed) {
            return child!;
          } else if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error loading saved items'));
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return const Center(child: Text('Saved items loaded'));
          },
        ),
      ),
    );
  }
}
