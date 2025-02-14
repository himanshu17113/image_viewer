import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:image_viewer/image.dart';

/// The entry point of the application.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// A [Widget] displaying the home page with an image and bottom sheet actions.
class HomePage extends StatefulWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// The state for [HomePage].
class _HomePageState extends State<HomePage> {
  /// Controller for the image URL [TextField].
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Shows a bottom sheet with "Enter Fullscreen" and "Exit Fullscreen" actions.
  ///
  /// The background is dimmed. Tapping outside the bottom sheet will dismiss it.
  void _showMenuSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: Colors.black54, // Dims the background.
      isDismissible: true, // Tap outside to close.
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.fullscreen),
                title: const Text('Enter fullscreen'),
                onTap: () {
                  _enterFullscreen();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.fullscreen_exit),
                title: const Text('Exit fullscreen'),
                onTap: () {
                  _exitFullscreen();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Requests the browser to enter fullscreen mode (web only).
  void _enterFullscreen() {
    html.document.documentElement?.requestFullscreen();
  }

  /// Exits fullscreen mode if currently active (web only).
  void _exitFullscreen() {
    if (html.document.fullscreenElement != null) {
      html.document.exitFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(12)),
                  child: _controller.text.isNotEmpty ? HtmlImageWidget(imageUrl: _controller.text) : const SizedBox.shrink(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Image URL'))),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Trigger rebuild to display new image
                    });
                  },
                  child: const Padding(padding: EdgeInsets.fromLTRB(0, 12, 0, 12), child: Icon(Icons.arrow_forward)),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showMenuSheet(context), child: const Icon(Icons.add)),
    );
  }
}
