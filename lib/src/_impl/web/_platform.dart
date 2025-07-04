import 'dart:js_interop';
import 'dart:math';

import 'package:meta/meta.dart';

import '../../converters/cast_converter.dart';
import '../../converters/converter.dart';
import '../../converters/num_converter.dart';
import '../../squadron_platform_type.dart';
import '../../squadron_singleton.dart';
import '../../utils.dart';
import '_patch.dart';

// threadIDs may not be unique on Web...
final threadId = Random.secure().nextInt(0x100000000).hex;

const double _one = 1.0;
final _platformType = (_one is int)
    ? SquadronPlatformType.js // JavaScript
    : SquadronPlatformType.wasm; // Web Assembly

Converter getPlatformConverter() => _platformType.isJs
    ? CastConverter.instance // JavaScript
    : NumConverter.instance; // Web Assembly

SquadronPlatformType getPlatformType() => _platformType;

Uri mapUrl(String url) {
  if (url.startsWith('~')) {
    final root = getRootUrl();
    if (root != null) {
      url = '$root${url.substring(1)}';
    }
  } else if (url.startsWith('@') && Squadron.assetBase != null) {
    url = '${Squadron.assetBase}${url.substring(1)}';
  }

  return Uri.parse(url).normalizePath();
}

@internal
bool isSameInstance(Object a, Object b) => (a is JSObject)
    ? ((b is JSObject) && $is(a, b))
    : ((b is! JSObject) && identical(a, b));
