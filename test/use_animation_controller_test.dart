import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:frhooks/frhooks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'hook_builder.dart';

// Use official test case: https://github.com/flutter/flutter/blob/master/packages/flutter/test/animation/animations_test.dart

void tick(Duration duration) {
  // We don't bother running microtasks between these two calls
  // because we don't use Futures in these tests and so don't care.
  SchedulerBinding.instance.handleBeginFrame(duration);
  SchedulerBinding.instance.handleDrawFrame();
}

void main() {
  // TODO：Test with TickerMode

  testWidgets("Remove before animation finished should throw error",
      (tester) async {
    AnimationController controller;
    await tester.pumpWidget(HookBuilder(builder: () {
      controller = useAnimationController(duration: Duration(seconds: 1));
      controller.forward();
      return Container();
    }));

    FlutterError.onError = (error) {
      ErrorSummary summary = error.summary;

      expectSync(
          summary
              .toDescription()
              .contains("HookBuilder was disposed with an active Ticker."),
          true);

      controller.stop();
    };

    await tester.pumpWidget(Container());
  });

  testWidgets("toString control test", (tester) async {
    await tester.pumpWidget(HookBuilder(
      builder: () {
        CurvedAnimation curvedAnimation = CurvedAnimation(
          parent: kAlwaysDismissedAnimation,
          curve: Curves.ease,
        );

        final AnimationController controller =
            useAnimationController(duration: const Duration(milliseconds: 500));

        controller
          ..value = 0.5
          ..reverse();

        curvedAnimation = CurvedAnimation(
          parent: controller,
          curve: Curves.ease,
          reverseCurve: Curves.elasticOut,
        );

        expect(curvedAnimation, hasOneLineDescription);

        controller.stop();
        return Container();
      },
    ));
  });

  testWidgets("AnimationMean control test", (tester) async {
    await tester.pumpWidget(HookBuilder(builder: () {
      return TickerMode(
        child: HookBuilder(builder: () {
          final left = useAnimationController(value: 0.5);
          final right = useAnimationController();
          final AnimationMean mean = AnimationMean(left: left, right: right);

          expect(mean, hasOneLineDescription);
          expect(mean.value, equals(0.25));

          final List<double> log = <double>[];
          void logValue() {
            log.add(mean.value);
          }

          mean.addListener(logValue);

          right.value = 1.0;

          expect(mean.value, equals(0.75));
          expect(log, equals(<double>[0.75]));
          log.clear();

          mean.removeListener(logValue);

          left.value = 0.0;

          expect(mean.value, equals(0.50));
          expect(log, isEmpty);

          return Container();
        }),
        enabled: true,
      );
    }));
  });

  testWidgets(
      "CurvedAnimation running with different forward and reverse durations.",
      (tester) async {
    AnimationController controller;

    await tester.pumpWidget(HookBuilder(
      builder: () {
        controller = useAnimationController(
            duration: const Duration(milliseconds: 100),
            reverseDuration: const Duration(milliseconds: 50));
        return Container();
      },
    ));

    final CurvedAnimation curved = CurvedAnimation(
        parent: controller, curve: Curves.linear, reverseCurve: Curves.linear);

    controller.forward();
    tick(const Duration(milliseconds: 0));
    tick(const Duration(milliseconds: 10));
    expect(curved.value, closeTo(0.1, precisionErrorTolerance));
    tick(const Duration(milliseconds: 20));
    expect(curved.value, closeTo(0.2, precisionErrorTolerance));
    tick(const Duration(milliseconds: 30));
    expect(curved.value, closeTo(0.3, precisionErrorTolerance));
    tick(const Duration(milliseconds: 40));
    expect(curved.value, closeTo(0.4, precisionErrorTolerance));
    tick(const Duration(milliseconds: 50));
    expect(curved.value, closeTo(0.5, precisionErrorTolerance));
    tick(const Duration(milliseconds: 60));
    expect(curved.value, closeTo(0.6, precisionErrorTolerance));
    tick(const Duration(milliseconds: 70));
    expect(curved.value, closeTo(0.7, precisionErrorTolerance));
    tick(const Duration(milliseconds: 80));
    expect(curved.value, closeTo(0.8, precisionErrorTolerance));
    tick(const Duration(milliseconds: 90));
    expect(curved.value, closeTo(0.9, precisionErrorTolerance));
    tick(const Duration(milliseconds: 100));
    expect(curved.value, closeTo(1.0, precisionErrorTolerance));
    controller.reverse();
    tick(const Duration(milliseconds: 110));
    expect(curved.value, closeTo(1.0, precisionErrorTolerance));
    tick(const Duration(milliseconds: 120));
    expect(curved.value, closeTo(0.8, precisionErrorTolerance));
    tick(const Duration(milliseconds: 130));
    expect(curved.value, closeTo(0.6, precisionErrorTolerance));
    tick(const Duration(milliseconds: 140));
    expect(curved.value, closeTo(0.4, precisionErrorTolerance));
    tick(const Duration(milliseconds: 150));
    expect(curved.value, closeTo(0.2, precisionErrorTolerance));
    tick(const Duration(milliseconds: 160));
    expect(curved.value, closeTo(0.0, precisionErrorTolerance));

    await tester.pumpWidget(Container());
  });
}
