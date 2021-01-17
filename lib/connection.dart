import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';

class CallbackConnection extends TextInputConnection {
  ValueChanged<TextInputType> _onInputTypeChanged;
  ValueChanged<TextEditingValue> _onEditingValueSet;

  CallbackConnection(
    TextInputClient client, {
    required ValueChanged<TextInputType> onInputTypeChanged,
    required ValueChanged<TextEditingValue> onEditingValueSet,
  })   : _onInputTypeChanged = onInputTypeChanged,
        _onEditingValueSet = onEditingValueSet,
        super(client);

  @override
  void setClient(TextInputConfiguration configuration) {
    _onInputTypeChanged(configuration.inputType);
  }

  @override
  void updateConfig(TextInputConfiguration configuration) {
    _onInputTypeChanged(configuration.inputType);
  }

  @override
  void setEditingState(TextEditingValue value) {
    _onEditingValueSet(value);
  }

  @override
  void show() {}

  @override
  void hide() {}

  @override
  void clearClient() {}

  @override
  void setComposingRect(Rect rect) {}

  @override
  void setEditableSizeAndTransform(Size editableBoxSize, Matrix4 transform) {}

  @override
  void setStyle({
    required String? fontFamily,
    required double? fontSize,
    required FontWeight? fontWeight,
    required TextDirection textDirection,
    required TextAlign textAlign,
  }) {}

  @override
  void requestAutofill() {}

  @override
  void close() {}

  @override
  void connectionClosedReceived() {}
}
