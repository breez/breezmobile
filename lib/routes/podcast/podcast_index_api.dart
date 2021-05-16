// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import 'package:anytime/api/podcast/podcast_api.dart';
import 'package:anytime/core/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:podcast_search/podcast_search.dart';

import '../../logger.dart';

const PODCAST_INDEX_KEY = "XXWQEGULBJABVHZUM8NF";
const PODCAST_INDEX_SECRET = "KZ2uy4upvq4t3e\$m\$3r2TeFS2fEpFTAaF92xcNdX";
const SEARCH_API_ENDPOINT = 'https://api.podcastindex.org/api/1.0/search';
const TRENDING_API_ENDPOINT =
    'https://api.podcastindex.org/api/1.0/podcasts/trending';

/// An implementation of the PodcastApi. A simple wrapper class that
/// interacts with the iTunes search API via the podcast_search package.
class PodcastIndexAPI extends PodcastApi {
  final Search api = Search();
  // static String userAgent =
  //     'Anytime/${AnytimePodcastApp.applicationVersion} (https://github.com/amugofjava/anytime_podcast_player)';

  @override
  Future<SearchResult> search(String term,
      {String country,
      String attribute,
      int limit,
      String language,
      String searchProvider,
      int version = 0,
      bool explicit = false}) async {
    return _search(term);
  }

  @override
  Future<SearchResult> charts(
    int size,
  ) async {
    return _charts(0);
    //return compute(_charts, 0);
  }

  @override
  Future<Podcast> loadFeed(String url) async {
    return _loadFeed(url);
  }

  static Future<SearchResult> _search(String term) async {
    var res = await Search(userAgent: Environment.userAgent())
        .search(term,
            queryParams: {"val": "lightning"},
            searchProvider: PodcastIndexProvider(
                key: 'XXWQEGULBJABVHZUM8NF',
                secret: 'KZ2uy4upvq4t3e\$m\$3r2TeFS2fEpFTAaF92xcNdX'))
        .timeout(Duration(seconds: 10));
    log.severe(
        "search results: successful=${res.successful}, lastError=${res.lastError}, resultCount=${res.resultCount} lastErrorType=${res.lastErrorType}");
    return res;
  }

  static Future<SearchResult> _charts(int size) async {
    var test = await testCharts();
    if (test == null) {
      log.severe("test charts returned null");
    } else {
      log.severe(
          "test charts returned: successful=${test.successful}, lastError=${test.lastError}, resultCount=${test.resultCount} lastErrorType=${test.lastErrorType}");
    }
    var res = await Search(userAgent: Environment.userAgent()).charts(
        searchProvider: PodcastIndexProvider(
            key: 'NBVJ9GPWMLPXJMFFD3KV',
            secret: 'be7kR2CWeCFk4nkKCKV4XAX35y2eXrDeCPvs#v4F'),
        queryParams: {
          'val': 'lightning',
          'aponly': 'true'
        }).timeout(Duration(seconds: 10));
    log.severe(
        "charts results: successful=${res.successful}, lastError=${res.lastError}, resultCount=${res.resultCount} lastErrorType=${res.lastErrorType}");
    return res;
  }

  static Future<Podcast> _loadFeed(String url) {
    return Podcast.loadFeed(url: url, userAgent: Environment.userAgent());
  }

  @override
  Future<Chapters> loadChapters(String url) {
    return Podcast.loadChaptersByUrl(url: url);
  }

  static Future<SearchResult> testCharts(
      {Country country = Country.UNITED_KINGDOM,
      int limit = 20,
      bool explicit = false,
      Genre genre,
      Map<String, dynamic> queryParams = const {}}) async {
    try {
      var response = await _createClient().get(TRENDING_API_ENDPOINT,
          queryParameters: {
            'since': -1 * 3600 * 24 * 7,
          }..addAll(queryParams));

      return SearchResult.fromJson(
          json: response.data, type: ResultType.podcastIndex);
    } on DioError catch (e) {
      log.info("failed to call testCharts ${e.toString()}");
    }

    return null;
  }

  static Dio _createClient() {
    var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    var newUnixTime = unixTime.toString();
    log.info("current time = ${DateTime.now().toString()}");
    log.info("unixTime = $unixTime");
    log.info("unixTime = $newUnixTime");
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
        connectTimeout: 10000,
        receiveTimeout: 10000,
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
}
