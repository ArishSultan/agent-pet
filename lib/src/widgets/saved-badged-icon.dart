import 'package:agent_pet/src/pages/profile/saved_ads-page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/material.dart';
import 'badge.dart';

class SavedBadgeIcon extends StatefulWidget {
  final bool pets;
  SavedBadgeIcon({this.pets=true});

  @override
  SavedBadgeIconState createState() => SavedBadgeIconState();
}

class SavedBadgeIconState extends State<SavedBadgeIcon> {
  @override
  void initState() {
    super.initState();

    LocalData.registerLikeListener(() {
      setState(() {});
    });
  }

  @override
  build(BuildContext context) {

    return  IconButton(
      icon: Badge.numbered(number: widget.pets ?  LocalData.getSavedPetsIds().length : LocalData.getSavedProductsIds().length ,child: Icon(Icons.favorite,color: Colors.white,)),
      onPressed: () => CustomNavigator.navigateTo(context,  SavedAds() ),
    );
  }

  @override
  void dispose() {
    LocalData.unRegisterLikeListener();

    super.dispose();
  }
}
