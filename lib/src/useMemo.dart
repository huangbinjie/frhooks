part of 'hook.dart';

T useMemo<T>(T Function() returnMemorizedState, [List<dynamic> deps]) {
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memorizedState == null) {
    _workInProgressHook.memorizedState = {
      "state": returnMemorizedState(),
      "deps": deps
    };
  } else {
    final memorizedState = _workInProgressHook.memorizedState;

    if (memorizedState is Map && memorizedState["state"] is T) {
      if (!areHookInputsEqual(memorizedState["deps"], deps)) {
        _workInProgressHook.memorizedState = {
          "state": returnMemorizedState(),
          "deps": deps
        };
      }
    } else {
      throw _HookTypeError();
    }
  }

  return _workInProgressHook.memorizedState["state"];
}
