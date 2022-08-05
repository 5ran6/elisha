import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elisha/src/repositories/theme_manager_repository.dart';

final themeRepositoryProvider = ChangeNotifierProvider<ThemeManagerRepository>((ref) {
  return ThemeManagerRepository();
});
