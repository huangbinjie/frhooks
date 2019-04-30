part of 'hook.dart';

T useCallback<T extends Function>(T callback, [List<dynamic> deps]) {
  return useMemo(callback, deps);
}
