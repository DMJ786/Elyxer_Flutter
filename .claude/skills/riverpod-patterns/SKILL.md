---
name: riverpod-patterns
description: Riverpod state management patterns and conventions for this project. Auto-loaded when writing providers, notifiers, or state management code.
user-invocable: false
---

# Riverpod Patterns — Elyxer Flutter

This project uses **Riverpod 3.0** with code generation. Follow these patterns exactly.

## Provider Types

### Stateful Notifier (persistent across screens)
```dart
@Riverpod(keepAlive: true)
class MyNotifier extends _$MyNotifier {
  @override
  MyState build() => const MyState(); // initial state

  void updateField(String value) {
    state = state.copyWith(field: value);
  }
}
```

### Auto-dispose Notifier (screen-scoped)
```dart
@riverpod
class ScreenNotifier extends _$ScreenNotifier {
  @override
  ScreenState build() => const ScreenState();
}
```

### Async Provider (API calls)
```dart
@riverpod
Future<Result> fetchData(Ref ref, {required String id}) async {
  final service = ref.read(serviceProvider);
  return service.getData(id);
}
```

### Computed/Derived Provider
```dart
@riverpod
bool canProceed(Ref ref) {
  final data = ref.watch(myNotifierProvider);
  return data.requiredField.isNotEmpty;
}
```

## Timer Pattern (OTP countdown)
```dart
@Riverpod(keepAlive: true)
class OTPTimer extends _$OTPTimer {
  Timer? _timer;

  @override
  int build() => 120; // 2 minutes

  void start() {
    _timer?.cancel();
    state = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state > 0) { state--; } else { _timer?.cancel(); }
    });
  }

  void cancel() { _timer?.cancel(); }
}
```

## Rules
- ALWAYS use `@riverpod` or `@Riverpod()` annotations — never manual Provider()
- ALWAYS run `build_runner` after adding/changing providers
- Use `keepAlive: true` ONLY for data that persists across screen navigation
- Use `ref.watch()` in build methods, `ref.read()` in callbacks
- Use `ref.listen()` for side effects (navigation, snackbars)
- Notifier state must be immutable — use Freezed `copyWith()`
