import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/widgets/drawer.dart';
import 'package:agent_pet/src/widgets/search_bar.dart';
import 'package:agent_pet/src/ui/views/home_view.dart';
import 'package:agent_pet/src/ui/views/localized_view.dart';
import 'package:agent_pet/src/widgets/cart-badged-icon.dart';
import 'package:agent_pet/src/widgets/saved-badged-icon.dart';

class HomePage extends StatelessWidget {
  final _selectedView = ValueNotifier(0);
  static final _views = [
    HomeView()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedView.value > 0) {
          _selectedView.value = 0;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        drawer: DrawerWidget(),
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          actions: [CartButtonBadged(), FavoriteButtonBadged()],
          title: Image.asset(Assets.logo, fit: BoxFit.cover, scale: 8),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Hero(tag: 'main_search_bar', child: SearchBar()),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: _selectedView,
          builder: (BuildContext context, value, Widget child) {
            return _views[0];
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 1,
              padding: EdgeInsets.zero,
              side: BorderSide(color: Colors.white, width: 2),
              primary: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Column(children: [
              Spacer(flex: 2),
              Icon(CupertinoIcons.paw),
              Text('Add Pet', style: TextStyle(fontSize: 11, letterSpacing: 0)),
              Spacer(flex: 3),
            ]),
            onPressed: () {
              // LocalData.isSignedIn ? CustomNavigator.navigateTo(context, AddPetPage()) : CustomNavigator.navigateTo(context, LoginPage());
            },
          ),
        ),
        bottomNavigationBar: _NavigationBar(notifier: _selectedView),
      ),
    );
  }
}

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
      child: LocalizedView(
        builder: (context, lang) => BottomAppBar(
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,
          shape: CircularNotchedRectangle(),
          child: ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, val, child) => Row(children: [
              Expanded(
                child: _NavigationButton(
                  label: lang.home,
                  selected: val == 0,
                  icon: CupertinoIcons.home,
                  onPressed: () => selectView(0),
                ),
              ),
              Expanded(
                child: _NavigationButton(
                  label: lang.petStore,
                  selected: val == 1,
                  icon: Icons.storefront,
                  onPressed: () => selectView(1),
                ),
              ),
              Spacer(),
              Expanded(
                child: _NavigationButton(
                  label: lang.adoptPet,
                  selected: val == 2,
                  icon: CupertinoIcons.paw,
                  onPressed: () => selectView(2),
                ),
              ),
              Expanded(
                child: _NavigationButton(
                  label: lang.relocation,
                  selected: val == 3,
                  icon: CupertinoIcons.airplane,
                  onPressed: () => selectView(3),
                ),
              ),
            ]),
          ),
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
