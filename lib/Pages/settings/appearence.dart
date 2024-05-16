import 'package:chat_app/colours/ColorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:provider/provider.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  _AppearanceSettingsState createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  @override
  Widget build(BuildContext context) {
    Color selectedColor = Provider.of<ColorProvider>(context).selectedColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance Settings"),// This appears as the title on the page
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Color Picker
              ColorPicker(
                color: selectedColor,
                onColorChanged: (Color color) {
                  Provider.of<ColorProvider>(context, listen: false)
                      .selectedColor = color;
                },
                width: 150.0,
                height: 150.0,
                borderRadius: 5.0,
                heading: const Text('Pick a color'), // Appears as text on the page
                subheading: const Text('Select a color'),
                pickersEnabled: const {
                  ColorPickerType.both: false,
                  ColorPickerType.primary: true,
                  ColorPickerType.accent: false,
                  ColorPickerType.bw: false,
                  ColorPickerType.custom: false,
                  ColorPickerType.wheel: false,
                },
                spacing: 5.0,
              ),

              // Display the selected color
              Padding(
                padding: const EdgeInsets.all(16.0), // The size of the edges on the boxes
                child: Text(
                  'Selected Color: ${selectedColor.toString()}',
                  style: TextStyle(color: selectedColor),
                ),
              ),

              // Save button
              ElevatedButton(
                onPressed: () {
                  // No need to save here, as color is updated in onColorChanged
                  Navigator.pop(context); // Close the AppearanceSettings screen
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
