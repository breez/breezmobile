import 'dart:async';
import 'dart:convert';

import 'package:anytime/entities/episode.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/bloc/nostr/nostr_comments/nostr_comments_model.dart';
import 'package:breez/bloc/nostr/nostr_comments/nostr_comments_state_event.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:nostr_tools/nostr_tools.dart';

class NostrCommentBloc extends Bloc {
  final Stream<Episode> episodeStream;
  final NostrBloc nostrBloc;
  NostrCommentBloc({this.episodeStream, this.nostrBloc}) {
    init();
  }

  final relaysList = [
    "wss://relay.damus.io",
    "wss://nostr1.tunnelsats.com",
    "wss://nostr-pub.wellorder.net",
    "wss://relay.nostr.info",
    "wss://nostr-relay.wlvs.space",
    "wss://nostr.bitcoiner.social",
    "wss://nostr-01.bolt.observer",
    "wss://relayer.fiatjaf.com",
  ];
  RelayPoolApi _relayPool;

  Set<String> _connectedRelays;

  List<Event> sortedEvents;
  String _rootId;
  bool isRootEventPresent;
  Episode currentEpisode;
  String replyToRoot;

  String userPubKey;

  Map<String, Metadata> metaDatas;

  Map<String, bool> _eventMap;

  bool _isAddEventToController;

  bool isRelayConnected;

  bool nostrEnabled = false;

  List<String> _userRelayList;

  final StreamController<bool> toggleCommentController =
      StreamController<bool>.broadcast();

  Stream<bool> get toggleCommentStream => toggleCommentController.stream;

  final StreamController<CommentAction> commentActionController =
      StreamController<CommentAction>.broadcast();

  Stream<CommentAction> get commentActionStream =>
      commentActionController.stream;

  final StreamController<Event> _eventController =
      StreamController<Event>.broadcast();

  final StreamController<String> _publicKeyController =
      StreamController<String>.broadcast();

  final StreamController<Map<String, dynamic>> _signEventController =
      StreamController<Map<String, dynamic>>.broadcast();

  final StreamController<Metadata> _userMetaDataController =
      StreamController<Metadata>.broadcast();

  Stream<Metadata> get userMetaDataStream => _userMetaDataController.stream;

  Stream<String> get pubKeyStream => _publicKeyController.stream;
  Stream<Map<String, dynamic>> get signEventStream =>
      _signEventController.stream;

  Map<String, dynamic> previousEvent;

  Stream<Event> stream = StreamController<Event>.broadcast().stream;

  Stream<Message> _streamConnect;
  StreamSubscription _streamSubscription;

  Stream<Event> get eventStream => _eventController.stream;

  void init() {
    _relayPool = RelayPoolApi(relaysList: relaysList);
    metaDatas = {};
    _eventMap = {};
    sortedEvents = [];
    _isAddEventToController = false;
    _isAddEventToController = false;
    isRelayConnected = false;

    _listenToEnableNostr();

    // making sure keyPair is generated and fetching the pubKey
    _getPubKey();

    _listenToEpisode();
    _listenToActions();
  }

  void _listenToEnableNostr() {
    toggleCommentStream.listen((event) {
      nostrEnabled = event;
    });
  }

  void _listenToActions() {
    commentActionStream.listen((event) {
      if (event is CreateRootComment) {
        createRootEvent(event.userComment);
      } else if (event is CreateReplyComment) {
        createComment(event.userComment);
      } else if (event is ReloadConnection) {
        reloadConnection();
      } else if (event is GetUserPubKey) {
        _getPubKey();
      }
    });
  }

  // setting listener for episode
  void _listenToEpisode() {
    episodeStream.listen((episode) {
      if (currentEpisode == null && episode != null) {
        currentEpisode = episode;
        initRelayConnection();
      }
      // reload in case of a different episode
      else if (currentEpisode != episode) {
        currentEpisode = episode;
        reloadConnection();
      }
    });
  }

  void _getUserMetaData(Metadata metadata) async {
    String profile = metadata.nip05;
    // fetching the nip05 identifier of the user to get their RelayList
    ProfilePointer nostrProfile = await Nip05().queryProfile(profile);
    _userRelayList = nostrProfile?.relays;
    if (_userRelayList != null) {
      _relayPool = RelayPoolApi(relaysList: _userRelayList);
      reloadConnection();
    }
    _userMetaDataController.add(metadata);
  }

  // create a comment
  Future<void> createComment(String content) async {
    Map<String, dynamic> eventData = <String, dynamic>{
      "created_at": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "kind": 1,
      "tags": [
        ['e', _rootId],
      ],
      "content": content,
    };
    await signEvent(eventData);
  }

  Future<void> reloadConnection() async {
    // setting each variable to its default value
    isRootEventPresent = false;
    _isAddEventToController = false;
    isRelayConnected = false;
    _rootId = null;
    sortedEvents.clear();
    metaDatas.clear();
    _eventMap.clear();
    _connectedRelays.clear();

    // need to close the relay stream for a fresh connection
    _relayPool.close();
    _streamSubscription?.cancel();

    // calling relay connection again
    await initRelayConnection();
  }

  Future<void> createRootEvent(String userComment) async {
    replyToRoot = userComment;
    // if no Root Event present then create one
    Map<String, dynamic> eventData = <String, dynamic>{
      "created_at": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "kind": 1,
      "tags": [
        ['t', currentEpisode.contentUrl],
      ],
      "content":
          "comments about episode ${currentEpisode.title} at ${currentEpisode.contentUrl}",
    };
    await signEvent(eventData);
  }

