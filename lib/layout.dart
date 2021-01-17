import 'package:flutter/services.dart';

class TextInputLayout {
  TextInputType _type;

  TextInputLayout([this._type = TextInputType.text]);

  bool get _isNumeric => _type == TextInputType.number;

  List<List<String>> get keys {
    return _isNumeric ? _numbers : _letters;
  }

  List<List<String>> get _letters {
    return [
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.'],
      [' '],
    ];
  }

  List<List<String>> get _numbers {
    return [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      [',', '0', '.'],
    ];
  }
}
