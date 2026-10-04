import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// Whether network images are kept on disk between launches. On by default;
/// tests turn it off (the cache needs real platform storage, which a unit-test
/// environment doesn't have).
bool diskImageCacheEnabled = true;

/// An image from [url] that is downloaded once and then served from the
/// device's own storage, so covers and avatars don't re-download on every
/// launch or after a scroll. (On the web the browser's own HTTP cache does the
/// same job.)
ImageProvider cachedImage(String url) =>
    diskImageCacheEnabled ? CachedNetworkImageProvider(url) : NetworkImage(url);
