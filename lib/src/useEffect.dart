part of 'hook.dart';

useEffect(void Function() Function() effectCallback, [List<dynamic> deps]) {
  var currentContext = _resolveCurrentContext();
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memoizedState == null) {
    _workInProgressHook.memoizedState = deps;
    currentContext.updatePhaseEffectQueue.add(effectCallback);
  } else {
    var prefDeps = _workInProgressHook.memoizedState;

    if (areHookInputsEqual(prefDeps, deps)) {
      _workInProgressHook.memoizedState = deps;
    } else {
      currentContext.updatePhaseEffectQueue.add(effectCallback);
    }
  }
}
