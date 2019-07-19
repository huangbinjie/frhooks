part of 'hook.dart';

TickerProvider useTickerProvider() {
  final context = useContext();
  final tickerProvider = useMemo(() => _SingleTickerProvider(context), []);

  if (tickerProvider.ticker != null) {
    tickerProvider.ticker.muted = !TickerMode.of(context);
  }

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
