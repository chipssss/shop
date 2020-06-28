

import 'package:shop/Utils.dart';
import 'package:shop/view/theme.dart';

/// 订单评价
class Evaluation {
  // 分数，0.5~5.0 可打半星
  final double score;
  String createTime;
  int productId;
  final String comment;

  // todo 选择图片信息,用户信息
  List<String> _imgList = [];
  String username;
  Evaluation(this.score, this.comment) {
    createTime = currentTime();
  }

  get label {
    return rate2Label(score);
  }

  @override
  String toString() {
    return 'Evaluation{score: $score, createTime: $createTime, productId: $productId, comment: $comment, _imgList: $_imgList, username: $username}';
  }
}

String rate2Label(double rate) {
  switch (rate.floor()) {
    case 0:
    case 1:
      return '非常差';
    case 2:
      return '差';
    case 3:
      return '一般';
    case 4:
      return '好';
    case 5:
      return '非常好';
    default:
      return '未知';
  }
}