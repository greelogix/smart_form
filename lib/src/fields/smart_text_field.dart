import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_form_toolkit/src/controller/smart_form_controller.dart';
import 'package:smart_form_toolkit/src/models/field_decoration.dart';
import 'package:smart_form_toolkit/src/models/smart_style.dart';
import 'package:smart_form_toolkit/src/smart_form.dart';

/// A versatile text input widget that integrates with [SmartFormController].
/// 
/// It supports platform-aware styling, debounced [onChanged] events, 
/// asynchronous validation, and a wide array of standard text field properties.
class SmartTextField extends StatefulWidget {
  /// The unique key for this field in the [SmartFormController].
  final String name;

  /// The label text to display above or inside the field.
  final String? label;

  /// The placeholder text to display when the field is empty.
  final String? hint;

  /// Whether to hide the text being entered (e.g., for passwords).
  final bool obscureText;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  /// The maximum number of lines for the text.
  final int? maxLines;

  /// The minimum number of lines for the text.
  final int? minLines;

  /// Overrides the default form style for this specific field.
  final SmartStyle? style;

  /// Custom visual decoration for the field.
  final FieldDecoration? decoration;

  /// The delay before [onChanged] is triggered after typing stops.
  final Duration debounce;

  /// Explicit height for the field's container.
  final double? height;

  /// Explicit width for the field's container.
  final double? width;

  /// Triggered whenever the value changes (debounced).
  final ValueChanged<String>? onChanged;

  /// Triggered when the field gains focus.
  final VoidCallback? onFocus;

  /// Triggered when the field loses focus.
  final VoidCallback? onBlur;

  /// A function for validating the input, supports asynchronous operations.
  final FutureOr<String?> Function(String?)? validator;

  /// Whether to use [TextFormField] for native form integration or a basic [TextField].
  final bool useFormField;

  /// Whether the field should take focus automatically.
  final bool autofocus;

  /// Whether the field is in a read-only state.
  final bool readOnly;

  /// Whether the field is interactive.
  final bool enabled;

  /// Formatters to restrict or modify input as the user types.
  final List<TextInputFormatter>? inputFormatters;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Custom text style for the input.
  final TextStyle? textStyle;

  /// The type of action button to show on the keyboard.
  final TextInputAction? textInputAction;

  /// Triggered when the user submits the field (e.g., presses [TextInputAction.done]).
  final ValueChanged<String>? onSubmitted;

  /// Triggered when editing is complete.
  final VoidCallback? onEditingComplete;

  /// An optional external focus node to control focus from outside.
  final FocusNode? externalFocusNode;

  /// An optional external controller for direct text manipulation.
  final TextEditingController? externalController;

  /// Creates a [SmartTextField].
  const SmartTextField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.decoration,
    this.debounce = const Duration(milliseconds: 300),
    this.height,
    this.width,
    this.onChanged,
    this.onFocus,
    this.onBlur,
    this.validator,
    this.useFormField = true,
    this.autofocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.textInputAction,
    this.onSubmitted,
    this.onEditingComplete,
    this.externalFocusNode,
    this.externalController,
  });

  @override
  State<SmartTextField> createState() => _SmartTextFieldState();
}

class _SmartTextFieldState extends State<SmartTextField> {
  late TextEditingController _textController;
  Timer? _debounceTimer;
  SmartFormController? _controller;
  String? _errorText;
  late FocusNode _focusNode;
  bool _isAsyncValidating = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.externalFocusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _textController = widget.externalController ?? TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = SmartFormProvider.of(context);
    if (provider != null) {
      if (_controller != provider.controller) {
        _controller = provider.controller;
        _controller!.addListener(_handleControllerChange);
        
        // Initialize value from controller if exists and not using external controller
        if (widget.externalController == null) {
          final initialValue = _controller!.getValue(widget.name);
          _textController.text = initialValue?.toString() ?? '';
        }
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.externalFocusNode == null) _focusNode.dispose();
    _controller?.removeListener(_handleControllerChange);
    if (widget.externalController == null) _textController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleControllerChange() {
    if (_controller == null) return;
    final newValue = _controller!.getValue(widget.name)?.toString() ?? '';
    if (_textController.text != newValue) {
        _textController.text = newValue;
    }
    
    // Update error state
    if (_errorText != _controller!.getError(widget.name)) {
      setState(() {
        _errorText = _controller!.getError(widget.name);
      });
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      widget.onFocus?.call();
    } else {
      widget.onBlur?.call();
      _controller?.setTouched(widget.name);
    }
  }

  void _onChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(widget.debounce, () {
      _updateController(value);
      widget.onChanged?.call(value);
    });
  }

