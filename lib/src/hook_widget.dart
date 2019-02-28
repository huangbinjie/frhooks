part of './hook.dart';

abstract class HookWidget extends Widget {
  const HookWidget({Key key}) : super(key: key);

  @override
  HookElement createElement() {
    return HookElement(this);
  }

  Widget build();
}
