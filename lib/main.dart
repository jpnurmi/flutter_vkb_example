import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'keyboard.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom VKB',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _controllers = {
    TextInputType.text: TextEditingController(),
    TextInputType.number: TextEditingController(),
  };

  @override
  void dispose() {
    super.dispose();
    _controllers.values.forEach((controller) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom VKB'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final entry in _controllers.entries)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                autofocus: true,
                keyboardType: entry.key,
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: entry.key.name,
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: entry.value,
                    builder: (context, TextEditingValue value, child) {
                      // enable backspace when there's something to erase
                      final atBeginning = value.selection.start == 0;
                      final hasSelection = !value.selection.isCollapsed;
                      return IconButton(
                        onPressed: !atBeginning || hasSelection
                            ? () => _handleBackspace(entry.value)
                            : null,
                        icon: Icon(Icons.backspace),
                      );
                    },
                  ),
                ),
              ),
            ),
          Spacer(),
          Theme(
            data: ThemeData.dark().copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(primary: Colors.grey),
              ),
            ),
            child: VirtualKeyboard(),
          ),
        ],
      ),
    );
  }

  void _handleBackspace(TextEditingController controller) {
    final value = controller.value;
    final selection = controller.selection;

    // erase selection vs. previous char
    final start = selection.isCollapsed ? selection.start - 1 : selection.start;
    final text = value.text.replaceRange(start, selection.end, '');

    controller.value = value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: start),
    );
  }
}

extension TextInputTypeName on TextInputType {
  String get name {
    final str = toJson()['name'].split('.').last;
    return str[0].toUpperCase() + str.substring(1);
  }
}
