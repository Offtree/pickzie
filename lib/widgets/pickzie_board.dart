import 'package:flare_dart/animation/actor_animation.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:pickzie/models.dart';
import 'package:scoped_model/scoped_model.dart';

class PickzieBoard extends StatelessWidget {
  @override
  build(context) {
    var gameModel = ScopedModel.of<PickzieGame>(context, rebuildOnChange: true);
    if (gameModel.pickzies.isEmpty) return Container();
    return Stack(
        children: gameModel.pickzies
            .map<Widget>((it) => Bubble(
                  key: ValueKey(it.id),
                  pickzie: it,
                  winner: it.id == gameModel.winner?.id,
                  state: gameModel.state,
                ))
            .toList());
  }
}

class Bubble extends StatefulWidget {
  Bubble({Key key, this.pickzie, this.winner, this.state}) : super(key: key);
  final Pickzie pickzie;
  final bool winner;
  final Game state;
  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> implements FlareController {
  double _time = 0;
  ActorAnimation _pulse;
  setViewTransform(tansform) {}
  initialize(board) {
    _pulse = board.getAnimation("pulse");
  }

  get animation => widget.state == Game.resolving
      ? "resolve"
      : widget.state == Game.resolved
          ? widget.winner ? "winner" : "leave"
          : "join";
  advance(board, elapsed) {
    _time += elapsed;
    if (!["leave", "winner"].contains(animation)) {
      _pulse.apply(_time % _pulse.duration, board, .5);
    }
    return true;
  }

  @override
  build(context) => AnimatedPositioned(
      child: Container(
          height: 120,
          width: 120,
          child: FlareActor("assets/Pickzie.flr",
              color: widget.pickzie.color,
              animation: animation,
              controller: this)),
      left: widget.pickzie.offset.dx - 60,
      top: widget.pickzie.offset.dy - 60,
      duration: Duration(milliseconds: 50));
}
