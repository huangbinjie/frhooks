import 'package:flutter_hooks/src/useContext.dart';

useMount(void Function() Function() useMountCallback) {
  var currentContext = useContext();
  var currentHook = currentContext.hook;
  var currentMountCallbacks = currentHook.mountCallbacks;

  currentMountCallbacks.add(useMountCallback);
}
