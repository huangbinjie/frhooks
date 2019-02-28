part of 'hook.dart';

useCallback(void Function() Function() callback, [List<dynamic> deps = null]) {
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memoizedState == null) {
    _workInProgressHook.memoizedState = {"callback": callback, "deps": deps};
  } else {
    var memoizedState = _workInProgressHook.memoizedState;

    if (areHookInputsEqual(memoizedState["deps"], deps)) {
      _workInProgressHook.memoizedState = {"callback": callback, "deps": deps};
    }
  }

  return _workInProgressHook.memoizedState["callback"];
}
