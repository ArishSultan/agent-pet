import '_model.dart';
import 'product-attributes.dart';
import 'product-images.dart';

class Product extends Model {
  int typeId;
  int brandId;
  String sku;
  String name;
  String slug;
  String description;
  String cover;
  int quantity;
  String price;
  String salePrice;
  int normalShipping;
  int fastShipping;
  int freeShipping;
  bool featured;
  int status;
  int weight;
  String length;
  String width;
  String height;
  String distanceUnit;
  String massUnit;
  String createdAt;
  String updatedAt;
  bool isFeatured;
  int isFlashDeal;
  String cat;
  String typeName;
  String attributePrice;
  List<Attributes> attributes;
  List<ProductImage> images;

  Product({
    int id,
    this.typeId,
    this.brandId,
    this.sku,
    this.name,
    this.slug,
    this.description,
    this.cover,
    this.quantity,
    this.price,
    this.salePrice,
    this.normalShipping,
    this.fastShipping,
    this.freeShipping,
    this.featured,
    this.status,
    this.length,
    this.width,
    this.height,
    this.distanceUnit,
    this.weight,
    this.massUnit,
    this.createdAt,
    this.updatedAt,
    this.isFeatured,
    this.isFlashDeal,
    this.cat,
    this.typeName,
    this.attributePrice,
    this.attributes,
    this.images
  }): super(id);

  Product.fromJson(Map<String, dynamic> json): this(
    id: json['id'],
    typeId: Model.resolveInt(json['type_id'].toString()),
    brandId: Model.resolveInt(json['brand_id'].toString() == null? '0': json['brand_id'].toString()),
    sku: json['sku'],
    name: json['name'],
    slug: json['slug'],
    description: json['description'],
    cover: json['cover'],
    quantity: Model.resolveInt(json['quantity'].toString()),
    price: json['price'],
    salePrice: json['sale_price'],
    normalShipping: Model.resolveInt(json['normal_shipping'].toString()),
    fastShipping: Model.resolveInt(json['fast_shipping'].toString()),
    freeShipping: Model.resolveInt(json['free_shipping'].toString()),
    featured: Model.resolveInt(json['featured'].toString()) == 1,
    status: Model.resolveInt(json['status'].toString()),
    length: json['length'],
    width: json['width'],
    height: json['height'],
    distanceUnit: json['distance_unit'],
    weight : Model.resolveInt(json['weight'].toString()),
    massUnit: json['mass_unit'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    isFeatured: Model.resolveInt(json['is_featured'].toString()) == 1,
    isFlashDeal: Model.resolveInt(json['is_flash_deal'].toString()),
    cat: json['cat_slug'],
    typeName : json['type_name'],
    attributePrice : json['attribute_price'],
    attributes: (json['attributes'] as List)
        ?.map((i) => Attributes.fromJson(i))
        ?.toList(),
    images: (json['images'] as List)
        ?.map((i) => ProductImage.fromJson(i))
        ?.toList(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['brand_id'] = this.brandId;
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['cover'] = this.cover;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['sale_price'] = this.salePrice;
    data['normal_shipping'] = this.normalShipping;
    data['fast_shipping'] = this.fastShipping;
    data['free_shipping'] = this.freeShipping;
    data['featured'] = this.featured;
    data['status'] = this.status;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['distance_unit'] = this.distanceUnit;
    data['weight'] = this.weight;
    data['mass_unit'] = this.massUnit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_featured'] = this.isFeatured;
    data['is_flash_deal'] = this.isFlashDeal;
    data['cat_slug'] = this.cat;
    data['type_name'] = this.typeName;
    data['attributePrice'] = this.attributePrice;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    data['images'] = this.images?.map((v) => v.toJson())?.toList();
    return data;
  }
}