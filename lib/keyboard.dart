import 'package:flutter/material.dart';

import 'input_control.dart';
import 'layout.dart';

class VirtualKeyboard extends StatefulWidget {
  @override
  _VirtualKeyboardState createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard> {
  final _inputControl = VirtualKeyboardControl();

  @override
  void initState() {
    super.initState();
    _inputControl.register();
  }

  @override
  void dispose() {
    _inputControl.unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      canRequestFocus: false,
      child: Container(
        color: Theme.of(context).backgroundColor,
        height: MediaQuery.of(context).size.height / 3,
        child: ValueListenableBuilder<TextInputLayout>(
            valueListenable: _inputControl.layout,
            builder: (_, layout, __) {
              return Column(
                children: [
                  for (final keys in layout.keys)
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                          valueListenable: _inputControl.attached,
                          builder: (_, attached, __) {
                            return VirtualKeyboardRow(
                              keys: keys,
                              enabled: attached,
                              onInput: _handleKeyPress,
                            );
                          }),
                    ),
                ],
              );
            }),
      ),
    );
  }

  void _handleKeyPress(String key) {
    _inputControl.processInput(key);
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
