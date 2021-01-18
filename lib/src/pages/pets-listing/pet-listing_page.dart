import 'package:agent_pet/src/models/paginated-pet.dart';
import 'package:agent_pet/src/pages/auth/login_page.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-filters_page.dart';
import 'package:agent_pet/src/services/paginated-service.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/bottom_sheets/notify-me_bottom_sheet.dart';
import 'package:agent_pet/src/widgets/bottom_sheets/sorting-bottom_sheet.dart';
import 'package:agent_pet/src/widgets/dots-loading-indicator.dart';
import 'package:agent_pet/src/widgets/saved-badged-icon.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../add-or-edit-pet/main-add-or-edit-pet.dart';
import 'pet-filters_page.dart';
import 'paginated-listing.dart';

class PaginatedData<T> {
  List<T> data;
  int currentPage;
}

class PaginationService {}

class PetListingPage extends StatefulWidget {
  @override
  _PetListingPageState createState() => _PetListingPageState();
}

class _PetListingPageState extends State<PetListingPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ActionButton extends Expanded {
  _ActionButton({String text, VoidCallback onPressed})
      : super(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
                minimumSize: Size.fromHeight(48),
                backgroundColor: Colors.grey.shade200,
              ),
              child: Text(text),
              onPressed: onPressed,
            ),
          ),
        );
}

class PetListing extends StatefulWidget {
  final int listing;
  final int petTypeId;
  final String petName;
  final String query;
  final String title;

  PetListing(
      {this.petTypeId, this.petName, this.listing = 0, this.query, this.title});

  @override
  _PetListingState createState() => _PetListingState();
}

class _PetListingState extends State<PetListing> {
  Future<List<PaginatedPet>> pets;
  var _service = PaginatedPetService();
  String count = '';
  String _title = '';
  String _postTitle = 'For Sale and Adoption in Pakistan';
  String _orderBy = '';
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var listingScaffoldKey = GlobalKey<ScaffoldState>();
  var _keyword = TextEditingController();
  String _searchVal;
  ScrollController scrollController;
  bool showIndicator = false;
  bool _searchFieldIsEmpty = true;
  String oldKeyword;
  bool isNewKeyword;
  bool refreshed = false;

  void _petsByCat(int id) {
    pets = _service.getPetsByType(id, _orderBy);
  }

  Future _handleListing([bool refresh = false]) async {
    if (_searchFieldIsEmpty) {
      if (widget.petTypeId != null) {
        _title = '${widget.petName} $_postTitle';
        _petsByCat(widget.petTypeId);
      }

      switch (widget.listing) {
        case 0:
          // All Pets
          pets = _service.getAllPets(_orderBy);
          _title = 'Pets $_postTitle';
          break;
        case 1:
          //Pets For Adoption
          pets = _service.getPetsForAdoption(_orderBy);
          _title = 'Pets for Adoption / Match Making In Pakistan';
          break;
        case 2:
          //Advanced Search + Filters
          pets = _service.getPetsByQuery(widget.query, _orderBy);
          _title = widget.title;
          break;
        case 3:
          //Search Page
          pets = _service.searchPetByKeyword(widget.query, _orderBy);
          _title = '${widget.query} $_postTitle';
          break;
        case 4:
          //All Featured Pets
          pets = _service.getAllFeaturedPets(_orderBy);
          _title = 'Featured Pets $_postTitle';
          break;
        case 5:
          //Pets By User ID
          pets = _service.petsByUser(int.parse(widget.query), _orderBy);
          _title = 'Ads By ${widget.title}';
          break;
      }
    } else {
      _title = '$_searchVal $_postTitle';
      pets = _service.searchPetByKeyword(_searchVal, _orderBy);
    }

    if (refresh) {
      await pets;
      refreshed = true;
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);

      setState(() {});
    }