  Future<void> _updateController(String value) async {
    if (_controller != null) {
      _controller!.setValue(widget.name, value);
      if (widget.validator != null) {
         setState(() => _isAsyncValidating = true);
         final error = await widget.validator!(value);
         if (mounted) {
           setState(() => _isAsyncValidating = false);
           _controller!.setError(widget.name, error);
         }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = SmartFormProvider.of(context);
    final effectiveStyle = widget.style ?? provider?.defaultStyle ?? SmartStyle.adaptive;
    
    final platform = Theme.of(context).platform;
    final bool useCupertino = effectiveStyle == SmartStyle.cupertino || 
        (effectiveStyle == SmartStyle.adaptive && (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS));

    Widget field;
    if (useCupertino) {
      field = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) 
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(widget.label!, style: CupertinoTheme.of(context).textTheme.textStyle),
            ),
          SizedBox(
            height: widget.height,
            child: CupertinoTextField(
              controller: _textController,
              focusNode: _focusNode,
              placeholder: widget.hint,
              placeholderStyle: widget.decoration?.hintStyle,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              onChanged: _onChanged,
              onSubmitted: widget.onSubmitted,
              onEditingComplete: widget.onEditingComplete,
              autofocus: widget.autofocus,
              readOnly: widget.readOnly,
              enabled: widget.enabled,
              inputFormatters: widget.inputFormatters,
              textAlign: widget.textAlign,
              style: widget.textStyle,
              textInputAction: widget.textInputAction,
              prefix: widget.decoration?.prefixIcon ?? widget.decoration?.prefix,
              suffix: widget.decoration?.suffixIcon ?? widget.decoration?.suffix ?? (_isAsyncValidating ? const Padding(padding: EdgeInsets.all(8), child: CupertinoActivityIndicator(radius: 8)) : null),
              padding: widget.decoration?.padding ?? const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.decoration?.fillColor ?? CupertinoColors.white,
                border: Border.all(
                  color: _errorText != null ? CupertinoColors.systemRed : (widget.decoration?.borderColor ?? CupertinoColors.systemGrey4),
                  width: widget.decoration?.borderWidth ?? 1.0,
                ),
                borderRadius: BorderRadius.circular(widget.decoration?.borderRadius ?? 8.0),
                boxShadow: widget.decoration?.shadows,
              ),
            ),
          ),
          if (_errorText != null)
             Padding(
               padding: const EdgeInsets.only(top: 4.0),
               child: Text(_errorText!, style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 12)),
             ),
        ],
      );
    } else {
      InputDecoration decoration = InputDecoration(
        labelText: widget.label,
        labelStyle: widget.decoration?.labelStyle,
        hintText: widget.hint,
        hintStyle: widget.decoration?.hintStyle,
        prefix: widget.decoration?.prefix,
        prefixIcon: widget.decoration?.prefixIcon,
        suffix: widget.decoration?.suffix,
        suffixIcon: widget.decoration?.suffixIcon ?? (_isAsyncValidating ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))) : null),
        errorText: _errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.decoration?.borderRadius ?? 4.0),
          borderSide: BorderSide(
            color: widget.decoration?.borderColor ?? Colors.grey,
            width: widget.decoration?.borderWidth ?? 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(widget.decoration?.borderRadius ?? 4.0),
           borderSide: BorderSide(
            color: widget.decoration?.borderColor ?? Colors.grey,
            width: widget.decoration?.borderWidth ?? 1.0,
           ),
        ),
        filled: widget.decoration?.fillColor != null,
        fillColor: widget.decoration?.fillColor,
        contentPadding: widget.decoration?.padding,
      );

      if (widget.useFormField) {
        field = SizedBox(
          height: widget.height,
          child: TextFormField(
            controller: _textController,
            focusNode: _focusNode,
            decoration: decoration,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            onChanged: _onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onEditingComplete: widget.onEditingComplete,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            inputFormatters: widget.inputFormatters,
            textAlign: widget.textAlign,
            style: widget.textStyle,
            textInputAction: widget.textInputAction,
          ),
        );
      } else {
        field = SizedBox(
          height: widget.height,
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            decoration: decoration,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            onChanged: _onChanged,
            onSubmitted: widget.onSubmitted,
            onEditingComplete: widget.onEditingComplete,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            inputFormatters: widget.inputFormatters,
            textAlign: widget.textAlign,
            style: widget.textStyle,
            textInputAction: widget.textInputAction,
          ),
        );
      }
    }

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: field);
    }
    return field;
  }
}
