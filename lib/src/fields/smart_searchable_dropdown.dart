import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_form/src/controller/smart_form_controller.dart';
import 'package:smart_form/src/models/field_decoration.dart';
import 'package:smart_form/src/models/smart_style.dart';
import 'package:smart_form/src/smart_form.dart';

/// A dropdown menu that supports dynamic, asynchronous searching.
/// 
/// It displays an overlay with results fetched via the [search] callback.
/// Supports debounced queries and platform-adaptive UI using [SmartStyle].
class SmartSearchableDropdown<T extends Object> extends StatefulWidget {
  /// The unique key for this field in the [SmartFormController].
  final String name;

  /// A callback that fetches results based on the current search text.
  final Future<List<T>> Function(String query) search;

  /// A builder for rendering individual items in the results overlay.
  final Widget Function(BuildContext context, T item, bool isSelected) itemBuilder;

  /// An optional function to convert an item of type [T] into a displayable string.
  final String Function(T item)? itemLabel;

  /// The delay before the [search] callback is triggered after typing stops.
  final Duration debounce;

  /// Overrides the default form style for this specific field.
  final SmartStyle? style;

  /// Custom visual decoration for the dropdown field.
  final FieldDecoration? decoration;

  /// Explicit height for the dropdown's input field.
  final double? height;

  /// Explicit width for the dropdown's input field.
  final double? width;

  /// The label text to display for the field.
  final String? label;

  /// Triggered whenever a new item is selected.
  final ValueChanged<T?>? onChanged;

  /// Creates a [SmartSearchableDropdown].
  const SmartSearchableDropdown({
    super.key,
    required this.name,
    required this.search,
    required this.itemBuilder,
    this.itemLabel,
    this.debounce = const Duration(milliseconds: 300),
    this.style,
    this.decoration,
    this.height,
    this.width,
    this.label,
    this.onChanged,
  });

  @override
  State<SmartSearchableDropdown<T>> createState() => _SmartSearchableDropdownState<T>();
}

class _SmartSearchableDropdownState<T extends Object> extends State<SmartSearchableDropdown<T>> {
  SmartFormController? _controller;
  T? _selectedItem;
  Timer? _debounceTimer;
  List<T> _results = [];
  bool _isLoading = false;
  late TextEditingController _searchController;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = SmartFormProvider.of(context);
    if (provider != null && _controller != provider.controller) {
      _controller = provider.controller;
      _controller!.addListener(_handleControllerChange);
      _selectedItem = _controller!.getValue(widget.name);
      if (_selectedItem != null && widget.itemLabel != null) {
         _searchController.text = widget.itemLabel!(_selectedItem as T);
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleControllerChange);
    _searchController.dispose();
    _debounceTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _handleControllerChange() {
    if (_controller != null) {
      final val = _controller!.getValue(widget.name);
      if (val != _selectedItem) {
        setState(() {
          _selectedItem = val;
          if (_selectedItem != null && widget.itemLabel != null) {
             _searchController.text = widget.itemLabel!(_selectedItem as T);
          } else {
             _searchController.text = '';
          }
        });
      }
    }
  }

  void _onSearchChanged(String query) {
     if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
     if (query.isEmpty) {
        setState(() {
           _results = [];
           _isLoading = false;
        });
        _removeOverlay();
        return;
     }

     _debounceTimer = Timer(widget.debounce, () async {
        setState(() {
           _isLoading = true;
        });
        
        _showOverlay();

        try {
          final results = await widget.search(query);
          if (mounted) {
            setState(() {
              _results = results;
              _isLoading = false;
            });
            _overlayEntry?.markNeedsBuild();
          }
        } catch (e) {
          if (mounted) {
            setState(() {
               _isLoading = false;
               _results = [];
            });
          }
        }
     });
  }

  void _selectItem(T item) {
    setState(() {
      _selectedItem = item;
      if (widget.itemLabel != null) {
         _searchController.text = widget.itemLabel!(item);
      } else {
         _searchController.text = item.toString();
      }
      _results = [];
    });
    _removeOverlay();
    _controller?.setValue(widget.name, item);
    widget.onChanged?.call(item);
  }
  
  void _showOverlay() {
    if (_overlayEntry != null) return;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: _isLoading 
                  ? const Center(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ))
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                         final item = _results[index];
                         return InkWell(
                           onTap: () => _selectItem(item),
                           child: widget.itemBuilder(context, item, item == _selectedItem),
                         );
                      },
                    ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
       field = CupertinoTextField(
         controller: _searchController,
         placeholder: widget.label ?? 'Search...',
         placeholderStyle: widget.decoration?.hintStyle,
         onChanged: _onSearchChanged,
         prefix: widget.decoration?.prefixIcon ?? widget.decoration?.prefix,
         suffix: widget.decoration?.suffixIcon ?? widget.decoration?.suffix ?? (_isLoading ? const Padding(padding: EdgeInsets.all(8), child: CupertinoActivityIndicator()) : null),
         padding: widget.decoration?.padding ?? const EdgeInsets.all(12),
         decoration: BoxDecoration(
           color: widget.decoration?.fillColor ?? CupertinoColors.white,
           border: Border.all(
             color: widget.decoration?.borderColor ?? CupertinoColors.systemGrey4,
             width: widget.decoration?.borderWidth ?? 1.0,
           ),
           borderRadius: BorderRadius.circular(widget.decoration?.borderRadius ?? 8.0),
           boxShadow: widget.decoration?.shadows,
         ),
       );
    } else {
       field = TextField(
         controller: _searchController,
         decoration: InputDecoration(
           labelText: widget.label,
           labelStyle: widget.decoration?.labelStyle,
           hintStyle: widget.decoration?.hintStyle,
           prefix: widget.decoration?.prefix,
           prefixIcon: widget.decoration?.prefixIcon,
           suffix: widget.decoration?.suffix,
           suffixIcon: widget.decoration?.suffixIcon ?? (_isLoading ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.arrow_drop_down)),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(widget.decoration?.borderRadius ?? 4.0),
           ),
           filled: widget.decoration?.fillColor != null,
           fillColor: widget.decoration?.fillColor,
           contentPadding: widget.decoration?.padding,
         ),
         onChanged: _onSearchChanged,
       );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: field,
      ),
    );
  }
}
