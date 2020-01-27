import 'package:flutter/widgets.dart';
import 'package:frhooks/frhooks.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets('useState basic', (tester) async {
    StateContainer<int> stateContainer;
    HookElement element;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        element = useContext();
        stateContainer = useState(0);
        return Container();
      },
    ));

    expect(stateContainer.state, 0);
    expect(element.dirty, false);

    await tester.pump();

    expect(stateContainer.state, 0);
    expect(element.dirty, false);

    stateContainer.setState(2);
    expect(element.dirty, true);
    await tester.pump();

    expect(stateContainer.state, 2);
    expect(element.dirty, false);

    await tester.pumpWidget(SizedBox());

    await tester.pumpWidget(HookBuilder(
      builder: () {
        element = useContext();
        stateContainer = useState(0);
        return Container();
      },
    ));

    expect(stateContainer.state, 0);
    expect(element.dirty, false);
  });

  testWidgets("useState should return same the reference of StateContainer .",
      (tester) async {
    List<StateContainer<int>> stateContainers = [];
    HookElement context;
    await tester.pumpWidget(HookBuilder(builder: () {
      context = useContext();
      stateContainers.add(useState(1));
      return Container();
    }));

    await tester.pump();

    context.markNeedsBuild();

    await tester.pump();

    expect(stateContainers[0], stateContainers[1]);
  });

  testWidgets("build widget before useState", (tester) async {
    StateContainer<int> stateContainer;
    StateContainer<String> childStateContainer;
    int renderedNum = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        renderedNum++;
        final c = HookBuilder(builder: () {
          childStateContainer = useState("1");
          return Container();
        });
        stateContainer = useState(0);
        return c;
      },
    ));

    expect(stateContainer.state, 0);
    expect(childStateContainer.state, "1");
    expect(renderedNum, 1);

    stateContainer.setState(1);

    await tester.pump();

    expect(stateContainer.state, 1);
    expect(childStateContainer.state, "1");
    expect(renderedNum, 2);
  });

  testWidgets("useState should accept null as parameter.", (tester) async {
    StateContainer<int> stateContainer;
    int renderedNum = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        renderedNum++;
        stateContainer = useState<int>(null);
        return Container();
      },
    ));

    expect(stateContainer.state, null);
    expect(renderedNum, 1);

    stateContainer.setState(1);

    await tester.pump();

    expect(stateContainer.state, 1);
    expect(renderedNum, 2);
  });
}
