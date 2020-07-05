import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchTileItem extends StatelessWidget {
  final String image;
  final String text;
  final Color color;
  Function onPressed;
  SearchTileItem({this.color,this.text,this.onPressed,this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 80.0,
                    child: CircleAvatar(
                      backgroundColor: color,
                      child: Image.asset(
                        "assets/icons/$image",
                        fit: BoxFit.fitWidth,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          text,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
//                          color: secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}

