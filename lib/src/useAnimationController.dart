part of 'hook.dart';

/// No need to call dispose() on AnimationController manually, this hook will auto dispose for you.
AnimationController useAnimationController(
    {double value,
    Duration duration,
    Duration reverseDuration,
    String debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    AnimationBehavior animationBehavior,
    TickerProvider ticker}) {
  final tickerProvider = ticker ?? useTickerProvider();

  final animationController = useMemo(
      () => AnimationController(
          value: value,
          duration: duration,
          reverseDuration: reverseDuration,
          lowerBound: lowerBound,
          upperBound: upperBound,
          animationBehavior: animationBehavior,
          vsync: tickerProvider),
      []);

  useEffect(() {
    return () {
      animationController.dispose();
    };
  }, []);

  return animationController;
}
