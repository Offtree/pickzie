import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vibrate/vibrate.dart';

enum Game { waiting, resolving, resolved }
const c = [
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.teal,
  Colors.cyan,
  Colors.red,
  Colors.orange,
  Colors.pink
];

class Pickzie {
  int id;
  Offset offset;
  Pickzie({@required this.id, this.offset});
  get color => c[id % c.length];
}

class PickzieGame extends Model {
  Game state;
  Pickzie winner;
  List<Pickzie> _pickzies = [];
  Timer _waitingTimer, _resolvingTimer;

  static PickzieGame of(context) => ScopedModel.of<PickzieGame>(context);

  get pickzies => _pickzies.toList();

  get isResolved => state == Game.resolved;

  _setWinner() {
    winner = (_pickzies..shuffle()).first;
    state = Game.resolved;
    Vibrate.feedback(FeedbackType.heavy);
    notifyListeners();
  }

  _updateTimers() {
    if (isResolved) return;
    _waitingTimer?.cancel();
    _resolvingTimer?.cancel();
    state = Game.waiting;
    notifyListeners();

    if (_pickzies.length <= 1) return;
    _waitingTimer = Timer(Duration(seconds: 2), () {
      state = Game.resolving;
      notifyListeners();
      _resolvingTimer = Timer(Duration(seconds: 2), _setWinner);
    });
  }

  create(Pickzie pickzie) {
    if (!isResolved) {
      _pickzies.add(pickzie);
      Vibrate.feedback(FeedbackType.success);
      _updateTimers();
    }
  }

  update(Pickzie pickzie) {
    var match = (Pickzie it) => it.id == pickzie.id;
    try {
      _pickzies.removeWhere(match);
      _pickzies.add(pickzie);
      notifyListeners();
    } catch (err) {}
  }

  remove(int pickzieId) {
    _pickzies.removeWhere((it) => it.id == pickzieId);
    if (_pickzies.isEmpty) state = Game.waiting;
    _updateTimers();
  }
}
