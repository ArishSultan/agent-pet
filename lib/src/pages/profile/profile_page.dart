import 'package:agent_pet/src/models/user.dart';
import 'package:agent_pet/src/pages/profile/messages_page.dart';
import 'package:agent_pet/src/pages/profile/my-ads_page.dart';
import 'package:agent_pet/src/pages/profile/saved_ads-page.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/user-service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/date-formatter.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/loading-builder.dart';
import 'package:flutter/material.dart';
import 'edit-profile_page.dart';
import 'manage-address_page.dart';
import 'my-orders_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  Future<User> _userProfile;
  var _userService = UserService();
  var refreshKey = GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {
    super.initState();
      LocalData.reloadProfile();
  }

  Text _headerText(final String name) {
    return Text(name, style: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.bold
    ));
  }
  Text _titleText(final String title) {
    return Text(title, style: TextStyle(fontWeight: FontWeight.bold));
  }
  Widget _action(final String name, IconData icon, Function() onPressed) {
    final size = MediaQuery.of(context).size.width / 5 - 20;

    return Column(children: <Widget>[
      InkWell(child: Container(
        width: size,
        height: size,
        child: Center(child: Icon(icon, color: Colors.white)),
        decoration: BoxDecoration(color: Colors.accents[0], borderRadius: BorderRadius.circular(size / 2)),
      ), onTap: onPressed),
      SizedBox(height: 5),
      Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 11))
    ]);
  }

  @override
  Widget build(BuildContext context) {


    return RefreshIndicator(
      key: refreshKey,
      color: Colors.primaries[0],
      onRefresh: () async {
        await LocalData.reloadProfile();
         setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Profile"),),
        body: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// AppBar Section.
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(65)
                  ),
                  child: Stack(children: <Widget>[
                    Container(
                      width: 140.0,
                      height: 140.0,
                      decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.primaries[0])
                      ),
                      child: LocalData.user.photo.isEmpty ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/icons/user.png',height: 140,width: 140,),
                      ) : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          Service.getConvertedImageUrl(LocalData.user.photo),
                          fit: BoxFit.cover,
                            loadingBuilder: circularImageLoader
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.8, 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: RaisedButton(
                            padding: EdgeInsets.zero,
                            child: Icon(Icons.edit, size: 15),
                            onPressed: () async {
                             var _edit = await CustomNavigator.navigateTo(context, EditProfile());
                            _edit!=null ?  refreshKey.currentState.show() : null;
                            }
                          ),
                        ),
                      )
                    ),
                  ]),
                ),
              ),
              SizedBox(height: 10),
              Center(child: Text(LocalData.user.name, style: TextStyle(fontSize: 17))),

              SizedBox(height: 30),
              Row(children: <Widget>[
                _action("Edit Address", Icons.edit, () async {
                  var _edit = await CustomNavigator.navigateTo(context, ManageAddressPage());
                  _edit!=null ?  refreshKey.currentState.show() : null;
                  }),
                _action("My Ads", Icons.pets, () {
                CustomNavigator.navigateTo(context,  MyAds());
                }),
                _action("Favorites", Icons.favorite, () {
                CustomNavigator.navigateTo(context, SavedAds());
                }),
                _action("Messages", Icons.mail_outline, () {
                CustomNavigator.navigateTo(context, MessagesPage());
                }),
                _action("Orders", Icons.description, () {
                CustomNavigator.navigateTo(context,  MyOrders());
                }),
              ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
              SizedBox(height: 30),

              /// Details Section.
              _headerText("Profile"),
              Divider(thickness: 1),

              SizedBox(height: 4),
              _titleText("Full Name"),
              SizedBox(height: 4),
              Text(LocalData.user.name),
              SizedBox(height: 16),

              _titleText("Email"),
              SizedBox(height: 4),
              Text(LocalData.user.email),
              SizedBox(height: 16),

              LocalData.user.gender.isNotEmpty ?
              Column(children: <Widget>[
                _titleText("Gender"),
                SizedBox(height: 4),
                Text(LocalData.user.gender),
                SizedBox(height: 16),
              ],)
             : SizedBox(),

              LocalData.user.dateOfBirth!=null ?
              Column(
                children: <Widget>[
                  _titleText("Date of Birth"),
                  SizedBox(height: 4),
                  Text(getFormattedDate(LocalData.user.dateOfBirth.toIso8601String())),
                  SizedBox(height: 16),
                ],
              ) : SizedBox(),


              _titleText("Phone"),
              SizedBox(height: 4),
              Text(LocalData.user.phone),
              SizedBox(height: 16),

//              _headerText("Address"),
//              Divider(thickness: 1),


              LocalData.user.city.isNotEmpty ?
              Column(
                children: <Widget>[
                  _titleText("City"),
                  SizedBox(height: 4),
                  Text(LocalData.user.city),
                  SizedBox(height: 16),
                ],
              ) : SizedBox(),

              LocalData.user.address.isNotEmpty ?
              Column(
                children: <Widget>[
                  _titleText("Address"),
                  SizedBox(height: 4),
                  Text(LocalData.user.address),
                  SizedBox(height: 16),
                ],
              ) : SizedBox(),

              LocalData.user.zipCode.isNotEmpty ?
              Column(
                children: <Widget>[
                  _titleText("Zip Code"),
                  SizedBox(height: 4),
                  Text(LocalData.user.zipCode),
                  SizedBox(height: 16),
                ],
              )  : SizedBox(),

            ],
          ),
        )),
      ),
    );
  }
}

