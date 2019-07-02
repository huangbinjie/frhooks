part of 'hook.dart';

class StateContainer<T> {
  T state;
  void Function(T) setState;

  StateContainer(this.state, this.setState);
}

_genSetState(currentContext, currentHook) {
  return (nextState) {
    currentHook.memorizedState.state = nextState;
    currentContext.markNeedsBuild();
  };
}

StateContainer<T> useState<T>(T initialState) {
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.memorizedState == null) {
    _workInProgressHook.memorizedState = StateContainer(initialState,
        _genSetState(_resolveCurrentContext(), _workInProgressHook));
  }

  if (_workInProgressHook.memorizedState is StateContainer &&
      _workInProgressHook.memorizedState.state is T) {
    return _workInProgressHook.memorizedState;
  } else {
    throw _HookTypeError();
  }
}
