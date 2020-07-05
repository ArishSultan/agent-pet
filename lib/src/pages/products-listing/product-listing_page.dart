import 'package:agent_pet/src/models/paginated-product.dart';
//import 'package:agent_pet/src/pages/products-listing/pet-filters_page.dart';
import 'package:agent_pet/src/pages/products-listing/paginated-product-listing.dart';
import 'package:agent_pet/src/pages/products-listing/product-filters_page.dart';
import 'package:agent_pet/src/services/paginated-product-service.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/badge.dart';
import 'package:agent_pet/src/widgets/bottom_sheets/notify-me_bottom_sheet.dart';
import 'package:agent_pet/src/widgets/bottom_sheets/sorting-bottom_sheet.dart';
import 'package:agent_pet/src/widgets/cart-badged-icon.dart';
import 'package:agent_pet/src/widgets/dots-loading-indicator.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/saved-badged-icon.dart';
import 'package:flutter/material.dart';
import '../profile/saved_ads-page.dart';

class ProductListing extends StatefulWidget {
  final int listing;
  final int brandId;
  final int petTypeId;
  final String query;
  final String title;
  final String petName;
  final String category;
  final String priceRange;

  ProductListing({this.brandId,this.petTypeId,this.listing,this.query,this.title,this.petName,this.category='',this.priceRange});
  @override
  _ProductListingState createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {

  Future<List<PaginatedProduct>> products;
  var _service = PaginatedProductService();
  String count = '';
  String _title = '';
  String _postTitle = 'To Buy';
  String _orderBy = '';
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var listingScaffoldKey = GlobalKey<ScaffoldState>();
  var _keyword = TextEditingController();
  String _searchVal;
  ScrollController scrollController;
  bool showIndicator = false;
  bool _searchFieldIsEmpty=true;
  String oldKeyword;
  bool isNewKeyword;
  bool refreshed=false;




  Future _handleListing([bool refresh=false]) async {
    if(_searchFieldIsEmpty){

      switch(widget.listing){
        case 0:
          // All Products
          products = _service.getProducts(orderBy: _orderBy);
          _title = 'Pet Foods and Accessories $_postTitle';
          break;
        case 1:
          //Products on Sale
          products = _service.getProducts(flash: 'yes',orderBy: _orderBy);
          _title = 'Pet Foods and Accessories On Sale';
          break;
        case 2:
        //Featured Products
          products = _service.getProducts(featured: 'yes',orderBy: _orderBy);
          _title = 'Featured Pet Foods and Accessories $_postTitle';
          break;
        case 3:
        //Pet Food
          products = _service.getProducts(category: 'pet-food',orderBy: _orderBy);
          _title = 'Pet Foods $_postTitle';
          break;
        case 4:
        //Pet Accessories
          products = _service.getProducts(category: 'pet-accessories',orderBy: _orderBy);
          _title = 'Pet Accessories $_postTitle';
          break;
        case 5:
        //Featured Pet Food
          products = _service.getProducts(category: 'pet-food',featured: 'yes',orderBy: _orderBy);
          _title = 'Featured Pet Foods $_postTitle';
          break;
        case 6:
        //Featured Pet Accessories
          products = _service.getProducts(category: 'pet-accessories',featured: 'yes',orderBy: _orderBy);
          _title = 'Featured Pet Accessories $_postTitle';
          break;
        case 7:
        //Popular Products
          products = _service.getProducts(popular: 'yes',orderBy: _orderBy);
          _title = 'Popular Pet Foods and Accessories $_postTitle';
          break;
        case 9:
        //Products By Brand
          products = _service.getProducts(brandId: widget.brandId,orderBy: _orderBy);
          _title = 'Pet Foods and Accessories To Buy By ${widget.title}' ;
          break;
        case 10:
        //Products By Pet
          products = _service.getProducts(type: widget.petTypeId,category: widget.category,orderBy: _orderBy);
//          _productsByPet(petName: widget.petName,category: widget.category);
          StringBuffer _titleStr = StringBuffer();
          _titleStr.write(widget.category.isEmpty ? 'Foods and Accessories' : widget.category=='pet-food' ? 'Foods' : 'Accessories');
          _title = '${widget.petName[0].toUpperCase() + widget.petName.toLowerCase().substring(1)} ${_titleStr.toString()} $_postTitle';
          break;
        case 11:
        //Filters
          products = _service.getProducts(keyword: widget.query,
              category: widget.category,
              priceRange: widget.priceRange,
              type: widget.petTypeId,orderBy: _orderBy);
          _title = widget.title ;
          break;
      }
    }else{
      _title = '$_searchVal Foods and Accessories $_postTitle';
      products = _service.getProducts(keyword: _searchVal,orderBy: _orderBy);
    }




    if(refresh){
      await products;
      refreshed=true;
      scrollController.animateTo(scrollController.position.minScrollExtent,duration: Duration(milliseconds: 300),curve: Curves.easeIn);

      setState(() {});
    }

    products.then((products){
      if(this.mounted){
        setState(() {
          count = products[0].total.toString();
          _title = count + ' ' +  _title;
        });
      }

    });

  }



  Future _inPageSearch(String query) async {
    setState(() {
      _title = '$query Foods and Accessories $_postTitle';
    });
    products = _service.getProducts(keyword: query,orderBy: _orderBy);
    products.then((products){
      setState(() {
        count = products[0].total.toString();
        _title = count + ' ' + _title;
      });
    });
    await products;
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
      key: listingScaffoldKey,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        actions: <Widget>[
          CartBadgedIcon(),
          SavedBadgeIcon(pets: false,),



        ],
        title: TextFormField(
          controller: _keyword,
          style: TextStyle(color: Colors.white),
          onEditingComplete: (){
            //Using this variable for purpose of notify
            // ing paginated widget
            //that search by keyword needs to be called
            _searchFieldIsEmpty=_keyword.text.length < 1;
            print(_searchFieldIsEmpty);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onFieldSubmitted: (value) async {
            if(value.isNotEmpty){
              await _inPageSearch(value);
              _searchVal=value;
            }
          },
          decoration: InputDecoration(
            hintStyle: TextStyle(
                color: Colors.white
            ),
            suffixIcon: IconButton(icon: Icon(Icons.clear),color: Colors.white,
              onPressed: (){
                _keyword.clear();
              },),
            hintText: 'Search',
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white
                )
            ),
            prefixIcon: Icon(Icons.search,color: Colors.white,),

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
            SliverAppBar(
              titleSpacing: 0,
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Row(children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200
                    ),
                    child: FlatButton(child: Text("FILTER",),
                      textColor: Colors.black,
                      onPressed: () {
                        CustomNavigator.navigateTo(context, ProductFilters());
                      },),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200
                      ),
                      child: FlatButton(child: Text("SORT"),onPressed: () async {
                        var _orderByResult =  await showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                            ),context: context, builder: (context)=> SortBottomSheet(selectedSort: _orderBy=='asc' ? 2 : 1,
                        ));
                        if(_orderByResult!=null){
                          _orderBy =  _orderByResult ;
                          refreshKey.currentState.show();
                        }
                      },
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200
                    ),
                    child: FlatButton(child: Text("NOTIFY ME"),onPressed: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                          ),context: context, builder: (context)=> NotifyBottomSheet(listingKey: listingScaffoldKey,));
                    },
                      textColor: Colors.black,
                    ),
                  ),
                ),
              ],),
              pinned: true,),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text(_title, style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),overflow: TextOverflow.ellipsis,),
                ),
              ),
            ),

            PaginatedProductListing(
              notifyParent: refresh,
              future: products,
              listing: widget.listing,
              query: widget.query,
              brandId: widget.brandId,
              priceRange: widget.priceRange,
              category: widget.category,
              controller: scrollController,
              orderBy: _orderBy,
              keyword: _keyword.text,
              searchFieldIsEmpty: _searchFieldIsEmpty,
              refreshed: refreshed,
              petTypeId: widget.petTypeId,
            ),

          SliverToBoxAdapter(child:   Center(child: showIndicator ? DotsLoadingIndicator(size: 40,) : SizedBox()))

          ],
        ),
      ),
    );
  }



}
