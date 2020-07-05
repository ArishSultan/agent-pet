import 'package:agent_pet/src/models/_model.dart';
import 'package:agent_pet/src/models/brand.dart';
import 'package:agent_pet/src/models/comments.dart';

import 'product.dart';
import 'ratings-count.dart';

class ProductDetail extends Model {
  Product product;
//  List<ProductImage> images;
  RatingsCount ratingsCount;
  List<Comment> comments;
  List<Product> relatedProducts;
  Brand brand;
  ProductDetail ({this.product,this.comments,this.relatedProducts, this.ratingsCount,this.brand}):super(0);

  ProductDetail .fromJson(Map<String, dynamic> json) : this (
    product : json['product'] != null ? new Product.fromJson(json['product']) : null,
    comments: (json['productComments'] as List)
        ?.map((i) => Comment.fromJson(i))
        ?.toList(),
    relatedProducts: (json['relatedProducts'] as List)
        ?.map((i) => Product.fromJson(i))
      ?.toList(),
//    images: (json['images'] as List)
//        ?.map((i) => ProductImage.fromJson(i))
//        ?.toList(),
    ratingsCount : json['ratingsCount'] != null ? RatingsCount.fromJson(json['ratingsCount']) : null,
    brand : json['brand'] != null ? Brand.fromJson(json['brand']) : null,
  );

  Map<String, dynamic> toJson() => {
    'product': this.product?.toJson(),
    'productComments': this.comments?.map((v) => v.toJson())?.toList(),
//    'images': this.images?.map((v) => v.toJson())?.toList(),
    'ratingsCount': this.ratingsCount?.toJson()
  };
}