import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../core/themes/dimensions.dart';
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
        actions: [CustomIconButton.normal(icon: CustomIcons.add, onTap: () {})],
      ),
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, child) {
          if (viewModel.load.completed) {
            return child!;
          } else if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ErrorIndicator(
              title: localizations.sourcesLoadErrorTitle,
              label: localizations.sourcesLoadErrorLabel,
              onPressed: viewModel.load.execute,
            );
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return viewModel.sources.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingMedium,
                    ),
                    itemCount: viewModel.sources.length,
                    itemBuilder: _buildSourceCard,
                  )
                : Center(
                    child: Text(
                      localizations.sourcesEmptyLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildSourceCard(BuildContext context, int index) {
    final source = viewModel.sources[index];
    return SourceCard(
      source: source,
      onModifySource: () async {
        await viewModel.modifySource(source);
      },
      onRemoveSource: () async {
        await viewModel.removeSource(source);
      },
    );
  }
}
