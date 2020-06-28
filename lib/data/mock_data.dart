
import 'package:shop/model/evalutaion.dart';
import 'package:shop/model/order.dart';

class MockData {
  static List<Order> userOrderList = [
    new Order({7: 1, 8:2}, 49.4, 40, 2.4, 7)
      ..productEvaluationMap[7] = Evaluation(4.5, 7, "测试评价信息")
      ..productEvaluationMap[8] = Evaluation(4.5, 8, "测试评价信息"),
    new Order({7: 1, 1:1, 2:3}, 49.4, 40, 2.4, 7)
  ];
}