import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/favorite-button.dart';
import 'package:agent_pet/src/utils/convert-yes-or-no.dart';
import 'package:agent_pet/src/widgets/icon-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'local-favorite-button.dart';

class PetListingWidget extends StatefulWidget {
  final Pet pet;
  PetListingWidget(
      {this.pet,
     });

  @override
  _PetListingWidgetState createState() => _PetListingWidgetState();
}

class _PetListingWidgetState extends State<PetListingWidget> {
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(width: 0.5, color: Colors.black12)),
        padding: EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ClipRect(child: SizedBox(
                width: 90,
                height: 90,
                child: Stack(children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: Image.network(widget.pet.images.isNotEmpty
                      ? Service.getConvertedImageUrl(widget.pet.images[0].src)
                      : 'https://www.agentpet.com/img/no-image2.png',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, widget, event) {
                          if (event != null) {
                            return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.black),
                                  value: event.cumulativeBytesLoaded / event.expectedTotalBytes
                              ),
                            );
                          } else if (widget != null) {
                            return widget;
                          } return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          );
                        }),
                  ),
                  widget.pet.featured?
                  Transform.translate(
                      offset: Offset(-55, -55),
                      child: Transform.rotate(
                        angle: 225.45,
                        child: Container(
                            width: 100,
                            height: 100,
                            color: Theme.of(context).primaryColor,
                            child: Align(
                              alignment: Alignment(0, .97),
                              child: Text("Featured", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold
                              ), textAlign: TextAlign.center),
                            )
                        ),
                      )
                  ): Container()
                ]),
              ))
//              Image.network(
//                  widget.pet.images.isNotEmpty
//                      ? Service.getConvertedImageUrl(widget.pet.images[0].src,widget.pet.id>5113)
//                      : 'https://www.agentpet.com/img/no-image2.png',
//                  width: 90,
//                  height: 90,
//                  fit: BoxFit.fill,
//                  loadingBuilder: (context, widget, event) {
//                    if (event != null) {
//                      return  Padding(
//                        padding: const EdgeInsets.all(27.0),
//                        child: CircularProgressIndicator(
//                              valueColor: AlwaysStoppedAnimation(Colors.black),
//                              value: event.cumulativeBytesLoaded / event.expectedTotalBytes
//                        ),
//                      );
//                    } else if (widget != null) {
//                      return widget;
//                    } return CircularProgressIndicator(
//                      valueColor: AlwaysStoppedAnimation(Colors.black),
//                    );
//                  }
//                ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.pet.name[0].toUpperCase() +
                                    widget.pet.name.substring(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16,),
                              ),
                            ),
                            SizedBox(height:5,),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${widget.pet.ownerCity}",
                                style: TextStyle(
                                    color: Colors.black45, fontWeight: FontWeight.bold,fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                   FavoriteButton(id: widget.pet.id,)
                    ],
                  ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        ImageText(
                          padding: EdgeInsets.all(2),
                          image: Image.asset(
                            "assets/icons/vaccination.png",
                            scale: 5,
                            color: Colors.grey.shade600,
                          ),
                          text: Text(convertBool(widget.pet.vaccinated)),
                        ),

                        ImageText(
                          padding: EdgeInsets.all(2),
                          image: Image.asset(
                            "assets/icons/pet-group.png",
                            scale: 5,
                            color: Colors.grey.shade600,
                          ),
                          text: Text(widget.pet.group),
                        ),

                        IconText(
                          padding: EdgeInsets.all(2),
                          icon: Icon(Icons.color_lens,size: 14,color: Colors.grey.shade600,),
                          text:  Text(widget.pet.color,style: TextStyle(color: Colors.grey.shade600,
                          ),),
                        ),

                        IconText(
                          padding: EdgeInsets.all(2),
                          icon: Icon(Icons.pets,size: 14,color: Colors.grey.shade600,),
                          text: Text(widget.pet.gender,),
                        ),
                        SizedBox(),

                      ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text("PKR ${widget.pet.price}",style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15,color: Colors.primaries[0]),),

                ],
              ),)
                ],
              ),
            ),
//            Expanded(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                         ],
//                       ),
//                      Expanded(child: Container(),),
//                     LocalData.isSignedIn ? FavoriteButton(id: widget.id,) : SizedBox(),
//                    ],
//                  ),
//
//
//                  SizedBox(
//                    height: 3,
//                  ),
//                  Row(
//                      children: <Widget>[
//                        Image.asset(
//                          "assets/icons/vaccination.png",
//                          scale: 5,
//                          color: Colors.grey.shade600,
//                        ),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        Text(convertBool(widget.vaccinated)),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        Image.asset(
//                          "assets/icons/pet-group.png",
//                          scale: 5,
//                          color: Colors.grey.shade600,
//                        ),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        Text(widget.group),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        Icon(
//                          Icons.color_lens,
//                          size: 14,
//                          color: Colors.grey.shade600,
//                        ),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        Text(widget.color),
//                      ],
//                  ),
//                  SizedBox(
//                    height: 7,
//                  ),
//                  Text("PKR ${widget.price}",style: TextStyle(
//                      fontWeight: FontWeight.bold, fontSize: 13,color: Colors.primaries[0]),),
//
//                ],
//              ),
//            ),

    );
  }
}
