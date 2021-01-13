import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/convert-yes-or-no.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:';

class PetBox extends StatelessWidget {
  final Pet pet;
  PetBox(this.pet);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
        ),

        child: Column(children: [
          // Image(image: NetworkImage,),
        ]),
      ),
    );
  }
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
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 110,
              height: 110,
              child: ClipRect(child: Stack(children: <Widget>[
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
                                fontSize: 11,
                                fontWeight: FontWeight.bold
                            ), textAlign: TextAlign.center),
                          )
                      ),
                    )
                ): Container()
              ]))
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 3),
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
                        fontWeight: FontWeight.bold, fontSize: 16,),
                    ),
                    Text("PKR ${widget.pet.price}",style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13,color: Colors.primaries[0]),),
                    Text(
                      "${widget.pet.ownerCity}",
                      style: TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold,fontSize: 13),
                    ),


                    SizedBox(
                      height: 3,
                    ),
                     Row(
                        children: <Widget>[
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
                    ]
                    ),


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
