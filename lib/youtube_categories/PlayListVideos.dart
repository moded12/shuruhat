import 'dart:convert';

import 'package:naat_app/MultipleGridView.dart';
import 'package:naat_app/constans.dart';
import 'package:naat_app/services.dart';
import 'package:naat_app/youtube_categories/VideoScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayListVideos extends StatefulWidget {
 late String title;
 late String api_url;
  PlayListVideos(String title,String api_url){
    this.title = title;
    this.api_url = api_url;

  }
  @override
  _PlayListVideosState createState() => _PlayListVideosState();
}

class _PlayListVideosState extends State<PlayListVideos> {
  List allSeasons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Text(widget.title,style: GoogleFonts.cairo(textStyle: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        )),),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder(
              future: getApiResponse(widget.api_url),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    var convertedJson = jsonDecode(snapshot.data.toString());
                    allSeasons = convertedJson['items'];

                    return Container(
                      child: ListView.builder(
                        itemCount: allSeasons.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index ==1) {
                            return Column(children: [
                         //     showNativeBannerAd(),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                                child: Ink(
                                  child: Card(
                                    elevation: 18.0,
                                    child: Container(
                                      child: ListTile(
                                        onTap: () {
                                          String videoId =  allSeasons[index]['snippet']['resourceId']['videoId'];
                                         /* Navigator.push(context, MaterialPageRoute(builder: (context){
                                            return VideoScreen(videoId);
                                          }));*/
                                        },
                                        contentPadding: EdgeInsets.all(15),
                                        title: Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            allSeasons[index]['snippet']['title'],
                                            style: GoogleFonts.cairo(textStyle: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 16.0,
                                            )),
                                            maxLines: 2,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            allSeasons[index]['snippet']['description'],
                                            style: GoogleFonts.cairo(textStyle: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 12.0,
                                            )),
                                            maxLines: 2,
                                          ),
                                        ),
                                        leading: Card(
                                          elevation: 18.0,
                                          color: Color(0xFF000000),
                                          child: Image.network(allSeasons[index]['snippet']['thumbnails']['medium']['url']),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],);
                          }else{
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                              child: Ink(
                                child: Card(
                                  elevation: 18.0,
                                  child: Container(
                                    child: ListTile(
                                      onTap: () {
                                        String videoId =  allSeasons[index]['snippet']['resourceId']['videoId'];
                                      /*  Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return VideoScreen(videoId);
                                        }));*/
                                      },
                                      contentPadding: EdgeInsets.all(15),
                                      title: Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          allSeasons[index]['snippet']['title'],
                                          style: GoogleFonts.cairo(textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 16.0,
                                          )),
                                          maxLines: 2,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          allSeasons[index]['snippet']['description'],
                                          style: GoogleFonts.cairo(textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 12.0,
                                          )),
                                          maxLines: 2,
                                        ),
                                      ),
                                      leading: Card(
                                        elevation: 18.0,
                                        color: Color(0xFF000000),
                                        child: Image.network(allSeasons[index]['snippet']['thumbnails']['medium']['url']),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
