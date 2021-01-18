import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/base/nav.dart';
import 'package:agent_pet/src/base/services.dart';
import 'package:agent_pet/src/base/theme.dart';
import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/pages/pet-detail_page.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/convert-yes-or-no.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
// import 'package:';

class PetDetailTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class PetDetailBox extends StatelessWidget {
  final Pet pet;

  PetDetailBox(this.pet);

  String get image {
    if (pet.images.isNotEmpty) {
      return AppServices.makeImageUrl(pet.images.first.src);
    } else {
      return 'https://www.agentpet.com/img/no-image2.png';
    }
  }

  String get name => pet.name;

  @override
  Widget build(BuildContext context) {
    final box = InkWell(
      onTap: () => AppNavigation.to(context, PetDetailPage(pet: pet)),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
        ),
        child: Column(children: [
          Image(
            image: NetworkImageWithRetry(image),
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3),
            child: SizedBox(
              width: 97,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'PKR ${pet.price}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    pet.ownerCity,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(children: <Widget>[
                    Image.asset(
                      Assets.vaccination,
                      scale: 5,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 2),
                    Text(pet.vaccinated ? 'Yes' : 'No'),
                    Spacer(),
                    Image.asset(
                      Assets.petGroup,
                      scale: 5,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 2),
                    Text(pet.group),
                  ]),
                ],
              ),
            ),
          )
        ]),
      ),
    );

    if (pet.featured) {
      return CustomPaint(
        foregroundPainter: FeaturedFlagPainter(),
        child: box,
      );
    } else {
      return box;
    }
  }
}

class FeaturedFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(4, 4)
        ..lineTo(size.width / 2, 4)
        ..lineTo(4, size.width / 2)
        ..close(),
      Paint()..color = AppTheme.primaryColor,
    );

    canvas.rotate(5.5);
    TextPainter(
        text: TextSpan(
          text: 'Featured',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(
        canvas,
        Offset(-22.5, 33),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NewPetsWidget extends StatefulWidget {
  final Pet pet;

  NewPetsWidget({this.pet});

  @override
  _NewPetsWidgetState createState() => _NewPetsWidgetState();
}

class _NewPetsWidgetState extends State<NewPetsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                width: 110,
                height: 110,
                child: ClipRect(
                    child: Stack(children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: Image.network(
                        widget.pet.images.isNotEmpty
                            ? Service.getConvertedImageUrl(
                                widget.pet.images[0].src)
                            : 'https://www.agentpet.com/img/no-image2.png',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, widget, event) {
                      if (event != null) {
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                              value: event.cumulativeBytesLoaded /
                                  event.expectedTotalBytes),
                        );
                      } else if (widget != null) {
                        return widget;
                      }
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      );
                    }),
                  ),
                  widget.pet.featured
                      ? Transform.translate(
                          offset: Offset(-55, -55),
                          child: Transform.rotate(
                            angle: 225.45,
                            child: Container(
                                width: 100,
                                height: 100,
                                color: Theme.of(context).primaryColor,
                                child: Align(
                                  alignment: Alignment(0, .97),
                                  child: Text("Featured",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                )),
                          ))
                      : Container()
                ]))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3),
              child: SizedBox(
                width: 97,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.pet.name[0].toUpperCase() +
                          widget.pet.name.substring(1),
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "PKR ${widget.pet.price}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.primaries[0]),
                    ),
                    Text(
                      "${widget.pet.ownerCity}",
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(children: <Widget>[
                      Image.asset(
                        "assets/icons/vaccination.png",
                        scale: 5,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(convertBool(widget.pet.vaccinated)),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "assets/icons/pet-group.png",
                        scale: 5,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(widget.pet.group),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
