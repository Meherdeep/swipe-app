import 'package:flutter/material.dart';

class CircularLoader extends StatefulWidget {
  final bool isLoading;

  const CircularLoader({Key key, this.isLoading}) : super(key: key);

  @override
  _CircularLoaderState createState() => _CircularLoaderState();
}

class _CircularLoaderState extends State<CircularLoader> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }
}
