import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/base/nav.dart';
import 'package:agent_pet/src/base/theme.dart';
import 'package:agent_pet/src/ui/views/localized_view.dart';
import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _CategoryCell extends StatelessWidget {
  final _PetCategory category;

  const _CategoryCell(this.category);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          minimumSize: Size(60, 60),
          primary: Theme.of(context).primaryColor,
        ),
        child: Column(children: [
          Expanded(
              child: Image.asset(
            category.image,
            color: Theme.of(context).primaryColor,
          )),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ]),
      ),
    );
  }
}

class _PetCategory {
  final String name;
  final String image;

  const _PetCategory({this.name, this.image});

  static const all = [
    _PetCategory(name: 'Dog', image: Assets.dog),
    _PetCategory(name: 'Cat', image: Assets.cat),
    _PetCategory(name: 'Bird', image: Assets.bird),
    _PetCategory(name: 'Fish', image: Assets.fish),
    _PetCategory(name: 'Cow', image: Assets.cow),
    _PetCategory(name: 'Lion', image: Assets.lion),
    _PetCategory(name: 'Rabbit', image: Assets.rabbit),
    _PetCategory(name: 'Parrot', image: Assets.parrot),
    _PetCategory(name: 'Monkey', image: Assets.monkey),
    _PetCategory(name: 'Lizard', image: Assets.lizard),
    _PetCategory(name: 'Hamsters', image: Assets.hamster),
    _PetCategory(name: 'Pony', image: Assets.pony),
    _PetCategory(name: 'Iguana', image: Assets.iguana),
    _PetCategory(name: 'Ferret', image: Assets.ferret),
    _PetCategory(name: 'Crocodile', image: Assets.crocodile),
    _PetCategory(name: 'Pig', image: Assets.pig),
    _PetCategory(name: 'Guinea Pig', image: Assets.pig),
    _PetCategory(name: 'Horse', image: Assets.pony),
    _PetCategory(name: 'Snake', image: Assets.snake),
    _PetCategory(name: 'Frog', image: Assets.frog),
    _PetCategory(name: 'Turtle', image: Assets.turtle),
    _PetCategory(name: 'Other Pets', image: Assets.pig),
  ];
}

class _PetsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var rows = 2;
        var pages = 0;
        final itemsInRow = (constraints.maxWidth - 25) ~/ 75;
        final space =
            ((constraints.maxWidth - 30) - (itemsInRow * 70)) / itemsInRow;

        if (itemsInRow < _PetCategory.all.length) {
          pages = (_PetCategory.all.length / (itemsInRow * 2)).ceil();
        } else {
          rows = 1;
        }

        return SizedBox(
          height: 150 + space + space,
          child: PageView(children: [
            for (var i = 0; i < pages; ++i)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(children: [
                  for (var j = 0; j < rows; ++j)
                    Expanded(
                      child: Row(
                          children: List.generate(itemsInRow, (index) {
                        print(j);
                        final _index =
                            index + (j * itemsInRow) + (i * itemsInRow * 2);
                        if (_index < _PetCategory.all.length) {
                          return Expanded(
                            child: Center(
                                child: _CategoryCell(_PetCategory.all[_index])),
                          );
                        } else {
                          return Spacer();
                        }
                      })),
                    )
                ]),
              )
          ]),
        );
      },
    );
  }
}

class _HomeViewAction extends StatelessWidget {
  final Color color;
  final Widget image;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  _HomeViewAction({
    this.color,
    this.image,
    this.title,
    this.subtitle,
    this.onPressed,
  });

  static const _horizontalPadding = EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: Colors.grey,
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(children: [
        Padding(
          padding: _horizontalPadding,
          child: CircleAvatar(radius: 25, child: image, backgroundColor: color),
        ),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 30),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
        Padding(
          padding: _horizontalPadding,
          child: Icon(CupertinoIcons.chevron_right, color: Colors.grey[400]),
        ),
      ]),
    );
    // return ListTile(
    //   onTap: () {
    //     print('here');
    //   },
    //   dense: true,
    //   // padding
    //   contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
    //   leading: CircleAvatar(
    //     radius: 25,
    //     backgroundColor: color,
    //     child: Image.asset(image, scale: 2.2, color: Colors.white),
    //   ),
    //
    //   title: Text(
    //     title,
    //     style: TextStyle(
    //       color: AppTheme.primaryColor,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   subtitle: Text(subtitle),
    //   // trailing: Icon(CupertinoIcons.chevron_right),
    // );
  }
}

class HomeView extends StatelessWidget {
  const HomeView();

  static const _divider = Divider(height: 0);

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => RefreshIndicator(
        color: Colors.black,
        onRefresh: () {
          return Future.delayed(Duration(seconds: 5));
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            SectionHeader(lang.selectCategory),
            _PetsTable(),
            SectionHeader(lang.ourServices),
            _HomeViewAction(
              image: Image.asset(
                Assets.petBuySell,
                color: Colors.white,
                scale: 1.7,
              ),
              title: lang.petBuySell,
              color: AppTheme.colors[0],
              subtitle: lang.petBuySellDetail,
              onPressed: () => AppNavigation.toPage(context, AppPage.allPets),
            ),
            _divider,
            _HomeViewAction(
              title: lang.petAdoption,
              color: AppTheme.colors[1],
              subtitle: lang.petAdoptionDetail,
              onPressed: () =>
                  AppNavigation.toPage(context, AppPage.petsForAdoption),
              image: Image.asset(Assets.mate, color: Colors.white, scale: 2),
            ),
            _divider,
            _HomeViewAction(
              title: lang.petStore,
              color: AppTheme.colors[2],
              subtitle: lang.petStoreDetail,
              image:
                  Image.asset(Assets.petStore, color: Colors.white, scale: 2),
              onPressed: () {
                //   CustomNavigator.baseNavigateTo(1, 0, 0);
              },
            ),
            _divider,
            _HomeViewAction(
              image: Image.asset(
                Assets.relocation,
                color: Colors.white,
                scale: 2.5,
              ),
              color: AppTheme.colors[3],
              title: lang.petRelocation,
              subtitle: lang.petRelocationDetail,
              onPressed: () {
                //   CustomNavigator.navigateTo(context, PetRelocationPage());
              },
            ),
            _divider,
            _HomeViewAction(
              image: Image.asset(
                Assets.veterinary,
                color: Colors.white,
                scale: 2.5,
              ),
              title: lang.petAndVet,
              color: AppTheme.colors[1],
              subtitle: lang.petAndVetDetail,
              onPressed: () {
                // CustomNavigator.navigateTo(context, PetAndVetPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
