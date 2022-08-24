import 'package:flutter/material.dart';

class PaymentAddressFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String tooltip;
  final Color iconColor;
  final TextStyle textStyle;
  final FormFieldValidator<String> validator;
  final Function() onPressed;
  final FocusNode focusNode;
  final bool readOnly;
  final Function(String) onChanged;
  final AutovalidateMode autovalidateMode;

  const PaymentAddressFormField({
    Key key,
    this.controller,
    this.label,
    this.tooltip,
    this.iconColor,
    this.textStyle,
    this.validator,
    this.onPressed,
    this.focusNode,
    this.readOnly = false,
    this.onChanged,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          padding: EdgeInsets.only(top: 21.0),
          alignment: Alignment.bottomRight,
          icon: Image(
            image: AssetImage("src/icon/qr_scan.png"),
            color: iconColor,
            fit: BoxFit.contain,
            width: 24.0,
            height: 24.0,
          ),
          tooltip: tooltip,
          onPressed: onPressed,
        ),
      ),
      style: textStyle,
      validator: validator,
      focusNode: focusNode,
      readOnly: readOnly,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
    );
  }
}
