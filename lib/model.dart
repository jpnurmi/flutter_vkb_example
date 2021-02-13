import 'package:flutter/services.dart';

class TextInputModel {
  String _text = '';
  TextSelection _selection = TextSelection.collapsed(offset: 0);

  TextEditingValue get value =>
      TextEditingValue(text: _text, selection: _selection);

  TextEditingValue insert(String text) {
    _removeText(_selection.start, _selection.end);
    _insertText(_selection.start, text);
    return value;
  }

  void reset(TextEditingValue value) {
    _text = value.text;
    _selection = value.selection;
  }

  void _insertText(int start, String text) {
    _text = _text.replaceRange(start, start, text);
    _selection = TextSelection.collapsed(offset: start + text.length);
  }

  void _removeText(int start, int end) {
    _text = _text.replaceRange(start, end, '');
    _selection = TextSelection.collapsed(offset: start);
  }
}
