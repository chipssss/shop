// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:shop/data/gallery_options.dart';
import 'package:shop/l10n/gallery_localizations.dart';
import 'package:shop/l10n/strings_resource.dart';
import 'package:shop/layout/adaptive.dart';
import 'package:shop/layout/text_scale.dart';
import '../constants.dart';
import 'app.dart';
import 'colors.dart';
import 'package:shop/model/app_state_model.dart';
import 'package:shop/model/product.dart';
import 'page_status.dart';
import 'triangle_category_indicator.dart';

double desktopCategoryMenuPageWidth({
  BuildContext context,
}) {
  return 232 * reducedTextScale(context);
}

class CategoryMenuPage extends StatelessWidget {
  CategoryMenuPage({Key key, this.onCategoryTap, this.onSearchChange, @required this.tabController})
      : super(key: key);

  final VoidCallback onCategoryTap;
  final TabController tabController;
  final DataCallback<String> onSearchChange;

  Duration _tabSwitchDuration = const Duration(milliseconds: 0);

  Widget _buttonText(String caption, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        caption,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _divider({BuildContext context}) {
    return Container(
      width: 56 * GalleryOptions.of(context).textScaleFactor(context),
      height: 1,
      color: const Color(0xFF8F716D),
    );
  }

  Widget _buildCategory(Category category, BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    final categoryString = category.name(context);

    final selectedCategoryTextStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(fontSize: isDesktop ? 17 : 19);

    final unselectedCategoryTextStyle = selectedCategoryTextStyle.copyWith(
        color: shrineBrown900.withOpacity(0.6));

    final indicatorHeight = (isDesktop ? 28 : 30) *
        GalleryOptions.of(context).textScaleFactor(context);
    final indicatorWidth = indicatorHeight * 34 / 28;

    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => Semantics(
        selected: model.selectedCategory == category,
        button: true,
        child: GestureDetector(
          onTap: () {
            tabController.animateTo(0, duration: _tabSwitchDuration);
            model.setCategory(category);
            if (onCategoryTap != null) {
              onCategoryTap();
            }
          },
          child: model.selectedCategory == category
              ? CustomPaint(
                  painter: TriangleCategoryIndicator(
                    indicatorWidth,
                    indicatorHeight,
                  ),
                  child: _buttonText(categoryString, selectedCategoryTextStyle),
                )
              : _buttonText(categoryString, unselectedCategoryTextStyle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    final logoutTextStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: isDesktop ? 17 : 19,
          color: shrineBrown900.withOpacity(0.6),
        );

    if (isDesktop) {
      return AnimatedBuilder(
        animation: PageStatus.of(context).cartController,
        builder: (context, child) => ExcludeSemantics(
          excluding: !menuPageIsVisible(context),
          child: Material(
            child: Container(
              color: shrinePink100,
              width: desktopCategoryMenuPageWidth(context: context),
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  Image.asset(
                    'packages/shrine_images/diamond.png',
                    excludeFromSemantics: true,
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    container: true,
                    child: Text(
                      'SHRINE',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  const Spacer(),
                  for (final category in categories)
                    _buildCategory(category, context),
                  _divider(context: context),
                  Semantics(
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        tabController.animateTo(1, duration: _tabSwitchDuration);
                        Navigator.of(context).pushNamed(ShrineApp.orderRoute);
                      },
                      child: _buttonText(
                        TextRes.ORDER,
                        logoutTextStyle,
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(ShrineApp.loginRoute);
                      },
                      child: _buttonText(
                        GalleryLocalizations.of(context)
                            .shrineLogoutButtonCaption,
                        logoutTextStyle,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.all(6),
                    child: TextFormField(
                      onChanged: onSearchChange,
                      cursorColor: shrineBrown600,
                      decoration: InputDecoration(
                          suffix: SizedBox(width: 10,),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            tooltip:
                            GalleryLocalizations.of(context).shrineTooltipSearch,
                          )),
                    ),
                  ),
                  const SizedBox(height: 72),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return AnimatedBuilder(
        animation: PageStatus.of(context).cartController,
        builder: (context, child) => AnimatedBuilder(
          animation: PageStatus.of(context).menuController,
          builder: (context, child) => ExcludeSemantics(
            excluding: !menuPageIsVisible(context),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 40),
                color: shrinePink100,
                child: ListView(
                  children: [
                    for (final category in categories)
                      _buildCategory(category, context),
                    Center(
                      child: _divider(context: context),
                    ),
                    Semantics(
                      button: true,
                      child: GestureDetector(
                        onTap: () {
                          if (onCategoryTap != null) {
                            onCategoryTap();
                          }
                          Navigator.of(context).pushNamed(ShrineApp.loginRoute);
                        },
                        child: _buttonText(
                          GalleryLocalizations.of(context)
                              .shrineLogoutButtonCaption,
                          logoutTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
