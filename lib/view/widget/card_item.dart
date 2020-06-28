import 'dart:html';

import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  String title;
  Widget child;
  bool useCard;
  Color color;

  CardItem(
      {@required this.title,
      @required this.child,
      this.useCard = true,
      this.color});

  @override
  Widget build(BuildContext context) {
    if (color == null) color = Theme.of(context).primaryColor;
    return SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                      width: 5.0,
                      height: 15.0,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                    width: double.infinity,
                    child: useCard
                        ? Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            child: child)
                        : Padding(
                            padding: EdgeInsets.all(6),
                            child: child,
                          )),
              ]),
        ));
  }
}
