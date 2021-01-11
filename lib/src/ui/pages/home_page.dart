import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/pages/pet-store_page.dart';
import 'package:agent_pet/src/widgets/cart-badged-icon.dart';
import 'package:agent_pet/src/widgets/drawer.dart';
import 'package:agent_pet/src/widgets/saved-badged-icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  final _selectedView = ValueNotifier(0);

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
        drawer: DrawerWidget(),
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          actions: [CartBadgedIcon(), SavedBadgeIcon()],
          title: Image.asset(Assets.logo, fit: BoxFit.cover, scale: 8),
        ),

        // body: ValueListenableBuilder(
        //   valueListenable: _selectedView,
        //   builder: (BuildContext context, value, Widget child) {
        //     return PetStorePage();
        //   },
        // ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Image.asset("assets/icons/footer-main.png"),
          elevation: 0,
          onPressed: () {
            // BottomNavigationBar
            // LocalData.isSignedIn ? CustomNavigator.navigateTo(context, AddPetPage()) : CustomNavigator.navigateTo(context, LoginPage());
          },
        ),

        bottomNavigationBar: _NavigationBar(
          notifier: _selectedView,
        ),
        // bottomNavigationBar: BottomAppBar(
        //     notchMargin: 6,
        //     clipBehavior: Clip.antiAlias,
        //     shape: CircularNotchedRectangle(),
        //     child: Row(children: [
        //       TextButton(
        //         child: Text('Home'),
        //       )
        //     ])
        //     // BottomNavigationBar(
        //     //   unselectedItemColor: Colors.grey,
        //     //   // currentIndex: _page,
        //     //   items: [
        //     //     BottomNavigationBarItem(
        //     //       label: 'Home',
        //     //       icon: Icon(Icons.home),
        //     //     ),
        //     //     BottomNavigationBarItem(
        //     //       label: 'Pet Store',
        //     //       icon: Icon(Icons.store),
        //     //     ),
        //     //     BottomNavigationBarItem(
        //     //       label: ' ',
        //     //       icon: Icon(Icons.add),
        //     //     ),
        //     //     BottomNavigationBarItem(
        //     //       label: 'Adopt a Pet',
        //     //       icon: Image.asset(
        //     //         "assets/icons/mate.png",
        //     //         scale: 3,
        //     //         // color: _page != 3 ? Colors.grey : Colors.primaries[0],
        //     //       ),
        //     //     ),
        //     //     BottomNavigationBarItem(
        //     //       label: 'Relocation',
        //     //       icon: Image.asset("assets/icons/plane.png", scale: 3
        //     //           // color: _page != 4 ? Colors.grey : Colors.primaries[0],
        //     //           ),
        //     //     ),
        //     //   ],
        //     //   type: BottomNavigationBarType.fixed,
        //     //   // onTap: (val) => _displayPage(val ),
        //     // ),
        //     ),
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

class _NavigationBar extends StatelessWidget {
  final ValueNotifier notifier;

  _NavigationBar({this.notifier});

  void selectView(int index) {
    if (index == notifier.value) return;
    notifier.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: BottomAppBar(
        notchMargin: 10,
        shape: CircularNotchedRectangle(),
        child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (context, val, child) => Row(children: [
            Expanded(
              child: _NavigationButton(
                label: 'Home',
                selected: val == 0,
                icon: CupertinoIcons.home,
                onPressed: () => selectView(0),
              ),
            ),
            Expanded(
              child: _NavigationButton(
                label: 'Pet Store',
                selected: val == 1,
                icon: Icons.storefront,
                onPressed: () => selectView(1),
              ),
            ),
            Spacer(),
            Expanded(
              child: _NavigationButton(
                label: 'Adopt a Pet',
                selected: val == 2,
                icon: CupertinoIcons.paw,
                onPressed: () => selectView(2),
              ),
            ),
            Expanded(
              child: _NavigationButton(
                label: 'Relocation',
                selected: val == 3,
                icon: CupertinoIcons.airplane,
                onPressed: () => selectView(3),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  _NavigationButton({
    this.icon,
    this.label,
    this.onPressed,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).primaryColor : Colors.grey;
    return TextButton(
      onPressed: selected ? null : onPressed,
      style: TextButton.styleFrom(
          primary: Theme.of(context).primaryColor.withOpacity(.5)),
      child: Column(children: [
        Icon(icon, color: color),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ]),
    );
  }
}
