part of './hook.dart';

class HookElement extends ComponentElement {
  HookWidget _widget;
  Hook hook = Hook();

  List<void Function() Function()> updatePhaseEffectQueue = [];
  List<void Function()> unmountPhaseEffectQueue = [];

  /// Creates an element that uses the given widget as its configuration.
  HookElement(HookWidget widget)
      : _widget = widget,
        super(widget);

  static HookElement currentContext;

  @override
  Widget build() {
    HookElement.currentContext = this;
    var widget = _widget.build();
    didUpdate();
    return widget;
  }

  /// cause of [mount] called before [build]. So create a method [didUpdate] for react like didUpdate.
  void didUpdate() {
    updatePhaseEffectQueue.forEach((callback) {
      var removalEffectCallback = callback();
      if (removalEffectCallback != null) {
        this.unmountPhaseEffectQueue.add(removalEffectCallback);
      }
    });

    updatePhaseEffectQueue.clear();
    _workInProgressHook = null;
  }

  @override
  void unmount() {
    this.unmountPhaseEffectQueue.forEach((callback) => callback());
    this.unmountPhaseEffectQueue.clear();
    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
  }
}
