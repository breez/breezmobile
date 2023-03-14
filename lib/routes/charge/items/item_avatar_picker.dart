import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/min_font_size.dart';
import 'item_avatar.dart';

class ItemAvatarPicker extends StatefulWidget {
  final String itemImage;
  final Function(String selectedImage) onImageSelected;
  final String itemName;

  const ItemAvatarPicker(
    this.itemImage,
    this.onImageSelected, {
    this.itemName,
  });

  @override
  State<StatefulWidget> createState() {
    return ItemAvatarPickerState();
  }
}

class ItemAvatarPickerState extends State<ItemAvatarPicker> {
  final TextEditingController _imageFilterController = TextEditingController();
  String _selectedImage;
  final List<ProductIcon> _iconList = [];

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.itemImage ?? "";
    _imageFilterController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.pos_invoice_item_management_avatar_title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 0.0, right: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildItemAvatar(context),
            const SizedBox(height: 16),
            _buildSearchBar(context),
            const SizedBox(height: 8),
            _buildIconGrid(context),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildItemAvatar(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return badges.Badge(
      showBadge: _selectedImage != "",
      position: badges.BadgePosition.topEnd(top: 5, end: -10),
      badgeAnimation: const badges.BadgeAnimation.fade(),
      badgeStyle: badges.BadgeStyle(
        badgeColor: themeData.primaryTextTheme.titleSmall.color,
      ),
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
                  style: BorderStyle.solid,
                ),
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    themeData.primaryColorLight,
                    BlendMode.srcATop,
                  ),
                  image: const AssetImage("src/images/avatarbg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.edit, size: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: AutoSizeText(
                      texts.pos_invoice_item_management_avatar_title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                      style: const TextStyle(
                        fontSize: 12.3,
                        color: Color.fromRGBO(255, 255, 255, 0.88),
                        letterSpacing: 0.0,
                        fontFamily: "IBMPlexSans",
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ItemAvatar(
              _selectedImage,
              itemName: widget.itemName,
              radius: 48,
              useDecoration: true,
            ),
    );
  }

  Widget _buildResetIconBadge(BuildContext context) {
    final themeData = Theme.of(context);

    return GestureDetector(
      child: SizedBox(
        height: 24,
        width: 24,
        child: Icon(
          Icons.delete_outline,
          size: themeData.iconTheme.deleteBadgeIconTheme.size,
          color: themeData.iconTheme.deleteBadgeIconTheme.color,
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

  Widget _buildSearchBar(BuildContext context) {
    final texts = context.texts();

    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            textCapitalization: TextCapitalization.none,
            controller: _imageFilterController,
            enabled: _iconList != null,
            decoration: InputDecoration(
              hintText: texts.pos_invoice_item_management_avatar_search,
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
                padding: const EdgeInsets.only(right: 24, top: 4),
              ),
              border: const UnderlineInputBorder(),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildIconGrid(BuildContext context) {
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);

    return StreamBuilder<List<ProductIcon>>(
      stream: posCatalogBloc.productIconsStream,
      builder: (context, snapshot) {
        final allIcons = (snapshot.data ?? [])
            .where((icon) => icon.matches(
                  _imageFilterController.text.toLowerCase().trim(),
                ))
            .map((icon) => _icon(icon))
            .toList();

        return Expanded(
          child: GridView.count(
            crossAxisCount: 5,
            children: allIcons,
          ),
        );
      },
    );
  }

  Widget _icon(ProductIcon icon) {
    return IconButton(
      icon: SvgPicture.asset(
        icon.assetPath,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcATop,
        ),
      ),
      iconSize: 36,
      onPressed: () => setState(() {
        _selectedImage = "icon:${icon.name}";
        widget.onImageSelected(_selectedImage);
      }),
    );
  }
}
