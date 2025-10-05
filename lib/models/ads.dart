class Ads {
  String? id;
  String? image;
  String? productId;
  String? categoryId;

  Ads({this.id, this.image, this.productId, this.categoryId});

  // تحويل JSON إلى Ads مع التأكد من أن كل الحقول String
  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    image = json['image']?.toString();
    productId = json['product_id']?.toString();
    categoryId = json['category_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    return data;
  }
}
