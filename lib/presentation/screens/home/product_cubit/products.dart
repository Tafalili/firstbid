import 'dart:convert';
/// id : "4102c1b7-95a5-4a8e-ba50-527bc935634e"
/// created_at : "2025-09-09T07:51:49.071444+00:00"
/// name : "harddisk"
/// description_en : "great hard disk"
/// description_ar : "قرص صلب رائع"
/// image_url : "https://inimqdnpyefpsbinlnfo.supabase.co/storage/v1/object/public/products/desktop-computer.jpg"
/// image_urls : ["url1","url2","url3"]
/// current_price : 1
/// end_date : "2025-09-09T11:51:26"
/// category_id : "07ff4304-4adb-4482-a7ff-138c4be39a5b"
/// is_featured : true
/// status : "Used"
/// serial_number : "SN123456"
/// original_price : 100

class Products {
  Products({
    String? id,
    String? createdAt,
    String? name,
    String? descriptionAr,
    String? descriptionEn,
    String? imageUrl,
    List<String>? imageUrls,
    num? currentPrice,
    String? endDate,
    String? categoryId,
    bool? isFeatured,
    String? status,
    String? serialNumber,
    num? originalPrice,
  }){
    _id = id;
    _createdAt = createdAt;
    _name = name;
    _descriptionAr = descriptionAr;
    _descriptionEn = descriptionEn;
    _imageUrl = imageUrl;
    _imageUrls = imageUrls;
    _currentPrice = currentPrice;
    _endDate = endDate;
    _categoryId = categoryId;
    _isFeatured = isFeatured;
    _status = status;
    _serialNumber = serialNumber;
    _original_price = originalPrice;
  }

  Products.fromJson(dynamic json) {
    _id = json['id'];
    _createdAt = json['created_at'];
    _name = json['name'];
    _descriptionAr = json['description_ar'];
    _descriptionEn = json['description_en'];
    _imageUrl = json['image_url'];
    if (json['image_urls'] != null) {
      _imageUrls = json['image_urls'].cast<String>();
    }
    _currentPrice = json['current_price'];
    _endDate = json['end_date'];
    _categoryId = json['category_id'];
    _isFeatured = json['is_featured'];
    _status = json['status'];
    _serialNumber = json['serial_number'];
    _original_price = json['original_price'];
  }
  String? _id;
  String? _createdAt;
  String? _name;
  String? _descriptionAr;
  String? _descriptionEn;
  String? _imageUrl;
  List<String>? _imageUrls;
  num? _currentPrice;
  String? _endDate;
  String? _categoryId;
  bool? _isFeatured;
  String? _status;
  String? _serialNumber;
  num? _original_price;
  Products copyWith({
    String? id,
    String? createdAt,
    String? name,
    String? descriptionAr,
    String? descriptionEn,
    String? imageUrl,
    List<String>? imageUrls,
    num? currentPrice,
    String? endDate,
    String? categoryId,
    bool? isFeatured,
    String? status,
    String? serialNumber,
    num? originalPrice,
  }) => Products(
    id: id ?? _id,
    createdAt: createdAt ?? _createdAt,
    name: name ?? _name,
    descriptionAr: descriptionAr ?? _descriptionAr,
    descriptionEn: descriptionEn ?? _descriptionEn,
    imageUrl: imageUrl ?? _imageUrl,
    imageUrls: imageUrls ?? _imageUrls,
    currentPrice: currentPrice ?? _currentPrice,
    endDate: endDate ?? _endDate,
    categoryId: categoryId ?? _categoryId,
    isFeatured: isFeatured ?? _isFeatured,
    status: status ?? _status,
    serialNumber: serialNumber ?? _serialNumber,
    originalPrice: originalPrice ?? _original_price,
  );
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get name => _name;
  String? get descriptionAr => _descriptionAr;
  String? get descriptionEn => _descriptionEn;
  String? get imageUrl => _imageUrl;
  List<String>? get imageUrls => _imageUrls;
  num? get currentPrice => _currentPrice;
  String? get endDate => _endDate;
  String? get categoryId => _categoryId;
  bool? get isFeatured => _isFeatured;
  String? get status => _status;
  String? get serialNumber => _serialNumber;
  num? get originalPrice => _original_price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['created_at'] = _createdAt;
    map['name'] = _name;
    map['description_ar'] = _descriptionAr;
    map['description_en'] = _descriptionEn;
    map['image_url'] = _imageUrl;
    map['image_urls'] = _imageUrls;
    map['current_price'] = _currentPrice;
    map['end_date'] = _endDate;
    map['category_id'] = _categoryId;
    map['is_featured'] = _isFeatured;
    map['status'] = _status;
    map['serial_number'] = _serialNumber;
    map['original_price'] = _original_price;
    return map;
  }

}
