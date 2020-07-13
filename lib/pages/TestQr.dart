import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:ps3_01/widgets/AppBottomNavigationBar.dart';

class TestQr extends StatefulWidget {
  @override
  _TestQrState createState() => _TestQrState();
}

class _TestQrState extends State<TestQr> {
  String cameraScanResult = 'none';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: AppBottomNavigationBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(cameraScanResult),
            RaisedButton(
              onPressed: () async {
                var result = await BarcodeScanner.scan();
                setState(() {
                  cameraScanResult = result.rawContent;
                });
              },
              child: Text('scan barcode'),
            ),
          ],
        ),
      ),
    );
  }
}
