import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/base/nav.dart';
import 'package:agent_pet/src/base/theme.dart';
import 'package:agent_pet/src/pages/add-or-edit-pet/main-add-or-edit-pet.dart';
import 'package:agent_pet/src/pages/how-it-works_page.dart';
import 'package:agent_pet/src/pages/pet-relocation/main-pet-relocation.dart';
import 'package:agent_pet/src/pages/products-listing/product-listing_page.dart';
import 'package:agent_pet/src/pages/profile/edit-profile_page.dart';
import 'package:agent_pet/src/pages/profile/my-ads_page.dart';
import 'package:agent_pet/src/pages/profile/my-alerts_page.dart';
import 'package:agent_pet/src/pages/profile/my-orders_page.dart';
import 'package:agent_pet/src/services/auth_service.dart';
import 'file:///D:/Workspace/Tools/Flutter/agent_pet/lib/src/ui/pages/contact-us_page.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/pages/pets-and-vets_page.dart';
import 'package:agent_pet/src/pages/auth/login_page.dart';
import 'package:agent_pet/src/pages/profile/messages_page.dart';
import 'package:agent_pet/src/pages/profile/saved_ads-page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatefulWidget {
  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Image.asset(Assets.logo, fit: BoxFit.cover, scale: 8),
          ),
          SizedBox(height: 20),
          if (LocalData.isSignedIn)
            DrawerExpansionTile(
              icon: Icon(
                CupertinoIcons.person_circle,
                color: Colors.grey.shade700,
              ),
              title: LocalData.user.name.toUpperCase(),
              children: [
                MiniDrawerTile(
                  title: 'My Profile',
                  icon: Icon(CupertinoIcons.person, color: Colors.grey.shade800),
                  onPressed: () async {
                    await CustomNavigator.navigateTo(context, EditProfile());
                    LocalData.reloadProfile();
                  },
                ),
                MiniDrawerTile(
                  title: 'My Ads',
                  icon: Image.asset(Assets.petStore, color: Colors.grey.shade800),
                  onPressed: () async {
                    CustomNavigator.navigateTo(context, MyAds());
                  },
                ),
                MiniDrawerTile(
                  title: 'Orders',
                  icon: Icon(CupertinoIcons.square_list, color: Colors.grey.shade800),
                  onPressed: () async {
                    CustomNavigator.navigateTo(context, MyOrders());
                  },
                ),
                MiniDrawerTile(
                  title: 'Messages',
                  icon: Icon(CupertinoIcons.chat_bubble_2, color: Colors.grey.shade800),
                  onPressed: () async {
                    CustomNavigator.navigateTo(context, MessagesPage());
                  },
                ),
                MiniDrawerTile(
                  title: 'Alert',
                  icon: Icon(CupertinoIcons.bell, color: Colors.grey.shade800),
                  onPressed: () async {
                    CustomNavigator.navigateTo(context, MyAlerts());
                  },
                ),
                MiniDrawerTile(
                  title: 'Logout',
                  icon: Icon(Icons.exit_to_app, color: Colors.grey.shade800),
                  onPressed: () => AuthService().logOut(),
                ),
              ],
            )
          else
            DrawerTile(
              bold: true,
              icon: Icon(
                CupertinoIcons.person_circle,
                color: Colors.grey.shade700,
              ),
              title: 'SIGN IN / SIGN UP',
              onPressed: () async {
                await CustomNavigator.navigateTo(context, LoginPage());
                setState(() {});
              },
            ),
          DrawerTile(
            title: 'Post Pet Ad',
            icon: Image.asset(Assets.addPet, width: 32),
            onPressed: () {
              CustomNavigator.navigateTo(
                  context, LocalData.isSignedIn ? AddPetPage() : LoginPage());
            },
          ),
          DrawerExpansionTile(
            title: 'Pet Store',
            icon: Icon(Icons.storefront, color: Colors.grey.shade700),
            children: [
              MiniDrawerTile(
                title: 'Dog',
                icon: Image.asset(Assets.dog),
                onPressed: () {
                  CustomNavigator.navigateTo(
                    context,
                    ProductListing(listing: 10, petTypeId: 2, petName: 'Dog'),
                  );
                },
              ),
              MiniDrawerTile(
                title: 'Cat',
                icon: Image.asset(Assets.cat),
                onPressed: () {
                  CustomNavigator.navigateTo(
                    context,
                    ProductListing(listing: 10, petTypeId: 1, petName: 'Cat'),
                  );
                },
              ),
              MiniDrawerTile(
                title: 'Bird',
                icon: Image.asset(Assets.bird),
                onPressed: () {
                  CustomNavigator.navigateTo(
                    context,
                    ProductListing(listing: 10, petTypeId: 6, petName: 'Bird'),
                  );
                },
              ),
              MiniDrawerTile(
                title: 'Fish',
                icon: Image.asset(Assets.fish),
                onPressed: () {
                  CustomNavigator.navigateTo(
                    context,
                    ProductListing(listing: 10, petTypeId: 3, petName: 'Fish'),
                  );
                },
              ),
            ],
          ),
          DrawerTile(
            title: 'Buy / Sell Pet',
            icon: Image.asset(
              Assets.buySell,
              width: 25,
              color: Colors.grey.shade700,
            ),
            onPressed: () {
              CustomNavigator.navigateTo(context, PetListing(listing: 0));
            },
          ),
          DrawerTile(
            icon: Image.asset(Assets.mate, color: Colors.grey.shade700),
            title: 'Adopt a Pet',
            onPressed: () {
              CustomNavigator.navigateTo(
                  context,
                  PetListing(
                    listing: 1,
                  ));
            },
          ),
          DrawerTile(
            icon: Icon(CupertinoIcons.airplane, color: Colors.grey.shade700),
            title: 'Pet Relocation',
            onPressed: () {
              CustomNavigator.navigateTo(context, PetRelocationPage());
            },
          ),
          DrawerTile(
            icon: Image.asset(Assets.veterinary,
                width: 25, color: Colors.grey.shade700),
            title: 'Pets & Vets',
            onPressed: () {
              CustomNavigator.navigateTo(context, PetAndVetPage());
            },
          ),
          DrawerTile(
            icon: Icon(CupertinoIcons.heart, color: Colors.grey.shade700),
            title: 'My Favorites',
            onPressed: () {
              CustomNavigator.navigateTo(context, SavedAds());
            },
          ),
          DrawerTile(
            icon: Icon(CupertinoIcons.info_circle, color: Colors.grey.shade700),
            title: 'How it works',
            onPressed: () {
              CustomNavigator.navigateTo(context, HowItWorks());
            },
          ),
          DrawerTile(
            icon: Icon(CupertinoIcons.mail, color: Colors.grey.shade700),
            title: 'Contact Us',
            onPressed: () => AppNavigation.toPage(context, AppPage.contactUs),
          ),
        ]),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final bool bold;
  final bool isLast;
  final Color color;
  final Widget icon;
  final String title;
  final Function onPressed;
  final List<Widget> trailings;

  DrawerTile({
    this.title,
    this.icon,
    this.color,
    this.onPressed,
    this.trailings,
    this.isLast = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = Padding(
      padding: const EdgeInsets.only(right: 25),
      child: SizedBox(
        height: 45,
        child: TextButton(
          child: Row(children: [
            SizedBox(width: 30, height: 30, child: Center(child: icon)),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade900,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            ...?trailings,
          ]),
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: color,
            primary: AppTheme.primaryColor,
            padding: const EdgeInsets.only(left: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
            ),
          ),
        ),
      ),
    );

    if (isLast) {
      return button;
    } else {
      return DecoratedBox(
        child: button,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      );
    }
  }
}

class MiniDrawerTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onPressed;

  MiniDrawerTile({this.title, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: SizedBox(
        height: 35,
        child: TextButton(
          child: Row(children: [
            SizedBox(width: 23, height: 23, child: icon),
            SizedBox(width: 15),
            Text(title, style: TextStyle(color: Colors.grey.shade900)),
          ]),
          onPressed: onPressed,
          style: TextButton.styleFrom(
            primary: AppTheme.primaryColor,
            padding: const EdgeInsets.only(left: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerExpansionTile extends StatefulWidget {
  final Widget icon;
  final String title;
  final List<Widget> children;

  DrawerExpansionTile({
    this.title,
    this.icon,
    this.children = const [],
  });

  @override
  _DrawerExpansionTileState createState() => _DrawerExpansionTileState();
}

class _DrawerExpansionTileState extends State<DrawerExpansionTile> {
  var active = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Wrap(children: [
        DrawerTile(
          isLast: true,
          icon: widget.icon,
          title: widget.title,
          trailings: [
            Spacer(),
            Icon(
              CupertinoIcons.chevron_forward,
              size: 20,
              color: Colors.grey.shade600,
            ),
            SizedBox(width: 5)
          ],
          color: active ? AppTheme.primaryColor.withOpacity(.15) : null,
          onPressed: () => setState(() => active = !active),
        ),
        if (active && widget.children.isNotEmpty) ...widget.children
      ]),
    );
  }
}
