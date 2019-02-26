import 'package:flutter/material.dart';
import 'package:pickzie/models.dart';
import 'package:pickzie/widgets/gesture_board.dart';
import 'package:pickzie/widgets/pickzie_board.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      title: 'Pickzie',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: ScopedModel<PickzieGame>(
            model: PickzieGame(),
            child: Stack(children: [PickzieBoard(), GestureBoard()])),
      ),
    );
  }
}
