part of 'hook.dart';

TickerProvider useTickerProvider() {
  final context = useContext();
  final tickerProvider = useMemo(() => _SingleTickerProvider(context), []);

  if (tickerProvider.ticker != null) {
    tickerProvider.ticker.muted = !TickerMode.of(context);
  }

  useEffect(() {
    return () {
      assert(() {
        if (tickerProvider.ticker == null || !tickerProvider.ticker.isActive)
          return true;
        throw FlutterError(
            '${context.widget} was disposed with an active Ticker.\n'
            '${context.widget} created a Ticker via useTicker or useAnimationController, but at the time '
            'clean effect was called on the useEffect, that Ticker was still active. The Ticker must '
            'be disposed before unmount. Tickers used by AnimationControllers '
            'should be disposed by calling dispose() on the AnimationController itself. '
            'Otherwise, the ticker will leak.\n'
            'The offending ticker was: ${tickerProvider.ticker.toString(debugIncludeStack: true)}');
      }());
    };
  }, []);

  return tickerProvider;
}

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
