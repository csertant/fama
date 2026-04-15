import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/connectivity_service/connectivity_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../routing/routes.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/widgets.dart';
import 'sources_viewmodel.dart';
import 'widgets/source_card.dart';

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({super.key, required this.viewModel});

  final SourcesViewModel viewModel;

  @override
  State<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.removeSource.addListener(_onRemoveSourceResult);
  }

  @override
  void didUpdateWidget(covariant SourcesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.removeSource.removeListener(_onRemoveSourceResult);
    widget.viewModel.removeSource.addListener(_onRemoveSourceResult);
  }

  @override
  void dispose() {
    widget.viewModel.removeSource.removeListener(_onRemoveSourceResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final connectivityService = context.watch<ConnectivityService>();
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.sourcesTitle,
        actions: [
          CustomIconButton.redirectInApp(
            context: context,
            icon: CustomIcons.add,
            route: Routes.explore,
            tooltip: localizations.navigationLabelExplore,
          ),
        ],
      ),
      body: Column(
        children: [
          if (connectivityService.isOffline)
            CustomErrorBanner(
              message: localizations.noInternetConnectionTitle,
              iconPath: CustomIcons.noInternet,
            ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.completed) {
                  return child!;
                } else if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ErrorIndicator(
                    title: localizations.sourcesLoadErrorTitle,
                    label: localizations.sourcesLoadErrorLabel,
                    onPressed: widget.viewModel.load.execute,
                  );
                }
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  return widget.viewModel.sources.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium,
                          ),
                          itemCount: widget.viewModel.sources.length,
                          itemBuilder: _buildSourceCard,
                          separatorBuilder: (context, index) =>
                              const CustomDivider(),
                        )
                      : CustomPlaceholder(
                          message: localizations.sourcesEmptyLabel,
                          action: CustomIconButton.redirectInApp(
                            context: context,
                            icon: CustomIcons.add,
                            route: Routes.explore,
                            tooltip: localizations.navigationLabelExplore,
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard(BuildContext context, int index) {
    final source = widget.viewModel.sources[index];
    return SourceCard(
      source: source,
      onRemoveSource: () {
        unawaited(widget.viewModel.removeSource.execute(source));
      },
    );
  }

  void _onRemoveSourceResult() {
    final localizations = AppLocalizations.of(context)!;
    showFeedbackOnResult(
      context: context,
      action: widget.viewModel.removeSource,
      successMessage: localizations.sourceRemoved,
      errorMessage: localizations.errorWhileRemovingSource,
    );
  }
}
