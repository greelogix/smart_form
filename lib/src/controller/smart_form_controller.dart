import 'dart:async';
import 'package:flutter/foundation.dart';

/// A controller that manages the state of a [SmartForm].
/// 
/// It tracks values, errors, and interaction state (dirty/touched) for each field.
class SmartFormController extends ChangeNotifier {
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, bool> _dirty = {};
  final Map<String, bool> _touched = {};
  final Map<String, FutureOr<String?> Function(dynamic)?> _validators = {};
  final Set<String> _registeredFields = {};
  
  VoidCallback? _onSubmitCallback;

  /// Returns an unmodifiable map of current field values.
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  /// Returns an unmodifiable map of current validation errors.
  Map<String, String?> get errors => Map.unmodifiable(_errors);
  
  /// Returns `true` if all fields are valid (no errors).
  bool get isValid => _errors.values.every((e) => e == null);

  /// Returns `true` if any field has been modified.
  bool get isDirty => _dirty.isNotEmpty;

  /// Registers a field with the controller (for tracking validators and duplicate names).
  void registerField(String name, {FutureOr<String?> Function(dynamic)? validator}) {
    if (_registeredFields.contains(name)) {
      debugPrint('Warning: Duplicate field name "$name" detected in SmartForm! Overwriting existing validator!');
    } else {
      _registeredFields.add(name);
    }
    if (validator != null) {
      _validators[name] = validator;
    }
  }

  /// Unregisters a field from the controller.
  void unregisterField(String name) {
    _registeredFields.remove(name);
    _validators.remove(name);
  }

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

  /// Validates all registered fields and returns true if all are valid.
  Future<bool> validate() async {
    bool valid = true;
    for (final name in _validators.keys) {
      final validator = _validators[name];
      if (validator != null) {
        final error = await validator(_values[name]);
        setError(name, error);
        if (error != null) {
          valid = false;
        }
      }
    }
    return valid;
  }

  /// Resets the form state, clearing all values, errors, interaction flags, and registered fields/validators.
  void reset() {
    _values.clear();
    _errors.clear();
    _dirty.clear();
    _touched.clear();
    _registeredFields.clear();
    _validators.clear();
    notifyListeners();
  }

  /// Manually triggers form submission via the controller.
  Future<void> submit() async {
    await validate();
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
