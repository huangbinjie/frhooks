part of 'hook.dart';

useEffect(void Function() Function() effectCallback, [List<dynamic> deps]) {
  var currentContext = _resolveCurrentContext();
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memorizedState == null) {
    _workInProgressHook.memorizedState = deps;
    currentContext.updatePhaseEffectQueue.add(effectCallback);
  } else {
    var prevDeps = _workInProgressHook.memorizedState;

    if (areHookInputsEqual(prevDeps, deps)) {
      _workInProgressHook.memorizedState = deps;
    } else {
      currentContext.updatePhaseEffectQueue.add(effectCallback);
    }
  }
}
