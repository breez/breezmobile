import 'package:breez/widgets/particles_animations.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SuccessfulPaymentRoute extends StatefulWidget {
  final Function() onPrint;

  const SuccessfulPaymentRoute({
    this.onPrint,
  });

  @override
  State<StatefulWidget> createState() {
    return SuccessfulPaymentRouteState();
  }
}

class SuccessfulPaymentRouteState extends State<SuccessfulPaymentRoute>
    with WidgetsBindingObserver {
  Future _showFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_showFuture == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _showFuture = showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: true,
          builder: (context) => _buildDialog(context),
        ).whenComplete(() => Navigator.of(context).pop());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Particles(
            50,
            color: Colors.blue.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _buildDialog(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).pop(),
      child: AlertDialog(
        title: widget.onPrint != null
            ? Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: texts.successful_payment_print,
                  iconSize: 24.0,
                  color: themeData.appBarTheme.actionsIconTheme.color,
                  icon: SvgPicture.asset(
                    "src/icon/printer.svg",
                    colorFilter: ColorFilter.mode(
                      themeData.appBarTheme.actionsIconTheme.color,
                      BlendMode.srcATop,
                    ),
                    fit: BoxFit.contain,
                    width: 24.0,
                    height: 24.0,
                  ),
                  onPressed: widget.onPrint,
                ),
              )
            : const SizedBox(
                height: 40,
              ),
        titlePadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 40),
        content: _buildSuccessfulPaymentMessage(context),
      ),
    );
  }

  _buildSuccessfulPaymentMessage(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          texts.successful_payment_received,
          textAlign: TextAlign.center,
          style: themeData.primaryTextTheme.headlineMedium.copyWith(
            fontSize: 16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image(
              image: const AssetImage("src/icon/ic_done.png"),
              height: 48.0,
              color: themeData.primaryColorLight,
            ),
          ),
        ),
      ],
    );
  }
}
