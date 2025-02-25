import 'dart:developer';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

/// Displays an HTML image element with fullscreen toggle on double-click.
class HtmlImageWidget extends StatefulWidget {
  const HtmlImageWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<HtmlImageWidget> createState() => _HtmlImageWidgetState();
}

class _HtmlImageWidgetState extends State<HtmlImageWidget> {
  late final String _viewType;
  late final html.ImageElement _image;

  @override
  void initState() {
    super.initState();
    _viewType = _generateViewType();
    _registerViewFactory();
  }

  /// Returns a unique string used as the HTML view type for embedding the image.
  String _generateViewType() =>
      'html_image_${DateTime.now().millisecondsSinceEpoch}_${widget.imageUrl.hashCode}';

  void _registerViewFactory() {
    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final container =
          html.DivElement()
            ..style.display = 'flex'
            ..style.width = '100%'
            ..style.height = '100%';

      _image =
          html.ImageElement()
            ..src = widget.imageUrl
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = 'contain'
            ..onDoubleClick.listen((_) => _toggleFullscreen())
            ..onError.listen(
              (_) => log('Image load failed: ${widget.imageUrl}'),
            );

      container.append(_image);
      return container;
    });
  }

  @override
  void didUpdateWidget(HtmlImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _image.src = widget.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }

  /// Toggles the fullscreen mode of the Image.
  ///
  /// If the Image is currently in fullscreen mode, this method will exit-
  /// fullscreen mode. If the image is not in fullscreen mode, this method
  /// will request fullscreen mode for the Image to veiw.

  void _toggleFullscreen() {
    final doc = html.document;
    if (doc.fullscreenElement != null) {
      doc.exitFullscreen();
    } else {
      doc.documentElement?.requestFullscreen();
    }
  }
}
