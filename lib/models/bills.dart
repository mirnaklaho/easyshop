class Bills {
  int? id;
  String? username;
  String? createdAt;
  String? state;
  double? total; //  عدّل هنا إلى double

  Bills({this.id, this.username, this.createdAt, this.state, this.total});

  Bills.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    createdAt = json['createdAt'];
    state = json['state'];
    total = json['total'] != null
        ? (json['total'] is num
        ? (json['total'] as num).toDouble()
        : double.tryParse(json['total'].toString()))
        : null;
    //  تحويل آمن
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['createdAt'] = createdAt;
    data['state'] = state;
    data['total'] = total;
    return data;
  }
}
