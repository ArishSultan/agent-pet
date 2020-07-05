import 'package:agent_pet/src/models/_model.dart';
import 'package:agent_pet/src/models/address.dart';

class Order extends Model{
  int id;
  String reference;
  int userId;
  int addressId;
  String payment;
  String shippingMethod;
  int shippingCost;
  String discounts;
  String totalProducts;
  String tax;
  String total;
  String totalPaid;
  String invoice;
  String labelUrl;
  String trackingNumber;
  String shippingService;
  String trackingUrl;
  String shippingNote;
  String productName;
  String productPrice;
  int quantity;
  String additionalInfo;
  int status;
  String createdAt;
  String updatedAt;
//  Address address;

  Order(
      {this.id,
        this.reference,
        this.userId,
        this.addressId,
        this.payment,
        this.shippingMethod,
        this.shippingCost,
        this.discounts,
        this.totalProducts,
        this.tax,
        this.total,
        this.totalPaid,
        this.invoice,
        this.labelUrl,
        this.trackingNumber,
        this.shippingService,
        this.trackingUrl,
        this.shippingNote,
        this.additionalInfo,
        this.status,
        this.createdAt,
        this.productPrice,
        this.updatedAt,
//        this.address,
        this.quantity,this.productName}):super(id);

  Order.fromJson(Map<String, dynamic> json) : this (
    id : json['id'],
    reference : json['reference'],
    userId : json['user_id'],
    addressId : json['address_id'],
    payment : json['payment'],
    shippingMethod : json['shipping_method'],
    shippingCost : json['shipping_cost'],
    productName : json['product_name']!=null ? json['product_name'] : '',
    productPrice : json['product_price']!=null ? json['product_price'] : '',
    discounts : json['discounts'],
    quantity : json['quantity']!=null ? json['quantity'] : '',
    totalProducts : json['total_products'],
    tax : json['tax'],
    total : json['total'],
    totalPaid : json['total_paid'],
    invoice : json['invoice'],
    labelUrl : json['label_url'],
    trackingNumber : json['tracking_number'],
    shippingService : json['shipping_service'],
    trackingUrl : json['tracking_url'],
    shippingNote : json['shipping_note'],
    additionalInfo : json['additional_info'],
    status : json['status'],
    createdAt : json['created_at'],
    updatedAt : json['updated_at'],
//    address : json['address'] != null ?  Address.fromJson(json['address']) : null,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reference'] = this.reference;
    data['user_id'] = this.userId;
    data['address_id'] = this.addressId;
    data['payment'] = this.payment;
    data['shipping_method'] = this.shippingMethod;
    data['shipping_cost'] = this.shippingCost;
    data['discounts'] = this.discounts;
    data['total_products'] = this.totalProducts;
    data['tax'] = this.tax;
    data['total'] = this.total;
    data['total_paid'] = this.totalPaid;
    data['invoice'] = this.invoice;
    data['quantity'] = this.quantity;
    data['product_name'] = this.productName;
    data['label_url'] = this.labelUrl;
    data['tracking_number'] = this.trackingNumber;
    data['shipping_service'] = this.shippingService;
    data['tracking_url'] = this.trackingUrl;
    data['shipping_note'] = this.shippingNote;
    data['additional_info'] = this.additionalInfo;
    data['status'] = this.status;
    data['product_price'] = this.productPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
//    if (this.address != null) {
//      data['address'] = this.address.toJson();
//    }
    return data;
  }
}



