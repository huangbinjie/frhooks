part of 'hook.dart';

HookElement useContext() {
  var currentContext = HookElement.currentContext;

  assert(currentContext != null);

  return currentContext;
}
