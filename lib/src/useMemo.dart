part of 'hook.dart';

T useMemo<T>(T Function() create, [List<dynamic> deps]) {
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memorizedState == null) {
    _workInProgressHook.memorizedState = {
      "state": create(),
      "deps": deps
    };
  } else {
    final memorizedState = _workInProgressHook.memorizedState;

    if (memorizedState is Map && memorizedState["state"] is T) {
      if (!areHookInputsEqual(memorizedState["deps"], deps)) {
        _workInProgressHook.memorizedState = {
          "state": create(),
          "deps": deps
        };
      }
    } else {
      throw _HookTypeError();
    }
  }

  return _workInProgressHook.memorizedState["state"];
}
