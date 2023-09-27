import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2940615698168678/6765060844';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2940615698168678/9322941429';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

}
