part of 'hook.dart';

HookElement useContext() {
  var currentContext = _resolveCurrentContext();

  assert(currentContext != null);

  return currentContext;
}
