import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_form_toolkit/src/controller/smart_form_controller.dart';
import 'package:smart_form_toolkit/src/models/smart_style.dart';
import 'package:smart_form_toolkit/src/smart_form.dart';

/// The type of toggle widget to display.
enum ToggleType {
  /// A standard switch/toggle.
  switchType,
  
  /// A standard checkbox.
  checkbox,
  
  /// A standard radio button.
  radio,
}

/// A platform-adaptive toggle field (Switch, Checkbox, or Radio) integrated with [SmartFormController].
class SmartToggleField extends StatefulWidget {
  /// The unique key for this field in the [SmartFormController].
  final String name;

  /// The label text to display alongside the toggle.
  final String label;

  /// The specific type of toggle UI to use.
  final ToggleType type;

  /// Overrides the default form style for this specific field.
  final SmartStyle? style;

  /// Optional icon to show when the toggle is ON.
  final IconData? onIcon;

  /// Optional icon to show when the toggle is OFF.
  final IconData? offIcon;

  /// Triggered whenever the toggle value changes.
  final ValueChanged<bool>? onChanged;

  /// Creates a [SmartToggleField].
  const SmartToggleField({
    super.key,
    required this.name,
    required this.label,
    this.type = ToggleType.switchType,
    this.style,
    this.onIcon,
    this.offIcon,
    this.onChanged,
  });

  @override
  State<SmartToggleField> createState() => _SmartToggleFieldState();
}

class _SmartToggleFieldState extends State<SmartToggleField> {
  SmartFormController? _controller;
  bool _value = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = SmartFormProvider.of(context);
    if (provider != null) {
      if (_controller != provider.controller) {
        _controller = provider.controller;
        _controller!.addListener(_handleControllerChange);
        _value = _controller!.getValue(widget.name) ?? false;
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    if (_controller != null) {
      final val = _controller!.getValue(widget.name) ?? false;
      if (val != _value) {
        setState(() {
          _value = val;
        });
      }
    }
  }

  void _onChanged(bool newValue) {
    setState(() {
      _value = newValue;
    });
    _controller?.setValue(widget.name, newValue);
    // Simple toggle doesn't usually have validation errors but we could clear them
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final provider = SmartFormProvider.of(context);
    final effectiveStyle = widget.style ?? provider?.defaultStyle ?? SmartStyle.adaptive;
    final platform = Theme.of(context).platform;
    final bool useCupertino = effectiveStyle == SmartStyle.cupertino || 
        (effectiveStyle == SmartStyle.adaptive && (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS));

    if (useCupertino && widget.type == ToggleType.switchType) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: CupertinoTheme.of(context).textTheme.textStyle),
            CupertinoSwitch(
              value: _value,
              onChanged: _onChanged,
            ),
          ],
        ),
      );
    }

    // Material or non-adaptive fallbacks
    if (widget.type == ToggleType.checkbox) {
       return CheckboxListTile(
         title: Text(widget.label),
         value: _value,
         onChanged: (v) => _onChanged(v ?? false),
         secondary: (widget.onIcon != null || widget.offIcon != null) 
            ? Icon(_value ? (widget.onIcon ?? widget.offIcon) : (widget.offIcon ?? widget.onIcon)) 
            : null,
       );
    } else if (widget.type == ToggleType.radio) {
        return RadioListTile<bool>(
          title: Text(widget.label),
          value: true,
          // ignore: deprecated_member_use
          groupValue: _value,
          // ignore: deprecated_member_use
          onChanged: (v) => _onChanged(v ?? false),
          secondary: (widget.onIcon != null || widget.offIcon != null) 
            ? Icon(_value ? (widget.onIcon ?? widget.offIcon) : (widget.offIcon ?? widget.onIcon)) 
            : null,
        );
    }

    // Default Switch
    return SwitchListTile(
      title: Text(widget.label),
      value: _value,
      onChanged: _onChanged,
      secondary: (widget.onIcon != null || widget.offIcon != null) 
            ? Icon(_value ? (widget.onIcon ?? widget.offIcon) : (widget.offIcon ?? widget.onIcon)) 
            : null,
    );
  }
}
