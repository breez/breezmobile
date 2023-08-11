// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:podcast_search/podcast_search.dart';

const PODCAST_INDEX_KEY = "XXWQEGULBJABVHZUM8NF";
const PODCAST_INDEX_SECRET = "KZ2uy4upvq4t3e\$m\$3r2TeFS2fEpFTAaF92xcNdX";
const BYFEED_API_ENDPOINT =
    'https://api.podcastindex.org/api/1.0/podcasts/byfeedurl';
const EPISODES_BYFEED_API_ENDPOINT =
    'https://api.podcastindex.org/api/1.0/episodes/byfeedurl';
const EPISODES_BYGUID_API_ENDPOINT =
    'https://api.podcastindex.org/api/1.0/episodes/byguid';

class PodcastIndexClient {
  static Dio _createClient() {
    var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    var newUnixTime = unixTime.toString();
    var firstChunk = utf8.encode(PODCAST_INDEX_KEY);
    var secondChunk = utf8.encode(PODCAST_INDEX_SECRET);
    var thirdChunk = utf8.encode(newUnixTime);

    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);
    input.add(firstChunk);
    input.add(secondChunk);
    input.add(thirdChunk);
    input.close();
    var digest = output.events.single;

    return Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        responseType: ResponseType.json,
        headers: {
          'X-Auth-Date': newUnixTime,
          'X-Auth-Key': PODCAST_INDEX_KEY,
          'Authorization': digest.toString(),
          'user-agent': 'breez',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> loadFeed({
    @required String url,
    int timeout = 20000,
    String userAgent,
  }) {
    return _createClient().get(BYFEED_API_ENDPOINT, queryParameters: {
      "url": url,
    }).then((res) {
      return res.data as Map<String, dynamic>;
    }).catchError((e) {
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionError:
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.unknown:
            throw PodcastTimeoutException(e.message);
            break;
          case DioExceptionType.badCertificate:
          case DioExceptionType.badResponse:
            throw PodcastFailedException(e.message);
            break;
          case DioExceptionType.cancel:
            throw PodcastCancelledException(e.message);
            break;
        }
      }
      throw e;
    });
  }

  Future<Map<String, dynamic>> loadEpisodes({
    @required String url,
    int timeout = 20000,
    int max = 100,
    String userAgent,
  }) {
    return _createClient().get(EPISODES_BYFEED_API_ENDPOINT, queryParameters: {
      "url": url,
      "max": max,
    }).then((res) {
      return res.data as Map<String, dynamic>;
    }).catchError((e) {
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionError:
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.unknown:
            throw PodcastTimeoutException(e.message);
            break;
          case DioExceptionType.badCertificate:
          case DioExceptionType.badResponse:
            throw PodcastFailedException(e.message);
            break;
          case DioExceptionType.cancel:
            throw PodcastCancelledException(e.message);
            break;
        }
      }
      throw e;
    });
  }

  Future<Map<String, dynamic>> loadEpisode({
    @required int feedId,
    @required String guid,
    int timeout = 20000,
    int max = 100,
    String userAgent,
  }) {
    return _createClient().get(EPISODES_BYGUID_API_ENDPOINT, queryParameters: {
      "feedid": feedId,
      "guid": guid,
    }).then((res) {
      return res.data as Map<String, dynamic>;
    }).catchError((e) {
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionError:
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.unknown:
            throw PodcastTimeoutException(e.message);
            break;
          case DioExceptionType.badCertificate:
          case DioExceptionType.badResponse:
            throw PodcastFailedException(e.message);
            break;
          case DioExceptionType.cancel:
            throw PodcastCancelledException(e.message);
            break;
        }
      }
      throw e;
    });
  }
}
