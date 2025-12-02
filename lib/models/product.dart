class Product {
  int? id;
  String? name;
  double? price;
  String? image;
  int? categoryId;
  String? description;
  int? numberOfSeen;
  List<Map<String, dynamic>>? subImages;

  //  إضافة حقل كمية المنتج للسلة
  int amount = 1;

  Product({
    this.id,
    this.name,
    this.price,
    this.image,
    this.categoryId,
    this.description,
    this.numberOfSeen,
    this.subImages,
    this.amount = 1,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = double.tryParse(json['price'].toString()) ?? 0;
    image = json['image'];
    categoryId = json['categoryId'];
    description = json['description'];
    numberOfSeen = json['numberOfSeen'];
    if (json['subImages'] != null) {
      subImages = List<Map<String, dynamic>>.from(json['subImages']);
    }
    amount = json['amount'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['categoryId'] = categoryId;
    data['description'] = description;
    data['numberOfSeen'] = numberOfSeen;
    data['subImages'] = subImages;
    data['amount'] = amount;
    return data;
  }
}
