import 'package:flutter/material.dart';

import '../../data/repositories/source/source_repository.dart';

class SourcesViewModel extends ChangeNotifier {
  SourcesViewModel({required SourceRepository sourceRepository})
    : _sourceRepository = sourceRepository;

  final SourceRepository _sourceRepository;
}
