import './are_hook_inputs_equal.dart';
import 'package:flutter/material.dart';
part 'useContext.dart';
part 'useState.dart';
part 'useEffect.dart';
part 'useCallback.dart';
part './hook_widget.dart';
part 'hook_element.dart';

class Hook {
  dynamic baseState;
  dynamic memoizedState;
  Hook next;
}

Hook _workInProgressHook;

HookElement _resolveCurrentContext() {
  return HookElement.currentContext;
}

Hook _createWorkInProgressHook() {
  var currentContext = _resolveCurrentContext();
  _workInProgressHook = currentContext.hook;

  if (_workInProgressHook == null) {
    _workInProgressHook = currentContext.hook;
  } else {
    if (_workInProgressHook.next == null) {
      _workInProgressHook = _workInProgressHook.next = Hook();
    } else {
      _workInProgressHook = _workInProgressHook.next;
    }
  }

  return _workInProgressHook;
}
