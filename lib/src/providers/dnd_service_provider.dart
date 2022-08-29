import 'package:elisha/src/repositories/dnd_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dndRepositoryProvider = ChangeNotifierProvider<DNDRepository>((ref) {
  return DNDRepository();
});
