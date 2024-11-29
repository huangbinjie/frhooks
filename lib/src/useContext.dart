part of 'hook.dart';

HookElement useContext() {
  var currentContext = _stashedContext;

  assert(currentContext != null);

  return currentContext!;
}
