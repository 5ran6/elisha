import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:flutter/cupertino.dart';

class DNDRepository with ChangeNotifier {
  String dndStatus = "off";
  String get currentDNDStatus => dndStatus;

  void changeDNDStatus(newStatus) {
    PrefManager.setDND(newStatus);
    dndStatus = newStatus;
    notifyListeners();
  }
}
