part of 'hook.dart';

T useMemo<T>(T memorizedState) {
  final memoContainer = useState(memorizedState);
  return memoContainer.state;
}
