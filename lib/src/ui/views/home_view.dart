import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/widgets/carousel.dart';
import 'package:agent_pet/src/widgets/new-pets-widget.dart';
import 'package:agent_pet/src/widgets/view_all_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:agent_pet/src/base/nav.dart';
import 'package:agent_pet/src/base/theme.dart';
import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/base/services.dart';
import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:agent_pet/src/ui/views/localized_view.dart';
import 'package:agent_pet/src/widgets/refreshable_widget.dart';

class _PetCategoryBlock extends SizedBox {
  static const blockSize = 70.0;
  static const buttonSize = blockSize - 10;

  _PetCategoryBlock(_PetCategory cat)
      : super(
          width: blockSize,
          height: blockSize,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              primary: AppTheme.primaryColor,
              minimumSize: Size(buttonSize, buttonSize),
            ),
            child: Column(children: [
              Expanded(
                  child: Image.asset(
                cat.image,
                color: AppTheme.primaryColor,
              )),
              Text(
                cat.name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.primaryColor,
                ),
              ),
            ]),
          ),
        );
}

class _PetCategory {
  final String name, image;

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

class _PetsCategoriesGrid extends StatefulWidget {
  @override
  __PetsCategoriesGridState createState() => __PetsCategoriesGridState();
}

class __PetsCategoriesGridState extends State<_PetsCategoriesGrid>
    with AutomaticKeepAliveClientMixin {
  final _page = ValueNotifier(0);

  final _type = ValueNotifier(0);

  final _selectedStyle = TextButton.styleFrom(
    primary: Colors.white,
    shape: StadiumBorder(),
    backgroundColor: Colors.black,
    visualDensity: VisualDensity.compact,
  );

  final _unselectedStyle = TextButton.styleFrom(
    primary: Colors.black,
    shape: StadiumBorder(),
    visualDensity: VisualDensity.compact,
    // side: BorderSide(color: Colors.black),
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        var rows = 2, pages = 0;
        final itemsInRow =
            (constraints.maxWidth - 25) ~/ (_PetCategoryBlock.blockSize + 5);
        final space = ((constraints.maxWidth - 30) -
                (itemsInRow * _PetCategoryBlock.blockSize)) /
            itemsInRow;

        if (itemsInRow < _PetCategory.all.length) {
          pages = (_PetCategory.all.length / (itemsInRow * 2)).ceil();
        } else {
          rows = 1;
        }

        return Wrap(children: [
          ValueListenableBuilder(
            valueListenable: _type,
            builder: (context, val, child) => Row(
              children: [
                TextButton(
                  child: Text('Pets'),
                  onPressed: () => _type.value = 0,
                  style: val == 0 ? _selectedStyle : _unselectedStyle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    child: Text('Foods'),
                    onPressed: () => _type.value = 1,
                    style: val == 1 ? _selectedStyle : _unselectedStyle,
                  ),
                ),
                TextButton(
                  onPressed: () => _type.value = 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Accessories'),
                  ),
                  style: val == 2 ? _selectedStyle : _unselectedStyle,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          SizedBox(
            height: rows == 2 ? 150 + space + space : 90,
            child: PageView(
              children: [
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
                                    child: _PetCategoryBlock(
                                        _PetCategory.all[_index])),
                              );
                            } else {
                              return Spacer();
                            }
                          })),
                        )
                    ]),
                  )
              ],
              onPageChanged: (val) => _page.value = val,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _page,
            builder: (context, val, child) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < pages; ++i)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 10),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: val == i
                            ? AppTheme.primaryColor
                            : Colors.grey.shade400,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ]);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
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
  }
}

class _PetType extends StatelessWidget {
  final PetType type;

  _PetType(this.type);

  Widget _images(int id) {
    if (Assets.petTypes.containsKey(id)) {
      return Image.asset(Assets.petTypes[id], color: AppTheme.primaryColor);
    } else {
      print('${type.name} - ${type.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: AppTheme.primaryColor,
          padding: EdgeInsets.zero,
        ),
        onPressed: () => AppNavigation.to(
          context,
          PetListing(petName: type.name, petTypeId: type.id),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 2)),
              child: _images(type.id),
            ),
            Text(
              type.name.split(' ').first,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
            Text(
              type.petsCount.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView();

  static const _divider = Divider(height: 0);

  final _newPetsController = RefreshController();
  final _petTypesController = RefreshController();
  final _featuredPetsController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => RefreshIndicator(
        color: Colors.black,
        onRefresh: () => Future.wait([
          _newPetsController.refresh(),
          _petTypesController.refresh(),
          _featuredPetsController.refresh()
        ]),
        child: ListView(
          addAutomaticKeepAlives: true,
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            SectionHeader(lang.selectCategory),
            _PetsCategoriesGrid(),
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
                /// TODO: Work to be done in the end.
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
              onPressed: () =>
                  AppNavigation.toPage(context, AppPage.petRelocation),
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
              onPressed: () => AppNavigation.toPage(context, AppPage.petAndVet),
            ),
            SectionHeader(
              'Featured Pets',
              SmallOutlinedButton(
                'View All',
                () => AppNavigation.toPage(context, AppPage.featuredPets),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 210,
                child: Refreshable(
                  scrollDirection: Axis.horizontal,
                  controller: _featuredPetsController,
                  builder: (pet) => PetDetailBox(pet),
                  fetcher: () => AppServices.pet.getFeaturedPets(),
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, bottom: 14),
                child: Carousel.live(
                  indicatorBuilder: Carousel.defaultIndicatorBuilder,
                  children: Assets.banners
                      .map((e) => Image.asset(e, fit: BoxFit.fitWidth))
                      .toList(),
                ),
              ),
            ),
            SectionHeader(
              'Newly Added Pets',
              SmallOutlinedButton(
                'View All',
                () => AppNavigation.toPage(context, AppPage.newlyAddedPets),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 210,
                child: Refreshable(
                  controller: _newPetsController,
                  scrollDirection: Axis.horizontal,
                  builder: (pet) => PetDetailBox(pet),
                  fetcher: () => AppServices.pet.getNewlyAddedPets(),
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                ),
              ),
            ),
            SectionHeader('Most Popular Pets in Pakistan'),
            SizedBox(
              height: 107,
              child: Refreshable<PetType>(
                controller: _petTypesController,
                scrollDirection: Axis.horizontal,
                builder: (type) => _PetType(type),
                padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                fetcher: () => AppServices.petType.getPopularPets(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
