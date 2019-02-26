import './hook_element.dart';

useMount(void Function() Function() useMountCallback) {
  var currentContext = RactorHookElement.currentContext;
  var currentHook = currentContext.hook;
  var currentMountCallbacks = currentHook.mountCallbacks;

  currentMountCallbacks.add(useMountCallback);
}
