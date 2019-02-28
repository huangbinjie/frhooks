// import 'package:flutter_hooks/flutter_hooks.dart';

// T useCallback<T extends dynamic Function()>(T callback) {
//   var currentContext = useContext();
//   var currentHook = currentContext.hook;
//   var hookCallbackList = currentHook.callbackList;
//   var hookCallbackIndex = currentHook.callbackIndex;

//   try {
//     var cachedCallback = hookCallbackList.elementAt(hookCallbackIndex);
//     currentHook.callbackIndex++;
//     return cachedCallback;  
//   } catch (e) {
//     hookCallbackList.add(callback);
//     currentHook.callbackIndex++;
//     return callback;
//   }
// }
