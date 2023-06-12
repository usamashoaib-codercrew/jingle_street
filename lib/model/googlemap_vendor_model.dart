class GoogleMapVendors {
  final String? location;
  final int? createdAt;
  final int? updatedAt;
  final String? id;
  final String? userId;
  final String? hashtags;
  final String? address;
  final double? longitude;
  final double? latitude;
  final String? businessname;
  final String? profilepic;
  final int? type;

  GoogleMapVendors({
    this.location,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.userId,
    this.hashtags,
    this.address,
    this.longitude,
    this.latitude,
    this.businessname,
    this.profilepic,
    this.type,
  });

  GoogleMapVendors.fromJson(Map<String, dynamic> json)
      : location = json['location'] as String?,
        createdAt = json['createdAt'] as int?,
        updatedAt = json['updatedAt'] as int?,
        id = json['id'] as String?,
        userId = json['user_id'] as String?,
        hashtags = json['hashtags'] as String?,
        address = json['address'] as String?,
        longitude = json['longitude'] as double?,
        latitude = json['latitude'] as double?,
        businessname = json['businessname'] as String?,
        profilepic = json['profilepic'] as String?,
        type = json['type'] as int?;

  Map<String, dynamic> toJson() => {
    'location' : location,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt,
    'id' : id,
    'user_id' : userId,
    'hashtags' : hashtags,
    'address' : address,
    'longitude' : longitude,
    'latitude' : latitude,
    'businessname' : businessname,
    'profilepic' : profilepic,
    'type' : type
  };
}