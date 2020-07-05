import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/models/paginated-pet.dart';
import 'package:agent_pet/src/services/paginated-service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/pet-listing-widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import '../pet-detail_page.dart';
import 'pet-listing_page.dart';



enum LoadMoreStatus{
  LOADING,
  STABLE
}

class PaginatedPetListing extends StatefulWidget {
  final int petTypeId;
  final Future<List<PaginatedPet>> future;
  final String orderBy;
  final ScrollController controller;
  final String keyword;
  final int listing;
  final String query;
  final PetListing parent;
  final searchFieldIsEmpty;
  final refreshed;
  final Function(dynamic) notifyParent;

  PaginatedPetListing({this.refreshed,this.searchFieldIsEmpty,this.notifyParent,Key key,this.parent,this.query,this.listing,@required this.petTypeId,@required this.keyword,@required this.controller,@required this.future,@required this.orderBy}): super(key: key);
  @override
  _PaginatedPetListingState createState() => _PaginatedPetListingState();
}

class _PaginatedPetListingState extends State<PaginatedPetListing> {
  Future<List<PaginatedPet>> pets;
  var _service = PaginatedPetService();
  LoadMoreStatus loadMoreStatus = LoadMoreStatus.STABLE;
  ScrollController scrollController;
  List<Pet> petsData;
  int currentPageNo = 1;
  CancelableOperation petOperation;
  String _orderBy;
  bool _canFetchMore = true;
  bool refreshed;
  String _oldKeyword;

  @override
  void initState() {
    print("Called");
    refreshed=widget.refreshed;
    _orderBy = widget.orderBy;
    scrollController = widget.controller;
    scrollController.addListener(_scrollListener);
    super.initState();
  }



   void checkListingScenario(){


    if(refreshed!=widget.refreshed || _orderBy!=widget.orderBy || !widget.searchFieldIsEmpty && _oldKeyword != widget.keyword){

      currentPageNo=1;

      /*
      =====Check Listing Scenario====
      This method checks for the following scenarios and then resets currentPageNo to 1 and _canFetchMore to true.
      1-If user had refreshed the page.
      2-If user has changed the orderBy
      3-If user has searched a different search query than previous one when using search since last pagination

      In all the above cases currentPageNo resets to 1 because new data is fetched from api and list is rest
      */

      //
      refreshed = widget.refreshed;
      _oldKeyword=widget.keyword;
      _orderBy = widget.orderBy;

    }
  }


  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("bottom");

      if(refreshed!=widget.refreshed || _orderBy!=widget.orderBy || !widget.searchFieldIsEmpty && _oldKeyword != widget.keyword){
        //OrderBy changed so list is new..more data can be fetched
        _canFetchMore=true;
      }



      if (loadMoreStatus != null &&
          loadMoreStatus == LoadMoreStatus.STABLE && _canFetchMore==true) {

        setState(() {
          loadMoreStatus = LoadMoreStatus.LOADING;
          widget.notifyParent(true);
          //Notify Listing page to show dotsIndicator as data is being loaded
        });


        checkListingScenario();



        petOperation = CancelableOperation.fromFuture(
            _handleListing(currentPageNo+1)
                .then((petsDataObject) {
              currentPageNo = petsDataObject[0].currentPage;
              setState(() {
                petsData.addAll(petsDataObject[0].data);
                loadMoreStatus = LoadMoreStatus.STABLE;
                _canFetchMore = petsDataObject[0].data.length > 0;
                //if length of new data returned is 0 it's end
                //and data cannot be fetched further
                widget.notifyParent(false); // data loaded stop indicator
              });
            }));

      }
    }

  }
  @override
  void dispose() {
    scrollController.dispose();
    if(petOperation != null) petOperation.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return SimpleFutureBuilder.simplerSliver(
      context: context,
      future: widget.future,
        builder: (AsyncSnapshot<List<PaginatedPet>> snapshot) {
          var _paginatedPet = snapshot.data[0];
          petsData = _paginatedPet.data;

          return _paginatedPet.data.length > 0 ? SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, i) {
                    var _pet = _paginatedPet.data[i];

                    return InkWell(
                      highlightColor: Colors.grey.shade200,
                      onTap: () {
                            CustomNavigator.navigateTo(context, PetDetailPage(pet: _pet,));
                      },

                      child: PetListingWidget(
                        pet: _pet,
                      ),
                    ) ;
                  },

                  childCount: _paginatedPet.data.length

              )

          ): SliverFillRemaining(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Icon(Icons.search,size: 60,),
          SizedBox(height: 7,),
          Text("No Results",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
          SizedBox(height: 10,),
          Text("Sorry, your search did not return any results."),
          ],
          ),);
        }
    );

  }







  void _petsByCat(int id,int pageNo){
    pets = _service.getPetsByType(id, widget.orderBy,pageNo);
  }


  Future<List<PaginatedPet>> _handleListing([int pageNo]) async {

    if(widget.searchFieldIsEmpty){
      if(widget.petTypeId!=null){
        _petsByCat(widget.petTypeId, pageNo);
      }

      switch(widget.listing){
        case 0:
        // All Pets
          pets = _service.getAllPets(widget.orderBy,pageNo);
          break;
        case 1:
        //Pets For Adoption
          pets = _service.getPetsForAdoption(widget.orderBy,pageNo);
          break;
        case 2:
        //Advanced Search + Filters
          pets = _service.getPetsByQuery(widget.query,widget.orderBy,pageNo);
          break;
        case 3:
        //Search Page
          pets = _service.searchPetByKeyword(widget.query, widget.orderBy,pageNo);
          break;
        case 4:
        //All Featured Pets
          pets = _service.getAllFeaturedPets(widget.orderBy,pageNo);
          break;
        case 5:
        //Pets By User ID
          pets = _service.petsByUser(int.parse(widget.query),_orderBy,pageNo);
          break;
      }
    }else{
      pets= _service.searchPetByKeyword(widget.keyword,widget.orderBy,pageNo);
    }
    return pets;

  }

}


