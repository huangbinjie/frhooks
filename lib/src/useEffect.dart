part of 'hook.dart';

useEffect(void Function() Function() effectCallback,
    [List<dynamic> deps = null]) {
  var currentContext = _resolveCurrentContext();
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memoizedState == null) {
    _workInProgressHook.memoizedState = {
      "effectCallback": effectCallback,
      "deps": deps
    };
    currentContext.updatePhaseEffectQueue.add(effectCallback);
  } else {
    var prefEffect = _workInProgressHook.memoizedState;

    if (areHookInputsEqual(prefEffect["deps"], deps)) {
      _workInProgressHook.memoizedState = {
        "effectCallback": effectCallback,
        "deps": deps
      };
    } else {
      currentContext.updatePhaseEffectQueue.add(effectCallback);
    }
  }
}
