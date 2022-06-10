import 'package:breez/bloc/podcast_history/model.dart';

import '../async_action.dart';

class UpdatePodcastHistoryTimeRange extends AsyncAction {
  final PodcastHistoryTimeRange range;

  UpdatePodcastHistoryTimeRange(this.range);
}

class UpdatePodcastHistorySort extends AsyncAction {
  final PodcastHistorySortOptions sortOptions;

  UpdatePodcastHistorySort(this.sortOptions);
}
