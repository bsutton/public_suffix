/*
 * Copyright 2019 Jakob Hjelm (Komposten)
 *
 * This file is part of public_suffix.
 *
 * public_suffix is a free Dart library: you can use, redistribute it and/or modify
 * it under the terms of the MIT license as written in the LICENSE file in the root
 * of this project.
 */
import 'dart:html';

import '../public_suffix_list.dart';

/// A static helper class for initialising [PublicSuffixList].
///
/// This class provides simple functions for initialising [PublicSuffixList]
/// from resources obtained using http requests.
///
/// To initialise directly from strings instead, use [PublicSuffixList.initFromString].
class PublicSuffixListHelper {
  PublicSuffixListHelper._();

  /// Initialises [PublicSuffixList] using a suffix list resource obtained from a URI.
  ///
  /// [HttpRequest.request] is used to retrieve the resource, and the optional
  /// parameters can be used to tweak this request. If more fine-grained control
  /// over the request is needed, consider obtaining the suffix list using custom
  /// code first and then passing it to [PublicSuffixList.initFromString].
  ///
  /// An [Exception] is thrown if the request fails.
  static Future<void> initFromUri(Uri publicSuffixList,
      {bool withCredentials,
      Map<String, String> requestHeaders,
      dynamic sendData,
      void Function(ProgressEvent) onProgress}) async {
    try {
      var request = await HttpRequest.request(publicSuffixList.toString(),
          withCredentials: withCredentials,
          requestHeaders: requestHeaders,
          sendData: sendData,
          onProgress: onProgress);

      switch (request.status) {
        case 200:
          PublicSuffixList.initFromString(request.responseText);
          break;
        default:
          throw request;
      }
    } catch (e) {
      var object = e;

      if (e is ProgressEvent) {
        object = e.target;
      }

      if (e is HttpRequest) {
        throw Exception(
            "Request for public suffix list failed: [${object.status}] ${object.statusText}");
      } else {
        throw Exception("Request for public suffix list failed: $object");
      }
    }
  }
}
