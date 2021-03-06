// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:shop/data/gallery_options.dart';
import 'package:shop/l10n/gallery_localizations.dart';
import 'package:shop/layout/adaptive.dart';
import '../Utils.dart';
import 'backdrop.dart';
import 'category_menu_page.dart';
import 'expanding_bottom_sheet.dart';
import 'home.dart';
import 'login.dart';
import 'package:shop/model/app_state_model.dart';
import 'order/order_view.dart';
import 'page_status.dart';
import 'scrim.dart';
import 'supplemental/layout_cache.dart';
import 'theme.dart';
import 'package:scoped_model/scoped_model.dart';

class ShrineApp extends StatefulWidget {

  const ShrineApp();

  static const String loginRoute = '/shrine/login';
  static const String homeRoute = '/shrine';
  static const String orderRoute = '/shrine/order';

  static const int PAGE_INDEX_PRODUCT = 0;
  static const int PAGE_INDEX_ORDER = 1;

  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> with TickerProviderStateMixin {
  // Controller to coordinate both the opening/closing of backdrop and sliding
  // of expanding bottom sheet
  AnimationController _menuController;

  // Animation Controller for expanding/collapsing the cart menu.
  AnimationController _expandingController;

  TabController _tabController;
  static const int TAB_LEN = 2;

  AppStateModel _model;

  final Map<String, List<List<int>>> _layouts = {};


  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1,
    );
    _expandingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _tabController = TabController(length: TAB_LEN, vsync: this);
    _model = AppStateModel()..loadProducts();
  }

  @override
  void dispose() {
    _menuController.dispose();
    _expandingController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget mobileBackdrop() {
    return Backdrop(
      frontLayer: buildPageView(),
      backLayer: CategoryMenuPage(
          onCategoryTap: () => _menuController.forward(),
          onSearchChange: onSearchChange, tabController: _tabController,),
      frontTitle: const Text('SHRINE'),
      backTitle: Text(GalleryLocalizations.of(context).shrineMenuCaption),
      controller: _menuController,
    );
  }

  Widget desktopBackdrop() {
    return DesktopBackdrop(
      frontLayer: buildPageView(),
      backLayer: CategoryMenuPage(
        onCategoryTap: () {

        },
        onSearchChange: onSearchChange, tabController: _tabController,
      ),
    );
  }
  
  Widget buildPageView() {
    return TabBarView(
      controller: _tabController,
      children: [
        ProductPage(),
        OrderPage()
      ],
      physics: NeverScrollableScrollPhysics(),
    );
  }

  // Closes the bottom sheet if it is open.
  Future<bool> _onWillPop() async {
    final status = _expandingController.status;
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.forward) {
      _expandingController.reverse();
      return false;
    }

    return true;
  }

  void onSearchChange(String input) {
    print('search change: $input');
    _model.search(input);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    final backdrop = isDesktop ? desktopBackdrop() : mobileBackdrop();
    final Widget home = LayoutCache(
      layouts: _layouts,
      child: PageStatus(
        menuController: _menuController,
        cartController: _expandingController,
        child: HomePage(
          backdrop: backdrop,
          scrim: Scrim(controller: _expandingController),
          expandingBottomSheet: ExpandingBottomSheet(
            hideController: _menuController,
            expandingController: _expandingController,
          ),
        ),
      ),
    );

    return ScopedModel<AppStateModel>(
      model: _model,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: MaterialApp(
          title: 'Shrine',
          debugShowCheckedModeBanner: false,
          initialRoute: GlobalConfig.isDebug? ShrineApp.homeRoute: ShrineApp.loginRoute,
          onGenerateInitialRoutes: (_) {
            return [
              MaterialPageRoute<void>(
                builder: (context) => const LoginPage(),
              ),
            ];
          },
          routes: {
            ShrineApp.loginRoute: (context) => const LoginPage(),
            ShrineApp.homeRoute: (context) {
              return home;
            },
            ShrineApp.orderRoute: (context) {
              return home;
            }
          },
          theme: shrineTheme.copyWith(
            platform: GalleryOptions.of(context).platform,
          ),
          // L10n settings.
          localizationsDelegates: GalleryLocalizations.localizationsDelegates,
          supportedLocales: GalleryLocalizations.supportedLocales,
          locale: GalleryOptions.of(context).locale,
        ),
      ),
    );
  }
}



