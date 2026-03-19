import 'package:flutter/material.dart';

import 'saved_viewmodel.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.viewModel});

  final SavedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Saved screen'));
  }
}
