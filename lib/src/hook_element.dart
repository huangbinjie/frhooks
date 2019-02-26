import 'package:flutter/material.dart';
import './hook_widget.dart';

class RactorHookElement extends ComponentElement {
  HookWidget _widget;
  int hookIndex = 0;
  List<Object> stateStack = [];
  List<void Function() Function()> mountHookCallbacks = [];
  List<void Function()> unmountHookCallbacks = [];

  /// Creates an element that uses the given widget as its configuration.
  RactorHookElement(HookWidget widget)
      : _widget = widget,
        super(widget);

  static RactorHookElement currentContext;

  useContext() {
    return RactorHookElement.currentContext;
  }

  /// If can't find element at [stateStack](Bad State: No element), it means it's new state, and should be append to [stateStack]
  List<dynamic> useState<T>(T state) {
    try {
      var value = stateStack.elementAt(hookIndex);
      setState(nextState) {
        stateStack.replaceRange(hookIndex, hookIndex + 1, [nextState]);
      }

      hookIndex++;
      return [value, setState];
    } catch (e) {
      stateStack.add(state);
      setState(nextState) {
        stateStack.replaceRange(hookIndex, hookIndex + 1, [nextState]);
      }

      hookIndex++;
      return [state, setState];
    }
  }

  void useMount(void Function() Function() mountCallback) {
    mountHookCallbacks.add(mountCallback);
  }

  @override
  Widget build() {
    RactorHookElement.currentContext = this;
    var widget = _widget.build();
    didUpdate();
    return widget;
  }

  /// cause of [mount] called before [build]. So create a method [didUpdate] for react like didUpdate.
  void didUpdate() {
    mountHookCallbacks
        .forEach((callback) => unmountHookCallbacks.add(callback()));
    hookIndex = 0;
  }

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    unmountHookCallbacks.forEach((callback) => callback);
    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    hookIndex = 0;
    super.update(newWidget);
  }
}
