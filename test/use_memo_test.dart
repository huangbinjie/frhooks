import 'package:flutter/widgets.dart';
import 'package:frhooks/frhooks.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets("useMemo basic", (tester) async {
    List<Map<String, dynamic>> memorizedStates = [];
    StateContainer stateContainer;
    await tester.pumpWidget(HookBuilder(builder: () {
      final memorizedState = useMemo(() => {"n": 1});
      stateContainer = useState(0);
      memorizedStates.add(memorizedState);
      return Container();
    }));

    expect(memorizedStates[0]["n"], 1);
    expect(stateContainer.state, 0);

    stateContainer.setState(1);

    await tester.pump();

    expect(memorizedStates[0]["n"], 1);
    expect(memorizedStates[1]["n"], 1);
    // Without inputs should always return new value
    expect(memorizedStates[0] == memorizedStates[1], false);
    expect(stateContainer.state, 1);
  });

  testWidgets("same useMemo inputs return first used value", (tester) async {
    List<Map<String, dynamic>> memorizedStates = [];
    StateContainer stateContainer;
    await tester.pumpWidget(HookBuilder(builder: () {
      stateContainer = useState(0);
      final memorizedState = useMemo(() => {"n": 1}, []);
      memorizedStates.add(memorizedState);
      return Container();
    }));

    stateContainer.setState(1);

    await tester.pump();

    expect(memorizedStates[0] == memorizedStates[1], true);
  });

  testWidgets("useMemo changing inputs return new value", (tester) async {
    List memorizedStates = [];
    StateContainer stateContainer;
    await tester.pumpWidget(HookBuilder(builder: () {
      stateContainer = useState(0);
      final memorizedState = useMemo(() => {"n": 1}, [stateContainer.state]);
      memorizedStates.add(memorizedState);
      return Container();
    }));

    stateContainer.setState(1);

    await tester.pump();

    expect(memorizedStates[0] == memorizedStates[1], false);
  });
}
