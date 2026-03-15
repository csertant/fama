import 'package:flutter/material.dart';

import '../../data/repositories/profile/profile_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  final ProfileRepository _profileRepository;
}
