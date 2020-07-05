import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/pages/map-page.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/pet-service.dart';
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

    _controller.addListener(() {
      if (_controller.offset > 200 && !_controller.position.outOfRange) {
        if (!silverCollapsed) {
          silverCollapsed = true;
          setState(() {});
        }
      }
      if (_controller.offset <= 200 && !_controller.position.outOfRange) {
        if (silverCollapsed) {
          silverCollapsed = false;
          setState(() {});
        }
      }

      if (_controller.offset > 350 && !_controller.position.outOfRange) {
        if (!_scrolled) {
          _scrolled = true;
          setState(() {});
        }
      }
      if (_controller.offset <= 350 && !_controller.position.outOfRange) {
        if (_scrolled) {
          _scrolled = false;
          setState(() {});
        }
      }
    });
    pets = _service.getSimilarPets(widget.pet.id, widget.pet.typeId);
  }

  @override
  build(context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _scrolled
            ? FloatingActionButton(
          heroTag: "btn1",
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
              stretch: false,
              expandedHeight: 300,
              backgroundColor: !silverCollapsed ? Colors.transparent : null,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: !silverCollapsed ? Colors.black : Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: silverCollapsed ? Text(widget.pet.name) : SizedBox(),
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      PageView.builder(
                        controller: _pageController,
                        itemCount: widget.pet.images.length,
                        itemBuilder: (context, i) => Image.network(
                          Service.getConvertedImageUrl(
                              widget.pet.images[i].src),
                          fit: BoxFit.contain,
                          loadingBuilder: circularImageLoader,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 16,
                        child:  FavoriteButton(
                          id: widget.pet.id,
                          bordered: true,
                        )
                      ),
                      Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
//                      color: Colors.grey[800].withOpacity(0.5),
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: DotsIndicator(
                                  controller: _pageController,
                                  itemCount: widget.pet.images.length,
                                  onPageSelected: (int page) {
                                    _pageController.animateToPage(
                                      page,
                                      duration: _kDuration,
                                      curve: _kCurve,
                                    );
                                  },
                                ),
                              ))),
//
                    ],
                  )),
              pinned: true,
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
                              fontSize: 23)),
                    ),


