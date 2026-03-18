import 'package:flutter/material.dart';

import '../../data/repositories/source/source_repository.dart';

class SubscribeViewModel extends ChangeNotifier {
  SubscribeViewModel({required SourceRepository sourceRepository})
    : _sourceRepository = sourceRepository;

  final SourceRepository _sourceRepository;
}
