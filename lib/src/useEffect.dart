part of 'hook.dart';

_Effect _pushEffect(needUpdate, create, deps, destroy) {
  var currentContext = _stashedContext;
  var effect = _Effect(
      needUpdate: needUpdate, destroy: destroy, create: create, deps: deps);
  if (currentContext.lastEffect == null) {
    currentContext.lastEffect = effect.next = effect;
  } else {
    effect.next = currentContext.lastEffect;
    currentContext.lastEffect = currentContext.lastEffect.next = effect;
  }
  return effect;
}

useEffect(Function() create, [List<dynamic> deps]) {
  _workInProgressHook = _createWorkInProgressHook();

  _Effect prevEffects = _workInProgressHook.memorizedState;

  if (areHookInputsEqual(prevEffects?.deps, deps)) {
    _pushEffect(false, create, deps, prevEffects?.destroy);
  } else {
    _workInProgressHook.memorizedState =
        _pushEffect(true, create, deps, prevEffects?.destroy);
  }
}
