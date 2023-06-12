import 'package:flutter/material.dart';

extension NavigatorFunctions on State{
  Future push <t extends Object>(Widget route){
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => route,
      ),
    );
  }

  Future replace<T extends Object>(Widget route) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (c) => route,
      ),
    );
  }

  pop<T extends Object>([T? result]) {
    var canPop = Navigator.canPop(context);
    assert(canPop, "Unable to pop the (initial) route");
    Navigator.of(context).pop<T>(result);
  }

  popTillFirst() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  mustPop<T extends Object>([T? result]) {
    Navigator.of(context).pop<T>(result);
  }
}