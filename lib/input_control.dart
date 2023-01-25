import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model.dart';
import 'layout.dart';

class VirtualKeyboardControl with TextInputControl {
  TextInputModel? _model;
  final _attached = ValueNotifier<bool>(false);
  final _layout = ValueNotifier<TextInputLayout>(TextInputLayout());

  ValueNotifier<bool> get attached => _attached;
  ValueNotifier<TextInputLayout> get layout => _layout;

  void register() {
    TextInput.setInputControl(this);
  }

  void unregister() {
    TextInput.restorePlatformInputControl();
  }

  void processInput(String input) {
    final value = _model!.insert(input);
    setEditingState(value);
    TextInput.updateEditingValue(value);
  }

  @override
  void attach(TextInputClient client, TextInputConfiguration configuration) {
    _model = TextInputModel();
    _attached.value = true;
    updateConfig(configuration);
  }

  @override
  void detach(TextInputClient client) {
    _model = null;
    _attached.value = false;
  }

  @override
  void setEditingState(TextEditingValue value) {
    _model!.reset(value);
  }

  @override
  void updateConfig(TextInputConfiguration configuration) {
    _layout.value = TextInputLayout(configuration.inputType);
  }
}
