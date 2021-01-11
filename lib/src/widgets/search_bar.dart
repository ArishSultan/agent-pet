import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String placeholder;

  SearchBar({this.placeholder = 'Search here...'});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: SizedBox(
        height: 40,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CupertinoTextField(
            controller: _controller,
            placeholder: placeholder,
            textInputAction: TextInputAction.search,
            placeholderStyle: TextStyle(
                fontFamily: 'SourceSansPro', color: Colors.grey.shade400),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(CupertinoIcons.search,
                  size: 22, color: Colors.grey.shade500),
            ),
            cursorColor: Theme.of(context).primaryColor,
            clearButtonMode: OverlayVisibilityMode.editing,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}
