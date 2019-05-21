import 'package:flutter/widgets.dart';
import 'package:frhooks/frhooks.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets("support conditional hooks", (tester) async {
    StateContainer<int> firstStateContainer;
    StateContainer<String> secondStateContainer;
    int memorizedState;
    HookElement element;
    int builtTime = 0;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        builtTime += 1;
        element = useContext();
        firstStateContainer = useState(0);
        if (firstStateContainer.state == 0) {
          secondStateContainer = useState(builtTime == 1 ? "one" : "two");
        } else {
          secondStateContainer = null;
        }
        memorizedState = useMemo(() => firstStateContainer.state, []);
        return Container();
      },
    ));

    await tester.pump();

    // useContext doesn't increase currentHooksLength.
    expect(element.currentHooksLength, 3);
    expect(memorizedState, 0);
    expect(builtTime, 1);
    expect(secondStateContainer.state, "one");

    builtTime = 0;

    firstStateContainer.setState(1);

    await tester.pump();

    expect(element.currentHooksLength, 3);
    expect(memorizedState, 0);
    expect(builtTime, 2);
    expect(secondStateContainer.state, "two");
  });
}