//                      Padding(
//                        padding: const EdgeInsets.only(right: 10.0),
//                        child: InkWell(
//                          borderRadius: BorderRadius.circular(15),
//                          splashColor: Colors.grey.shade400,
//                          onTap: (){
//                            dial("tel:${widget.pet.ownerPhone}");
//                          },
//                          child: Container(
//                            width: 37, height: 37,
//                            child:  Center(child: Icon(Icons.phone, color: Colors.white)
//                                    ),
//                            decoration: BoxDecoration(
//                                color: Colors.orangeAccent,
//                                borderRadius: BorderRadius.circular(20)
//                            ),
//                          ),
//                        ),
//                      )
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
                              text: Text("${widget.pet.ownerCity}",
                                  style: TextStyle(fontSize: 12))),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconText(
                              padding: const EdgeInsets.only(left: 10),
                              icon: Icon(Icons.loop, size: 14, color: Colors.grey),
                              text: Flexible(child: Text("Last updated at ${getFormattedDate(widget.pet.updatedAt)}", style: TextStyle(fontSize: 10)))
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconText(
                              padding: const EdgeInsets.only(right: 2),
                              icon: Icon(Icons.folder_open, size: 14, color: Colors.grey),
                              text: Text("Ad ref # ${widget.pet.id}", style: TextStyle(fontSize: 10))
                          ),
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
                        onTap: (){
                          CustomNavigator.navigateTo(context, PetListing(title: widget.pet.ownerName,listing: 5,query: widget.pet.userId.toString(),));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: IconText(
                              padding: const EdgeInsets.only(right: 2,left: 2),
                              icon: Icon(Icons.person, size: 24, color: Colors.grey),
                              text: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${widget.pet.ownerName}", style: TextStyle(fontSize: 10)),
                                  Text("More ads by ${widget.pet.ownerName}", style: TextStyle(fontSize: 10,color: Colors.primaries[0])),
                                ],
                              )
                          ),
                        ),
                      ),
                    ],
                  ),




                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Divider(),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 40),
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.phone,
                                size: 15,
                              ),
                            ),
                            Text('Show Number'),
                          ],
                        ),
                        color: Colors.primaries[0],
                        onPressed: () async {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.0)),
                              ),
                              context: context,
                              builder: (context) => ShowNumberSheet(
                                phoneNum: widget.pet.ownerPhone,
                              ));
                        },
                      ),
                    ),
                  ),

                  Row(children: <Widget>[
                    Expanded(
                        child: Column(children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.grey.shade400,
                            onTap: () {
                              dial("sms:${widget.pet.ownerPhone}");
                            },
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Icon(Icons.sms,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("SMS"),
                          )
                        ])),
                    Expanded(
                        child: Column(children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.grey.shade400,
                            onTap: () {
                              CustomNavigator.navigateTo(
                                  context,
                                  MapPage(
                                    shopTitle: widget.pet.name,
                                    shopLatLng: LatLng(double.parse(widget.pet.lat),double.parse(widget.pet.lng)),
                                    shopPhoneNumber: widget.pet.ownerPhone,
                                    shopAddress: widget.pet.ownerAddress,

                                  ));
                            },
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Icon(Icons.pin_drop,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("Map"),
                          )
                        ])),
                    Expanded(
                        child: Column(children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.grey.shade400,
                            onTap: () {
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
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Icon(Icons.chat,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("Chat"),
                          )
                        ])),
                    Expanded(
                        child: Column(children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.grey.shade400,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  child: ReportDialog(
                                    petId: widget.pet.id,
                                  ));
                            },
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Icon(Icons.flag,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("Report"),
                          )
                        ])),
                    Expanded(
                        child: Column(children: <Widget>[
                          InkWell(
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Icon(Icons.share,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onTap: () {
                              Share.share('https://www.agentpet.com/pet-detail/${widget.pet.slug}');
//
//                              showModalBottomSheet(
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.vertical(
//                                        top: Radius.circular(15.0)),
//                                  ),
//                                  context: context,
//                                  builder: (context) => ShareBottomSheet(
//                                    slug: widget.pet.slug,
//                                  ));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("Share"),
                          )
                        ])),
                  ]),

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
              child: Table(
                children: [
                TableRow(children: [
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
                  TableRow(
                    children: [
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
                    ]
                  )
                  ]
              ),
            )),
          )),
            SliverToBoxAdapter(child: SizedBox(height: 10,),), SliverToBoxAdapter(
              child: InkWell(
                  onTap: (){
                    CustomNavigator.navigateTo(context, ProductListing(listing: 10,
                      petName: 'Cat',
                      category: 'pet-food',petTypeId: 1,));
                  },
                  child: Image.asset("assets/banners/cat-food.png")),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 10,),),
            SliverSectionHeader('Similar Pets'),
            SliverToBoxAdapter(
              child: SimpleFutureBuilder<List<Pet>>.simpler(
                  context: context,
                  future: pets,
                  builder: (AsyncSnapshot<List<Pet>> snapshot) {
                    return snapshot.data.isNotEmpty ?  Container(
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
                                              constraints: BoxConstraints.expand(),
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
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      child: Align(
                                                        alignment:
                                                        Alignment(0, .97),
                                                        child: Text("Featured",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                            textAlign: TextAlign
                                                                .center),
                                                      )),
                                                ))
                                                : SizedBox()
                                          ]),
                                        )),
                                    SizedBox(
                                        width: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5),
                                          child: Text(
                                            _pet.name[0].toUpperCase() +
                                                _pet.name.substring(1),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                    Text(_pet.type.name,
                                        style: TextStyle(
                                            fontSize: 9, color: Colors.grey)),
                                    Text(_pet.ownerCity,
                                        style: TextStyle(fontSize: 9)),
                                  ]),
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length),
                    ): Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.pets,size:16,),
                            SizedBox(width: 10,),
                            Text("No Similar Pets in this category."),
                          ],
                        ),
                        SizedBox(height: 30,),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