//final String url = "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";
//
//class CustomAppBar extends StatefulWidget
//    with PreferredSizeWidget {
//
//  @override
//  _CustomAppBarState createState() => _CustomAppBarState();
//
//  @override
//  Size get preferredSize => Size(double.infinity, 320);
//}
//
//class _CustomAppBarState extends State<CustomAppBar> {
//
//  @override
//  Widget build(BuildContext context) {
//    return ClipPath(
//      clipper: MyClipper(),
//      child: Container(
//        padding: EdgeInsets.only(top: 4),
//        decoration: BoxDecoration(
//          color: Colors.redAccent,
//          boxShadow: [
//            BoxShadow(
//              color: Colors.red,
//              blurRadius: 20,
//              offset: Offset(0, 0)
//            )
//          ]
//        ),
//        child: Column(
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: <Widget>[
//                Column(
//                  children: <Widget>[
//                    Container(
//                      width: 100,
//                      height: 100,
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          image: DecorationImage(
//                              fit: BoxFit.cover,
//                              image: NetworkImage(url)
//                          )
//                      ),
//                    ),
//                    SizedBox(height: 16,),
//                    Text(LocalData.user.name, style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 20
//                    ),)
//                  ],
//                ),
//
//                    Column(
//                      children: <Widget>[
//                        RaisedButton.icon(
//                            onPressed: (){
//
//                            }, icon: Icon(Icons.pets,size: 17,), label: Text("My Ads"),
//                          color: Colors.white,
//                          shape: StadiumBorder(),
//                        ),
//                        RaisedButton.icon(
//                          onPressed: (){
//
//                          }, icon: Icon(Icons.favorite,size: 17,), label: Text("Saved Pets"),
//                          color: Colors.white,
//                          shape: StadiumBorder(),
//                        ),
//
//                      ],
//                    ),
//
//
//                Column(
//                  children: <Widget>[
//                    RaisedButton.icon(
//                      onPressed: (){
//
//                      }, icon: Icon(Icons.mail_outline,size: 17,), label: Text("Messages"),
//                      color: Colors.white,
//                      shape: StadiumBorder(),
//                    ),
//                    RaisedButton.icon(
//                      onPressed: (){
//
//                      }, icon: Icon(Icons.description,size: 17,), label: Text("Orders"),
//                      color: Colors.white,
//                      shape: StadiumBorder(),
//                    ),
//                  ],
//                ),
//
//
//              ],
//            ),
//
//            SizedBox(height: 20,),
//             Padding(
//                  padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
//                  child: Transform.rotate(
//                    angle: (math.pi * 0.05),
//                    child: RaisedButton.icon(
//                      onPressed: () async {
//                        await CustomNavigator.navigateTo(context, ManageAddress());
//                        print("Came Back");
//                        setState(() {});
//                      }, icon: Icon(Icons.edit,size: 17,), label: Text("Manage Address"),
//                      color: Colors.white,
//                      shape: StadiumBorder(),
//                    ),
//                  ),
//              ),
//
//            Align(
//              alignment: Alignment.bottomRight,
//              child: Padding(
//                  padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
//                  child: Transform.rotate(
//                    angle: (math.pi * 0.05),
//                    child: RaisedButton.icon(
//                      onPressed: () async {
//                        await CustomNavigator.navigateTo(context, EditProfile());
//                        setState(() {});
//                      }, icon: Icon(Icons.edit,size: 17,), label: Text("Edit Profile"),
//                      color: Colors.white,
//                      shape: StadiumBorder(),
//                    ),
//                  ),
//              ),
//            ),
//            SizedBox(height: 20,),
//
//          ],
//        ),
//      ),
//    );
//  }
//}
//

//        ClipPath(
//          clipper: MyClipper(),
//          child: Container(
//            height: 320,
//            width: double.infinity,
//            padding: EdgeInsets.all(8),
//            color: Colors.primaries[0].withOpacity(0.96),
//
//            child: Column(children: <Widget>[
//              Row(children: <Widget>[
//                Container(
//                  width: 100,
//                  height: 100,
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.circular(50)
//                  ),
//                )
//              ])
//            ])
////            Column(children: <Widget>[
////              Row(
////                mainAxisAlignment: MainAxisAlignment.spaceAround,
////                children: <Widget>[
////                  Column(
////                    children: <Widget>[
////                      Container(
////                        width: 100,
////                        height: 100,
////                        decoration: BoxDecoration(
////                            shape: BoxShape.circle,
////                            image: DecorationImage(
////                              fit: BoxFit.cover,
////                              image: NetworkImage('')
////                            )
////                        ),
////                      ),
////                      SizedBox(height: 16,),
////                      Text(LocalData.user.name, style: TextStyle(
////                          color: Colors.white,
////                          fontSize: 20
////                      ),)
////                    ],
////                  ),
////
////                      Column(
////                        children: <Widget>[
////                          RaisedButton.icon(
////                              onPressed: (){
////
////                              }, icon: Icon(Icons.pets,size: 17,), label: Text("My Ads"),
////                            color: Colors.white,
////                            shape: StadiumBorder(),
////                          ),
////                          RaisedButton.icon(
////                            onPressed: (){
////
////                            }, icon: Icon(Icons.favorite,size: 17,), label: Text("Saved Pets"),
////                            color: Colors.white,
////                            shape: StadiumBorder(),
////                          ),
////
////                        ],
////                      ),
////
////
////                  Column(
////                    children: <Widget>[
////                      RaisedButton.icon(
////                        onPressed: (){
////
////                        }, icon: Icon(Icons.mail_outline,size: 17,), label: Text("Messages"),
////                        color: Colors.white,
////                        shape: StadiumBorder(),
////                      ),
////                      RaisedButton.icon(
////                        onPressed: (){
////
////                        }, icon: Icon(Icons.description,size: 17,), label: Text("Orders"),
////                        color: Colors.white,
////                        shape: StadiumBorder(),
////                      ),
////                    ],
////                  ),
////
////
////                ],
////              ),
////
////              SizedBox(height: 20,),
////               Padding(
////                    padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
////                    child: Transform.rotate(
////                      angle: (math.pi * 0.05),
////                      child: RaisedButton.icon(
////                        onPressed: () async {
////                          await CustomNavigator.navigateTo(context, ManageAddress());
////                          print("Came Back");
////                          setState(() {});
////                        }, icon: Icon(Icons.edit,size: 17,), label: Text("Manage Address"),
////                        color: Colors.white,
////                        shape: StadiumBorder(),
////                      ),
////                    ),
////                ),
////
////              Align(
////                alignment: Alignment.bottomRight,
////                child: Padding(
////                    padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
////                    child: Transform.rotate(
////                      angle: (math.pi * 0.05),
////                      child: RaisedButton.icon(
////                        onPressed: () async {
////                          await CustomNavigator.navigateTo(context, EditProfile());
////                          setState(() {});
////                        }, icon: Icon(Icons.edit,size: 17,), label: Text("Edit Profile"),
////                        color: Colors.white,
////                        shape: StadiumBorder(),
////                      ),
////                    ),
////                ),
////              ),
////              SizedBox(height: 20,),
////
////            ],
////          ),
//        ),
//      ),

//class MyClipper extends CustomClipper<Path>{
//
//  @override
//  Path getClip(Size size) => Path()
//    ..lineTo(0, size.height - 70)
//    ..lineTo(size.width, size.height)
//    ..lineTo(size.width, 0)
//    ..close();
//
//  @override
//  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
//}
