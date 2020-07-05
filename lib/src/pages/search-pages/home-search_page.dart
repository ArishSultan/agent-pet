import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/search-tile.dart';
import 'package:flutter/material.dart';
import '../products-listing/product-listing_page.dart';

class HomeSearchPage extends StatefulWidget {
  @override
  _HomeSearchPageState createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage>with SingleTickerProviderStateMixin {

  var _keyword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              titleSpacing: 0,

              actions: <Widget>[
                SizedBox(width: 20,)
              ],
              title: TextFormField(
                controller: _keyword,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                onFieldSubmitted: (value){
                  CustomNavigator.navigateTo(context, PetListing(query: value,listing: 3,));
                },
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,color: Colors.white,),
                  suffixIcon: IconButton(icon: Icon(Icons.clear),color: Colors.white,
                    onPressed: (){
                      _keyword.clear();
                    },),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.search,
              ),
            ),

            SliverToBoxAdapter(
                child: SearchTiles()
            )
          ],
        ),
      ),
    );
  }
}



class SearchTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchTileItem(image: "buy-sell-pets.png",text:'Buy & Sell Pets online In Pakistan',color: Colors.blueGrey,onPressed: (){
          CustomNavigator.navigateTo(context, PetListing(listing: 0,));
        }),
        SearchTileItem(image:"adopt-pets.png",text:'Find Pets For Adoption / Match Making',color: Colors.amber,onPressed: (){
          CustomNavigator.navigateTo(context, PetListing(listing: 1,));

        }),
        SearchTileItem(image:"pet-food.png",text:'Best pet foods from your favorite brand',color:Color(0xFF49c5b7),onPressed: (){
          CustomNavigator.navigateTo(context, ProductListing(listing: 3));
        }),
        SearchTileItem(image:"pet-accessories.png",text:'Best pet accessories from your favorite brand',color:Color(0xFFe6c043),onPressed: (){
          CustomNavigator.navigateTo(context, ProductListing(listing: 4));
        }),

      ],
    );
  }
//
//  Widget SearchTileItem({String image,String text,Color color,Function onPressed}){
//    return Padding(
//      padding: const EdgeInsets.symmetric(vertical:5.0,horizontal: 10),
//      child: Card(
//        shape: ContinuousRectangleBorder(),
//        child: Padding(
//          padding: const EdgeInsets.symmetric(vertical:15.0),
//          child: ListTile(
//            contentPadding: EdgeInsets.all(0),
//            trailing: Icon(Icons.navigate_next),
//            leading: CircleAvatar(
//              backgroundColor: color,
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Image.asset("assets/icons/$image"),
//              ),),
//             title: Text(text),
//            onTap: onPressed
//          ),
//        ),
//      ),
//    );
//  }
}
