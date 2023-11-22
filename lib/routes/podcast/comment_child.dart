import 'package:breez/bloc/nostr/nostr_comments/nostr_comments_model.dart';
import 'package:breez/widgets/comment_user_image.dart';
import 'package:flutter/material.dart';

class CommentChild extends StatefulWidget {
  final CommentModel userRootComment;

  CommentChild(this.userRootComment);

  @override
  State<CommentChild> createState() => _CommentChildState();
}

class _CommentChildState extends State<CommentChild> {
  Widget userCommentTree = Container();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Theme(
      data: themeData,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child:
                    CommentUserImage(userImage: widget.userRootComment.userPic),
              ),
              title: Text(
                '@${widget.userRootComment.userName} • ${widget.userRootComment.date}',
                style: themeData.primaryTextTheme.bodySmall,
              ),
              subtitle: Text(
                widget.userRootComment.userMessage,
                style: themeData.primaryTextTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
