part of 'hook.dart';

class RefContainer<T> {
  dynamic current;
}

RefContainer useRef() {
  final refStateContainer = useState(RefContainer());

  return refStateContainer.state;
}
