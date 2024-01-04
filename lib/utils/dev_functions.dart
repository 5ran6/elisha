import '../src/models/devotional.dart';
import '../src/services/devotionalDB_helper.dart';

class DevotionalItemsRetrieveClass {
  static Future<String?> getTodayVerse(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].memoryVerse;
      }
    }
    return null;
  }

  static Future<String?> getTodayVersePassage(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].memoryVersePassage;
      }
    }
    return null;
  }

  static Future<String?> getTodayTitle(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].title;
      }
    }
    return null;
  }

  static Future<String?> getTodayFullPassage(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].fullPassage;
      }
    }
    return null;
  }

  static Future<String?> getTodayMainWriteUp(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].fullText;
      }
    }
    return null;
  }

  static Future<String?> getTodayPrayer(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].prayerBurden;
      }
    }
    return null;
  }

  static Future<String?> getTodayThoughtOfTheDay(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].thoughtOfTheDay;
      }
    }
    return null;
  }

  static Future<String?> getImage(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].image;
      }
    }
    return null;
  }

  static Future<String?> getMemoryVerseImage(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].memoryVerseImageToShare;
      }
    }
    return null;
  }

  static Future<String?> getThoughtOfTheDayImage(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].thoughtOfTheDayImageToShare;
      }
    }
    return null;
  }

  static Future<String?> getPrayerBurdenImage(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].prayerBurdenImageToShare;
      }
    }
    return null;
  }

  static Future<String?> getBibleInYear(String todayDate) async {
    List<Devotional> devs = await DevotionalDBHelper.instance.getDevotionalsDB();
    for (int i = 0; i < devs.length; i++) {
      if (devs[i].date == todayDate) {
        return devs[i].bibleInAYear;
      }
    }
    return null;
  }
}
