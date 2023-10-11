import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/admin_login_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/stream_builder_extensions.dart';
import 'package:breez/widgets/breez_navigation_drawer.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey _podcastMenuItemKey =
    GlobalKey(debugLabel: "podcastMenuItemKey");

class HomeNavigationDrawer extends StatelessWidget {
  final Function(String) _onNavigationItemSelected;
  final List<DrawerItemConfig> Function(List<DrawerItemConfig>) _filterItems;

  const HomeNavigationDrawer(
    this._onNavigationItemSelected,
    this._filterItems, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final themeData = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: themeData.appBarTheme.systemOverlayStyle.copyWith(
        systemNavigationBarColor:
            theme.customData[theme.themeId].navigationDrawerBgColor,
      ),
      child: StreamBuilder2<BreezUserModel, AccountModel>(
        streamA: userProfileBloc.userStream,
        streamB: accountBloc.accountStream,
        builder: (context, userSnapshot, accountSnapshot) {
          final user = userSnapshot.data;
          final account = accountSnapshot.data;
          if (user == null || account == null) {
            return BreezNavigationDrawer(
                false, const [], _onNavigationItemSelected);
          }

          final refundableAddresses =
              account.swapFundsStatus.maturedRefundableAddresses;

          return Theme(
            data: theme.themeMap[user.themeId],
            child: BreezNavigationDrawer(
              true,
              [
                if (refundableAddresses.isNotEmpty)
                  DrawerItemConfigGroup(
                    [
                      DrawerItemConfig(
                        "",
                        texts.home_drawer_item_title_get_refund,
                        "src/icon/withdraw_funds.png",
                        onItemSelected: (_) => protectAdminRoute(
                          context,
                          user,
                          "/get_refund",
                        ),
                      )
                    ],
                  ),
                DrawerItemConfigGroup([
                  DrawerItemConfig(
                    "",
                    texts.home_drawer_item_title_balance,
                    "src/icon/balance.png",
                    isSelected: user.appMode == AppMode.balance,
                    onItemSelected: (_) {
                      protectAdminAction(
                        context,
                        user,
                        () {
                          userProfileBloc.userActionsSink.add(
                            SetAppMode(AppMode.balance),
                          );
                          return Future.value(null);
                        },
                      );
                    },
                  )
                ]),
                DrawerItemConfigGroup([
                  DrawerItemConfig(
                    "",
                    texts.home_drawer_item_title_podcasts,
                    "src/icon/podcast.png",
                    key: _podcastMenuItemKey,
                    isSelected: user.appMode == AppMode.podcasts,
                    onItemSelected: (_) {
                      protectAdminAction(
                        context,
                        user,
                        () {
                          userProfileBloc.userActionsSink.add(
                            SetAppMode(AppMode.podcasts),
                          );
                          return Future.value(null);
                        },
                      );
                    },
                  )
                ]),
                DrawerItemConfigGroup([
                  DrawerItemConfig(
                    "",
                    texts.home_drawer_item_title_pos,
                    "src/icon/pos.png",
                    isSelected: user.appMode == AppMode.pos,
                    onItemSelected: (_) {
                      userProfileBloc.userActionsSink.add(
                        SetAppMode(AppMode.pos),
                      );
                    },
                  )
                ]),
                DrawerItemConfigGroup([
                  DrawerItemConfig(
                    "",
                    texts.home_drawer_item_title_apps,
                    "src/icon/apps.png",
                    isSelected: user.appMode == AppMode.apps,
                    onItemSelected: (_) {
                      protectAdminAction(
                        context,
                        user,
                        () {
                          userProfileBloc.userActionsSink
                              .add(SetAppMode(AppMode.apps));
                          return Future.value(null);
                        },
                      );
                    },
                  )
                ]),
                const DrawerItemConfigGroup([]),
                if (user.appMode == AppMode.pos)
                  DrawerItemConfigGroup(
                    [
                      DrawerItemConfig(
                        "/transactions",
                        texts.home_drawer_item_title_transactions,
                        "src/icon/transactions.png",
                      ),
                    ],
                  ),
                if (user.appMode == AppMode.podcasts)
                  DrawerItemConfigGroup(
                    [
                      DrawerItemConfig(
                        "/podcast_history",
                        texts.podcast_history_drawer,
                        "src/icon/top_podcast_icon.png",
                      ),
                    ],
                  ),
                DrawerItemConfigGroup(
                  _filterItems(
                    [
                      DrawerItemConfig(
                        "/fiat_currency",
                        texts.home_drawer_item_title_fiat_currencies,
                        "src/icon/fiat_currencies.png",
                      ),
                      DrawerItemConfig(
                        "/network",
                        texts.home_drawer_item_title_network,
                        "src/icon/network.png",
                      ),
                      DrawerItemConfig(
                        "",
                        texts.home_drawer_item_title_security_and_backup,
                        "src/icon/security.png",
                        onItemSelected: (_) =>
                            protectAdminRoute(context, user, "/security"),
                      ),
                      DrawerItemConfig(
                        "",
                        texts.home_drawer_item_title_payment_options,
                        "src/icon/payment_options.png",
                        onItemSelected: (_) => protectAdminRoute(
                          context,
                          user,
                          "/payment_options",
                        ),
                      ),
                      DrawerItemConfig(
                        "",
                        "Nostr",
                        "src/icon/nostr_key1.png",
                        onItemSelected: (_) =>
                            protectAdminRoute(context, user, "/nostr_screen"),
                      ),
                      user.appMode == AppMode.pos
                          ? DrawerItemConfig(
                              "",
                              texts.home_drawer_item_title_pos_settings,
                              "src/icon/settings.png",
                              onItemSelected: (_) =>
                                  protectAdminRoute(context, user, "/settings"),
                            )
                          : DrawerItemConfig(
                              "/developers",
                              texts.home_drawer_item_title_developers,
                              "src/icon/developers.png",
                            ),
                    ],
                  ),
                  groupTitle: texts.home_drawer_item_title_preferences,
                  groupAssetImage: "",
                ),
              ],
              _onNavigationItemSelected,
            ),
          );
        },
      ),
    );
  }
}
