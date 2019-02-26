import './hook_element.dart';

RactorHookElement useContext() {
  var currentContext = RactorHookElement.currentContext;

  assert(currentContext != null);

  return currentContext;
}
