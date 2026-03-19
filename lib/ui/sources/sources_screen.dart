import 'package:flutter/material.dart';

import 'sources_viewmodel.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key, required this.viewModel});

  final SourcesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Sources screen'));
  }
}
