import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_game/card_board.dart';
import 'package:flutter_card_game/card_item.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int score = 0;
  int time = 0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), runTimer);
  }

  void runTimer() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        this.time += 1;
        runTimer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black87,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.black87,
                Colors.black87,
                Colors.orange,
                Colors.black87,
                Colors.black87
              ])),
          child: Column(
            children: <Widget>[
              SizedBox(height: 24.0),
              buildScore(),
              buildBoard()
            ],
          ),
        ));
  }

  Widget buildScore() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(time.toString() + "s",
              style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.yellowAccent,
                  fontFamily: 'GamjaFlower')),
          Text(score.toString(),
              style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.yellowAccent,
                  fontFamily: 'GamjaFlower'))
        ],
      ),
    );
  }

  Widget buildBoard() {
    return Flexible(
        child: Stack(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(8.0), child: CardBoard(onWin: onWin)),
        buildGradientView()
      ],
    ));
  }

  Widget buildGradientView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 32.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black, Colors.transparent])),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 32.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black, Colors.black])),
        )
      ],
    );
  }

  void onWin() {
    setState(() => this.score += 200);
  }
}
