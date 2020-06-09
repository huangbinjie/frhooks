part of './hook.dart';

class HookElement extends StatelessElement {
  _Hook hook = _Hook();
  _Effect lastEffect;

  HookElement(HookWidget widget) : super(widget);

  Widget resetHooksAndReBuild() {
    hook = _Hook();

    debugPrint(
        "It looks like you have inserted/removed a hook, hooks will rerun the build(BuildContext context) of ${widget}.");

    return build();
  }

  @override
  Widget build() {
    willBuild();
    try {
      return super.build();
    } catch (e) {
      if (e is _HookTypeError) {
        return resetHooksAndReBuild();
      } else {
        throw e;
      }
    }
  }

  void willBuild() {
    lastEffect = null;
    _stashedContext = this;
    _workInProgressHook = null;
    WidgetsBinding.instance.addPostFrameCallback(didBuild);
  }

  /// cause of [mount] called before [build]. So create a method [didBuild] for react like didUpdate.
  void didBuild(Duration duration) {
    if (lastEffect != null) {
      var firstEffect = lastEffect.next;
      var effect = firstEffect;
      do {
        if (effect.needUpdate) {
          effect?.destroy?.call();
          var destroy = effect.create();
          if (destroy != null) {
            if (destroy is Function) {
              effect.destroy = destroy;
            } else {
              if (destroy is Future) {
                throw FlutterError(
                    'It looks like you wrote useEffect(async () => ...) or returned a Promise.');
              }

              throw FlutterError(
                  'An effect function must not return anything besides a function, which is used for clean-up.');
            }
          }
        }
      } while ((effect = effect.next) != firstEffect);
    }
  }

  @override
  void unmount() {
    super.unmount();
    _stashedContext = null;
    _workInProgressHook = null;
    if (lastEffect != null) {
      var firstEffect = lastEffect.next;
      var effect = firstEffect;
      do {
        effect?.destroy?.call();
      } while ((effect = effect.next) != firstEffect);
      lastEffect = null;
    }
  }
}
