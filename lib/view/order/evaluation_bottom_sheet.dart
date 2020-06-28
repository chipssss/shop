import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/l10n/strings_resource.dart';
import 'package:shop/model/app_state_model.dart';
import 'package:shop/model/evalutaion.dart';
import 'package:shop/view/colors.dart';
import 'package:shop/view/widget/CommonButton.dart';
import 'package:shop/view/widget/card_item.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class EvaluationBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EvaluationState();
  }
}

class EvaluationState extends State<EvaluationBottomSheet> {
  // 底部工作表高度占比
  static const _HEIGHT_PERCENT = 0.6;

  double rate = 0;
  String comment = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final spaceBox = const SizedBox(
      height: 20,
    );
    final color = shrinePink400;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * _HEIGHT_PERCENT,
      alignment: Alignment.center,
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardItem(
              color: color,
              title: TextRes.EVALUATION_PRODUCT_SATIS,
              useCard: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothStarRating(
                    onRated: (v) {
                      setState(() {
                        print(v);
                        rate = v;
                      });
                    },
                    color: shrinePink400,
                  ),
                  Text(rate == 0? TextRes.EVALUATION_COMMENT_STRA: rate2Label(rate))
                ],
              ),
            ),
            spaceBox,
            CardItem(
              color: color,
              title: TextRes.EVALUATION_COMMENT_LABEL,
              useCard: false,
              child: TextFormField(
                maxLines: 5,
                onChanged: (v) {
                  comment = v;
                },
                decoration: InputDecoration(
                    labelText: TextRes.EVALUATION_COMMENT_LABEL,
                    hintText: TextRes.EVALUATION_COMMENT_HINT,
                    helperText: TextRes.EVALUATION_COMMENT_HELPER,
                    focusColor: color
                ),
              ),
            ),
            spaceBox,
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: CommonButton(
                  onPressed: () {
                    Navigator.of(context).pop(Evaluation(rate, comment));
                  },
                  text: TextRes.EVALUATION_CONFIRM,
                  color: color
              ),
            )
          ],
        ),
      ),
    );
  }
}
