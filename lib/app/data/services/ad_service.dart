import 'package:get/get.dart';

class AdService extends GetxService {
  Future<AdService> init() async {
    // AdMob logic disabled by request
    return this;
  }

  // Placeholder methods to prevent breaking calls if any exist
  String get bannerAdUnitId => '';
  String get interstitialAdUnitId => '';
}
