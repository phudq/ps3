import 'package:flutter/material.dart';

class Loading {
  static Future show(context, Future fetch) async {
    BuildContext dialogContext;
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
    var value = await fetch;
    Navigator.of(dialogContext).pop();
    // if (value == null) {
    //   await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text('Something wrong, Please try again later.'),
    //         actions: <Widget>[
    //           RaisedButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Text('Ok'),
    //           )
    //         ],
    //       );
    //     },
    //   );
    // }
    return value;
  }
}
