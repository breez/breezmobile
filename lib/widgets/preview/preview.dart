import 'package:breez/theme_data.dart';
import 'package:breez/widgets/preview/fill_view_port_column_scroll_view.dart';
import 'package:flutter/material.dart';

class Preview extends StatefulWidget {
  final List<Widget> children;

  const Preview(
    this.children, {
    Key key,
  }) : super(key: key);

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = constraints.maxWidth ~/ 8;
                  final rows = constraints.maxHeight ~/ 8;
                  return GridView.builder(
                    itemCount: cols * rows + cols,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                    ),
                    itemBuilder: (context, index) {
                      final oddRow = (index ~/ cols).isOdd;
                      final oddCol = (index % cols).isOdd;
                      return Container(
                        color: oddRow == oddCol ? Colors.grey.withAlpha(128) : Colors.blueGrey.withAlpha(128),
                      );
                    },
                  );
                },
              ),
              Container(
                height: 48.0,
                color: theme?.canvasColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Theme:"),
                    TextButton(
                      onPressed: () => _changeTheme(null),
                      child: const Text("None"),
                    ),
                    TextButton(
                      onPressed: () => _changeTheme(blueTheme),
                      child: const Text("Light"),
                    ),
                    TextButton(
                      onPressed: () => _changeTheme(darkTheme),
                      child: const Text("Dark"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: FillViewPortColumnScrollView(
                  children: widget.children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeTheme(ThemeData theme) {
    setState(() {
      this.theme = theme;
    });
  }
}
