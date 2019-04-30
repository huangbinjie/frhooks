part of 'hook.dart';

T useMemo<T>(T memorizedState, [List<dynamic> deps]) {
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memoizedState == null) {
    _workInProgressHook.memoizedState = {
      "memorizedState": memorizedState,
      "deps": deps
    };
  } else {
    var memoizedState = _workInProgressHook.memoizedState;

    if (!areHookInputsEqual(memoizedState["deps"], deps)) {
      _workInProgressHook.memoizedState = {
        "memorizedState": memorizedState,
        "deps": deps
      };
    }
  }

  return _workInProgressHook.memoizedState["memorizedState"];
}
