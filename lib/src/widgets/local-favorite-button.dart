//import 'package:agent_pet/src/models/pet.dart';
//import 'package:agent_pet/src/models/product.dart';
//import 'package:agent_pet/src/utils/local-data.dart';
//import 'package:flutter/material.dart';
//
//class LocalFavoriteButton extends StatefulWidget {
//  final Pet pet;
//  final Product product;
//  final bool bordered;
//  final bool isPetAd;
//
//  LocalFavoriteButton({this.pet,this.product,this.bordered=false,this.isPetAd=true});
//
//  @override
//  _LocalFavoriteButtonState createState() => _LocalFavoriteButtonState();
//}
//
//class _LocalFavoriteButtonState extends State<LocalFavoriteButton> {
//
//
//  @override
//  Widget build(BuildContext context) {
//
//    var canSave = widget.isPetAd ? LocalData.canSavePet(widget.pet.id) : LocalData.canSaveProduct(widget.product.id);
//
//    return !widget.bordered ? IconButton(
//      alignment: Alignment.topRight,
//      tooltip: 'Favorite',
//      color: canSave? Colors.white: Colors.primaries[0],
//
//      icon: Icon(canSave? Icons.favorite_border: Icons.favorite, size: 17,color: Colors.primaries[0],),
//      onPressed: (){
//        if (canSave) {
//          widget.isPetAd ? LocalData.savePet(widget.pet) : LocalData.saveProduct(widget.product);
//        } else {
//          widget.isPetAd ? LocalData.getSavedPets().remove(widget.pet) : LocalData.getSavedProducts().remove(widget.product);
//          LocalData.writeData();
//        }
//
//        LocalData.likeChanged();
//      }
//    ): RaisedButton(
//      child:Icon(canSave? Icons.favorite_border: Icons.favorite,color: Colors.primaries[0],),
//      color: Colors.white,
//      onPressed: (){
//      if (canSave) {
//        widget.isPetAd ? LocalData.savePet(widget.pet) : LocalData.saveProduct(widget.product);
//      } else {
//        widget.isPetAd ? LocalData.getSavedPets().remove(widget.pet) : LocalData.getSavedProducts().remove(widget.product);
//        LocalData.writeData();
//      }
//
//      LocalData.likeChanged();
//    },
//      shape: CircleBorder(),
//
//    );
//  }
//}
