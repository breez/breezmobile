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
    // Get the PodcastIndex feed id.
    if (episode.metadata == null || episode.metadata["feed"] == null) {
      Future.error("no feed in podcast metadata");
    }

    final feedId = episode.metadata["feed"]["id"];
    if (feedId == null || !(feedId is int)) {
      Future.error("no feed id in podcast metadata");
    }

    return podcastIndexClient.loadEpisode(feedId: feedId, guid: episode.guid);
  }
}