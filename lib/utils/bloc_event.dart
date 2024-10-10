class BlocEvent<T> {
  BlocEvent(this._content);

  final T _content;
  bool _eventHandled = false;

  T? getContentIfNotHandled() {
    if (_eventHandled) {
      return null;
    } else {
      _eventHandled = true;
      return _content;
    }
  }
}
