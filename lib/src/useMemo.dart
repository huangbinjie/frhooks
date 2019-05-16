part of 'hook.dart';

T useMemo<T>(T Function() returnMemorizedState, [List<dynamic> deps]) {
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memoizedState == null) {
    _workInProgressHook.memoizedState = {
      "memorizedState": returnMemorizedState(),
      "deps": deps
    };
  } else {
    var memoizedState = _workInProgressHook.memoizedState;

    if (!areHookInputsEqual(memoizedState["deps"], deps)) {
      _workInProgressHook.memoizedState = {
        "memorizedState": returnMemorizedState(),
        "deps": deps
      };
    }
  }

  return _workInProgressHook.memoizedState["memorizedState"];
}
