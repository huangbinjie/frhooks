import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets("useCallback basic", (tester) async {
    List cbList = [];
    StateContainer stateContainer;
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

  testWidgets("same useCallback inputs return first used callback",
      (tester) async {
    List cbList = [];
    StateContainer stateContainer;
    await tester.pumpWidget(HookBuilder(builder: () {
      stateContainer = useState(0);
      var cb = useCallback(() {
        return 1;
      }, []);
      cbList.add(cb);
      return Container();
    }));

    expect(cbList[0](), 1);
    expect(stateContainer.state, 0);

    stateContainer.setState(1);

    await tester.pump();

    expect(cbList[0](), 1);
    expect(cbList[1](), 1);
    expect(cbList[0] == cbList[1], true);
    expect(stateContainer.state, 1);
  });

  testWidgets("useCallback changing inputs memorize new callback",
      (tester) async {
    List cbList = [];
    StateContainer stateContainer;
    await tester.pumpWidget(HookBuilder(builder: () {
      stateContainer = useState(0);
      var cb = useCallback(() {
        return 1;
      }, [stateContainer.state]);
      cbList.add(cb);
      return Container();
    }));

    expect(cbList[0](), 1);
    expect(stateContainer.state, 0);

    stateContainer.setState(1);

    await tester.pump();

    expect(cbList[0](), 1);
    expect(cbList[1](), 1);
    expect(cbList[0] == cbList[1], false);
    expect(stateContainer.state, 1);
  });
}
