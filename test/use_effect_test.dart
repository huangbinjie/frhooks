import 'package:flutter/widgets.dart';
import 'package:frhooks/frhooks.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets('useEffect basic', (tester) async {
    int effectResult = 0;
    late StateContainer stateContainer;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        final context = useContext();
        stateContainer = useState(0);
        useEffect(() {
          effectResult++;

          /// context.size can not be read during rebuild or relayout.
          /// this expect this callback should be call after relayout completely.
          expect(context.size, Size(800, 600));
        });
        return Container();
      },
    ));

    expect(effectResult, 1);

    stateContainer.setState(1);

    await tester.pump();

    expect(effectResult, 2);
  });

  testWidgets('useDidmount', (tester) async {
    late StateContainer stateContainer;
    int effectResult = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        stateContainer = useState(0);
        useEffect(() {
          effectResult++;

          return () => effectResult = 0;
        }, []);

        useEffect(() {
          effectResult++;
        });
        return Container();
      },
    ));

    await tester.pump();

    expect(stateContainer.state, 0);
    expect(effectResult, 2);

    stateContainer.setState(1);

    await tester.pump();

    expect(stateContainer.state, 1);
    expect(effectResult, 3);

    await tester.pumpWidget(Container());

    expect(effectResult, 0);
  });

  testWidgets('effect should called after setState', (tester) async {
    late StateContainer<int> stateContainer;
    int effectResult = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        stateContainer = useState(0);
        useEffect(() {
          effectResult++;
        });

        // trigger after unmount.
        useEffect(() => () => effectResult = 0, []);
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
