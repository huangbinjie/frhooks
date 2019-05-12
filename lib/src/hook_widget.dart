part of './hook.dart';

abstract class HookWidget extends StatelessWidget {
  const HookWidget({Key key}) : super(key: key);

  @override
  HookElement createElement() {
    return HookElement(this);
  }

  Widget build(BuildContext context);
}
