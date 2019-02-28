part of 'hook.dart';

class StateContainer<T> {
  T state;
  void Function(T) setState;

  StateContainer(this.state, this.setState);
}

_genSetState(currentHook) {
  return (nextState) {
    currentHook.baseState = nextState;
    _resolveCurrentContext().markNeedsBuild();
  };
}

StateContainer<T> useState<T>([T initialState]) {
  _workInProgressHook = _createWorkInProgressHook();

  if (_workInProgressHook.baseState == null) {
    _workInProgressHook.baseState = initialState;
  }

  return StateContainer(
      _workInProgressHook.baseState, _genSetState(_workInProgressHook));
}
