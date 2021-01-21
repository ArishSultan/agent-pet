import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/widgets/appBar.dart';
import 'package:agent_pet/src/widgets/bullet-point-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class HowItWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgentPetAppbar(context,),

      body: ListView(
          children: <Widget>[
            Container(
              height: 100,
               decoration: BoxDecoration(

            image: DecorationImage(
            image: AssetImage("assets/about-us-banner-image.jpg"),colorFilter: ColorFilter.mode(Color.fromRGBO(0, 0, 0, 0.4), BlendMode.darken),fit: BoxFit.fitWidth,
                )
          ),
              child: Center(child: Text("How It Works",style: TextStyle(color: Colors.white,fontSize: 20),)),
            ),



                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Pet Adoption",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                        SizedBox(height: 20,),
                        Center(child: ClipRRect(child:
                        Image.asset(Assets.howItWorks1, scale: 3),
                        borderRadius: BorderRadius.circular(10),)) ,
                        SizedBox(height: 20,),

                        Text("For domestic animals mating is a very essential process that should be carried out with certain considerations like the perfect mate, health, timing and environment. With science progressing we now have artificial mating process as well that is said to be safer as compared to natural mating. But if you are up for pet adoption there is no better website than AgentPet.com. AgentPet.com has been created with the purpose of providing its customers the ultimate comfort of finding their pet a mate. On our website you will find:"
                          ,style: TextStyle(), ),
                        SizedBox(height: 6,),

                        bulletPoint(title: "Different breeds from all over the world."),
                        bulletPoint(title: "Medical history of your chosen pet for mating."),
                        SizedBox(height: 20,),

                        Text("Pet Buy/Sell",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                        SizedBox(height: 20,),

                        Center(child: ClipRRect(child:
                        Image.asset(Assets.howItWorks2 ,scale: 3),
                          borderRadius: BorderRadius.circular(10),)) ,
                        SizedBox(height: 20,),

                        Text("AgentPet.com is one of the most famous and profoundly used websites all over the world. We wholly welcome our users to advertise their pets who either want to sell or buy them. Among our many pages, pet buying and selling is the most visited. We have every section available on our page therefore, if you have a unique pet like crocodile, monkey, ferret, cow, hamster etc. you will find your desired section on our website and also your fellow companions who have the same interest in pets as yours."),
                        SizedBox(height: 10,),
                        Text("We have made dealing and transactions on our page very stress-free and uncomplicated. Simply advertise your pet by leaving some pictures and details that will attract the visitor towards your pet. You can contact the owner on his mentioned email or contact number."),
                        SizedBox(height: 10,),
                        Text("Our website and experts behind it will ascertain that there are no fake accounts or forged deals with the clients. Moreover, we have all the information of our every user that makes our website safer and spam-free. So log in right now to AgentPet.com and choose your pet!"),
                        SizedBox(height: 20,),

                        Text("Pet Relocaion Made Easy",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                        SizedBox(height: 20,),
                        Center(child: ClipRRect(child:
                        Image.asset(Assets.howItWorks3, scale: 3),
                          borderRadius: BorderRadius.circular(10),)) ,
                        SizedBox(height: 20,),
                        Text("Now along with your luggage you can move your pets too! You don’t have to say your good-byes or sell your beloved pets; all you have to do is contact our website Agentpet.com."),
                        SizedBox(height: 10,),

                        Text("AgentPet.com has the experience, awareness and the knowhow of transporting animals from one place to another. We believe in providing our customers with the best. We are very well aware that our client’s needs include security and the comfort of their pet during the journey we are famous almost everywhere."),
                        SizedBox(height: 15,),

                        Text("International Travelling",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                        SizedBox(height: 20,),
                        Text("The first and foremost requirement of AgentPet.com while moving your pet abroad is its passport with the required documents of your pet. The second requirement of our website is a vaccinated animal."),
                        SizedBox(height: 10,),
                        Text("If you are taking your pet on a trip or permanently somewhere it is very important to get it vaccinated. The most dangerous disease that a pet like cat, dog, ferret etc. can carry easily is rabies. So, our website strictly requests a vaccinated pet to move along with a certificate of vaccination. Lastly, our website requests an allowance certificate from your veterinarian that claims that it is safe for your pet to fly."),
                        SizedBox(height: 10,),

                        Text("International Pet Transportation Service Overview",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                        SizedBox(height: 20,),
                        bulletPoint(title: "Dedicated team of multilingual experienced and knowledgeable specialists."),
                        bulletPoint(title: "Full consultation on animal import and export regulations."),
                        bulletPoint(title: "Veterinary and travel document compliance review."),
                        bulletPoint(title: "Preparation and submission of all necessary documentation (i.e. pet animal import license)."),
                        bulletPoint(title: "Coordinate quality, comfortable travel crates - custom made to suit individual pets."),
                        bulletPoint(title: "Consultation and planning of routing and transport options."),
                        bulletPoint(title: "Sourcing of multilingual veterinarians."),
                        Divider(thickness: 2,),
                      ],
                    ),
                  ),


          ],
        ),
    );
  }


}
