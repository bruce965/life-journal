import 'package:flutter/widgets.dart';

class InheritedData<T> {
  InheritedData._(T data, bool dynamic)
      : _dynamic = dynamic,
        _data = data;
  InheritedData(T data) : this._(data, false);
  InheritedData.dynamic(T initialData) : this._(initialData, true);

  final bool _dynamic;
  T _data;

  T get current => _data;

  static InheritedData<T>? of<T>(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_InheritedDataWidget<T>>();

    final state = widget?._state;
    if (state == null) {
      return null;
    }

    return _InheritedDataProxy<T>._(state);
  }

  static Widget provider(
      {required List<InheritedData<dynamic>> data, required Widget child}) {
    var widget = child;
    for (final datum in data) {
      widget = datum._makeProvider(widget);
    }
    return widget;
  }

  void set(T data) {
    throw UnsupportedError("Not supported");
  }

  _InheritedDataProvider<T> _makeProvider(Widget child) {
    return _InheritedDataProvider(data: this, child: child);
  }

  // TODO: override equals to support _InheritedDataProxy
}

class _InheritedDataProxy<T> implements InheritedData<T> {
  const _InheritedDataProxy._(_InheritedDataState<T> state) : _state = state;

  final _InheritedDataState<T> _state;

  @override
  bool get _dynamic => throw UnsupportedError("Not supported");

  @override
  T get _data => throw UnsupportedError("Not supported");
  @override
  set _data(T d) => throw UnsupportedError("Not supported");

  @override
  T get current => _state.widget.data.current;

  @override
  void set(T data) {
    _state.setData(data);
  }

  @override
  _InheritedDataProvider<T> _makeProvider(Widget child) {
    throw UnsupportedError("Not supported");
  }

  // TODO: override equals with InheritedData
}

class _InheritedDataProvider<T> extends StatefulWidget {
  const _InheritedDataProvider({
    super.key,
    required this.data,
    required this.child,
  });

  final InheritedData<T> data;
  final Widget child;

  @override
  State<_InheritedDataProvider<T>> createState() => _InheritedDataState<T>();
}

class _InheritedDataState<T> extends State<_InheritedDataProvider<T>> {
  int tick = 0;

  void setData(T data) {
    assert(widget.data._dynamic, "${widget.data.runtimeType} is read-only.");
    if (!widget.data._dynamic) throw Error();

    setState(() {
      tick++;
      widget.data._data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedDataWidget<T>(tick: tick, state: this);
  }
}

class _InheritedDataWidget<T> extends InheritedWidget {
  _InheritedDataWidget({super.key, required int tick, required _InheritedDataState<T> state})
      : _tick = tick, _state = state,
        super(
          child: state.widget.child,
        );

  final int _tick;
  final _InheritedDataState<T> _state;

  @override
  bool updateShouldNotify(covariant _InheritedDataWidget<T> previous) {
    return _tick != previous._tick || _state != previous._state;
  }
}
