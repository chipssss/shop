
import 'package:shop/model/order.dart';

class MockData {
  static List<Order> userOrderList = [
    new Order({7: 1, 8:2}, 49.4, 40, 2.4, 7),
    new Order({7: 1, 1:1, 2:3}, 49.4, 40, 2.4, 7)
  ];
}