import 'package:agent_pet/src/models/_model.dart';

///
///
//class Comments extends Model {
//  int currentPage;
//  List data;
//  String firstPageUrl;
//  String from;
//  int lastPage;
//  String lastPageUrl;
//  String nextPageUrl;
//  String path;
//  int perPage;
//  String prevPageUrl;
//  String to;
//  int total;
//
//  Comments(
//      {this.currentPage,
//        this.data,
//        this.firstPageUrl,
//        this.from,
//        this.lastPage,
//        this.lastPageUrl,
//        this.nextPageUrl,
//        this.path,
//        this.perPage,
//        this.prevPageUrl,
//        this.to,
//        this.total}):super(0);
//
//  Comments.fromJson(Map<String, dynamic> json): this (
//    currentPage : json['current_page'],
//    data: json['data'],
////    if (json['data'] != null) {
////      data = new List<Null>();
////      json['data'].forEach((v) {
////        data.add(new Null.fromJson(v));
////      });
////    }
//    firstPageUrl : json['first_page_url'],
//    from : json['from'],
//    lastPage : json['last_page'],
//    lastPageUrl : json['last_page_url'],
//    nextPageUrl : json['next_page_url'],
//    path : json['path'],
//    perPage : json['per_page'],
//    prevPageUrl : json['prev_page_url'],
//    to : json['to'],
//    total : json['total'],
//  );
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['current_page'] = this.currentPage;
//    if (this.data != null) {
//      data['data'] = this.data.map((v) => v.toJson()).toList();
//    }
//    data['first_page_url'] = this.firstPageUrl;
//    data['from'] = this.from;
//    data['last_page'] = this.lastPage;
//    data['last_page_url'] = this.lastPageUrl;
//    data['next_page_url'] = this.nextPageUrl;
//    data['path'] = this.path;
//    data['per_page'] = this.perPage;
//    data['prev_page_url'] = this.prevPageUrl;
//    data['to'] = this.to;
//    data['total'] = this.total;
//    return data;
//  }
//}



class Comment extends Model {
  int id;
  int userId;
  int productId;
  String name;
  String email;
  String description;
  int rating;
  String createdAt;
  String updatedAt;

  Comment({this.id, this.userId, this.productId, this.name, this.email, this.description, this.rating, this.createdAt, this.updatedAt}):super(id);

  Comment.fromJson(Map<String, dynamic> json) : this(
    id : json['id'],
    userId : json['user_id'],
    productId : int.parse(json['product_id'].toString()),
    name : json['name'],
    email : json['email'],
    description : json['description'],
    rating :  int.parse(json['rating'].toString()),
    createdAt : json['created_at'],
    updatedAt : json['updated_at'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}