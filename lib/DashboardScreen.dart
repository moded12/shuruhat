import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:launch_review/launch_review.dart';
import 'package:naat_app/Model/AllApps.dart';
import 'package:naat_app/Model/RecordsModel.dart';
import 'package:naat_app/MultipleGridView.dart';
import 'package:naat_app/WebViewExample.dart';
import 'package:naat_app/apiConstants.dart';
import 'package:naat_app/audio_categories/AudioCategories.dart';
import 'package:naat_app/audio_categories/QuranReciters.dart';
import 'package:naat_app/books_categories/OpenPdfExternal.dart';

//import 'package:naat_app/books_categories/WebViewPage.dart';
import 'package:naat_app/books_categories/web_view_screen.dart';
import 'package:naat_app/constans.dart';
import 'package:naat_app/main.dart';
import 'package:naat_app/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AdManager.dart';
import '../AdManager.dart';
import '../constans.dart';
import '../tasbeeh.dart';
import 'books_categories/BooksCategories.dart';
import 'books_categories/ReadQuran.dart';

class DashboardScreen extends StatefulWidget {
  late String title;
  late String api_url;
  static String BOOK_CATEGORIES = "";

  DashboardScreen(String title, String api_url) {
    this.title = title;
    this.api_url = api_url;
  }

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<AppsList> allSeasons = [];
  bool _hasRemovedAds = false;

  @override
  Widget build(BuildContext context) {
    return widget.title.isEmpty
        ? Container(
      color: AdManager.getNeumorphicBackgroundColor(),

      child: Column(
                children: [
          // Text widget to show the 2024 - 2025 منہاج جدید و مطور
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "2025 - 2024 منہاج جدید و مطور",
              style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: showData()),
                ],
              ),
        )
        : Scaffold(
            backgroundColor: AdManager.getNeumorphicBackgroundColor(),
            appBar: AppBar(
              backgroundColor: AdManager.getNeumorphicBackgroundColor(),
              iconTheme: IconThemeData(color: Colors.white),
              title: Center(
                  child: Text(
                widget.title,
                style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              actions: <Widget>[
                loadInAppWidget() == null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          iconSize: 25,
                          icon: Image.asset(
                            'assets/images/star.png',
                            fit: BoxFit.cover,
                            height: 25,
                          ),
                          onPressed: () {
                            if (Platform.isAndroid) {
                              LaunchReview.launch(
                                  androidAppId: "" + AdManager.packageName);
                            } else {
                              LaunchReview.launch(
                                  iOSAppId: "" + AdManager.packageName);
                            }
                          },
                        ),
                      )
                    : loadInAppWidget(),
              ],
            ),
            body: Column(
              children: [
                // Text widget to show the 2024 - 2025 منہاج جدید و مطور
                Text(
                  "2024 - 2025 منہاج جدید و مطور",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(child: showData()),
              ],
            ),
          );
  }

