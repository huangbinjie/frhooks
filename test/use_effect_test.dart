import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets('useEffect basic', (tester) async {
    int effectResult = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        useEffect(() {
          effectResult = 1;
        });
        return Container();
      },
    ));

    expect(effectResult, 1);
  });

  testWidgets('remove effect', (tester) async {
    int effectResult = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        useEffect(() {
          effectResult = 1;
          return () {
            effectResult = 2;
          };
        });
        return Container();
      },
    ));

    expect(effectResult, 1);

    await tester.pumpWidget(SizedBox());

    expect(effectResult, 2);
  });
  testWidgets('effect should called after setState', (tester) async {
    StateContainer<int> stateContainer;
    int effectResult = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        stateContainer = useState(0);
        useEffect(() {
          effectResult++;
          return () {
            effectResult = 0;
          };
        });
        return Container();
      },
    ));

    expect(effectResult, 1);
    expect(stateContainer.state, 0);

    stateContainer.setState(1);

    await tester.pump();

    expect(stateContainer.state, 1);
    expect(effectResult, 2);

    await tester.pumpWidget(SizedBox());

    expect(effectResult, 0);
  });
}
