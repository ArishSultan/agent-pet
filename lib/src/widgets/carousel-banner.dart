import 'package:agent_pet/src/pages/products-listing/product-listing_page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
 final List<String> images;

  Carousel(this.images);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  PageController _controller =  PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
  }

  void _animateSlider() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      if(this.mounted){
        int nextPage = _controller.page.round() + 1;

        if (nextPage == this.widget.images.length) {
          nextPage = 0;
        }
        _controller
            .animateToPage(nextPage, duration: Duration(seconds: 1), curve: Curves.easeIn)
            .then((_) => _animateSlider());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        switch(_currentPage){
          case 0:
            CustomNavigator.navigateTo(context, ProductListing(listing: 10,petName: 'Dog',category: 'pet-food',petTypeId: 2,));
            break;
          case 1:
            CustomNavigator.navigateTo(context, ProductListing(listing: 10,petName: 'Bird',category: 'pet-food',petTypeId: 6,));
            break;
          case 2:
            CustomNavigator.navigateTo(context, ProductListing(listing: 10,petName: 'Fish',category: 'pet-food',petTypeId: 3,));
            break;
          case 3:
            CustomNavigator.navigateTo(context, ProductListing(listing: 10,petName: 'Cat',category: 'pet-food',petTypeId: 1,));
            break;
          default:
            break;
        }
      },
      child: Container(
          height: 120,
          child:
          Stack(children: [
            PageView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: this.widget.images.length,
              onPageChanged: (page) => setState(() => this._currentPage = page ),
              itemBuilder: (context, index) => ConstrainedBox(
                constraints: BoxConstraints.expand(),
//              child: this.widget.images[index],
                child: Image.asset(this.widget.images[index]),
              ),
            ),


            Positioned.fill(
              top: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(this.widget.images.length, (val) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      width: 5, height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: val == _currentPage? Colors.primaries[0]: Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
            )

          ])
      ),
    );
  }
}
