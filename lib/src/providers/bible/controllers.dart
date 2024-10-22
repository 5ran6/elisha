
import 'package:elisha/src/providers/bible/bible_service.dart';
import 'package:get/get.dart';
export 'bible_service.dart';

Future<void> initControllers() async {
  Get.put(BibleService());
}
