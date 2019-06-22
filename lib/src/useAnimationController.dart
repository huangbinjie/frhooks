part of 'hook.dart';

class _SingleTickerProvider implements TickerProvider {
  Ticker ticker;
  BuildContext context;

  _SingleTickerProvider(this.context);

  @override
  Ticker createTicker(onTick) {
    ticker = Ticker(onTick,
        debugLabel: kDebugMode ? 'created by ${context.widget}' : null);
    return ticker;
  }
}

AnimationController useAnimationController({
  double value,
  Duration duration,
  Duration reverseDuration,
  String debugLabel,
  double lowerBound = 0.0,
  double upperBound = 1.0,
  AnimationBehavior animationBehavior,
}) {
  final context = useContext();
  final singleTickerProvider =
      useMemo(() => _SingleTickerProvider(context), []);
  final animationController = useMemo(
      () => AnimationController(
          value: value,
          duration: duration,
          reverseDuration: reverseDuration,
          lowerBound: lowerBound,
          upperBound: upperBound,
          animationBehavior: animationBehavior,
          vsync: singleTickerProvider),
      []);

  if (singleTickerProvider.ticker != null) {
    singleTickerProvider.ticker.muted = !TickerMode.of(context);
  }

  useEffect(() {
    return () {
      assert(() {
        if (singleTickerProvider.ticker == null ||
            !singleTickerProvider.ticker.isActive) return true;
        throw FlutterError(
            '${context.widget} was disposed with an active Ticker.\n'
            '${context.widget} created a Ticker via useAnimationController, but at the time '
            'clean effect was called on the useEffect, that Ticker was still active. The Ticker must '
            'be disposed before unmount. Tickers used by AnimationControllers '
            'should be disposed by calling dispose() on the AnimationController itself. '
            'Otherwise, the ticker will leak.\n'
            'The offending ticker was: ${singleTickerProvider.ticker.toString(debugIncludeStack: true)}');
      }());
    };
  }, []);

  return animationController;
}
