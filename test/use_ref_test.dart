import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frhooks/frhooks.dart';
import './hook_builder.dart';

void main() {
  testWidgets("useRef basic", (tester) async {
    RefContainer<int> ref;
    StateContainer state;
    await tester.pumpWidget(HookBuilder(builder: () {
      ref = useRef(0);
      state = useState(0);

      useEffect(() {
        ref.current += 1;
      });

      return Container();
    }));

    expect(ref.current, 1);

    state.setState(1);

    await tester.pump();

    expect(state.state, 1);
    expect(ref.current, 2);
  });
}
