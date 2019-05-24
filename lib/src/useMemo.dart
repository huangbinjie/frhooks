part of 'hook.dart';

T useMemo<T>(T Function() returnMemorizedState, [List<dynamic> deps]) {
  _workInProgressHook = _createWorkInProgressHook();
  var memorizedState = _workInProgressHook.memorizedState;

  if (memorizedState == null) {
    _workInProgressHook.memorizedState = {
      "memorizedState": returnMemorizedState(),
      "deps": deps
    };
  } else {
    if (!areHookInputsEqual(memorizedState["deps"], deps)) {
      _workInProgressHook.memorizedState = {
        "memorizedState": returnMemorizedState(),
        "deps": deps
      };
    }
  }

  if (memorizedState["memorizedState"] is T) {
    return memorizedState["memorizedState"];
  } else {
    throw _HookTypeError();
  }
}
