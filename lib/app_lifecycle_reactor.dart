
 import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_open_ad_manager.dart';
import 'main.dart';

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({ required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    print('New AppState state: $appState');
    if (appState == AppState.foreground) {
      if(box!=null){
        var ads_removed = box.get("ad_removed");
        if(ads_removed!=null&&ads_removed.isNotEmpty&&ads_removed=="yes") {

        }else{
          appOpenAdManager.showAdIfAvailable();
        }
      }else {
        appOpenAdManager.showAdIfAvailable();
      }
    }
  }
}
