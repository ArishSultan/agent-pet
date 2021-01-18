import 'package:agent_pet/src/base/services.dart';
import 'package:agent_pet/src/base/theme.dart';
import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/pages/map-page.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/pet-service.dart';
import 'package:agent_pet/src/widgets/carousel.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'package:agent_pet/src/utils/date-formatter.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/bottom_sheets/share-bottom-sheet.dart';
import 'package:agent_pet/src/widgets/bottom_sheets/show-number-bottom_sheet.dart';
import 'package:agent_pet/src/widgets/dialogs/report.dart';
import 'package:agent_pet/src/widgets/dots-indicator.dart';
import 'package:agent_pet/src/widgets/favorite-button.dart';
import 'package:agent_pet/src/widgets/feature-tile.dart';
import 'package:agent_pet/src/widgets/icon-text.dart';
import 'package:agent_pet/src/utils/convert-yes-or-no.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/dial-phone-or-sms.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/loading-builder.dart';
import 'package:agent_pet/src/widgets/local-favorite-button.dart';
import 'package:agent_pet/src/widgets/sliver-section-header.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'products-listing/product-listing_page.dart';
import 'profile/chat-page.dart';
import 'auth/login_page.dart';

class _PageTitle extends StatefulWidget {
  final String text;
  final ScrollController controller;

  _PageTitle(this.text, this.controller);

  @override
  __PageTitleState createState() => __PageTitleState();
}

class __PageTitleState extends State<_PageTitle> {
  var opacity = 0.0;

  void _handleChange() {
    if (widget.controller.offset <= 300) {
      setState(() {
        opacity = widget.controller.offset / 300;
      });
    }
  }

  Text _title;

  @override
  void initState() {
    super.initState();
    _title = Text(widget.text);
    widget.controller.addListener(_handleChange);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: opacity, child: _title);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_handleChange);
  }
}

class _Action extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  _Action({this.text, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(45, 45),
          primary: AppTheme.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: Colors.grey.shade200,
        ),
        child: Icon(icon),
      ),
      SizedBox(height: 5),
      Text(text)
    ]);
  }
}

class PetDetailPage extends StatefulWidget {
  final Pet pet;

  PetDetailPage({@required this.pet});

