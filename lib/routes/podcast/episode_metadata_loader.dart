import 'package:anytime/entities/episode.dart';
import 'package:breez/routes/podcast/podcast_loader.dart';
import 'package:meta/meta.dart';

class PodcastIndexMetadataLoader {
  final podcastIndexClient = PodcastIndexClient();

  Future<Map<String, dynamic>> loadPodcastMetadata({
    @required String url
  }) {
    return podcastIndexClient.loadFeed(url: url);
  }

  Future<Map<String, dynamic>> loadEpisodeMetadata({
    @required Episode episode
  }) {
    if (episode.metadata == null || episode.metadata["feed"] == null) {
      return Future.value({});
    }

    final feedId = episode.metadata["feed"]["id"];
    if (feedId == null || !(feedId is int)) {
      return Future.value({});
    }

    return podcastIndexClient.loadEpisode(feedId: feedId, guid: episode.guid);
  }
}
