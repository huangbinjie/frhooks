part of 'hook.dart';

T useMemo<T>(T Function() returnMemorizedState, [List<dynamic> deps]) {
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memorizedState == null) {
    _workInProgressHook.memorizedState = {
      "memorizedState": returnMemorizedState(),
      "deps": deps
    };
  } else {
    var memorizedState = _workInProgressHook.memorizedState;

    if (!areHookInputsEqual(memorizedState["deps"], deps)) {
      _workInProgressHook.memorizedState = {
        "memorizedState": returnMemorizedState(),
        "deps": deps
      };
    }
  }

  if (_workInProgressHook.memorizedState["memorizedState"] is T) {
    return _workInProgressHook.memorizedState["memorizedState"];
  } else {
    throw _HookTypeError();
  }

}
