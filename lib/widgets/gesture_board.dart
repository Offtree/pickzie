import 'package:flutter/material.dart';
import 'package:pickzie/models.dart';
import 'package:scoped_model/scoped_model.dart';

class GestureBoard extends StatelessWidget {
  @override
  build(context) {
    var game = ScopedModel.of<PickzieGame>(context);
    return Listener(
      onPointerDown: (event) {
        game.create(Pickzie(id: event.pointer, offset: event.position));
      },
      onPointerUp: (event) {
        game.remove(event.pointer);
      },
      onPointerMove: (event) {
        game.update(Pickzie(id: event.pointer, offset: event.position));
      },
      child: Container(color: Colors.transparent),
    );
  }
}
