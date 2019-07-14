# Frhooks

[![Build Status](https://travis-ci.org/huangbinjie/frhooks.svg?branch=master)](https://travis-ci.org/huangbinjie/frhooks)

use react like hooks in flutter.

## Motivation
Have the same thinking of the [flutter_hooks motivation](https://github.com/rrousselGit/flutter_hooks#motivation). React hooks is more brief to manage local state, and `StatefulWidget` are verbose. This library brings hooks to flutter. If your are React person, you will like it.

# Usage

## useContext

```dart
class MyWidget extends HookWidget {
  Widget build(BuildContext context) {
    BuildContext context = useContext() 
    return Container()
  }
}
```

## useState

```dart
class MyWidget extends HookWidget {
  Widget build(BuildContext context) {
    StateContainer result = useState(0)
    // result.state
    // result.setState
    return Container()
  }
}
```

## useEffect

```dart
class MyWidget extends HookWidget {
  Widget build(BuildContext context) {
    useEffect(() {
      // do effect here.
      return () {
        // remove effect here
      }
    })
    return Container()
  }
}
```

## useCallback

```dart
class MyWidget extends HookWidget {
  Widget build(BuildContext context) {
    var callback = useCallback(() {
      return 1
    }, [])
    // result == 1
    var result = callback()
    return Container()
  }
}
```

## useMemo

```dart
class MyWidget extends HookWidget {
  Widget build(BuildContext context) {
    var c = useMemo(() => computeExpensiveValue(a, b), [a, b]);
    return Container()
  }
}
```

## useRef

```dart
class MyWidget extends HookWidget {
  Widget build(BuildContext context) {
    final ref = useRef();
    // free to set and read ref.current
    return Container()
  }
}
```

## useAnimationController

```dart
class MyWidget extends HookWidget {
  Widget build(BuildContext context) {
    final controller = useAnimationController();
    // controller.forward()
    return Container()
  }
}
```

# Mixins

Frhooks aims to replace `State` completely, also include mixins.

## HookAutomaticKeepAliveClientMixin

Hook version of [AutomaticKeepAliveClientMixin](https://api.flutter.dev/flutter/widgets/AutomaticKeepAliveClientMixin-mixin.html).

```dart
class MyWidget extends HookWidget with HookAutomaticKeepAliveClientMixin {
  get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }
}
```