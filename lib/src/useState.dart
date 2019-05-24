part of 'hook.dart';

class StateContainer<T> {
  T state;
  void Function(T) setState;

  StateContainer(this.state, this.setState);
}

_genSetState(currentContext, currentHook) {
  return (nextState) {
    currentHook.memorizedState = nextState;
    currentContext.markNeedsBuild();
  };
}

StateContainer<T> useState<T>([T initialState]) {
  _workInProgressHook = _createWorkInProgressHook();
  var memorizedState = _workInProgressHook.memorizedState;

  if (memorizedState == null) {
    _workInProgressHook.memorizedState = initialState;
  }

  if (memorizedState is T) {
    return StateContainer(memorizedState,
        _genSetState(_resolveCurrentContext(), _workInProgressHook));
  } else {
    throw _HookTypeError();
  }
}
