
import 'package:elisha/src/models/note.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';

import 'GetProvider.dart';

class NoteController extends GetxController with StateMixin<List<Note>>{

  @override
  void onInit() {
    super.onInit();
    GetProvider().fetchNotes().then((value) {
      change(value, status: RxStatus.success());
    },onError: (error){
      change(null,status: RxStatus.error(error.toString()));
    });
  }

  @override
  void refresh() {

  }
}