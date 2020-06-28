
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const int _START_COUNT = 5;
/// 评分星星控件
class StartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class StartState extends State<StartWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

/// 静态显示控件
class StaticStarWidget extends StatelessWidget {
  final double score;

  const StaticStarWidget({Key key, this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> startList = [SizedBox(width: 4,)];
    int i;
    for (i=0; i<score.floor(); i++) {
      startList.add(Icon(Icons.star,));
      startList.add(SizedBox(width: 4,));
    }
    if (i++ < score) {
      startList.add(Icon(Icons.star_half,));
      startList.add(SizedBox(width: 4,));
    }
    while(i++ < _START_COUNT) {
      startList.add(Icon(Icons.star_border));
      startList.add(SizedBox(width: 4,));
    }
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: startList,
      ),
    );
  }
}