
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AdManager.dart';
import 'main.dart';

bool isPurchased = true;

String AUDIO_CATEGORY = "";
String BOOKS_CATEGORY = "";
String VIDEO_CATEGORY = "";
String PRODUCT_ID = "";

var isNativeBannerLoaded = false;
double nativeBannerAd = 330;
InterstitialAd? _interstitialAd;
int _numInterstitialLoadAttempts = 0;
const AdRequest request = AdRequest(
);

const int maxFailedLoadAttempts = 3;

consentF (){
  ConsentDebugSettings debugSettings = ConsentDebugSettings(
      debugGeography: DebugGeography.debugGeographyEea,
      testIdentifiers: ['496D874B3338DFC827B1D89327CA5B9D']);
  final params = ConsentRequestParameters(

      consentDebugSettings: debugSettings
  );
  ConsentInformation.instance.requestConsentInfoUpdate(
    params,
        () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        loadForm();
      }
    },
        (FormError error) {
      // Handle the error
    },
  );
}
void loadForm() {
  ConsentForm.loadConsentForm(
        (ConsentForm consentForm) async {
      // Present the form
    },
        (FormError formError) {
      // Handle the error
    },
  );
}

Future<void> setSharedPrefrences(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (key.isNotEmpty) {
    await prefs.setString(key, value);
  }
}

showAdmobFullScreenAds( ) async {
  if(box!=null){
    var ads_removed = box.get("ad_removed");
    if(ads_removed!=null&&ads_removed.isNotEmpty&&ads_removed=="yes") {
      return;
    }
  }
  final prefs = await SharedPreferences.getInstance();
  String? previousTime = prefs.getString('previous_time');
  if(previousTime!=null&&previousTime.isNotEmpty){
    DateTime dt1 = DateTime.parse(previousTime);
    DateTime dt2 = DateTime.now();
    Duration diff = dt2.difference(dt1);
    if(diff.inSeconds<25){
      if (_interstitialAd == null) {
        _createInterstitialAd();
      }
      return ;
    }else{
      DateTime dt1 = DateTime.now();
      String adShown = dt1.toString();
      await  prefs.setString("previous_time",adShown);
    }
  }else{
    DateTime dt1 = DateTime.now();
    String adShown = dt1.toString();
    await  prefs.setString("previous_time",adShown);
  }



  if (_interstitialAd == null) {
    _createInterstitialAd();
    return;
  }
  _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
    {

    },
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
      _createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
      _createInterstitialAd();
    },
  );
  _interstitialAd!.show();
  _interstitialAd = null;


}
void _createInterstitialAd() {
  if(box!=null){
    var ads_removed = box.get("ad_removed");
    if(ads_removed!=null&&ads_removed.isNotEmpty&&ads_removed=="yes") {
      return;
    }
  }
  InterstitialAd.load(
      adUnitId: AdManager.interstitialAdUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ));
}

class LoadAdmobBannerAds extends StatefulWidget {
  const LoadAdmobBannerAds();

  @override
  State<LoadAdmobBannerAds> createState() =>
      _LoadAdmobBannerAdsState();
}

class _LoadAdmobBannerAdsState extends State<LoadAdmobBannerAds> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(box!=null){
      var ads_removed = box.get("ad_removed");
      if(ads_removed!=null&&ads_removed.isNotEmpty&&ads_removed=="yes") {
        return;
      }else{
        _loadAd();
      }
    }else{
      _loadAd();
    }

  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      return;
    }

    _anchoredAdaptiveAd = BannerAd(

      // TODO: replace these test ad units with your own ad unit.
      adUnitId: AdManager.bannerAdUnitId,
      size: size,
      request: const AdRequest(extras: {"collapsible": "bottom"}),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },

      ),

    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) {
  //  return Container();
    if(box!=null){
      var ads_removed = box.get("ad_removed");
      if(ads_removed!=null&&ads_removed.isNotEmpty&&ads_removed=="yes") {
        return Container();
      }else{
        return (_anchoredAdaptiveAd != null && _isLoaded)? Container(
          color: Colors.transparent,
          width: _anchoredAdaptiveAd!.size.width.toDouble(),
          height: _anchoredAdaptiveAd!.size.height.toDouble(),
          child: AdWidget(ad: _anchoredAdaptiveAd!),
        ):Container();
      }
    }else{
      return (_anchoredAdaptiveAd != null && _isLoaded)? Container(
        color: Colors.transparent,
        width: _anchoredAdaptiveAd!.size.width.toDouble(),
        height: _anchoredAdaptiveAd!.size.height.toDouble(),
        child: AdWidget(ad: _anchoredAdaptiveAd!),
      ):Container();

    }
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
}



class LoadAdmobBannerAdss extends StatefulWidget {
  const LoadAdmobBannerAdss({super.key});

  @override
  State<LoadAdmobBannerAdss> createState() => _AdaptiveBannerState();
}

class _AdaptiveBannerState extends State<LoadAdmobBannerAdss> {
  bool isBannerAdLoaded = false;
  BannerAd? bannerAd;

  Future<InlineAdaptiveSize> adaptiveAdss(BuildContext context) async {
    return AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate().toInt());
  }

  void loadBannerAd() async {
   /* final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
       return;
    }*/
    bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
         // log(error.message);
        },
        onAdLoaded: (ad) {
          isBannerAdLoaded = true;
          setState(() {});
        },
      ),
      request: const AdRequest(extras: {"collapsible": "bottom"}),
    );

    bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bannerAd != null ? bannerAd!.size.height.toDouble() : 0,
      child: isBannerAdLoaded ? AdWidget(ad: bannerAd!) : const SizedBox(),
    );
  }
}
