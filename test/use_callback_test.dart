import 'package:flutter/widgets.dart';
import 'package:frhooks/frhooks.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets("useCallback basic", (tester) async {
    List cbList = [];
    late StateContainer stateContainer;
    await tester.pumpWidget(HookBuilder(builder: () {
      var cb = useCallback(() {
        return 1;
      });
      stateContainer = useState(0);
      cbList.add(cb);
      return Container();
    }));

    expect(cbList[0](), 1);
    expect(stateContainer.state, 0);

    stateContainer.setState(1);

    await tester.pump();

    expect(cbList[0](), 1);
    expect(cbList[1](), 1);
    // without inputs will always return new callback
    expect(cbList[0] == cbList[1], false);
    expect(stateContainer.state, 1);
  });

  testWidgets("useCallback with varargs function", (tester) async {
    late StateContainer stateContainer;
    List cbList = [];
    await tester.pumpWidget(HookBuilder(
      builder: () {
        stateContainer = useState(0);
        final cb = useCallback((int index) {
          return index;
        }, []);
        cbList.add(cb);
        return Container();
      },
    ));

    await tester.pump();

    expect(cbList[0](1), 1);

    stateContainer.setState(1);

    await tester.pump();

    expect(cbList[0], cbList[1]);

    expect(cbList[1](2), 2);
  });

  testWidgets("same useCallback inputs return first used callback",
      (tester) async {
    List cbList = [];
    late StateContainer stateContainer;
    await tester.pumpWidget(HookBuilder(builder: () {
      stateContainer = useState(0);
      var cb = useCallback(() {
        return 1;
      }, []);
      cbList.add(cb);
      return Container();
    }));

    stateContainer.setState(1);

    await tester.pump();

    expect(cbList[0] == cbList[1], true);
  });

  testWidgets("useCallback changing inputs return new callback",
      (tester) async {
    List cbList = [];
    late StateContainer stateContainer;
    await tester.pumpWidget(HookBuilder(builder: () {
      stateContainer = useState(0);
      var cb = useCallback(() {
        return 1;
      }, [stateContainer.state]);
      cbList.add(cb);
      return Container();
    }));

    stateContainer.setState(1);

    await tester.pump();

    expect(cbList[0] == cbList[1], false);
  });
}
