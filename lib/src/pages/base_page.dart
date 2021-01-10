import 'package:agent_pet/src/widgets/cart-badged-icon.dart';
import 'package:agent_pet/src/widgets/drawer.dart';
import 'package:agent_pet/src/widgets/saved-badged-icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
//         print(_page);
//         if(_page!=0){
//           _displayPage(0);
//           return false;
//         }
// //        _displayPage(3);
//         return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.primaries[0],
          title: Image.asset(
            "assets/agent-pet-logo.png",
            fit: BoxFit.cover,
            scale: 8,
          ),
          centerTitle: true,
          actions: [
            CartBadgedIcon(),
            SavedBadgeIcon(),
          ],
        ),
        drawer: DrawerWidget(),

        // body: _widget,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Image.asset("assets/icons/footer-main.png"),
          elevation: 0,
          onPressed: () {
            // LocalData.isSignedIn ? CustomNavigator.navigateTo(context, AddPetPage()) : CustomNavigator.navigateTo(context, LoginPage());
          },
        ),

        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 6,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            // currentIndex: _page,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'Pet Store',
                icon: Icon(Icons.store),
              ),
              BottomNavigationBarItem(
                label: ' ',
                icon: Icon(Icons.add),
              ),
              BottomNavigationBarItem(
                label: 'Adopt a Pet',
                icon: Image.asset(
                  "assets/icons/mate.png",
                  scale: 3,
                  // color: _page != 3 ? Colors.grey : Colors.primaries[0],
                ),
              ),
              BottomNavigationBarItem(
                label: 'Relocation',
                icon: Image.asset(
                  "assets/icons/plane.png",
                  scale: 3
                  // color: _page != 4 ? Colors.grey : Colors.primaries[0],
                ),
              ),
            ],
            type: BottomNavigationBarType.fixed,
            // onTap: (val) => _displayPage(val ),
          ),
        ),
      ),
    );
  }
}

// import 'package:agent_pet/src/pages/auth/login_page.dart';
// import 'package:agent_pet/src/pages/profile/saved_ads-page.dart';
// import 'package:agent_pet/src/pages/relocation_page.dart';
// import 'package:agent_pet/src/services/user-service.dart';
// import 'package:agent_pet/src/utils/local-data.dart';
// import 'package:agent_pet/src/widgets/badge.dart';
// import 'package:agent_pet/src/widgets/cart-badged-icon.dart';
// import 'package:agent_pet/src/widgets/drawer.dart';
// import 'package:agent_pet/src/widgets/saved-badged-icon.dart';
// import 'package:flutter/material.dart';
// import 'package:agent_pet/src/utils/custom-navigator.dart';
// import 'add-or-edit-pet/main-add-or-edit-pet.dart';
// import 'adopt-a-pet_page.dart';
// import 'cart/main-cart.dart';
// import 'home_page.dart';
// import 'pet-store_page.dart';
//
// class BasePage extends StatefulWidget {
//   @override
//   _BasePageState createState() => _BasePageState();
// }
//
// class _BasePageState extends State<BasePage> {
//   var _page = 0;
//   Widget _widget;
//
//   @override
//   void initState() {
//     super.initState();
// //    LocalData.loadData();
//     _widget = HomePage();
//     LocalData.reloadProfile();
//     LocalData.reloadSavedAdsIds();
//     CustomNavigator.registerBaseRouter(_displayPage);
//   }
//
//   @override
//   Widget build(BuildContext context) {

//   }
//
//   _displayPage(val) {
//     Widget page;
//
//     switch (val) {
//       case 0:
//         page = HomePage();
//         break;
//       case 1:
//         page = PetStorePage();
//         break;
//       case 3:
//         page = AdoptAPet();
//         break;
//       case 4:
//         page = Relocation();
//         break;
//
//     }
//
//     if (page != null) {
//       setState(() {
//         _page = val;
//         _widget = page;
//       });
//     }
//   }
// }
