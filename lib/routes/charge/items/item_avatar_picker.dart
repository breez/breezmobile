import 'package:badges/badges.dart';
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';

import 'item_avatar.dart';

class ItemAvatarPicker extends StatefulWidget {
  final String itemImage;
  final Function(String selectedImage) onImageSelected;
  final String itemName;

  ItemAvatarPicker(this.itemImage, this.onImageSelected, {this.itemName});

  @override
  State<StatefulWidget> createState() {
    return ItemAvatarPickerState();
  }
}

class ItemAvatarPickerState extends State<ItemAvatarPicker> {
  Map<String, IconData> iconMap = {
    'account_balance': Icons.account_balance,
    'map': Icons.map,
    'airline_seat_individual_suite': Icons.airline_seat_individual_suite,
    'attach_money': Icons.attach_money,
    'beach_access': Icons.beach_access,
    'brush': Icons.brush
  };
  TextEditingController _imageFilterController = TextEditingController();
  String _selectedImage;
  Color bgColor = Colors.transparent;
  Map<String, IconData> _iconList;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.itemImage ?? "";
    _iconList = iconMap;
    _imageFilterController.addListener(
      () {
        setState(() {
          _iconList = Map.from(iconMap)
            ..removeWhere((k, v) => !k.contains(_imageFilterController.text));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          "Select Image",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16, left: 0.0, right: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Badge(
              showBadge: _selectedImage != "",
              position: BadgePosition.topRight(top: 5, right: -10),
              animationType: BadgeAnimationType.fade,
              badgeColor: Theme.of(context).primaryTextTheme.subtitle2.color,
              badgeContent: GestureDetector(
                child: Container(
                  height: 24,
                  width: 24,
                  child: Icon(
                    Icons.delete_outline,
                    size: Theme.of(context).iconTheme.deleteBadgeIconTheme.size,
                    color:
                        Theme.of(context).iconTheme.deleteBadgeIconTheme.color,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedImage = "";
                    widget.onImageSelected(_selectedImage);
                  });
                },
              ),
              child: ItemAvatar(_selectedImage ?? null,
                  itemName: widget.itemName, radius: 48, useDecoration: true),
            )),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _imageFilterController,
                    enabled: _iconList != null,
                    decoration: InputDecoration(
                        hintText: "Search for an image",
                        contentPadding:
                            const EdgeInsets.only(top: 16, left: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _imageFilterController.text.isEmpty
                                ? Icons.search
                                : Icons.close,
                            size: 20,
                          ),
                          onPressed: _imageFilterController.text.isEmpty
                              ? null
                              : () {
                                  _imageFilterController.text = "";
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                          padding: EdgeInsets.only(right: 24, top: 4),
                        ),
                        border: UnderlineInputBorder()),
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 176,
              width: 600,
              padding: EdgeInsets.only(left: 16, right: 16),
              child: GridView.count(
                crossAxisCount: 4,
                children: _iconList
                    .map((value, icon) {
                      return MapEntry(
                          value,
                          Container(
                            height: 64,
                            width: 64,
                            key: Key(value),
                            child: IconButton(
                              icon: Icon(icon),
                              onPressed: () {
                                setState(() {
                                  _selectedImage = "icon:$value";
                                  widget.onImageSelected(_selectedImage);
                                });
                              },
                            ),
                          ));
                    })
                    .values
                    .toList(),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
