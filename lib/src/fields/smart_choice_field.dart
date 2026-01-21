import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_form/src/controller/smart_form_controller.dart';
import 'package:smart_form/src/models/choice_option.dart';
import 'package:smart_form/src/models/smart_style.dart';
import 'package:smart_form/src/smart_form.dart';

/// The layout strategy for displaying choice options.
enum ChoiceLayout {
  /// Options displayed in a horizontal row.
  row,
  
  /// Options displayed in a vertical column.
  column,
  
  /// Options displayed within a platform-specific segmented control.
  segmented,
  
  /// Options that wrap across multiple lines if necessary.
  wrap,
}

/// A field that allows selecting a single value from a group of [options].
/// 
/// It supports various [ChoiceLayout] strategies and adapts its internal
/// widgets (like Radios or Segmented Controls) to the active [SmartStyle].
class SmartChoiceField<T extends Object> extends StatefulWidget {
  /// The unique key for this field in the [SmartFormController].
  final String name;

  /// The label text to display above the choices.
  final String? label;

  /// The list of options available for selection.
  final List<ChoiceOption<T>> options;

  /// How the options should be arranged visually.
  final ChoiceLayout layout;

  /// Overrides the default form style for this specific field.
  final SmartStyle? style;

  /// Triggered whenever the selected value changes.
  final ValueChanged<T?>? onChanged;

  /// Creates a [SmartChoiceField].
  const SmartChoiceField({
    super.key,
    required this.name,
    required this.options,
    this.label,
    this.layout = ChoiceLayout.row,
    this.style,
    this.onChanged,
  });

  @override
  State<SmartChoiceField<T>> createState() => _SmartChoiceFieldState<T>();
}

class _SmartChoiceFieldState<T extends Object> extends State<SmartChoiceField<T>> {
  SmartFormController? _controller;
  T? _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = SmartFormProvider.of(context);
    if (provider != null) {
      if (_controller != provider.controller) {
        _controller = provider.controller;
        _controller!.addListener(_handleControllerChange);
        _selectedValue = _controller!.getValue(widget.name);
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
      final val = _controller!.getValue(widget.name);
      if (val != _selectedValue) {
        setState(() {
          _selectedValue = val;
        });
      }
    }
  }

  void _onChanged(T? value) {
    if (value == _selectedValue) return;
    setState(() {
      _selectedValue = value;
    });
    _controller?.setValue(widget.name, value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = SmartFormProvider.of(context);
    final effectiveStyle = widget.style ?? provider?.defaultStyle ?? SmartStyle.adaptive;
    final platform = Theme.of(context).platform;
    final bool useCupertino = effectiveStyle == SmartStyle.cupertino || 
        (effectiveStyle == SmartStyle.adaptive && (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS));

    if (useCupertino && widget.layout == ChoiceLayout.segmented) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            if (widget.label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(widget.label!, style: CupertinoTheme.of(context).textTheme.textStyle),
              ),
            SizedBox(
              width: double.infinity,
              child: CupertinoSegmentedControl<T>(
                groupValue: _selectedValue,
                onValueChanged: (val) {
                   _onChanged(val);
                },
                children: {
                  for (var option in widget.options)
                    option.value: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           if(option.iconCupertino != null) Icon(option.iconCupertino, size: 16),
                           if(option.iconCupertino != null && option.label.isNotEmpty) const SizedBox(width: 4),
                           Text(option.label),
                        ],
                      ),
                    ),
                },
              ),
            ),
         ],
       );
    }

    Widget content;
    
    List<Widget> children = widget.options.map((option) {
       final isSelected = _selectedValue == option.value;
       
       if (useCupertino) {
          return GestureDetector(
             onTap: () => _onChanged(option.value),
             child: Container(
               color: Colors.transparent, 
               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(
                     isSelected ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                     color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
                   ),
                   const SizedBox(width: 8),
                   if (option.iconCupertino != null) Icon(option.iconCupertino),
                   if (option.iconCupertino != null) const SizedBox(width: 4),
                   Text(option.label, style: CupertinoTheme.of(context).textTheme.textStyle),
                 ],
               ),
             ),
          );
       } else {
         return Row(
           mainAxisSize: MainAxisSize.min,
           children: [
             // ignore: deprecated_member_use
             Radio<T>(
               value: option.value,
               // ignore: deprecated_member_use
               groupValue: _selectedValue,
               // ignore: deprecated_member_use
               onChanged: _onChanged,
             ),
             if (option.iconMaterial != null) Icon(option.iconMaterial),
             if (option.iconMaterial != null) const SizedBox(width: 4),
             Text(option.label),
           ],
         );
       }
    }).toList();

    if (widget.layout == ChoiceLayout.column) {
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
    } else if (widget.layout == ChoiceLayout.wrap) {
      content = Wrap(spacing: 8.0, runSpacing: 4.0, children: children);
    } else {
      content = Row(children: children);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
           Padding(
             padding: const EdgeInsets.only(bottom: 8.0),
             child: Text(widget.label!, 
               style: useCupertino 
                 ? CupertinoTheme.of(context).textTheme.textStyle 
                 : Theme.of(context).textTheme.titleMedium),
           ),
        content,
      ],
    );
  }
}
