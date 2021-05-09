import 'package:eyes/src/eye.dart';
import 'package:eyes/src/region.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Builder(builder: (context) {
      return Center(
          child: ListenableMouseRegion(
              child: Container(
                  color: Colors.lightBlueAccent,
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Center(
                      child: Table(children: [
                    const TableRow(children: [Eye(), Eye(), Eye(), Eye()]),
                    const TableRow(children: [Eye(), Eye(), Eye(), Eye()]),
                    const TableRow(children: [Eye(), Eye(), Eye(), Eye()])
                  ])))));
    })));
  }
}
