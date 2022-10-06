// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:anytime/api/podcast/podcast_api.dart';
import 'package:anytime/core/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:podcast_search/podcast_search.dart';

/// An implementation of the PodcastApi. A simple wrapper class that
/// interacts with the iTunes search API via the podcast_search package.
class PodcastIndexAPI extends PodcastApi {
  SecurityContext _defaultSecurityContext;
  List<int> _certificateAuthorityBytes = [];
  final Search api = Search();

  @override
  Future<SearchResult> search(
    String term, {
    String country,
    String attribute,
    int limit,
    String language,
    String searchProvider,
    int version = 0,
    bool explicit = false,
  }) async {
    return compute(_search, term);
  }

  @override
  Future<SearchResult> charts({
    int size = 20,
    String genre,
    String searchProvider,
  }) async {
    return compute(_charts, 0);
  }

  @override
  Future<SearchResult> mostRecent() => _mostRecent();

  @override
  Future<Podcast> loadFeed(String url) async {
    return _loadFeed(url);
  }

  static Future<SearchResult> _search(String term) {
    return Search(
          userAgent: Environment.userAgent(),
          searchProvider: PodcastIndexProvider(
            key: 'XXWQEGULBJABVHZUM8NF',
            secret: 'KZ2uy4upvq4t3e\$m\$3r2TeFS2fEpFTAaF92xcNdX',
          ),
        )
        .search(
          term,
          queryParams: {"val": "lightning"},
        )
        .timeout(Duration(seconds: 10));
  }

  static Future<SearchResult> _charts(int size) {
    return Search(
      userAgent: Environment.userAgent(),
      searchProvider: PodcastIndexProvider(
        key: 'NBVJ9GPWMLPXJMFFD3KV',
        secret: 'be7kR2CWeCFk4nkKCKV4XAX35y2eXrDeCPvs#v4F',
      ),
    ).charts(
      queryParams: {
        'val': 'lightning',
        'aponly': 'true',
      },
    ).timeout(Duration(seconds: 10));
  }

  static Future<SearchResult> _mostRecent() {
    return Search(
      userAgent: Environment.userAgent(),
    ).mostRecent(
      searchProvider: PodcastIndexProvider(
        key: 'NBVJ9GPWMLPXJMFFD3KV',
        secret: 'be7kR2CWeCFk4nkKCKV4XAX35y2eXrDeCPvs#v4F',
      ),
      queryParams: {
        'val': 'lightning',
        'aponly': 'true',
      },
    ).timeout(Duration(seconds: 10));
  }

  static Future<Podcast> _loadFeed(String url) {
    return Podcast.loadFeed(url: url, userAgent: Environment.userAgent());
  }

  @override
  Future<Chapters> loadChapters(String url) {
    return Podcast.loadChaptersByUrl(url: url);
  }

  @override
  void addClientAuthorityBytes(List<int> certificateAuthorityBytes) {
    if (_certificateAuthorityBytes.isNotEmpty &&
        _defaultSecurityContext == null) {
      SecurityContext.defaultContext
          .setTrustedCertificatesBytes(_certificateAuthorityBytes);
      _defaultSecurityContext = SecurityContext.defaultContext;
    }
  }

  @override
  List<String> genres(String searchProvider) {
    var provider = PodcastIndexProvider(
      key: 'NBVJ9GPWMLPXJMFFD3KV',
      secret: 'be7kR2CWeCFk4nkKCKV4XAX35y2eXrDeCPvs#v4F',
    );

    return Search(
      userAgent: Environment.userAgent(),
      searchProvider: provider,
    ).genres();
  }
}
