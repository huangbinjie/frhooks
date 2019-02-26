# Flutter-Hooks

use react like hooks style in flutter

# Usage

## useState

```dart
class MyWidget extends HookWidget {
  Widget build() {
    var result = useState(0)
    // result.state
    // result.setState
    return null
  }
}
```

## useMount

```dart
class MyWidget extends HookWidget {
  Widget build() {
    seMount(() {
      // do something here.
    })
    return null
  }
}
```

## useContext

```dart
class MyWidget extends HookWidget {
  Widget build() {
    BuildContext context = useContext() 
    return null
  }
}
```
