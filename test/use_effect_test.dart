import 'package:flutter/widgets.dart';
import 'package:frhooks/frhooks.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets('useEffect basic', (tester) async {
    int effectResult = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        final context = useContext();
        useEffect(() {
          effectResult = 1;

          /// context.size can not be read during rebuild or relayout.
          /// this expect this callback should be call after relayout completely.
          expect(context.size, Size(800, 600));
        });
        return Container();
      },
    ));

    expect(effectResult, 1);
  });

  testWidgets('useDidmount', (tester) async {
    StateContainer stateContainer;
    int effectResult = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        stateContainer = useState(0);
        useEffect(() {
          effectResult++;
        }, []);
        return Container();
      },
    ));

    expect(stateContainer.state, 0);
    expect(effectResult, 1);

    stateContainer.setState(1);

    await tester.pump();

    expect(stateContainer.state, 1);
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
