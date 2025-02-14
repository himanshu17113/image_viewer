import 'dart:developer';
import 'dart:html' as html;
import 'dart:ui_web';

import 'package:flutter/material.dart';

/// Displays an HTML `<img>` element with fullscreen toggle on double-click.
///
/// Uses [HtmlElementView] to embed a DOM element, registering a unique
/// factory via [platformViewRegistry].  Image scales to container,
/// maintaining aspect ratio.
class HtmlImageWidget extends StatefulWidget {
  /// Creates an [HtmlImageWidget] to display an image from [imageUrl].
  const HtmlImageWidget({super.key, required this.imageUrl});

  /// The URL of the image to display.
  final String imageUrl;

  @override
  State<HtmlImageWidget> createState() => _HtmlImageWidgetState();
}

class _HtmlImageWidgetState extends State<HtmlImageWidget> {
  late final String _viewType;
  late final html.DivElement _container;
  late final html.ImageElement _image;

  @override
  void initState() {
    super.initState();
    _viewType = 'html_image_${DateTime.now().millisecondsSinceEpoch}_${widget.imageUrl.hashCode}';

    platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      _container =
          html.DivElement()
            ..style.display = 'flex'
            ..style.justifyContent = 'center'
            ..style.alignItems = 'center'
            ..style.width = '100%'
            ..style.height = '100%';

      _image =
          html.ImageElement()
            ..src = widget.imageUrl
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = 'contain'
            ..onDoubleClick.listen((_) => _toggleFullscreen())
            ..onError.listen((_) {
              log('Failed to load image from URL: ${widget.imageUrl}');
            });

      _container.append(_image);
      return _container;
    });
  }

  @override
  void didUpdateWidget(HtmlImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _image.src = widget.imageUrl;
      log('Updating image source to: ${widget.imageUrl}');
    }
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);

  /// Toggles fullscreen mode using JavaScript interop.
  void _toggleFullscreen() {
    if (html.document.fullscreenElement != null) {
      html.document.exitFullscreen();
    } else {
      html.document.documentElement?.requestFullscreen();
    }
  }
}
