import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'delegate.dart';
import 'connection.dart';
import 'layout.dart';

class VirtualKeyboard extends StatefulWidget {
  @override
  _VirtualKeyboardState createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard>
    implements TextInputSource {
  TextInputDelegate? _delegate;
  TextInputLayout _layout = TextInputLayout();

  @override
  void initState() {
    super.initState();
    TextInput.setSource(this);
  }

  @override
  void dispose() {
    TextInput.setSource(TextInput.defaultSource);
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
                  enabled: _delegate != null,
                  onInput: (String key) => _delegate!.addText(key),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void init() {}

  @override
  void cleanup() {}

  @override
  TextInputConnection attach(TextInputClient client) {
    setState(() => _delegate = TextInputDelegate(client));

    return CallbackConnection(
      client,
      onInputTypeChanged: (TextInputType inputType) {
        setState(() => _layout = TextInputLayout(inputType));
      },
      onEditingValueSet: (TextEditingValue value) {
        _delegate!.reset(value);
      },
    );
  }

  @override
  void detach(TextInputClient client) {
    setState(() => _delegate = null);
  }

  @override
  void finishAutofillContext({bool shouldSave = true}) {}
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
