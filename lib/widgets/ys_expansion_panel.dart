import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

/// 重写该组件 移除gap间隙 调整一些样式 YsExpansionPanelList

const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension;
const EdgeInsets _kPanelHeaderExpandedDefaultPadding =
    EdgeInsets.symmetric(vertical: 64.0 - _kPanelHeaderCollapsedHeight);

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is _SaltedKey<S, V> && other.salt == salt && other.value == value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? "<'$salt'>" : '<$salt>';
    final String valueString = V == String ? "<'$value'>" : '<$value>';
    return '[$saltString $valueString]';
  }
}

/// A material expansion panel. It has a header and a body and can be either
/// expanded or collapsed. The body of the panel is only visible when it is
/// expanded.
///
/// Expansion panels are only intended to be used as children for
/// [YsExpansionPanelList].
///
/// See [YsExpansionPanelList] for a sample implementation.
///
/// See also:
///
///  * [YsExpansionPanelList]
///  * <https://material.io/design/components/lists.html#types>
class YsExpansionPanel {
  /// Creates an expansion panel to be used as a child for [YsExpansionPanelList].
  /// See [YsExpansionPanelList] for an example on how to use this widget.
  ///
  /// The [headerBuilder], [body], and [isExpanded] arguments must not be null.
  YsExpansionPanel({
    required this.headerBuilder,
    required this.body,
    this.isExpanded = false,
    this.canTapOnHeader = false,
  })  : assert(headerBuilder != null),
        assert(body != null),
        assert(isExpanded != null),
        assert(canTapOnHeader != null);

  /// The widget builder that builds the expansion panels' header.
  final ExpansionPanelHeaderBuilder headerBuilder;

  /// The body of the expansion panel that's displayed below the header.
  ///
  /// This widget is visible only when the panel is expanded.
  final Widget body;

  /// Whether the panel is expanded.
  ///
  /// Defaults to false.
  final bool isExpanded;

  /// Whether tapping on the panel's header will expand/collapse it.
  ///
  /// Defaults to false.
  final bool canTapOnHeader;
}

/// An expansion panel that allows for radio-like functionality.
/// This means that at any given time, at most, one [YsExpansionPanelRadio]
/// can remain expanded.
///
/// A unique identifier [value] must be assigned to each panel.
/// This identifier allows the [YsExpansionPanelList] to determine
/// which [YsExpansionPanelRadio] instance should be expanded.
///
/// See [YsExpansionPanelList.radio] for a sample implementation.
class YsExpansionPanelRadio extends YsExpansionPanel {
  /// An expansion panel that allows for radio functionality.
  ///
  /// A unique [value] must be passed into the constructor. The
  /// [headerBuilder], [body], [value] must not be null.
  YsExpansionPanelRadio({
    required this.value,
    required ExpansionPanelHeaderBuilder headerBuilder,
    required Widget body,
    bool canTapOnHeader = false,
  })  : assert(value != null),
        super(
          body: body,
          headerBuilder: headerBuilder,
          canTapOnHeader: canTapOnHeader,
        );

  /// The value that uniquely identifies a radio panel so that the currently
  /// selected radio panel can be identified.
  final Object value;
}

/// A material expansion panel list that lays out its children and animates
/// expansions.
///
/// Note that [expansionCallback] behaves differently for [YsExpansionPanelList]
/// and [YsExpansionPanelList.radio].
///
/// {@tool dartpad --template=stateful_widget_scaffold}
///
/// Here is a simple example of how to implement ExpansionPanelList.
///
/// ```dart preamble
/// // stores ExpansionPanel state information
/// class Item {
///   Item({
///     this.expandedValue,
///     this.headerValue,
///     this.isExpanded = false,
///   });
///
///   String expandedValue;
///   String headerValue;
///   bool isExpanded;
/// }
///
/// List<Item> generateItems(int numberOfItems) {
///   return List.generate(numberOfItems, (int index) {
///     return Item(
///       headerValue: 'Panel $index',
///       expandedValue: 'This is item number $index',
///     );
///   });
/// }
/// ```
///
/// ```dart
/// List<Item> _data = generateItems(8);
///
/// @override
/// Widget build(BuildContext context) {
///   return SingleChildScrollView(
///     child: Container(
///       child: _buildPanel(),
///     ),
///   );
/// }
///
/// Widget _buildPanel() {
///   return ExpansionPanelList(
///     expansionCallback: (int index, bool isExpanded) {
///       setState(() {
///         _data[index].isExpanded = !isExpanded;
///       });
///     },
///     children: _data.map<ExpansionPanel>((Item item) {
///       return ExpansionPanel(
///         headerBuilder: (BuildContext context, bool isExpanded) {
///           return ListTile(
///             title: Text(item.headerValue),
///           );
///         },
///         body: ListTile(
///           title: Text(item.expandedValue),
///           subtitle: Text('To delete this panel, tap the trash can icon'),
///           trailing: Icon(Icons.delete),
///           onTap: () {
///             setState(() {
///               _data.removeWhere((currentItem) => item == currentItem);
///             });
///           }
///         ),
///         isExpanded: item.isExpanded,
///       );
///     }).toList(),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [YsExpansionPanel]
///  * [YsExpansionPanelList.radio]
///  * <https://material.io/design/components/lists.html#types>
class YsExpansionPanelList extends StatefulWidget {
  /// Creates an expansion panel list widget. The [expansionCallback] is
  /// triggered when an expansion panel expand/collapse button is pushed.
  ///
  /// The [children] and [animationDuration] arguments must not be null.
  const YsExpansionPanelList({
    Key? key,
    this.children = const <YsExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2.0,
  })  : assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = false,
        initialOpenPanelValue = null,
        super(key: key);

