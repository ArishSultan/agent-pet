import '_model.dart';

class RatingsCount extends Model {
  int i1;
  int i2;
  int i3;
  int i4;
  int i5;
  int total;

  RatingsCount({this.i1, this.i2, this.i3, this.i4, this.i5}): total = i1 + i2 + i3 + i4 + i5, super(0);

  RatingsCount.fromJson(Map<String, dynamic> json) : this (
    i1 : int.parse(json['1'].toString()),
    i2 : int.parse(json['2'].toString()),
    i3 : int.parse(json['3'].toString()),
    i4 : int.parse(json['4'].toString()),
    i5 : int.parse(json['5'].toString()),

  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.i1;
    data['2'] = this.i2;
    data['3'] = this.i3;
    data['4'] = this.i4;
    data['5'] = this.i5;
    return data;
  }
}