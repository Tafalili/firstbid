class Products {
Products({
String? id,
String? createdAt,
String? name,
String? description,
String? imageUrl,
num? currentPrice,
String? endDate,
String? categoryId,
bool? isFeatured, // Added isFeatured
}) {
_id = id;
_createdAt = createdAt;
_name = name;
_description = description;
_imageUrl = imageUrl;
_currentPrice = currentPrice;
_endDate = endDate;
_categoryId = categoryId;
_isFeatured = isFeatured; // Added isFeatured
}

Products.fromJson(dynamic json) {
_id = json['id'];
_createdAt = json['created_at'];
_name = json['name'];
_description = json['description'];
_imageUrl = json['image_url'];
_currentPrice = json['current_price'];
_endDate = json['end_date'];
_categoryId = json['category_id'];
_isFeatured = json['is_featured']; // Added isFeatured
}

String? _id;
String? _createdAt;
String? _name;
String? _description;
String? _imageUrl;
num? _currentPrice;
String? _endDate;
String? _categoryId;
bool? _isFeatured; // Added isFeatured

Products copyWith({
String? id,
String? createdAt,
String? name,
String? description,
String? imageUrl,
num? currentPrice,
String? endDate,
String? categoryId,
bool? isFeatured,
}) =>
Products(
id: id ?? _id,
createdAt: createdAt ?? _createdAt,
name: name ?? _name,
description: description ?? _description,
imageUrl: imageUrl ?? _imageUrl,
currentPrice: currentPrice ?? _currentPrice,
endDate: endDate ?? _endDate,
categoryId: categoryId ?? _categoryId,
isFeatured: isFeatured ?? _isFeatured,
);

String? get id => _id;
String? get createdAt => _createdAt;
String? get name => _name;
String? get description => _description;
String? get imageUrl => _imageUrl;
num? get currentPrice => _currentPrice;
String? get endDate => _endDate;
String? get categoryId => _categoryId;
bool? get isFeatured => _isFeatured; // Added isFeatured

Map<String, dynamic> toJson() {
final map = <String, dynamic>{};
map['id'] = _id;
map['created_at'] = _createdAt;
map['name'] = _name;
map['description'] = _description;
map['image_url'] = _imageUrl;
map['current_price'] = _currentPrice;
map['end_date'] = _endDate;
map['category_id'] = _categoryId;
map['is_featured'] = _isFeatured; // Added isFeatured
return map;
}
}
