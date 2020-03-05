import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/breez_dropdown.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateItemPage extends StatefulWidget {
  final PosCatalogBloc _posCatalogBloc;

  CreateItemPage(this._posCatalogBloc);

  @override
  State<StatefulWidget> createState() {
    return CreateItemPageState();
  }
}

class CreateItemPageState extends State<CreateItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Widget build(BuildContext context) {
    return _buildScaffold(
      ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: "Name", border: UnderlineInputBorder()),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        controller: _priceController,
                        decoration: InputDecoration(
                            hintText: "Price", border: UnderlineInputBorder()),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: BreezDropdownButton<String>(
                          value: "Sat",
                          iconEnabledColor: Colors.white,
                          style: theme.invoiceAmountStyle
                              .copyWith(color: Colors.white),
                          onChanged: (value) {},
                          items: [
                            DropdownMenuItem<String>(
                              value: "Sat",
                              child: Text(
                                "sats",
                                style: theme.invoiceAmountStyle
                                    .copyWith(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaffold(Widget body, [List<Widget> actions]) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          "Create Item",
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
      bottomNavigationBar: SingleButtonBottomBar(
        text: "Add Item",
        onPressed: () {
          {
            if (_formKey.currentState.validate()) {
              AddItem addItem = AddItem(Item(
                name: _nameController.text.trimRight(),
                currency: "Sat",
                price: double.parse(_priceController.text),
              ));
              widget._posCatalogBloc.actionsSink.add(addItem);
              addItem.future.then((_) {
                Navigator.pop(context);
              });
            }
          }
        },
      ),
    );
  }
}
