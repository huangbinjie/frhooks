import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frhooks/frhooks.dart';

class KeepAliveMixinTest extends HookWidget
    with HookAutomaticKeepAliveClientMixin {
  final VoidCallback onBuild;
  KeepAliveMixinTest(this.onBuild);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    onBuild();
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}

void main() {
  testWidgets("HookAutomaticKeepAliveClientMixin basic", (tester) async {
    int _builtTime = 0;
    final pageController = PageController();

    await tester.pumpWidget(MaterialApp(
      home: PageView(
        controller: pageController,
        children: <Widget>[KeepAliveMixinTest(() => _builtTime++), Container()],
      ),
    ));

    expect(_builtTime, 1);

    pageController.jumpToPage(1);
    
    pageController.jumpToPage(0);

    expect(_builtTime, 1);
  });
}
