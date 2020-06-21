

import 'dart:collection';

import 'package:shop/Utils.dart';

class Order {
  /// 存储 产品id-数量
  Map<int, int> productCart;
  String createTime;
  final double totalCost;
  final double productCost;
  final double taxCost;
  final double shippingCost;

  Order(Map<int, int> productCart, this.totalCost, this.productCost, this.taxCost, this.shippingCost) {
    this.createTime = currentTime();
    // 深拷贝
    this.productCart = HashMap.from(productCart);
  }

  @override
  String toString() {
    return 'Order{productCart: $productCart, createTime: $createTime, totalCost: $totalCost, productCost: $productCost, taxCost: $taxCost, shippingCost: $shippingCost}';
  }
}