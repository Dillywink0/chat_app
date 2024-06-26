// ignore_for_file: library_private_types_in_public_api

import 'package:chat_app/FontSizeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccessibilitySettings extends StatefulWidget {
  const AccessibilitySettings({super.key});

  @override
  _AccessibilitySettingsState createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  @override
  Widget build(BuildContext context) {
    // Accessing font size from the FontSizeProvider
    double fontSize = Provider.of<FontSizeProvider>(context).fontSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accessibility Settings"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              // Visual Settings Section
              _SectionHeader(title: "Visual Settings", fontSize: fontSize),
              _AccessibilitySettingTile(
                title: "Increase Font Size",
                icon: Icons.format_size,
                onTap: () {
                  // Increasing font size when the tile is tapped
                  Provider.of<FontSizeProvider>(context, listen: false)
                      .increaseFontSize();
                },
                fontSize: fontSize,
              ),
              _AccessibilitySettingTile(
                title: "High Contrast Mode",
                icon: Icons.compare,
                fontSize: fontSize,
              ),
              // Add more visual settings here

              // Hearing Settings Section
              _SectionHeader(title: "Hearing Settings", fontSize: fontSize),
              _AccessibilitySettingTile(
                title: "Subtitles",
                icon: Icons.subtitles,
                fontSize: fontSize,
              ),
              _AccessibilitySettingTile(
                title: "Text-to-Speech",
                icon: Icons.record_voice_over,
                fontSize: fontSize,
              ),
              // Add more hearing settings here

              // Motor Skills Settings Section
              _SectionHeader(
                  title: "Motor Skills Settings", fontSize: fontSize),
              _AccessibilitySettingTile(
                title: "Touch Sensitivity",
                icon: Icons.touch_app,
                fontSize: fontSize,
              ),
              _AccessibilitySettingTile(
                title: "Gesture Controls",
                icon: Icons.gesture,
                fontSize: fontSize,
              ),
              // Add more motor skills settings here
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final double fontSize;

  const _SectionHeader({required this.title, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18 + fontSize, fontWeight: FontWeight.bold), // Adjusting font size here
      ),
    );
  }
}

class _AccessibilitySettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final double fontSize;

  const _AccessibilitySettingTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16 + fontSize), // Adjusting font size here
      ),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}
