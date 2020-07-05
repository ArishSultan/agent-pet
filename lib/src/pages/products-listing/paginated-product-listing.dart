import 'package:agent_pet/src/models/paginated-product.dart';
import 'package:agent_pet/src/models/product.dart';
import 'package:agent_pet/src/services/paginated-product-service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/product-listing-widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import '../product-detail_page.dart';
import 'product-listing_page.dart';



enum LoadMoreStatus{
  LOADING,
  STABLE
}

class PaginatedProductListing extends StatefulWidget {
  final int brandId;
  final Future<List<PaginatedProduct>> future;
  final String orderBy;
  final ScrollController controller;
  final String keyword;
  final int listing;
  final String query;
  final int petTypeId;
  final String category;
  final String priceRange;
  final ProductListing parent;
  final searchFieldIsEmpty;
  final refreshed;
  final Function(dynamic) notifyParent;

  PaginatedProductListing({this.category='',this.priceRange,this.petTypeId,this.refreshed,this.searchFieldIsEmpty,this.notifyParent,Key key,this.parent,this.query,this.listing,@required this.brandId,@required this.keyword,@required this.controller,@required this.future,@required this.orderBy}): super(key: key);
  @override
  _PaginatedProductListingState createState() => _PaginatedProductListingState();
}

class _PaginatedProductListingState extends State<PaginatedProductListing> {
  Future<List<PaginatedProduct>> products;
  var _service = PaginatedProductService();
  LoadMoreStatus loadMoreStatus = LoadMoreStatus.STABLE;
  ScrollController scrollController;
  List<Product> productsData;
  int currentPageNo = 1;
  CancelableOperation productOperation;
  String orderBy;
  bool _canFetchMore = true;
  bool refreshed;
  String _oldKeyword;

  @override
  void initState() {
    refreshed=widget.refreshed;
    orderBy = widget.orderBy;
    scrollController = widget.controller;
    scrollController.addListener(_scrollListener);
    super.initState();
  }



   void checkListingScenario(){


    if(refreshed!=widget.refreshed || widget.orderBy!=widget.orderBy || !widget.searchFieldIsEmpty && _oldKeyword != widget.keyword){

      currentPageNo=1;

      /*
      =====Check Listing Scenario====
      This method checks for the following scenarios and then resets currentPageNo to 1 and _canFetchMore to true.
      1-If user had refreshed the page.
      2-If user has changed the orderBy
      3-If user has searched a different search query than previous one when using search since last pagination

      In all the above cases currentPageNo resets to 1 because new product is fetched from api and list is rest
      */

      //
      refreshed = widget.refreshed;
      _oldKeyword=widget.keyword;
      orderBy = widget.orderBy;

    }
  }


  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("bottom");

      if(refreshed!=widget.refreshed || widget.orderBy!=widget.orderBy || !widget.searchFieldIsEmpty && _oldKeyword != widget.keyword){
        //OrderBy changed so list is new..more product can be fetched
        _canFetchMore=true;
      }



      if (loadMoreStatus != null &&
          loadMoreStatus == LoadMoreStatus.STABLE && _canFetchMore==true) {

        setState(() {
          loadMoreStatus = LoadMoreStatus.LOADING;
          widget.notifyParent(true);
          //Notify Listing page to show dotsIndicator as product is being loaded
        });


        checkListingScenario();



        productOperation = CancelableOperation.fromFuture(
            _handleListing(currentPageNo+1)
                .then((productsDataObject) {
              currentPageNo = productsDataObject[0].currentPage;
              setState(() {
                productsData.addAll(productsDataObject[0].product);
                loadMoreStatus = LoadMoreStatus.STABLE;
                _canFetchMore = productsDataObject[0].product.length > 0;
                //if length of new product returned is 0 it's end
                //and product cannot be fetched further
                widget.notifyParent(false); // product loaded stop indicator
              });
            }));

      }
    }

  }
  @override
  void dispose() {
    scrollController.dispose();
    if(productOperation != null) productOperation.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return SimpleFutureBuilder<List<PaginatedProduct>>.simplerSliver(
      context: context,
      future: widget.future,
        builder: (AsyncSnapshot<List<PaginatedProduct>> snapshot) {
          var _paginatedProducts = snapshot.data[0];
          productsData = _paginatedProducts.product;

          return _paginatedProducts.product.length > 0 ? SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, i) {
                    var product = _paginatedProducts.product[i];

                    return InkWell(
                      highlightColor: Colors.grey.shade200,
                      onTap: () {
                            CustomNavigator.navigateTo(context, ProductDetailPage(product: product,));
                      },

                      child: ProductListingWidget(
                        product: product,
                      ),
                    ) ;
                  },

                  childCount: _paginatedProducts.product.length

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




  void _productsByPet({int pageNo,int petTypeId,String category=''}){
    products = _service.getProducts(type: petTypeId,category: category,orderBy: widget.orderBy,pageNo: pageNo);
  }

  Future<List<PaginatedProduct>> _handleListing(int pageNo) async {
    if(widget.searchFieldIsEmpty){

      switch(widget.listing){
        case 0:
        // All Products
          products = _service.getProducts(orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 1:
        //Flash Deals
          products = _service.getProducts(flash: 'yes',orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 2:
        //Featured Products
          products = _service.getProducts(featured: 'yes',orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 3:
        //Pet Food
          products = _service.getProducts(category: 'pet-food',orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 4:
        //Pet Accessories
          products = _service.getProducts(category: 'pet-accessories',orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 5:
        //Featured Pet Food
          products = _service.getProducts(category: 'pet-food',featured: 'yes',orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 6:
        //Featured Pet Accessories
          products = _service.getProducts(category: 'pet-accessories',featured: 'yes',orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 7:
        //Popular Products
          products = _service.getProducts(popular: 'yes',orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 9:
        //Products By Brand
          products = _service.getProducts(brandId: widget.brandId,orderBy: widget.orderBy,pageNo: pageNo);
          break;
        case 10:
        //Products By Pet
          _productsByPet(petTypeId: widget.petTypeId,category: widget.category,pageNo: pageNo);
          break;
        case 11:
        //Filters
          products = _service.getProducts(keyword: widget.query,
              category: widget.category,
              priceRange: widget.priceRange,
              type: widget.petTypeId,orderBy: widget.orderBy,pageNo: pageNo);
      }
    }else{
      products = _service.getProducts(keyword: widget.keyword,orderBy: widget.orderBy,pageNo: pageNo);
    }

    return products;

  }



}


