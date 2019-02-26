import './hook_element.dart';

useContext() {
  var currentContext = RactorHookElement.currentContext;

  assert(currentContext != null);

  return currentContext;
}