    pets.then((pets) {
      setState(() {
        count = pets[0].total.toString();
        _title = count + ' ' + _title;
      });
    });
  }

  Future _inPageSearch(String query) async {
    setState(() {
      _title = '$query $_postTitle';
    });
    pets = _service.searchPetByKeyword(query, _orderBy);
    pets.then((pets) {
      setState(() {
        count = pets[0].total.toString();
        _title = count + ' ' + _title;
      });
    });
    await pets;
  }

  @override
  void initState() {
    scrollController = ScrollController();
    _handleListing();
    super.initState();
  }

  refresh(dynamic childValue) {
    setState(() {
      showIndicator = childValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("Sell"),
        onPressed: () {
          CustomNavigator.navigateTo(
              context, LocalData.isSignedIn ? AddPetPage() : LoginPage());
        },
      ),
      key: listingScaffoldKey,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(CupertinoIcons.arrow_left),
        ),
        actions: <Widget>[FavoriteButtonBadged()],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(68),
          child: Row(children: [
            SizedBox(width: 5),
            _ActionButton(text: 'FILTER', onPressed: () {}),
            _ActionButton(text: 'SORT', onPressed: () {}),
            _ActionButton(text: 'NOTIFY ME', onPressed: () {}),
            SizedBox(width: 5),
          ]),
        ),
        title: TextFormField(
          controller: _keyword,
          style: TextStyle(color: Colors.white),
          onEditingComplete: () {
            //Using this variable for purpose of notify
            // ing paginated widget
            //that search by keyword needs to be called
            _searchFieldIsEmpty = _keyword.text.length < 1;
            print(_searchFieldIsEmpty);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onFieldSubmitted: (value) async {
            if (value.isNotEmpty) {
              await _inPageSearch(value);
              _searchVal = value;
            }
          },
          decoration: InputDecoration(
            isDense: true,
            hintStyle: TextStyle(color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              color: Colors.white,
              onPressed: () {
                _keyword.clear();
              },
            ),
            hintText: 'Search',
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          textInputAction: TextInputAction.search,
        ),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.primaries[0],
        onRefresh: () async {
          await _handleListing(true);
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            // SliverAppBar(
            //   titleSpacing: 0,
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   backgroundColor: Colors.white,
            //   title: Row(
            //     children: <Widget>[
            //       Expanded(
            //         child: Container(
            //           decoration: BoxDecoration(color: Colors.grey.shade200),
            //           child: FlatButton(
            //             child: Text(
            //               "FILTER",
            //             ),
            //             textColor: Colors.black,
            //             onPressed: () {
            //               CustomNavigator.navigateTo(context, PetFilters());
            //             },
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Padding(
            //           padding: const EdgeInsets.all(2.0),
            //           child: Container(
            //             decoration: BoxDecoration(color: Colors.grey.shade200),
            //             child: FlatButton(
            //               child: Text("SORT"),
            //               onPressed: () async {
            //                 var _orderByResult = await showModalBottomSheet(
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.vertical(
            //                           top: Radius.circular(15.0)),
            //                     ),
            //                     context: context,
            //                     builder: (context) => SortBottomSheet(
            //                           selectedSort: _orderBy == 'asc' ? 2 : 1,
            //                         ));
            //                 if (_orderByResult != null) {
            //                   _orderBy = _orderByResult;
            //                   refreshKey.currentState.show();
            //                 }
            //               },
            //               textColor: Colors.black,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(
            //           decoration: BoxDecoration(color: Colors.grey.shade200),
            //           child: FlatButton(
            //             child: Text("NOTIFY ME"),
            //             onPressed: () {
            //               showModalBottomSheet(
            //                   isScrollControlled: true,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.vertical(
            //                         top: Radius.circular(15.0)),
            //                   ),
            //                   context: context,
            //                   builder: (context) => NotifyBottomSheet(
            //                         listingKey: listingScaffoldKey,
            //                       ));
            //             },
            //             textColor: Colors.black,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            //   pinned: true,
            // ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text(
                    _title ?? "",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            PaginatedPetListing(
              notifyParent: refresh,
              future: pets,
              listing: widget.listing,
              query: widget.query,
              petTypeId: widget.petTypeId,
              controller: scrollController,
              orderBy: _orderBy,
              keyword: _keyword.text,
              searchFieldIsEmpty: _searchFieldIsEmpty,
              refreshed: refreshed,
            ),
            SliverToBoxAdapter(
                child: Center(
                    child: showIndicator
                        ? DotsLoadingIndicator(
                            size: 40,
                          )
                        : SizedBox()))
          ],
        ),
      ),
    );
  }
}
