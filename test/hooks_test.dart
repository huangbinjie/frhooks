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
        if (builtTime == 1) {
          secondStateContainer = useState("some value");
        } else {
          secondStateContainer = null;
        }
        memorizedState = useMemo(
            () => firstStateContainer.state, [firstStateContainer.state]);
        useCallback(() {});
        return Container();
      },
    ));

    await tester.pump();

    expect(memorizedState, 0);
    expect(builtTime, 1);
    expect(secondStateContainer.state, "some value");

    builtTime = 1;

    element.markNeedsBuild();

    await tester.pump();

    expect(memorizedState, 0);

    /// builtTime = 1, markNeedsBuild + 1, hook rerun + 1
    expect(builtTime, 3);

    /// builtTime = 2, builtTime = 3
    expect(secondStateContainer, null);

    firstStateContainer.setState(2);

    await tester.pump();

    expect(builtTime, 4);

    expect(memorizedState, 2);
  });
}
