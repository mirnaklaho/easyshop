class Offer {
  int? offerId;
  int? productId;
  String? name;
  String? image;
  String? description;
  String? oldPrice;
  String? newPrice;
  int? discount;

  Offer({
    this.offerId,
    this.productId,
    this.name,
    this.image,
    this.description,
    this.oldPrice,
    this.newPrice,
    this.discount,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      offerId: json['offerId'],
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      oldPrice: json['oldPrice']?.toString(),
      newPrice: json['newPrice']?.toString(),
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'productId': productId,
      'name': name,
      'image': image,
      'description': description,
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'discount': discount,
    };
  }
}