  Future<void> initRelayConnection() async {
    // connecting to relays
    try {
      _streamConnect = await _relayPool.connect();

      _relayPool.on((event) {
        if (event == RelayEvent.connect) {
          isRelayConnected = true;
          // if relay is connected add this to _isConnectedController
        } else if (event == RelayEvent.error ||
            event == RelayEvent.disconnect) {}
        _connectedRelays = _relayPool.connectedRelays;
        if (_connectedRelays.isEmpty) {
          isRelayConnected = false;
        }
      });
    } catch (e) {
      throw Exception(e);
    }

    // for fetching userMetaData
    _relayPool.sub([
      Filter(
        kinds: [1],
        authors: [userPubKey],
      ),
    ]);

    // checking for root event to be present or not
    if (_rootId == null) {
      _relayPool.sub([
        Filter(
          kinds: [1],
          // limit: 1,
          t: [currentEpisode.contentUrl],
        )
      ]);
    } else {
      _relayPool.sub([
        Filter(
          kinds: [1],
          limit: 100,
          // denoting that this is a root level reply
          e: [_rootId],
        )
      ]);
    }

    try {
      _streamSubscription = _streamConnect.listen(
        (message) {
          if (message.type == 'EVENT') {
            Event event = message.message as Event;
            if (event.kind == 1) {
              // check for being the rootEvent
              if (event.tags.isNotEmpty &&
                  event.tags[0][0] == "t" &&
                  event.tags[0][1] == currentEpisode.contentUrl) {
                _rootId = event.id;
                isRootEventPresent = true;

                _relayPool.sub([
                  Filter(
                    kinds: [1],
                    limit: 100,
                    // denoting that this is a root level reply
                    e: [_rootId],
                  )
                ]);
              } else if (event.tags.isNotEmpty &&
                  event.tags[0][0] == "e" &&
                  event.tags[0][1] == _rootId) {
                _addEvent(event);

                // if event is already present in List then return to avoid duplication
                if (_isAddEventToController == false) {
                  return;
                }

                _eventController.add(event);
                // setting _addEventController to false to check for the next event to be added
                _isAddEventToController = false;
              }

              // to get the metadata of the user of the comment
              _relayPool.sub([
                Filter(kinds: [0], authors: [event.pubkey])
              ]);
            } else if (event.kind == 0) {
              Metadata metadata = Metadata.fromJson(
                  jsonDecode(event.content) as Map<String, dynamic>);
              if (event.pubkey == userPubKey) {
                _getUserMetaData(metadata);
              }
              metaDatas[event.pubkey] = metadata;
            }
          }
        },
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  void _insertInDescendingOrder(Event event) {
    // using binary search to insert the new event
    int start = 0;
    int end = sortedEvents.length - 1;
    int midpoint;
    int position = start;

    if (end < 0) {
      position = 0;
    } else if (event.created_at < sortedEvents[end].created_at) {
      position = end + 1;
    } else if (event.created_at >= sortedEvents[start].created_at) {
      position = start;
    } else {
      while (true) {
        if (end <= start + 1) {
          position = end;
          break;
        }
        midpoint = (start + (end - start) / 2).floor();
        if (sortedEvents[midpoint].created_at > event.created_at) {
          start = midpoint;
        } else if (sortedEvents[midpoint].created_at > event.created_at) {
          end = midpoint;
        } else {
          position = midpoint;
        }
      }
    }
    sortedEvents.insert(position, event);
  }

  void _addEvent(Event event) {
    if (_eventMap.containsKey(event.id) == false) {
      // adding the event according its creation time
      _insertInDescendingOrder(event);
      _isAddEventToController = true;
      _eventMap[event.id] = true;
    } else {
      _isAddEventToController = false;
    }
  }

  // this method is to make sure keyPair is made before signing the sortedEvents
  Future<void> _getPubKey() async {
    // will log the user via nostrComments
    NostrSettings settings = await nostrBloc.nostrSettingsStream.first;
    if (!settings.isLoggedIn) {
      nostrBloc.nostrSettingsSettingsSink.add(settings.copyWith(
        isLoggedIn: true,
      ));
    }
    nostrBloc.actionsSink.add(GetPublicKey());
  }

  Future<void> signEvent(Map<String, dynamic> eventData) async {
    // _signEventController.add(eventData);

    nostrBloc.actionsSink.add(SignEvent(eventData));
    Map<String, dynamic> signedEvent = await nostrBloc.eventStream.first;
    final signedNostrEvent = CommentEvent.mapToEvent(signedEvent);
    await _publishNewEvent(signedNostrEvent);
  }

  void getPubKeyResult(String pubKey) {
    print('Received public key from Breez: $pubKey');
    userPubKey = pubKey;
  }

  // Future<void> signEventResult(Map<String, dynamic> signedEvent) async {
  //   final signedNostrEvent = CommentEvent.mapToEvent(signedEvent);

  //   await _publishNewEvent(signedNostrEvent);
  // }

  Future<void> _publishNewEvent(Event signedNostrEvent) async {
    try {
      _relayPool.publish(signedNostrEvent);
    } catch (e) {
      throw Exception(e);
    }

    // if it was the root event being published
    // creating the user comment as a reply to it
    if (signedNostrEvent.tags[0][0] == 't' &&
        signedNostrEvent.tags[0][1] == currentEpisode.contentUrl) {
      _rootId = signedNostrEvent.id;
      isRootEventPresent = true;
      await createComment(replyToRoot);
    }
  }

  @override
  void dispose() {
    // super.dispose();
    _relayPool.close();
    _eventController.close();
    _publicKeyController.close();
    _signEventController.close();
    toggleCommentController.close();
    commentActionController.close();
    _userMetaDataController.close();
  }
}
