import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final int id;
  final bool bordered;
  final bool isPetAd;

  FavoriteButton({this.id,this.bordered=false,this.isPetAd=true});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {



  @override
  Widget build(BuildContext context) {
    var canSave = widget.isPetAd ? LocalData.canSavePetId(widget.id) : LocalData.canSaveProductId(widget.id);



    return !widget.bordered ? IconButton(
      alignment: Alignment.topRight,
      tooltip: 'Favorite',
      color: canSave? Colors.white: Colors.primaries[0],

      icon: Icon(canSave? Icons.favorite_border: Icons.favorite, size: 17,color: Colors.primaries[0],),
      onPressed: () async {
        setState(() {
          if (canSave) {
            widget.isPetAd ? LocalData.savePetId(widget.id) : LocalData.saveProductId(widget.id) ;
          } else {
            widget.isPetAd ?  LocalData.getSavedPetsIds().remove(widget.id) : LocalData.getSavedProductsIds().remove(widget.id);
          }
          LocalData.likeChanged();
        });

        if(LocalData.isSignedIn){
          FormData _saveAd = widget.isPetAd ? FormData.fromMap({
            "user_id": LocalData.user.id,
            "pet_id": widget.id
          }) :
          FormData.fromMap({
            "user_id": LocalData.user.id,
            "product_id": widget.id
          });
          await Service.post(widget.isPetAd ?"save-ad" : "save-product", _saveAd);
        }

      }
    ): RaisedButton(
      child:Icon(canSave? Icons.favorite_border: Icons.favorite,color: Colors.primaries[0],),
      color: Colors.white,
      onPressed: () async {
        setState(() {
          if (canSave) {
            widget.isPetAd ? LocalData.savePetId(widget.id) : LocalData.saveProductId(widget.id) ;
          } else {
            widget.isPetAd ?  LocalData.getSavedPetsIds().remove(widget.id) : LocalData.getSavedProductsIds().remove(widget.id);
          }
          LocalData.likeChanged();
        });

        if(LocalData.isSignedIn){
          FormData _saveAd = widget.isPetAd ? FormData.fromMap({
            "user_id": LocalData.user.id,
            "pet_id": widget.id
          }) :
          FormData.fromMap({
            "user_id": LocalData.user.id,
            "product_id": widget.id
          });
          await Service.post(widget.isPetAd ?"save-ad" : "save-product", _saveAd);
        }
      },
      shape: CircleBorder(),

    );

  }

}
