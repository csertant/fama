import 'package:flutter/material.dart';

import '../core/widgets/widgets.dart';
import 'feed_viewmodel.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key, required this.viewModel});

  final FeedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          CustomIconButton.normal(icon: CustomIcons.read, onTap: () {}),
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
            return const Center(child: Text('Error loading feed'));
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return const Center(child: Text('Feed loaded'));
          },
        ),
      ),
    );
  }
}
