import 'package:flutter/widgets.dart';
import 'package:flutter_hooks2/flutter_hooks2.dart';
import 'package:flutter_test/flutter_test.dart';
import './hook_builder.dart';

void main() {
  testWidgets('useContext basic', (tester) async {
    HookElement element;

    await tester.pumpWidget(HookBuilder(builder: () {
      element = useContext();
      return Container();
    }));

    final context = tester.firstElement(find.byType(HookBuilder));

    expect(element, context);
  });
}
