part of 'hook.dart';

TickerProvider useTickerProvider() {
  final context = useContext();
  final tickerProvider = useMemo(() => _SingleTickerProvider(context), []);

  tickerProvider.ticker.muted = !TickerMode.of(context);

  return tickerProvider;
}

class _SingleTickerProvider implements TickerProvider {
  late Ticker ticker;
  BuildContext context;

  _SingleTickerProvider(this.context);

  @override
  Ticker createTicker(onTick) {
    ticker = Ticker(onTick,
        debugLabel: kDebugMode ? 'created by ${context.widget}' : null);
    return ticker;
  }
}
