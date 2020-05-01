import 'package:flutter/foundation.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter/material.dart';
import 'are_hook_inputs_equal.dart';

part 'useContext.dart';
part 'useState.dart';
part 'useEffect.dart';
part 'useCallback.dart';
part 'useMemo.dart';
part 'useRef.dart';
part 'useTickerProvider.dart';
part 'useAnimationController.dart';
part 'hook_widget.dart';
part 'hook_element.dart';

class _Hook {
  dynamic memorizedState;
  _Hook next;
}

class _Effect {
  bool needUpdate;
  Function() create;
  List<dynamic> deps;
  VoidCallback destroy;
  _Effect next;

  _Effect({this.needUpdate = false, this.create, this.deps, this.destroy});
}

class _HookTypeError extends Error {}

_Hook _workInProgressHook;
HookElement _stashedContext;

_Hook _createWorkInProgressHook() {
  final currentContext = _stashedContext;

  if (_workInProgressHook == null) {
    _workInProgressHook = currentContext.hook;
  } else {
    if (_workInProgressHook.next == null) {
      _workInProgressHook = _workInProgressHook.next = _Hook();
    } else {
      _workInProgressHook = _workInProgressHook.next;
    }
  }

  return _workInProgressHook;
}
