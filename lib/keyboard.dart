import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model.dart';
import 'layout.dart';

class VirtualKeyboard extends StatefulWidget {
  @override
  _VirtualKeyboardState createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard>
    with TextInputControl {
  TextInputModel? _model;
  TextInputLayout _layout = TextInputLayout();

  @override
  void initState() {
    super.initState();
    TextInput.addInputControl(this);
    TextInput.setCurrentInputControl(this);
  }

  @override
  void dispose() {
    TextInput.removeInputControl(this);
    TextInput.setCurrentInputControl(PlatformTextInputControl.instance);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      canRequestFocus: false,
      child: Container(
        color: Theme.of(context).backgroundColor,
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            for (final keys in _layout.keys)
              Expanded(
                child: VirtualKeyboardRow(
                  keys: keys,
                  enabled: _model != null,
                  onInput: _handleKeyPress,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleKeyPress(String key) {
    updateEditingValue(_model!.insert(key));
  }

  @override
  void attach(TextInputClient client, TextInputConfiguration configuration) {
    _model = TextInputModel();
    updateConfig(configuration);
  }

  @override
  void detach(TextInputClient client) {
    setState(() => _model = null);
  }

  @override
  void setEditingState(TextEditingValue value) {
    _model!.reset(value);
  }

  @override
  void updateConfig(TextInputConfiguration configuration) {
    setState(() => _layout = TextInputLayout(configuration.inputType));
  }
}

class VirtualKeyboardRow extends StatelessWidget {
  final bool _enabled;
  final List<String> _keys;
  final ValueSetter<String> _onInput;

  VirtualKeyboardRow({
    required bool enabled,
    required List<String> keys,
    required ValueSetter<String> onInput,
  })   : _enabled = enabled,
        _keys = keys,
        _onInput = onInput;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final key in _keys)
          Expanded(
            child: RawMaterialButton(
              onPressed: _enabled ? () => _onInput(key) : null,
              child: Center(child: Text(key)),
            ),
          ),
      ],
    );
  }
}
