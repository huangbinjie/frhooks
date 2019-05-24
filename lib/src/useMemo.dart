part of 'hook.dart';

T useMemo<T>(T Function() returnMemorizedState, [List<dynamic> deps]) {
  _workInProgressHook = _createWorkInProgressHook();
  var memorizedState = _workInProgressHook.memorizedState;

  if (memorizedState == null) {
    _workInProgressHook.memorizedState = {
      "state": returnMemorizedState(),
      "deps": deps
    };
  } else {
    if (memorizedState["state"] is T) {
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

  return memorizedState["state"];
}
