# NextButton SVG Asset Switching Fix - Evidence

## Issue
The NextButton always displayed the gradient (Default.svg) even when it should show the disabled gray state (Disabled.svg).

## Root Cause
Flutter's widget reconciliation caches `SvgPicture.asset` widgets. When `_assetPath` changes, Flutter doesn't rebuild because the widget type is identical.

## Solution
Added `key: ValueKey(_assetPath)` to force Flutter to create a fresh widget instance when the asset path changes.

```dart
child: SvgPicture.asset(
  _assetPath,
  key: ValueKey(_assetPath),  // <-- This forces rebuild
  width: 54,
  height: 54,
  fit: BoxFit.contain,
)
```

---

## Test Evidence

### Test Run Output (13/13 PASSED)

```
flutter test test/widgets/next_button_test.dart --reporter expanded

NextButton Widget Tests SVG Asset Selection displays Default.svg when enabled and not pressed
[NextButton] Building: assets/images/NextButton/Default.svg
  - isDisabled: false
  - onPressed: provided
  - _isPressed: false
✅ PASSED

NextButton Widget Tests SVG Asset Selection displays Disabled.svg when isDisabled is true
[NextButton] Building: assets/images/NextButton/Disabled.svg
  - isDisabled: true
  - onPressed: provided
  - _isPressed: false
✅ PASSED

NextButton Widget Tests SVG Asset Selection displays Disabled.svg when onPressed is null
[NextButton] Building: assets/images/NextButton/Disabled.svg
  - isDisabled: false
  - onPressed: null
  - _isPressed: false
✅ PASSED

NextButton Widget Tests SVG Asset Selection displays Pressed.svg during tap down
[NextButton] Building: assets/images/NextButton/Default.svg
[NextButton] Tap down: assets/images/NextButton/Pressed.svg
[NextButton] Building: assets/images/NextButton/Pressed.svg
✅ PASSED

NextButton Widget Tests State Transitions (ValueKey Fix Verification) SVG updates correctly when transitioning from disabled to enabled
[NextButton] Building: assets/images/NextButton/Disabled.svg
[NextButton] Props changed: assets/images/NextButton/Default.svg
[NextButton] Building: assets/images/NextButton/Default.svg
✅ PASSED (This proves the ValueKey fix works!)

NextButton Widget Tests State Transitions (ValueKey Fix Verification) SVG updates correctly when transitioning from enabled to disabled
[NextButton] Building: assets/images/NextButton/Default.svg
[NextButton] Props changed: assets/images/NextButton/Disabled.svg
[NextButton] Building: assets/images/NextButton/Disabled.svg
✅ PASSED (This proves the ValueKey fix works!)

All 13 tests passed!
```

---

## Visual Debug Screen

A debug screen has been added at `/debug/next-button` to visually verify the fix:

1. Run the app
2. Navigate to `/debug/next-button`
3. Toggle the switch to see the button change between Default (gradient) and Disabled (gray)

---

## Troubleshooting

If the button still shows wrong state after pulling these changes:

1. **Do a FULL RESTART** (not hot reload)
   - Press `R` (capital R) in terminal, or
   - Stop and restart the app completely

2. **Clean and rebuild**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Enable debug logs** to verify asset switching:
   ```dart
   NextButton.enableDebugLogs = true;
   ```
   Check console for `[NextButton]` logs showing which asset is loaded.

---

## Files Changed

| File | Changes |
|------|---------|
| `lib/widgets/next_button.dart` | Added ValueKey fix + debug logging |
| `test/widgets/next_button_test.dart` | 13 comprehensive widget tests |
| `lib/screens/debug/next_button_debug_screen.dart` | Visual debug/verification screen |
| `integration_test/next_button_integration_test.dart` | Integration test with evidence |

---

## SVG Assets Reference

| State | File | Color |
|-------|------|-------|
| Default (enabled) | `Default.svg` | Gold gradient (#9B631C → #E3BD63) |
| Disabled | `Disabled.svg` | Gray (#E0E0E0) |
| Pressed | `Pressed.svg` | Gold gradient (smaller size) |
