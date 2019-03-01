# Flutter-Hooks

use react like hooks in flutter.

## Motivation
Have the same thinking of the [flutter_hooks motivation](https://github.com/rrousselGit/flutter_hooks#motivation). React hooks is more brief to manage local state, and `StatefulWidget` are verbose. This library brings hooks to flutter. If your are React person, you will like it.

# Usage

## useContext

```dart
class MyWidget extends HookWidget {
  Widget build() {
    BuildContext context = useContext() 
    return Container()
  }
}
```

## useState

```dart
class MyWidget extends HookWidget {
  Widget build() {
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
  Widget build() {
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
  Widget build() {
    var callback = useCallback(() {
      return 1
    })
    // result == 1
    var result = callback()
    return Container()
  }
}
```
