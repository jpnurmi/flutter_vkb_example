import 'package:flutter/services.dart';

class TextInputDelegate {
  String _text = '';
  TextSelection _selection = TextSelection.collapsed(offset: 0);
  final TextInputClient _client;

  TextInputDelegate(this._client);

  TextEditingValue get value =>
      TextEditingValue(text: _text, selection: _selection);

  void reset(TextEditingValue value) {
    _text = value.text;
    _selection = value.selection;
  }

  void addText(String text) {
    removeText(_selection.start, _selection.end);
    insertText(_selection.start, text);

    _client.updateEditingValue(value);
  }

  void insertText(int start, String text) {
    _text = _text.replaceRange(start, start, text);
    _selection = TextSelection.collapsed(offset: start + text.length);
  }

  void removeText(int start, int end) {
    _text = _text.replaceRange(start, end, '');
    _selection = TextSelection.collapsed(offset: start);
  }
}
