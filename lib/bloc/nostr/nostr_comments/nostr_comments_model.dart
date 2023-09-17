import 'package:nostr_tools/nostr_tools.dart';

class CommentModel {
  String userName;
  String userPic;
  String userMessage;
  String date;
  String replyTo;
  String id;
  bool showReplies;
  CommentModel({
    this.userName,
    this.userPic,
    this.userMessage,
    this.date,
    this.replyTo,
    this.id,
    this.showReplies,
  });
}

class CommentEvent {
  static Event mapToEvent(Map<String, dynamic> comment) {
    return Event(
      kind: comment['kind'] as int,
      tags: comment['tags'] as List<List<String>>,
      content: comment['content'] as String,
      created_at: comment['created_at'] as int,
      id: comment['id'] as String,
      sig: comment['sig'] as String,
      pubkey: comment['pubkey'] as String,
    );
  }
}

class TimeAgo {
  static String format(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    Duration difference = DateTime.now().difference(dateTime);

    String timeAgo = '';

    if (difference.inDays > 0) {
      timeAgo =
          '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      timeAgo =
          '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      timeAgo =
          '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      timeAgo = 'just now';
    }

    return timeAgo;
  }
}
