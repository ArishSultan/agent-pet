import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final Icon icon;
  final Widget text;
  final EdgeInsets padding;

  IconText({
    this.icon,
    this.text,
    this.padding
  }): assert(icon != null),
      assert(text != null),
      assert(padding != null);

  @override build(context) {
    return Row(children: <Widget>[
      Padding(
        child: this.icon,
        padding: this.padding,
      ),
      this.text,
    ], mainAxisAlignment: MainAxisAlignment.start);
  }
}



class ImageText extends StatelessWidget {
  final Widget image;
  final Widget text;
  final EdgeInsets padding;

  ImageText({
    this.image,
    this.text,
    this.padding
  }): assert(image != null),
        assert(text != null),
        assert(padding != null);

  @override build(context) {
    return Row(children: <Widget>[
      Padding(
        child: this.image,
        padding: this.padding,
      ),
      this.text,
    ], mainAxisAlignment: MainAxisAlignment.start);
  }
}