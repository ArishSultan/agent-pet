import 'package:agent_pet/src/models/_model.dart';
import 'package:agent_pet/src/models/pet.dart';

class PaginatedPet extends Model{
  int currentPage;
  List<Pet> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  PaginatedPet(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total}) : super(0);

  PaginatedPet.fromJson(Map<String, dynamic> json) : this (
    data: (json['data'] as List)
        ?.map((i) => Pet.fromJson(i))
        ?.toList(),
    currentPage : json['current_page'],
      firstPageUrl : json['first_page_url'],
      from : json['from'],
      lastPage : json['last_page'],
      lastPageUrl : json['last_page_url'],
      nextPageUrl : json['next_page_url'],
      path : json['path'],
      perPage : json['per_page'],
      prevPageUrl : json['prev_page_url'],
      to : json['to'],
      total : json['total'],

  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}