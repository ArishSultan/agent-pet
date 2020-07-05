import 'package:agent_pet/src/models/_model.dart';

//class PetsAndVetsShop extends Model {
//  int currentPage;
//  List<ShopData> data;
//  String firstPageUrl;
//  int from;
//  int lastPage;
//  String lastPageUrl;
//  String nextPageUrl;
//  String path;
//  int perPage;
//  String prevPageUrl;
//  int to;
//  int total;
//
//  PetsAndVetsShop(
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
//        this.total}) : super(0);
//
//  PetsAndVetsShop.fromJson(Map<String, dynamic> json) : this (
//  currentPage : json['current_page'],
//  data: (json['data'] as List)
//        ?.map((i) => ShopData.fromJson(i))
//      ?.toList(),
//  firstPageUrl : json['first_page_url'],
//  from : json['from'],
//  lastPage : json['last_page'],
//  lastPageUrl : json['last_page_url'],
//  nextPageUrl : json['next_page_url'],
//  path : json['path'],
//  perPage : json['per_page'],
//  prevPageUrl : json['prev_page_url'],
//  to : json['to'],
//  total : json['total'],
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

class PetsAndVetsShop extends Model {
  int id;
  String name;
  String type;
  String lat;
  String lng;
  String city;
  String country;
  String address;
  String phone;
  String openAt;
  String closeAt;
  String rating;
  String image;
  String createdAt;
  String updatedAt;

  PetsAndVetsShop(
      {this.id,
        this.name,
        this.type,
        this.lat,
        this.lng,
        this.city,
        this.country,
        this.address,
        this.phone,
        this.openAt,
        this.closeAt,
        this.rating,
        this.image,
        this.createdAt,
        this.updatedAt}):super(id);

  PetsAndVetsShop.fromJson(Map<String, dynamic> json) : this (
    id : json['id'],
    name : json['name'],
    type : json['type'],
    lat : json['lat'],
    lng : json['lng'],
    city : json['city'],
    country : json['country'],
    address : json['address'],
    phone : json['phone'],
    openAt : json['open_at'],
    closeAt : json['close_at'],
    rating : json['rating'],
    image : json['image'],
    createdAt : json['created_at'],
    updatedAt : json['updated_at'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['city'] = this.city;
    data['country'] = this.country;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['open_at'] = this.openAt;
    data['close_at'] = this.closeAt;
    data['rating'] = this.rating;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}