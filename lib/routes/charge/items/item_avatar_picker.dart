import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/min_font_size.dart';
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
      child: _selectedImage == "" && widget.itemName == ""
          ? Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                      style: BorderStyle.solid),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColorLight,
                          BlendMode.srcATop),
                      image: AssetImage("src/images/avatarbg.png"),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.edit, size: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: AutoSizeText(
                      "Select Image",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                      style: TextStyle(
                          fontSize: 12.3,
                          color: Color.fromRGBO(255, 255, 255, 0.88),
                          letterSpacing: 0.0,
                          fontFamily: "IBMPlexSans"),
                    ),
                  ),
                ],
              ),
            )
          : ItemAvatar(_selectedImage,
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