  @override
  createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage>
    with SingleTickerProviderStateMixin {
  Future<List<Pet>> pets;
  final _service = PetService();
  ScrollController _controller;
  PageController _pageController = PageController();
  bool silverCollapsed = false;
  bool _scrolled = false;

  //Report Ad Radio
  bool sharePressed = false;

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  String choice;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    // _controller.addListener(() {
    //   if (_controller.offset > 200 && !_controller.position.outOfRange) {
    //     if (!silverCollapsed) {
    //       silverCollapsed = true;
    //       setState(() {});
    //     }
    //   }
    //   if (_controller.offset <= 200 && !_controller.position.outOfRange) {
    //     if (silverCollapsed) {
    //       silverCollapsed = false;
    //       setState(() {});
    //     }
    //   }
    //
    //   if (_controller.offset > 350 && !_controller.position.outOfRange) {
    //     if (!_scrolled) {
    //       _scrolled = true;
    //       setState(() {});
    //     }
    //   }
    //   if (_controller.offset <= 350 && !_controller.position.outOfRange) {
    //     if (_scrolled) {
    //       _scrolled = false;
    //       setState(() {});
    //     }
    //   }
    // });
    pets = _service.getSimilarPets(widget.pet.id, widget.pet.typeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _scrolled
          ? FloatingActionButton(
              child: Icon(Icons.call),
              elevation: 0,
              onPressed: () {
                dial("tel:${widget.pet.ownerPhone}");
              },
              backgroundColor: Colors.green,
            )
          : SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _scrolled
          ? BottomAppBar(
              notchMargin: 6,
              clipBehavior: Clip.antiAlias,
              child: BottomNavigationBar(
                currentIndex: 1,
                items: [
                  BottomNavigationBarItem(
                      title: Text("SMS"), icon: Icon(Icons.textsms)),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add), title: Text('')),
                  BottomNavigationBarItem(
                      title: Text("Chat"), icon: Icon(Icons.chat)),
                ],
                type: BottomNavigationBarType.fixed,
                onTap: (val) {
                  switch (val) {
                    case 0:
                      dial("sms:${widget.pet.ownerPhone}");
                      break;
                    case 2:
                      CustomNavigator.navigateTo(
                          context,
                          LocalData.isSignedIn
                              ? ChatPage(
                                  petId: widget.pet.id,
                                  receiverId: widget.pet.userId,
                                  receiverName: widget.pet.ownerName,
                                )
                              : LoginPage());
                      break;
                  }
                },
              ),
            )
          : SizedBox(),
      body: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 300,
            leading: IconButton(
              icon: Icon(CupertinoIcons.arrow_left),
              onPressed: () {
                final navigator = Navigator.of(context);
                if (navigator.canPop()) {
                  navigator.pop();
                }
              },
            ),
            title: _PageTitle(widget.pet.name, _controller),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              stretchModes: [StretchMode.fadeTitle],
              background: Container(
                color: Colors.black,
                child: Carousel.builder(
                  itemCount: widget.pet.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      AppServices.makeImageUrl(widget.pet.images[index].src),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            sliver: SliverToBoxAdapter(
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                    child: Text(
                      "${widget.pet.name[0].toUpperCase()}${widget.pet.name.substring(1)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 23,
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: IconText(
                          padding: const EdgeInsets.only(right: 2),
                          icon: Icon(Icons.location_on,
                              size: 15, color: Colors.grey),
                          text: Text(
                            "${widget.pet.ownerCity}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconText(
                            padding: const EdgeInsets.only(left: 10),
                            icon:
                                Icon(Icons.loop, size: 14, color: Colors.grey),
                            text: Flexible(
                                child: Text(
                                    "Last updated at ${getFormattedDate(widget.pet.updatedAt)}",
                                    style: TextStyle(fontSize: 10)))),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconText(
                            padding: const EdgeInsets.only(right: 2),
                            icon: Icon(Icons.folder_open,
                                size: 14, color: Colors.grey),
                            text: Text("Ad ref # ${widget.pet.id}",
                                style: TextStyle(fontSize: 10))),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("PKR ${widget.pet.price}",
                        style: TextStyle(fontSize: 18)),
                    InkWell(
                      onTap: () {
                        CustomNavigator.navigateTo(
                            context,
                            PetListing(
                              title: widget.pet.ownerName,
                              listing: 5,
                              query: widget.pet.userId.toString(),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconText(
                            padding: const EdgeInsets.only(right: 2, left: 2),
                            icon: Icon(Icons.person,
                                size: 24, color: Colors.grey),
                            text: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("${widget.pet.ownerName}",
                                    style: TextStyle(fontSize: 10)),
                                Text("More ads by ${widget.pet.ownerName}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.primaries[0])),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  constraints: BoxConstraints.expand(height: 40),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    icon: Icon(CupertinoIcons.phone, size: 19),
                    label: Text('Show Number'),
                    onPressed: () async {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                          ),
                          context: context,
                          builder: (context) =>
                              OwnerContactNumberSheet(widget.pet.ownerPhone)
                          );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      _Action(
                        text: 'SMS',
                        icon: CupertinoIcons.chat_bubble_text,
                        onPressed: () {
                          dial("sms:${widget.pet.ownerPhone}");
                        },
                      ),
                      _Action(
                        text: 'Map',
                        icon: CupertinoIcons.location,
                        onPressed: () {
                          CustomNavigator.navigateTo(
                            context,
                            MapPage(
                              shopTitle: widget.pet.name,
                              shopLatLng: LatLng(double.parse(widget.pet.lat),
                                  double.parse(widget.pet.lng)),
                              shopPhoneNumber: widget.pet.ownerPhone,
                              shopAddress: widget.pet.ownerAddress,
                            ),
                          );
                        },
                      ),
                      _Action(
                        text: 'Chat',
                        icon: CupertinoIcons.chat_bubble_2,
                        onPressed: () {
                          LocalData.isSignedIn
                              ? CustomNavigator.navigateTo(
                                  context,
                                  ChatPage(
                                    petId: widget.pet.id,
                                    receiverId: widget.pet.userId,
                                    receiverName: widget.pet.ownerName,
                                  ))
                              : CustomNavigator.navigateTo(
                                  context, LoginPage());
                        },
                      ),
                      _Action(
                        text: 'Report',
                        icon: CupertinoIcons.flag,
                        onPressed: () {
                          showDialog(
                            context: context,
                            child: ReportDialog(
                              petId: widget.pet.id,
                            ),
                          );
                        },
                      ),
                      _Action(
                        text: 'Share',
                        icon: CupertinoIcons.share,
                        onPressed: () {
                          Share.share(
                            'https://www.agentpet.com/pet-detail/${widget.pet.slug}',
                          );
                        },
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(),
                ),
              ], crossAxisAlignment: CrossAxisAlignment.start),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                  height: 50,
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Pet Features",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold)),
                  ))),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                FeatureTile(
                  t1: "Pet",
                  v1: "${widget.pet.type.name}",
                  t2: "Breed",
                  v2: "${widget.pet.primaryBreed}",
                  b1: false,
                ),
                FeatureTile(
                  t1: "Gender",
                  v1: "${widget.pet.gender}",
                  t2: "Color",
                  v2: "${widget.pet.color}",
                  b1: true,
                ),
                FeatureTile(
                  t1: "Age",
                  v1: "${widget.pet.age}",
                  t2: "Group",
                  v2: "${widget.pet.group}",
                  b1: false,
                ),
                FeatureTile(
                  t1: "Pet For",
                  v1: "${widget.pet.petFor}",
                  t2: "Hypoallergenic",
                  v2: "${convertBool(widget.pet.hypoallergenic)}",
                  b1: true,
                ),
                FeatureTile(
                  t1: "House Trained",
                  v1: "${convertBool(widget.pet.houseTrained)}",
                  t2: "Declawed",
                  v2: "${convertBool(widget.pet.declawed)}",
                  b1: false,
                ),
                FeatureTile(
                  t1: "Special Diet",
                  v1: "${convertBool(widget.pet.specialDiet)}",
                  t2: "Likes To Lap",
                  v2: "${convertBool(widget.pet.likesToLap)}",
                  b1: true,
                ),
                FeatureTile(
                  t1: "Special Needs",
                  v1: "${convertBool(widget.pet.specialNeeds)}",
                  t2: "Ongoing Medical",
                  v2: "${convertBool(widget.pet.ongoingMedical)}",
                  b1: false,
                ),
                FeatureTile(
                  t1: "Neutered",
                  v1: "${convertBool(widget.pet.neutered)}",
                  t2: "Vaccinated",
                  v2: "${convertBool(widget.pet.vaccinated)}",
                  b1: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8),
                  child: Container(
                      child: ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.pets,
                      size: 20,
                    ),
                    title: Text(
                      'High Risk',
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      "${convertBool(widget.pet.highRisk)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                  )),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: widget.pet.description != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey.shade200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4.0, left: 8, top: 8),
                            child: Text(
                              "Owner's comments",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${widget.pet.description}",
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                color: Colors.grey.shade200,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(children: [
                    TableRow(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Temperament",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            widget.pet.protective
                                ? Text(
                                    "Protective",
                                  )
                                : SizedBox(),
                            widget.pet.playful
                                ? Text(
                                    "Playful",
                                  )
                                : SizedBox(),
                            widget.pet.affectionate
                                ? Text(
                                    "Affectionate",
                                  )
                                : SizedBox(),
                            widget.pet.gentle
                                ? Text(
                                    "Gentle",
                                  )
                                : SizedBox(),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Compatibility",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            widget.pet.okayWithKids
                                ? Text(
                                    "Okay With Kids",
                                    style: TextStyle(),
                                  )
                                : SizedBox(),
                            widget.pet.okayWithDogs
                                ? Text(
                                    "Okay With Dogs",
                                    style: TextStyle(),
                                  )
                                : SizedBox(),
                            widget.pet.okayWithCats
                                ? Text(
                                    "Okay With Cats",
                                    style: TextStyle(),
                                  )
                                : SizedBox(),
                            widget.pet.okayWithAppartments
                                ? Text(
                                    "Okay With Apartments",
                                    style: TextStyle(),
                                  )
                                : SizedBox(),
                            widget.pet.okayWithSeniors
                                ? Text(
                                    "Okay With Seniors",
                                    style: TextStyle(),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "Training",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(widget.pet.trainingLevel),
                          ],
                        ),
                      ],
                    ),
                    TableRow(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Energy",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(widget.pet.energyLevel),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Grooming",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(widget.pet.groomingLevel),
                        ],
                      ),
                      SizedBox(),
                    ])
                  ]),
                )),
          )),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
                onTap: () {
                  CustomNavigator.navigateTo(
                      context,
                      ProductListing(
                        listing: 10,
                        petName: 'Cat',
                        category: 'pet-food',
                        petTypeId: 1,
                      ));
                },
                child: Image.asset("assets/banners/cat-food.png")),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverSectionHeader('Similar Pets'),
          SliverToBoxAdapter(
            child: SimpleFutureBuilder<List<Pet>>.simpler(
                context: context,
                future: pets,
                builder: (AsyncSnapshot<List<Pet>> snapshot) {
                  return snapshot.data.isNotEmpty
                      ? Container(
                          height: 175,
                          child: ListView.builder(
                              itemBuilder: (context, i) {
                                var _pet = snapshot.data[i];
                                return Material(
                                  child: InkWell(
                                    onTap: () {
                                      CustomNavigator.navigateTo(
                                          context,
                                          PetDetailPage(
                                            pet: _pet,
                                          ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Column(children: <Widget>[
                                        ClipRect(
                                            child: SizedBox(
                                          width: 90,
                                          height: 90,
                                          child: Stack(children: <Widget>[
                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.expand(),
                                              child: Image.network(
                                                  Service.getConvertedImageUrl(
                                                      _pet.images[0].src),
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      circularImageLoader),
                                            ),
                                            _pet.featured
                                                ? Transform.translate(
                                                    offset: Offset(-55, -55),
                                                    child: Transform.rotate(
                                                      angle: 225.45,
                                                      child: Container(
                                                          width: 100,
                                                          height: 100,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          child: Align(
                                                            alignment:
                                                                Alignment(
                                                                    0, .97),
                                                            child: Text(
                                                                "Featured",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          )),
                                                    ))
                                                : SizedBox()
                                          ]),
                                        )),
                                        SizedBox(
                                            width: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 5),
                                              child: Text(
                                                _pet.name[0].toUpperCase() +
                                                    _pet.name.substring(1),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                        Text(_pet.type.name,
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.grey)),
                                        Text(_pet.ownerCity,
                                            style: TextStyle(fontSize: 9)),
                                      ]),
                                    ),
                                  ),
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length),
                        )
                      : Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.pets,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("No Similar Pets in this category."),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        );
                }),
          ),
        ],
      ),
    );
  }
}
