import 'package:flutter/material.dart';

Widget SelectPlace(context, {Function onTab, leading, String value = ''}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Material(
        color: Colors.white,
        child: InkWell(
            onTap: onTab,
            child: Ink(
              child: Row(
                children: <Widget>[
                  leading,
                  SizedBox(
                    width: 10,
                  ),
                  Text(value)
                ],
              ),
            )),
      ));
}