  /// Creates a radio expansion panel list widget.
  ///
  /// This widget allows for at most one panel in the list to be open.
  /// The expansion panel callback is triggered when an expansion panel
  /// expand/collapse button is pushed. The [children] and [animationDuration]
  /// arguments must not be null. The [children] objects must be instances
  /// of [YsExpansionPanelRadio].
  ///
  /// {@tool dartpad --template=stateful_widget_scaffold}
  ///
  /// Here is a simple example of how to implement ExpansionPanelList.radio.
  ///
  /// ```dart preamble
  /// // stores ExpansionPanel state information
  /// class Item {
  ///   Item({
  ///     this.id,
  ///     this.expandedValue,
  ///     this.headerValue,
  ///   });
  ///
  ///   int id;
  ///   String expandedValue;
  ///   String headerValue;
  /// }
  ///
  /// List<Item> generateItems(int numberOfItems) {
  ///   return List.generate(numberOfItems, (int index) {
  ///     return Item(
  ///       id: index,
  ///       headerValue: 'Panel $index',
  ///       expandedValue: 'This is item number $index',
  ///     );
  ///   });
  /// }
  /// ```
  ///
  /// ```dart
  /// List<Item> _data = generateItems(8);
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SingleChildScrollView(
  ///     child: Container(
  ///       child: _buildPanel(),
  ///     ),
  ///   );
  /// }
  ///
  /// Widget _buildPanel() {
  ///   return ExpansionPanelList.radio(
  ///     initialOpenPanelValue: 2,
  ///     children: _data.map<ExpansionPanelRadio>((Item item) {
  ///       return ExpansionPanelRadio(
  ///         value: item.id,
  ///         headerBuilder: (BuildContext context, bool isExpanded) {
  ///           return ListTile(
  ///             title: Text(item.headerValue),
  ///           );
  ///         },
  ///         body: ListTile(
  ///           title: Text(item.expandedValue),
  ///           subtitle: Text('To delete this panel, tap the trash can icon'),
  ///           trailing: Icon(Icons.delete),
  ///           onTap: () {
  ///             setState(() {
  ///               _data.removeWhere((currentItem) => item == currentItem);
  ///             });
  ///           }
  ///         )
  ///       );
  ///     }).toList(),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  const YsExpansionPanelList.radio({
    Key? key,
    this.children = const <YsExpansionPanelRadio>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.initialOpenPanelValue,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2.0,
  })  : assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = true,
        super(key: key);

  /// The children of the expansion panel list. They are laid out in a similar
  /// fashion to [ListBody].
  final List<YsExpansionPanel> children;

  /// The callback that gets called whenever one of the expand/collapse buttons
  /// is pressed. The arguments passed to the callback are the index of the
  /// pressed panel and whether the panel is currently expanded or not.
  ///
  /// If ExpansionPanelList.radio is used, the callback may be called a
  /// second time if a different panel was previously open. The arguments
  /// passed to the second callback are the index of the panel that will close
  /// and false, marking that it will be closed.
  ///
  /// For ExpansionPanelList, the callback needs to setState when it's notified
  /// about the closing/opening panel. On the other hand, the callback for
  /// ExpansionPanelList.radio is simply meant to inform the parent widget of
  /// changes, as the radio panels' open/close states are managed internally.
  ///
  /// This callback is useful in order to keep track of the expanded/collapsed
  /// panels in a parent widget that may need to react to these changes.
  final ExpansionPanelCallback? expansionCallback;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  // Whether multiple panels can be open simultaneously
  final bool _allowOnlyOnePanelOpen;

  /// The value of the panel that initially begins open. (This value is
  /// only used when initializing with the [YsExpansionPanelList.radio]
  /// constructor.)
  final Object? initialOpenPanelValue;

  /// The padding that surrounds the panel header when expanded.
  ///
  /// By default, 16px of space is added to the header vertically (above and below)
  /// during expansion.
  final EdgeInsets expandedHeaderPadding;

  /// Defines color for the divider when [YsExpansionPanel.isExpanded] is false.
  ///
  /// If `dividerColor` is null, then [DividerThemeData.color] is used. If that
  /// is null, then [ThemeData.dividerColor] is used.
  final Color? dividerColor;

  /// Defines elevation for the [YsExpansionPanel] while it's expanded.
  ///
  /// This uses [kElevationToShadow] to simulate shadows, it does not use
  /// [Material]'s arbitrary elevation feature.
  ///
  /// The following values can be used to define the elevation: 0, 1, 2, 3, 4, 6,
  /// 8, 9, 12, 16, 24.
  ///
  /// By default, the value of elevation is 2.
  final elevation;

  @override
  State<StatefulWidget> createState() => _YsExpansionPanelListState();
}

