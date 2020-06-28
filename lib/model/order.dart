

import 'dart:collection';

import 'package:shop/Utils.dart';
import 'package:shop/model/evalutaion.dart';

class Order {
  /// 存储 产品id-数量
  Map<int, int> productCart;
  /// 存储 产品id-评价
  Map<int, Evaluation> productEvaluationMap = {};
  String createTime;
  String id;
  final double totalCost;
  final double productCost;
  final double taxCost;
  final double shippingCost;

  Order(Map<int, int> productCart, this.totalCost, this.productCost, this.taxCost, this.shippingCost) {
    this.createTime = currentTime();
    // 获取时间戳作为订单id
    this.id = DateTime.now().millisecondsSinceEpoch.toString();
    // 深拷贝
    this.productCart = HashMap.from(productCart);
  }
  
  @override
  String toString() {
    return 'Order{productCart: $productCart, createTime: $createTime, totalCost: $totalCost, productCost: $productCost, taxCost: $taxCost, shippingCost: $shippingCost}';
  }
  
  void addEvaluation(int productId, Evaluation evaluation) {
    productEvaluationMap[productId] = evaluation;
  }
}