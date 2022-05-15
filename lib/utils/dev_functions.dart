import '../src/models/devotional.dart';
import '../src/services/devotional_helper.dart';

class DevotionalItemsRetrieveClass {

  static Future<String> getTodayVerse(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance
        .getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].memoryVerse;
      }
    }
    throw '';

  }

  static Future<String> getTodayVersePassage(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance
        .getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].memoryVersePassage;
      }
    }
    throw '';
  }

  static Future<String> getTodayTitle(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance
        .getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].title;
      }
    }
    throw '';
  }

  static Future<String> getTodayMainWriteUp(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance
        .getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].fullText;
      }
    }
    throw '';
  }

  static Future<String> getTodayPrayer(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance
        .getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        print('kkkkkkkkkkkkkkkkkkkkkkkkkk');
        print(devs[i].prayerBurden);
        return devs[i].prayerBurden;
      }
    }
    throw '';
  }

  static Future<String> getTodayThoughtOfTheDay(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance
        .getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].thoughtOfTheDay;
      }
    }
    throw '';
  }

  static Future<String> getImage(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance
        .getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].image;
      }
    }
    throw '';
  }

}
