import 'package:badges/badges.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  TextEditingController _imageFilterController = TextEditingController();
  String _selectedImage;
  List<ProductIcon> _iconList = [];

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.itemImage ?? "";
    _imageFilterController.addListener(
      () {
        setState(() {});
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildItemAvatar(context),
            SizedBox(height: 16),
            _buildSearchBar(context),
            SizedBox(height: 8),
            _buildIconGrid(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  _buildItemAvatar(BuildContext context) {
    return Badge(
      showBadge: _selectedImage != "",
      position: BadgePosition.topEnd(top: 5, end: -10),
      animationType: BadgeAnimationType.fade,
      badgeColor: Theme.of(context).primaryTextTheme.subtitle2.color,
      badgeContent: _buildResetIconBadge(context),
      child: ItemAvatar(_selectedImage ?? null,
          itemName: widget.itemName, radius: 48, useDecoration: true),
    );
  }

  GestureDetector _buildResetIconBadge(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 24,
        width: 24,
        child: Icon(
          Icons.delete_outline,
          size: Theme.of(context).iconTheme.deleteBadgeIconTheme.size,
          color: Theme.of(context).iconTheme.deleteBadgeIconTheme.color,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedImage = "";
          widget.onImageSelected(_selectedImage);
        });
      },
    );
  }

  Row _buildSearchBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            textCapitalization: TextCapitalization.none,
            controller: _imageFilterController,
            enabled: _iconList != null,
            decoration: InputDecoration(
                hintText: "Search for an image",
                contentPadding: const EdgeInsets.only(top: 16, left: 16),
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
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                  padding: EdgeInsets.only(right: 24, top: 4),
                ),
                border: UnderlineInputBorder()),
          ),
        )
      ],
    );
  }

  _buildIconGrid() {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    return StreamBuilder<Object>(
        stream: posCatalogBloc.productIconsStream,
        builder: (context, snapshot) {
          List<ProductIcon> allIcons = snapshot.data ?? [];
          return Expanded(
            child: GridView.count(
              crossAxisCount: 5,
              children: allIcons
                  .where((icon) => icon.matches(
                      _imageFilterController.text.toLowerCase().trim()))
                  .map((icon) {
                return IconButton(
                  icon: SvgPicture.asset(icon.assetPath, color: Colors.white),
                  iconSize: 36,
                  onPressed: () {
                    setState(() {
                      _selectedImage = "icon:${icon.name}";
                      widget.onImageSelected(_selectedImage);
                    });
                  },
                );
              }).toList(),
            ),
          );
        });
  }
}
