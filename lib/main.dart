import 'package:flutter/material.dart';
import 'package:image_viewer/image.dart';
import 'dart:html' as html;

/// The entry point of the application.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// A widget displaying the home page with an image and bottom sheet actions.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  /// Shows a bottom sheet with fullscreen management actions.
  ///
  /// The background is dimmed and the sheet can be dismissed by tapping outside.
  void _showMenuSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: Colors.black54,
      isDismissible: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.fullscreen),
                title: const Text('Enter fullscreen'),
                onTap: () {
                  _setFullscreen(enable: true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.fullscreen_exit),
                title: const Text('Exit fullscreen'),
                onTap: () {
                  _setFullscreen(enable: false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Sets fullscreen mode based on the [enable] parameter.
  void _setFullscreen({required bool enable}) {
    if (enable) {
      html.document.documentElement?.requestFullscreen();
    } else {
      if (html.document.fullscreenElement != null) {
        html.document.exitFullscreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      _urlController.text.isEmpty
                          ? SizedBox.shrink()
                          : HtmlImageWidget(imageUrl: _urlController.text),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.arrow_forward),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () => setState(() {}),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMenuSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
