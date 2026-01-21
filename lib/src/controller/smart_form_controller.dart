import 'package:flutter/foundation.dart';

/// A controller that manages the state of a [SmartForm].
/// 
/// It tracks values, errors, and interaction state (dirty/touched) for each field.
class SmartFormController extends ChangeNotifier {
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, bool> _dirty = {};
  final Map<String, bool> _touched = {};
  
  VoidCallback? _onSubmitCallback;

  /// Returns an unmodifiable map of current field values.
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  /// Returns an unmodifiable map of current validation errors.
  Map<String, String?> get errors => Map.unmodifiable(_errors);
  
  /// Returns `true` if all fields are valid (no errors).
  bool get isValid => _errors.values.every((e) => e == null);

  /// Returns `true` if any field has been modified.
  bool get isDirty => _dirty.isNotEmpty;

  /// Sets the value for a specific field by its [name].
  void setValue(String name, dynamic value, {bool notify = true}) {
    if (_values[name] != value) {
      _values[name] = value;
      _dirty[name] = true;
      if (notify) notifyListeners();
    }
  }

  /// Retrieves the current value of a field by its [name].
  dynamic getValue(String name) => _values[name];

  /// Sets or clears the error message for a specific field by its [name].
  void setError(String name, String? error) {
    if (_errors[name] != error) {
      _errors[name] = error;
      notifyListeners();
    }
  }
  
  /// Retrieves the current error message for a field by its [name].
  String? getError(String name) => _errors[name];

  /// Marks a field as "touched" (interacted with).
  void setTouched(String name) {
    if (_touched[name] != true) {
      _touched[name] = true;
      notifyListeners();
    }
  }

  /// Resets the form state, clearing all values, errors, and interaction flags.
  void reset() {
    _values.clear();
    _errors.clear();
    _dirty.clear();
    _touched.clear();
    notifyListeners();
  }

  /// Manually triggers form submission via the controller.
  void submit() {
    if (_onSubmitCallback != null) {
      _onSubmitCallback!();
    }
  }

  /// internal: Sets the callback triggered by [submit].
  @internal
  void setOnSubmitCallback(VoidCallback? callback) {
    _onSubmitCallback = callback;
  }
}
