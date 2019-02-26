import 'package:flutter/material.dart';
import 'package:flutter_hooks/src/hook.dart';
import './hook_widget.dart';

class RactorHookElement extends ComponentElement {
  HookWidget _widget;
  Hook hook = Hook();

  /// Creates an element that uses the given widget as its configuration.
  RactorHookElement(HookWidget widget)
      : _widget = widget,
        super(widget);

  static RactorHookElement currentContext;

  @override
  Widget build() {
    RactorHookElement.currentContext = this;
    var widget = _widget.build();
    didUpdate();
    return widget;
  }

  /// cause of [mount] called before [build]. So create a method [didUpdate] for react like didUpdate.
  void didUpdate() {
    this
        .hook
        .mountCallbacks
        .forEach((callback) => this.hook.unmountCallbacks.add(callback()));
    this.hook.index = 0;
  }

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    this.hook.unmountCallbacks.forEach((callback) => callback);
    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    this.hook.index = 0;
    super.update(newWidget);
  }
}
