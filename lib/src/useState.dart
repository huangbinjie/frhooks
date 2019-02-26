import './hook_element.dart';

useState(dynamic initialState) {
  var currentContext = RactorHookElement.currentContext;
  var currentHook = currentContext.hook;
  var hookStateStack = currentHook.stateStack;
  var hookStateIndex = currentHook.index;

  try {
    var value = hookStateStack.elementAt(hookStateIndex);
    setState(nextState) {
      hookStateStack
          .replaceRange(hookStateIndex, hookStateIndex + 1, [nextState]);
    }

    hookStateIndex++;
    return [value, setState];
  } catch (e) {
    hookStateStack.add(initialState);
    setState(nextState) {
      hookStateStack
          .replaceRange(hookStateIndex, hookStateIndex + 1, [nextState]);
    }

    hookStateIndex++;
    return [initialState, setState];
  }
}