  loadInAppWidget() {
    return null;
    if (box != null) {
      var ads_removed = box.get("ad_removed");
      if (ads_removed != null &&
          ads_removed.isNotEmpty &&
          ads_removed == "yes") {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            iconSize: 25,
            icon: Image.asset(
              'assets/images/star.png',
              fit: BoxFit.cover,
              height: 25,
            ),
            onPressed: () {
              if (Platform.isAndroid) {
                LaunchReview.launch(androidAppId: "" + AdManager.packageName);
              } else {
                LaunchReview.launch(iOSAppId: "" + AdManager.packageName);
              }
            },
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ElevatedButton(
            onPressed: () {
              // Add your onPressed logic here
              _removeAds();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.red)))),
            child: Text(
              'لإلغاء الإعلانات',
              style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      color: AdManager.getTextColor(),
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ElevatedButton(
          onPressed: () {
            // Add your onPressed logic here
            _removeAds();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: Colors.red)))),
          child: Text(
            'لإلغاء الإعلانات',
            style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: AdManager.getTextColor(),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }
  }

  Future<void> _removeAds() async {
    Fluttertoast.showToast(
        msg: "جاري تحميل خيار الدفع...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings != null && offerings.current != null) {
        Package? package = offerings.current?.availablePackages.first;

        await Purchases.purchasePackage(package!);
        // setState(() {
        //    _hasRemovedAds = true;
        //  });
        // After purchasing, refresh ad removal status
        await _checkAdRemovalStatus();
      } else {
        print('Offerings current is null');
      }
    } catch (e) {
      print('Error removing ads: $e');
    }
  }

  Future<void> _checkAdRemovalStatus() async {
    try {
      CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();

      // Replace 'ad_removal_entitlement' with the identifier of your ad removal entitlement
      if (purchaserInfo.entitlements.active
          .containsKey('ad_removal_entitlement')) {
        // User has removed ads with payment
        setState(() {
          if (box != null) {
            box.put("ad_removed", "yes");
          }
          _hasRemovedAds = true;
        });
        RestartWidget.restartApp(context);
      }
    } catch (e) {
      print('Error checking ad removal status: $e');
    }
  }

  showDataOffline(String apiUrl) {
    if (apiUrl != null && apiUrl.isNotEmpty) {
      String? body = box.get(apiUrl);
      if (body != null && body.isNotEmpty) {
        allSeasons = AllApps.fromJson(jsonDecode(body)).appsList;
        String hasCategory = allSeasons[0].hasCategory;

        String title = allSeasons[0].name;
        if (hasCategory.isEmpty || hasCategory == "no") {
          String link = allSeasons[0].fileName;
          String server = allSeasons[0].server;
          if (link != null && link.isNotEmpty && link == "link") {
            return WebViewApp(server);
          } else if (link != null &&
              link.isNotEmpty &&
              link == "link_external") {
            return OpenPdfExternal(title, server);
          } else {
            return WebViewScreen(title, allSeasons);
          }
        } else {
          return Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: allSeasons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                        child: Ink(
                          child: Card(
                            color: AdManager.getRandomColor(),
                            elevation: 18.0,
                            child: new Directionality(
                              textDirection: TextDirection.rtl,
                              child: ListTile(
                                onTap: () {
                                  showAds++;
                                  if (showAds % 3 == 0) {
                                    showAdmobFullScreenAds();
                                  } else {
                                    showAdmobFullScreenAds();
                                  }
                                  goTo(hasCategory, context, index);
                                },
                                contentPadding: EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    allSeasons[index].name,
                                    style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                      color: AdManager.getTextColor(),
                                      fontSize: 16.0,
                                    )),
                                    maxLines: 2,
                                  ),
                                ),
                                leading: allSeasons[index].img.isNotEmpty
                                    ? Image.network(
                                        allSeasons[index].img,
                                        width: 40,
                                        height: 40,
                                      )
                                    : Icon(
                                        Icons.menu_book_sharp,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                allSeasons.length > 4 ? LoadAdmobBannerAds() : Container()
              ],
            ),
          );
        }
      } else {
        return CircularProgressIndicator();
      }
    } else {
      return CircularProgressIndicator();
    }
  }

  showData() {
    return Scaffold(
      backgroundColor: Color(0xFF1C3C47),
      body: Center(
        child: Container(
          child: FutureBuilder(
              future: getApiResponse(widget.api_url),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    allSeasons =
                        AllApps.fromJson(jsonDecode(snapshot.data)).appsList;
                    String hasCategory = allSeasons[0].hasCategory;

                    String title = allSeasons[0].name;
                    if (hasCategory.isEmpty || hasCategory == "no") {
                      String link = allSeasons[0].fileName;
                      String server = allSeasons[0].server;
                      if (link != null && link.isNotEmpty && link == "link") {
                        return WebViewApp(server);
                      } else if (link != null &&
                          link.isNotEmpty &&
                          link == "link_external") {
                        return OpenPdfExternal(title, server);
                      } else {
                        return WebViewScreen(title, allSeasons);
                      }
                    } else {
                      return Container(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: allSeasons.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 5.0,
                                        bottom: 5.0),
                                    child: Ink(
                                      child: Card(
                                        color: AdManager.getRandomColor(),
                                        elevation: 18.0,
                                        child: new Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            onTap: () {
                                              showAds++;
                                              if (showAds % 3 == 0) {
                                                showAdmobFullScreenAds();
                                              } else {
                                                showAdmobFullScreenAds();
                                              }
                                              goTo(hasCategory, context, index);
                                            },
                                            contentPadding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0.0),
                                              child: Text(
                                                allSeasons[index].name,
                                                style: GoogleFonts.cairo(
                                                    textStyle: TextStyle(
                                                  color:
                                                      AdManager.getTextColor(),
                                                  fontSize: 16.0,
                                                )),
                                                maxLines: 2,
                                              ),
                                            ),
                                            leading:
                                                allSeasons[index].img.isNotEmpty
                                                    ? Image.network(
                                                        allSeasons[index].img,
                                                        width: 40,
                                                        height: 40,
                                                      )
                                                    : Icon(
                                                        Icons.menu_book_sharp,
                                                        color: Colors.white,
                                                      ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            allSeasons.length > 0
                                ? LoadAdmobBannerAds()
                                : Container()
                          ],
                        ),
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                } else {
                  return showDataOffline(widget.api_url);
                }
              }),
        ),
      ),
    );
  }

  void goTo(String type, BuildContext context, int index) {
    type = "" + allSeasons[index].hasCategory;
    switch (type) {
      case 'tasbeeh':
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return tasbeeh();
        }));
        break;

      case 'listen_naats':
        AudioCategories.homeScreenStr = "";
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AudioCategories("Listen Naats",
              "https://example.com/apps/api/myserver_naats.json");
        }));
        break;
      case 'quran_reciters':
        QuranReciters.quran_reciters = "";
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return QuranReciters("Quran Reciters",
              "https://example.com/apps/api/quran_reciters_api.json", true);
        }));
        break;
      case 'quran_translations':
        QuranReciters.quran_reciters = "";
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return QuranReciters(
              "Quran Translations",
              "https://muslims.host/apps/ios_apps/ReadAndListenQuran/v1/quran_translations_api.json",
              true);
        }));
        break;
      case 'read_quran':
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ReadQuran("Read Quran",
              "https://example.com/apps/api/read_quran_api.json", true);
          //  return MultipleGridView( );
        }));
        break;
      case 'read_books':
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BooksCategories("Islamic Books",
              "https://example.com/apps/books/api/islamic_books.json");
          //  return MultipleGridView( );
        }));
        break;
      case 'rate_us':
        if (Platform.isAndroid) {
          LaunchReview.launch(androidAppId: "" + AdManager.packageName);
        } else {
          LaunchReview.launch(iOSAppId: "" + AdManager.packageName);
        }
        break;
      case 'more_apps':
        _launchURL();
        break;
      case 'web':
        String server = allSeasons[index].server;
        _launchWebURL(server);
        break;
      case 'share_app':
        if (Platform.isAndroid) {
          Share.share(
              'Please install this best application from Google Play Store and share it with your friends. Thanks\n ' +
                  AdManager.shareUrl,
              subject: 'Look what I made!');
        } else {
          Share.share(
              'Please install this best application from ios App Store and share it with your friends. Thanks\n ' +
                  AdManager.shareUrl,
              subject: 'Look what I made!');
        }
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          String server = allSeasons[index].server;
          String title = allSeasons[index].name;
          String hasCategory = allSeasons[index].hasCategory;

          if (hasCategory.isEmpty || server.isEmpty) {
            return Center(
                child: Container(
              child: Text(
                "No data found",
                style:
                    TextStyle(color: AdManager.getTextColor(), fontSize: 14.0),
              ),
            ));
          } else if (hasCategory == "no") {
            String link = allSeasons[0].fileName;
            if (link != null && link.isNotEmpty && link == "link") {
              return WebViewApp(server);
            } else {
              return WebViewScreen(title, allSeasons);
            }
          } else {
            return BooksCategories("" + allSeasons[index].name,
                AdManager.baseURL + "" + allSeasons[index].server);
          }
        }));
        break;
    }
  }

  _launchWebURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL() async {
    String url =
        'https://apps.apple.com/us/developer/mohammed-alsalak/id1609226760#see-all/i-phonei-pad-apps';
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/dev?id=6694032292184630684';
    } else {
      url =
          'https://apps.apple.com/us/developer/mohammed-alsalak/id1609226760#see-all/i-phonei-pad-apps';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
