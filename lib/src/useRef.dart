part of 'hook.dart';

class RefContainer<T> {
  dynamic current;
  RefContainer(this.current);
}

RefContainer<T> useRef<T>([T initialValue]) {
  final refStateContainer = useState(RefContainer(initialValue));

  return refStateContainer.state;
}