class _YsExpansionPanelListState extends State<YsExpansionPanelList> {
  YsExpansionPanelRadio? _currentOpenPanel;

  @override
  void initState() {
    super.initState();
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All ExpansionPanelRadio identifier values must be unique.');
      if (widget.initialOpenPanelValue != null) {
        _currentOpenPanel = searchPanelByValue(
            widget.children.cast<YsExpansionPanelRadio>(), widget.initialOpenPanelValue!);
      }
    }
  }

  @override
  void didUpdateWidget(YsExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All ExpansionPanelRadio identifier values must be unique.');
      // If the previous widget was non-radio ExpansionPanelList, initialize the
      // open panel to widget.initialOpenPanelValue
      if (!oldWidget._allowOnlyOnePanelOpen) {
        _currentOpenPanel = searchPanelByValue(
            widget.children.cast<YsExpansionPanelRadio>(), widget.initialOpenPanelValue!);
      }
    } else {
      _currentOpenPanel = null;
    }
  }

  bool _allIdentifiersUnique() {
    final Map<Object, bool> identifierMap = <Object, bool>{};
    for (final YsExpansionPanelRadio child in widget.children.cast<YsExpansionPanelRadio>()) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final YsExpansionPanelRadio radioWidget = widget.children[index] as YsExpansionPanelRadio;
      return _currentOpenPanel?.value == radioWidget.value;
    }
    return widget.children[index].isExpanded;
  }

  void _handlePressed(bool isExpanded, int index) {
    if (widget.expansionCallback != null) widget.expansionCallback!(index, isExpanded);

    if (widget._allowOnlyOnePanelOpen) {
      final YsExpansionPanelRadio pressedChild = widget.children[index] as YsExpansionPanelRadio;

      // If another ExpansionPanelRadio was already open, apply its
      // expansionCallback (if any) to false, because it's closing.
      for (int childIndex = 0; childIndex < widget.children.length; childIndex += 1) {
        final YsExpansionPanelRadio child = widget.children[childIndex] as YsExpansionPanelRadio;
        if (widget.expansionCallback != null &&
            childIndex != index &&
            child.value == _currentOpenPanel?.value) widget.expansionCallback!(childIndex, false);
      }

      setState(() {
        _currentOpenPanel = isExpanded ? null : pressedChild;
      });
    }
  }

  YsExpansionPanelRadio? searchPanelByValue(List<YsExpansionPanelRadio> panels, Object value) {
    for (final YsExpansionPanelRadio panel in panels) {
      if (panel.value == value) return panel;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
        kElevationToShadow.containsKey(widget.elevation),
        'Invalid value for elevation. See the kElevationToShadow constant for'
        ' possible elevation values.');

    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];

    for (int index = 0; index < widget.children.length; index += 1) {
      // if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
      // items.add(MaterialGap(key: _SaltedKey<BuildContext, int>(context, index * 2 - 1)));

      final YsExpansionPanel child = widget.children[index];
      final Widget headerWidget = child.headerBuilder(
        context,
        _isChildExpanded(index),
      );

      Widget expandIconContainer = Container(
        margin: const EdgeInsetsDirectional.only(end: 0.0),
        child: ExpandIcon(
          isExpanded: _isChildExpanded(index),
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          onPressed:
              !child.canTapOnHeader ? (bool isExpanded) => _handlePressed(isExpanded, index) : null,
        ),
      );
      if (!child.canTapOnHeader) {
        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        expandIconContainer = Semantics(
          label: _isChildExpanded(index)
              ? localizations.expandedIconTapHint
              : localizations.collapsedIconTapHint,
          container: true,
          child: expandIconContainer,
        );
      }
      Widget header = Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index) ? widget.expandedHeaderPadding : EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _kPanelHeaderCollapsedHeight),
                child: headerWidget,
              ),
            ),
          ),
          expandIconContainer,
        ],
      );
      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: InkWell(
            onTap: () => _handlePressed(_isChildExpanded(index), index),
            child: header,
          ),
        );
      }
      items.add(
        MaterialSlice(
          key: _SaltedKey<BuildContext, int>(context, index * 2),
          child: Column(
            children: <Widget>[
              header,
              AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: child.body,
                firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState:
                    _isChildExpanded(index) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
            ],
          ),
        ),
      );

      // if (_isChildExpanded(index) && index != widget.children.length - 1)
      // items.add(MaterialGap(key: _SaltedKey<BuildContext, int>(context, index * 2 + 1)));
    }
    return MergeableMaterial(
      hasDividers: true,
      dividerColor: widget.dividerColor,
      // elevation: widget.elevation, // int 兼容
      elevation: widget.elevation.toDouble(),
      children: items,
    );
  }
}
