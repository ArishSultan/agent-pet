import 'package:agent_pet/src/pages/cart/main-cart.dart';
import 'package:agent_pet/src/pages/profile/saved_ads-page.dart';
import 'package:agent_pet/src/widgets/badge.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/material.dart';

import 'badge.dart';
import 'cart-badged-icon.dart';
import 'saved-badged-icon.dart';


class AgentPetAppbar extends AppBar {
  AgentPetAppbar(BuildContext context, [String title,bool showCart=true]): super(
    title: title == null ? Image.asset("assets/agent-pet-logo.png", fit: BoxFit.cover,scale: 8,) : Text(title),
    centerTitle: true,
    actions: [
      showCart ?
      CartBadgedIcon():
      SizedBox(),
      title!='Saved Pets' ||  title!= 'Saved Products' ?
      SavedBadgeIcon() : SizedBox(),
    ],
  );
}
