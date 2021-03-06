import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shop/constants.dart';
import 'package:shop/l10n/gallery_localizations.dart';
import 'package:shop/l10n/strings_resource.dart';
import 'package:shop/model/app_state_model.dart';
import 'package:shop/model/evalutaion.dart';
import 'package:shop/model/order.dart';
import 'package:shop/model/product.dart';
import 'package:shop/view/order/evaluation_bottom_sheet.dart';
import 'package:shop/view/widget/card_item.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../colors.dart';

class OrderPage extends StatelessWidget {

  void _showBottomSheet(BuildContext context, Order order, Product product) {
    showModalBottomSheet<Evaluation>(context: context, builder: (context) {
      return EvaluationBottomSheet();
    }).then((value) {
      // 路由层回传给上层组件
      if (value != null) {
        // 通过Scoped_Model 调用model层事件
        // 并通过观察者模式通知其他ui刷新数据
        AppStateModel.of(context).addEvaluation(order, product, value);
      }
      print('回传：$value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TextRes.MY_ORDER,
                style: Theme.of(context).textTheme.headline5),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: model.userOrderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return OrderItemView( // OrderItemView为封装的控件
                    order: model.userOrderList[index],
                    model: model,
                    onEvaluation: (product) {
                      // 传入Order实体，显示底部栏目
                      _showBottomSheet(context, model.userOrderList[index], product);
                    }
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}

/// 订单项布局文件
class OrderItemView extends StatelessWidget {
  final Order order;
  final AppStateModel model;
  final DataCallback<Product> onEvaluation;

  OrderItemView({Key key, this.order, this.model, this.onEvaluation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );
    final textStyle =
        Theme.of(context).textTheme.bodyText2.copyWith(color: shrineBrown600);
    List<Widget> cartItemList = [];
    cartItemList.addAll(_createShoppingCartRows());
    return CardItem(
      title: "${TextRes.ORDER_ID} : ${order.id} ",
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: cartItemList
            ..addAll([
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: Row(
                    children: [
                      Text(
                        "${TextRes.ORDER_TOTAL}: ${formatter.format(order.totalCost)}",
                        style: textStyle,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        order.createTime,
                        style: textStyle,
                      )
                    ],
                  ),
                ),
              )
            ]),
        ),
      ),
    );
  }

  List<Widget> _createShoppingCartRows() {
    return order.productCart.entries
        .map((e) => _ShopItem(
              product: model.getProductById(e.key),
              quantity: e.value,
              onEvaluation: onEvaluation,
              evaluation: order.productEvaluationMap[e.key],
            ))
        .toList();
  }
}

/// 商品条目,包含点评功能
class _ShopItem extends StatelessWidget {
  const _ShopItem({
    @required this.product,
    @required this.quantity,
    @required this.evaluation,
    this.onEvaluation,
  });

  final Product product;
  final Evaluation evaluation;
  final int quantity;
  final DataCallback<Product> onEvaluation;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: evaluation == null
                            ? FlatButton(
                          child: Text(TextRes.ORDER_EVALUATION),
                          onPressed: () {
                            onEvaluation(product);
                          },
                        )
                            : SmoothStarRating(isReadOnly: true, color: shrinePink400, rating: evaluation.score,),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          const Divider(
            color: shrineBrown600,
            height: 16,
          )
        ],
      ),
    );
  }
}
