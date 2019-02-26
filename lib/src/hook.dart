class Hook {
  int index = 0;
  List<Object> stateStack = [];
  List<void Function() Function()> mountCallbacks = [];
  List<void Function()> unmountCallbacks = [];
}
