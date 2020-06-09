import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frhooks/frhooks.dart';

import 'hook_builder.dart';

class KeepAliveMixinTest extends HookWidget
    with HookAutomaticKeepAliveClientMixin {
  final VoidCallback onBuild;
  KeepAliveMixinTest(this.onBuild);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    useEffect(() {
      onBuild();
      return () {
        onBuild();
      };
    }, []);
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}

void main() {
  testWidgets("HookAutomaticKeepAliveClientMixin basic", (tester) async {
    int _builtTime = 0;
    PageController pageController;
    StateContainer pageIndexState;
    await tester.pumpWidget(HookBuilder(
      builder: () {
        pageIndexState = useState(0);
        pageController = useMemo(() => PageController(), []);
        return MaterialApp(
          home: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (pageIndex) {
              pageIndexState.setState(pageIndex);
            },
            children: <Widget>[
              KeepAliveMixinTest(() => _builtTime++),
              Container(),
            ],
          ),
        );
      },
    ));

    pageController.jumpToPage(1);

    await tester.pump();

    expect(pageIndexState.state, 1);

    pageController.jumpToPage(0);

    await tester.pump();

    pageController.jumpToPage(1);

    await tester.pump();

    expect(_builtTime, 1);
  });
}
