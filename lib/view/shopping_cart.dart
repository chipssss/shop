// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:shop/l10n/gallery_localizations.dart';
import 'package:shop/l10n/strings_resource.dart';
import 'package:shop/layout/letter_spacing.dart';
import 'package:shop/view/widget/CommonButton.dart';
import 'colors.dart';
import 'expanding_bottom_sheet.dart';
import 'package:shop/model/app_state_model.dart';
import 'package:shop/model/product.dart';
import 'theme.dart';

const _startColumnWidth = 60.0;
const _ordinalSortKeyName = 'shopping_cart';

/// ui-购物车边栏界面
class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (id) => ShoppingCartRow(
            product: model.getProductById(id),
            quantity: model.productsInCart[id],
            onPressed: () {
              model.removeItemFromCart(id);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: shrinePink50,
      body: SafeArea(
        child: Container(
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Stack(
                children: [
                  ListView(
                    children: [
                      Semantics(
                        sortKey:
                            const OrdinalSortKey(0, name: _ordinalSortKeyName),
                        child: Row(
                          children: [
                            SizedBox(
                              width: _startColumnWidth,
                              child: IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: () =>
                                    ExpandingBottomSheet.of(context).close(),
                                tooltip: GalleryLocalizations.of(context)
                                    .shrineTooltipCloseCart,
                              ),
                            ),
                            Text(
                              GalleryLocalizations.of(context)
                                  .shrineCartPageCaption,
                              style: localTheme.textTheme.subtitle1
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              GalleryLocalizations.of(context)
                                  .shrineCartItemCount(
                                model.totalCartQuantity,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        sortKey:
                            const OrdinalSortKey(1, name: _ordinalSortKeyName),
                        child: Column(
                          children: _createShoppingCartRows(model),
                        ),
                      ),
                      Semantics(
                        sortKey:
                            const OrdinalSortKey(2, name: _ordinalSortKeyName),
                        child: ShoppingCartSummary(model: model),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                  PositionedDirectional(
                    bottom: 16,
                    start: 16,
                    end: 16,
                    child: Semantics(
                      sortKey:
                          const OrdinalSortKey(3, name: _ordinalSortKeyName),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CommonButton(
                              onPressed: model.isCartEmpty? null: () {
                                  model.settleCart();
                                  ExpandingBottomSheet.of(context).close();
                                  // tips 交易成功显示
                                },
                              text: TextRes.SETTLE_ORDER),
                          SizedBox(
                            height: 10,
                          ),
                          CommonButton(
                            onPressed: () {
                              model.clearCart();
                              ExpandingBottomSheet.of(context).close();
                            },
                            text: GalleryLocalizations.of(context)
                                .shrineCartClearButtonCaption,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({this.model});

  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final smallAmountStyle =
        Theme.of(context).textTheme.bodyText2.copyWith(color: shrineBrown600);
    final largeAmountStyle = Theme.of(context)
        .textTheme
        .headline4
        .copyWith(letterSpacing: letterSpacingOrNone(mediumLetterSpacing));
    final formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );

    return Row(
      children: [
        const SizedBox(width: _startColumnWidth),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Column(
              children: [
                MergeSemantics(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        GalleryLocalizations.of(context).shrineCartTotalCaption,
                      ),
                      Expanded(
                        child: Text(
                          formatter.format(model.totalCost),
                          style: largeAmountStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                MergeSemantics(
                  child: Row(
                    children: [
                      Text(
                        GalleryLocalizations.of(context)
                            .shrineCartSubtotalCaption,
                      ),
                      Expanded(
                        child: Text(
                          formatter.format(model.subtotalCost),
                          style: smallAmountStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                MergeSemantics(
                  child: Row(
                    children: [
                      Text(
                        GalleryLocalizations.of(context)
                            .shrineCartShippingCaption,
                      ),
                      Expanded(
                        child: Text(
                          formatter.format(model.shippingCost),
                          style: smallAmountStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                MergeSemantics(
                  child: Row(
                    children: [
                      Text(
                        GalleryLocalizations.of(context).shrineCartTaxCaption,
                      ),
                      Expanded(
                        child: Text(
                          formatter.format(model.tax),
                          style: smallAmountStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShoppingCartRow extends StatelessWidget {
  const ShoppingCartRow({
    @required this.product,
    @required this.quantity,
    this.onPressed,
  });

  final Product product;
  final int quantity;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        key: ValueKey<int>(product.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            label: GalleryLocalizations.of(context)
                .shrineScreenReaderRemoveProductButton(product.name(context)),
            button: true,
            child: ExcludeSemantics(
              child: SizedBox(
                width: _startColumnWidth,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: onPressed,
                  tooltip:
                      GalleryLocalizations.of(context).shrineTooltipRemoveItem,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        product.assetName,
                        package: product.assetPackage,
                        fit: BoxFit.cover,
                        width: 75,
                        height: 75,
                        excludeFromSemantics: true,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MergeSemantics(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MergeSemantics(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        GalleryLocalizations.of(context)
                                            .shrineProductQuantity(quantity),
                                      ),
                                    ),
                                    Text(
                                      GalleryLocalizations.of(context)
                                          .shrineProductPrice(
                                        formatter.format(product.price),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                product.name(context),
                                style: localTheme.textTheme.subtitle1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: shrineBrown900,
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
