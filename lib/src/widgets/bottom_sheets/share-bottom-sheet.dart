import 'package:agent_pet/src/utils/dial-phone-or-sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class ShareBottomSheet extends StatelessWidget {

  final String slug;
  final bool product;
  ShareBottomSheet({this.slug,this.product=false});
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Share to",style: TextStyle(color: Colors.primaries[0],fontWeight: FontWeight.bold,fontSize: 15),),
                ),
                FlatButton(
                  splashColor: Colors.grey.shade200,
                  child: Text("Cancel",style: TextStyle(color: Colors.primaries[0]),),
                  onPressed: ()=> Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    SocialShareButton(name: 'link', color: Color(0xff25b7d3), onPressed: () {

                      Clipboard.setData( ClipboardData(text:  product ? "https://www.agentpet.com/pet-store/$slug" :
                      "https://www.agentpet.com/pet-detail/$slug"));
                      Navigator.of(context).pop();
                    }),
                    Text("Copy Link")

                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SocialShareButton(name: 'facebook', color: Color(0xff45619D), onPressed: () {
                      product ?
                      share("https://facebook.com/dialog/share?app_id=1793785197341700&href=https://www.agentpet.com/pet-store/$slug"):
                      share("https://facebook.com/dialog/share?app_id=1793785197341700&href=https://www.agentpet.com/pet-detail/$slug");
                    }),
                    Text("Facebook")
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SocialShareButton(name: 'twitter', color: Color(0xff55ACEE), onPressed: () {
                      product ? share("https://twitter.com/share?url=https://www.agentpet.com/pet-store/$slug"):
                      share("https://twitter.com/share?url=https://www.agentpet.com/pet-detail/$slug");
                    }),
                    Text("Twitter")

                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(

                  children: <Widget>[
                    SocialShareButton(name: 'whatsapp', color: Color(0xffF3aaf66), onPressed: () {
                      product ?  share("whatsapp://send?text=https://www.agentpet.com/pet-store/$slug"):
                      share("whatsapp://send?text=https://www.agentpet.com/pet-detail/$slug");
                    }),
                    Text("Whatsapp")
                  ],
                ),
              ),

            ],
          ),
          SizedBox(height: 10,),


        ],
      ),
    );
  }
}



class SocialShareButton extends MaterialButton {
  SocialShareButton({
    String name,
    Color color,
    Function onPressed,
  }): super(
      elevation: 0,
      height: 45,
      highlightElevation: 0,
      child: Row(children: <Widget>[
        Image.asset('assets/social/$name-logo.png', height: 25),
      ], mainAxisAlignment: MainAxisAlignment.center),
      minWidth: 0,
      shape: CircleBorder(),
      color: color,
      onPressed: onPressed
  );
}
