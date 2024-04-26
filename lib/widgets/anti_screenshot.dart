import 'package:flutter/services.dart';

const platform = MethodChannel('your_channel_name');

// Example method to disable screenshots
Future<void> disableScreenshots() async {
    try {
        await platform.invokeMethod('disableScreenshots');
    } on PlatformException catch (e) {
        print("Failed to disable screenshots: '${e.message}'.");
    }
}
