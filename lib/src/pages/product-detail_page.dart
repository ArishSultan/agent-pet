import 'package:agent_pet/src/models/order-item.dart';
import 'package:agent_pet/src/models/product-attributes.dart';
import 'package:agent_pet/src/models/product-detail.dart';
import 'package:agent_pet/src/models/product.dart';
import 'package:agent_pet/src/models/ratings-count.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/product-detail-service.dart';
import 'package:agent_pet/src/widgets/badge.dart';
import 'package:agent_pet/src/widgets/bottom_sheets/share-bottom-sheet.dart';
import 'package:agent_pet/src/widgets/carousel-banner.dart';
import 'package:agent_pet/src/widgets/cart-badged-icon.dart';
import 'package:agent_pet/src/widgets/favorite-button.dart';
import 'package:agent_pet/src/widgets/loading-builder.dart';
import 'package:agent_pet/src/widgets/local-favorite-button.dart';
import 'package:agent_pet/src/widgets/ratings-bars.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:share/share.dart';
import 'cart/main-cart.dart';
import 'products-listing/product-listing_page.dart';
import 'package:html/parser.dart';
//here goes the function


class ProductDetailPage extends StatefulWidget {
  final Product product;
  ProductDetailPage({@required this.product});

  @override
  createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  bool allowCart = false;
  ScrollController _controller;
  bool silverCollapsed = false;
  int _selectedQty = 1;
  Attributes _selectedAttribute;
  TabController _tabController;
  Future<List<ProductDetail>> _productDetail;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RatingsCount _count;
  final _service = ProductDetailService();
  double descriptionLength;


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
    });
    _productDetail = _service.getProductDetail(
        "${widget.product.slug}-category-${widget.product.cat}-type-${widget.product.typeName}-${widget.product.id}");

    _productDetail.then((data) {
      if(this.mounted){
        setState(() {
//          if (data[0].product.attributes.length > 0)
//            this._selectedAttribute = data[0].product.attributes[0];
          this.allowCart = true;
          this._count = data[0].ratingsCount;
        });
      }

    });

    this._tabController = TabController(length: 2, vsync: this);
  }


  List<String> _mobileBanners = [
    'assets/banners/dog-food.png',
    'assets/banners/cat-food.png',
    'assets/banners/bird-food.png',
    'assets/banners/fish-food.png',
  ];

  @override
  build(context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: widget.product.quantity > 0 ? allowCart
              ?  Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width/2,
                height: 60,
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  shape: RoundedRectangleBorder(),
                  child: Text("Add to Cart",style: TextStyle(color: allowCart ? Colors.white : Colors.black),),
                  onPressed: () {
                    if(_selectedAttribute!=null || widget.product.attributes.isEmpty){
                      var item = OrderItem(
                          qty: _selectedQty,
                          product: widget.product,
                          selectedAttribute: _selectedAttribute
                      );

                      if (LocalData.canPurchase(item)) {
                        setState(() {
                          LocalData.addToCart(item);
                        });
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              "$_selectedQty x ${widget.product.name} added successfuly!"),
                          behavior: SnackBarBehavior.floating,
                          shape:RoundedRectangleBorder(),
                        ));
                      } else {
                        List<OrderItem> _products =
                        LocalData.getCart();
                        _products.forEach((prod) {

                          if (item.id == prod.id) {
                            setState(() {
                              prod.qty += _selectedQty;
                            });
                          }
                        });
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              "$_selectedQty x ${widget.product.name} added successfuly!"),
                          behavior: SnackBarBehavior.floating,
                          shape:RoundedRectangleBorder(),
                        ));
                      }
                    }else{
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Please select packing"),
                        behavior: SnackBarBehavior.floating,
                        shape:RoundedRectangleBorder(),
                      ));
                    }


                  },
                  color: Color(0xFF06b729),
                ),
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width/2,
                child: MaterialButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(),
                    child: Text("Buy Now",style: TextStyle(color: allowCart ? Colors.white : Colors.black)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Colors.primaries[0],
                    onPressed:  () {
                      if(_selectedAttribute!=null || widget.product.attributes.isEmpty){
                        var item = OrderItem(
                            qty: _selectedQty,
                            product: widget.product,
                            selectedAttribute: _selectedAttribute);

                        if (LocalData.canPurchase(item)) {
                          LocalData.addToCart(item);
                          CustomNavigator.navigateTo(
                              context, CartPage());
//                      ));
                        } else {
                          List<OrderItem> _products =
                          LocalData.getCart();
                          _products.forEach((prod) {
                            if (item.id == prod.id) {
                              prod.qty += _selectedQty;
                            }
                          });
                          CustomNavigator.navigateTo(
                              context, CartPage());
                        }
                        LocalData.likeChanged();
                      }

                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Please select packing"),
                        behavior: SnackBarBehavior.floating,
                        shape:RoundedRectangleBorder(),
                      ));
                    }
                ),
              ),
            ],
          ): SizedBox(): SizedBox(),
          body: NestedScrollView(
            controller: _controller,
            headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                title: silverCollapsed
                    ? Text(
                  widget.product.name,
                  style: TextStyle(color: Colors.black),
                )
                    : SizedBox(),
                expandedHeight: 250,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                pinned: true,
                backgroundColor: Colors.white,

                flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: <Widget>[
                        PageView.builder(
                          itemCount: widget.product.images.length,
                          itemBuilder: (context, index) => Image.network(
                              Service.getConvertedImageUrl(
                                  "storage/${widget.product.images[index].src}")),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 16,
                          child: FavoriteButton(
                            id: widget.product.id,
                            bordered: true,
                            isPetAd: false,
                          )
                        ),
                      ],
                    )),
                actions: [
                  CartBadgedIcon(white: false,),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                          child: Text(widget.product.name,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.primaries[0], fontSize: 22))),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child:  IconButton(

                          icon: Icon(Icons.share),
                          onPressed: () {
                            Share.share('https://www.agentpet.com/pet-store/${widget.product.slug}');

//                            showModalBottomSheet(
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.vertical(
//                                      top: Radius.circular(15.0)),
//                                ),
//                                context: context,
//                                builder: (context) => ShareBottomSheet(
//                                    slug: widget.product.slug,
//                                    product: true));
                          },
                        ),

                      )
                    ]),
                    SimpleFutureBuilder<List<ProductDetail>>.simpler(
                        context: context,
                        future: _productDetail,
                        builder: (AsyncSnapshot<List<ProductDetail>> snapshot) {
                          final _product = snapshot.data[0].product;
                          final _brand = snapshot.data[0].brand;
                          return Column(children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                    "PKR ${_product.attributes.length > 0 ? _product.attributePrice : _product.price}",
                                    style: TextStyle(fontSize: 18)),
                                Spacer(),

                              ],
                            ),
                            _product.attributes.length == 0
                                ? Container()
                                : DropdownButtonHideUnderline(
                                  child: Container(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                                      child: DropdownButton<Attributes>(
                              icon: Icon(Icons.arrow_drop_down_circle),
                              isExpanded: true,
                              hint: Text("Please select Packing"),
                              value: _selectedAttribute,
                              items: _product.attributes.map((attr) {
                                      return DropdownMenuItem<Attributes>(
                                        child: Text(
                                            "${attr.weight} G (PKR ${attr.price})"),
                                        value: attr,
                                      );
                              }).toList(),
                              onChanged: (val) => setState(
                                            () => this._selectedAttribute = val),
                                        iconDisabledColor: Colors.primaries[0],
                                        style: TextStyle(fontSize: 15,color: Colors.black),
                            ),
                                    ),
                                  ),
                                ),
                            widget.product.quantity > 1 ? Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: <Widget>[
                                  MaterialButton(
                                    minWidth: 0,
                                    onPressed: () => setState(() {
                                      if (this._selectedQty > 1)
                                        --_selectedQty;
                                    }),
                                    child: Icon(Icons.remove_circle),
                                  ),
                                  Text('$_selectedQty'),
                                  MaterialButton(
                                    child: Icon(Icons.add_circle),
                                    onPressed: () => setState(() {
                                      if (this._selectedQty <=
                                          _product.quantity) ++_selectedQty;
                                    }),
                                    minWidth: 0,
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: (){
                                      CustomNavigator.navigateTo(context, ProductListing(listing: 9,brandId: _brand.id,title: _brand.name));
                                    },
                                    child: Align(
                                      child: Card(
                                        elevation: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(height:30,width: 100,child: Image.network(Service.getConvertedImageUrl(_brand.image),loadingBuilder: circularImageLoader,)),
                                            Text("Go To Store", style: TextStyle(fontSize: 12,color: Colors.primaries[0])),
                                          ],
                                        ),
                                      ),
                                      alignment: Alignment.topRight,
                                    ),
                                  ),
                                ],
                              ),
                            ): SizedBox(),

                          ], crossAxisAlignment: CrossAxisAlignment.start);
                        }),
                    Divider(),
                  ], crossAxisAlignment: CrossAxisAlignment.start),
                ),
              ),

              SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10.0),
                    child: Table(children: [
                      TableRow(children: [
                        Text('Product Code',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.product.sku),
                        Text('Availability',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          widget.product.quantity > 0
                              ? 'In Stock : ${widget.product.quantity}'
                              : 'Out Of Stock',
                          style: TextStyle(
                              color: widget.product.quantity > 0
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ]),
                      TableRow(children: [
                        Text('Standard shipping time',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('2-4 days'),
                        Text('Fast shipping time',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('1-2 days'),
                      ]),
                      TableRow(children: [
                        Text('Warranty:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('100% Authentic'),
                        Text('Return',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('7 Days Return'),
                      ]),
                    ]),
                  )),
              SliverToBoxAdapter(
                child: Container(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TabBar(
                        indicator: BoxDecoration(color: Colors.grey.shade400),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Colors.grey,
                        tabs: <Widget>[
                          Tab(
                              child: Text("Product Features",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500))),
                          Tab(
                              child: Text("Reviews",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500))),
                        ],
                        controller: this._tabController,
                      ),
                    )),
              ),

            ];},
            body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Html(data: widget.product.description),
                            )),
                      ),

                      relatedProducts(),



                    ],
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: this._count != null
                                  ? ReviewCounter(count: this._count)
                                  : Container(),
                            )),
                      ),
                      relatedProducts(),

                    ],
                  ),
                ]),
            )),
    );
  }

  Widget relatedProducts(){
    return  Column(

      children: <Widget>[
        InkWell(
          onTap: (){
            CustomNavigator.navigateTo(context, ProductListing(listing: 10,
              petName: 'Dog',
              category: 'pet-food',petTypeId: 2,));
          },
            child: Image.asset(_mobileBanners[0])),

        SizedBox(height: 15),
        SectionHeader("Related Products"),

        SimpleFutureBuilder<List<ProductDetail>>.simpler(
            context: context,
            future: _productDetail,
            builder: (AsyncSnapshot<List<ProductDetail>> snapshot) {
              return snapshot.data.isNotEmpty ?  Container(
                height: 175,
                child: ListView.builder(
                    itemBuilder: (context, i) {
                      var _product = snapshot.data[0].relatedProducts[i];
                      return Material(
                        child: InkWell(
                          onTap: () {
                            CustomNavigator.navigateTo(
                                context,
                                ProductDetailPage(
                                  product: _product,
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
                                                "storage/${_product.cover}"),
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                            circularImageLoader),
                                      ),
                                      _product.isFeatured
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
                                      _product.name[0].toUpperCase() +
                                          _product.name.substring(1),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),

                              Text("PKR ${_product.price}",
                                  style: TextStyle(fontSize: 13,color: Colors.primaries[0])),
                            ]),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data[0].relatedProducts.length),
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
      ],
    );
  }
}
