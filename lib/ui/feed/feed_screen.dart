import 'package:flutter/material.dart';

import 'feed_viewmodel.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key, required this.viewModel});

  final FeedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Feed screen'));
  }
}
