import 'package:anytime/entities/episode.dart';
import 'package:breez/bloc/nostr/nostr_comments/nostr_comments_bloc.dart';
import 'package:breez/bloc/nostr/nostr_comments/nostr_comments_state_event.dart';
import 'package:breez/routes/podcast/comment_render.dart';
import 'package:breez/routes/podcast/episode_comment_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodeComments extends StatefulWidget {
  final Episode episode;
  EpisodeComments({@required this.episode, Key key}) : super(key: key);

  @override
  State<EpisodeComments> createState() => _EpisodeCommentsState();
}

class _EpisodeCommentsState extends State<EpisodeComments> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  String hintText = "Add a comment...";

  final FocusNode _textFieldFocusNode = FocusNode();
  String userImage;

  NostrCommentBloc commentBloc;

  @override
  void initState() {
    super.initState();
    commentBloc = Provider.of<NostrCommentBloc>(context, listen: false);

    _init();
    _setUserMetaDataListener();
  }

  void _setUserMetaDataListener() {
    commentBloc.userMetaDataStream.listen((metadata) {
      if (metadata != null) {
        setState(() {
          userImage = metadata.picture;
        });
      }
    });
  }

  Future<void> _init() async {
    commentBloc.commentActionController.add(GetUserPubKey());
    commentBloc.commentActionController.add(ReloadConnection());
  }

  @override
  void dispose() {
    super.dispose();
    _textFieldFocusNode.dispose();
  }

  void _createComment() async {
    if (commentBloc.isRootEventPresent == false) {
      commentBloc.commentActionController
          .add(CreateRootComment(commentController.text.trim()));
    } else {
      commentBloc.commentActionController
          .add(CreateReplyComment(commentController.text.trim()));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Theme(
      data: themeData,
      child: RefreshIndicator(
        onRefresh: () async {
          await _init();
        },
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              _textFieldFocusNode.unfocus();
            }
          },
          child: CommentBox(
            userImage: userImage,
            hintText: hintText,
            withBorder: _textFieldFocusNode.hasFocus ? true : false,
            sendButtonMethod: () {
              if (formKey.currentState.validate()) {
                _createComment();
                commentController.clear();
                FocusScope.of(context).unfocus();
              } else {
                formKey.currentState.setState(() {});
              }
            },
            focusNode: _textFieldFocusNode,
            formKey: formKey,
            commentController: commentController,
            textColor: themeData.textTheme.titleMedium.color,
            sendWidget: _textFieldFocusNode.hasFocus
                ? Icon(
                    Icons.send,
                    size: 20,
                  )
                : SizedBox.shrink(),
            child: CommentRender(
              commentBloc: commentBloc,
            ),
          ),
        ),
      ),
    );
  }
}
