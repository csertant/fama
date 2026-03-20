import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../routing/routes.dart';
import '../core/widgets/widgets.dart';
import 'sources_viewmodel.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key, required this.viewModel});

  final SourcesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.sourcesTitle,
        actions: [
          CustomIconButton.redirectInApp(
            icon: CustomIcons.add,
            route: Routes.feed,
            context: context,
          ),
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
            return const Center(child: Text('Error loading sources'));
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return const Center(child: Text('Sources loaded'));
          },
        ),
      ),
    );
  }
}
