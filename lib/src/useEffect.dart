part of 'hook.dart';

useEffect(void Function() Function() effectCallback, [List<dynamic> deps]) {
  var currentContext = _resolveCurrentContext();
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memorizedState == null) {
    _workInProgressHook.memorizedState = deps;
    currentContext.updatePhaseEffectQueue.add(effectCallback);
  } else {
    var prevDeps = _workInProgressHook.memorizedState;

    // if dependencies changed, should memorize changed dependencies.
    if (!areHookInputsEqual(prevDeps, deps)) {
      _workInProgressHook.memorizedState = deps;
      currentContext.updatePhaseEffectQueue.add(effectCallback);
    }
  }
}

useAsyncEffect(Future<void Function()> Function() effectCallback,
    [List<dynamic> deps]) {
  var currentContext = _resolveCurrentContext();
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memorizedState == null) {
    _workInProgressHook.memorizedState = deps;
    currentContext.updatePhaseEffectQueue.add(effectCallback);
  } else {
    var prevDeps = _workInProgressHook.memorizedState;

    if (!areHookInputsEqual(prevDeps, deps)) {
      _workInProgressHook.memorizedState = deps;
      currentContext.updatePhaseEffectQueue.add(effectCallback);
    }
  }
}
