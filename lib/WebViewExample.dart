// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naat_app/books_categories/src/menu.dart';
import 'package:naat_app/books_categories/src/navigation_controls.dart';
import 'package:naat_app/books_categories/src/web_view_stack.dart';
import 'package:naat_app/constans.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
 late String server;
  WebViewApp(String server) {
    this.server = server;

  }

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: const Text('Flutter WebView'),
        actions: [
           NavigationControls(  controller),
           Menu( controller),
        ],
      ),*/
      body: Column(
        children: [
          Expanded(child: WebViewExample(  widget.server)),

       //   LoadAdmobBannerAds(),
        ],
      ),
    );
  }
}