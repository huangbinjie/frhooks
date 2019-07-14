part of './hook.dart';

abstract class HookWidget extends StatelessWidget {
  const HookWidget({Key key}) : super(key: key);

  @override
  HookElement createElement() {
    return HookElement(this);
  }

  Widget build(BuildContext context);
}

/// Frhook version of AutomaticKeepAliveClientMixin.
mixin HookAutomaticKeepAliveClientMixin on HookWidget {
  /// Whether the current instance should be kept alive.
  @protected
  bool get wantKeepAlive;

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    RefContainer<bool> wantKeepAliveRef = useRef(wantKeepAlive);
    RefContainer<KeepAliveHandle> keepAliveHandleRef = useRef(null);

    final ensureKeepAlive = useCallback(() {
      assert(keepAliveHandleRef.current == null);
      keepAliveHandleRef.current = KeepAliveHandle();
      KeepAliveNotification(keepAliveHandleRef.current).dispatch(context);
    }, []);

    final releaseKeepAlive = useCallback(() {
      keepAliveHandleRef.current.release();
      keepAliveHandleRef.current = null;
    }, []);

    final updateKeepAlive = useCallback(() {
      if (wantKeepAlive) {
        if (keepAliveHandleRef.current == null) ensureKeepAlive();
      } else {
        if (keepAliveHandleRef.current != null) releaseKeepAlive();
      }
    }, []);

    useEffect(() {
      if (wantKeepAliveRef.current != wantKeepAlive) {
        updateKeepAlive();
      }
    });

    useEffect(() {
      if (wantKeepAlive) ensureKeepAlive();
      return () {
        if (keepAliveHandleRef.current != null) releaseKeepAlive();
      };
    }, []);

    return null;
  }
}
