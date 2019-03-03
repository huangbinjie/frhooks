part of './hook.dart';

class HookElement extends ComponentElement {
  HookWidget _widget;
  Hook hook = Hook();

  List<void Function() Function()> updatePhaseEffectQueue = [];
  List<void Function()> unmountPhaseEffectQueue = [];

  HookElement(HookWidget widget)
      : _widget = widget,
        super(widget);

  @override
  Widget build() {
    willBuild();
    final widget = _widget.build();
    didBuild();
    return widget;
  }

  void willBuild() {
    _stashedContextStack.add(this);
  }

  /// cause of [mount] called before [build]. So create a method [didBuild] for react like didUpdate.
  void didBuild() {
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
