import 'package:santri/domain/entities/product/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.purchasePrice,
    required super.sellingPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      purchasePrice: json['purchasePrice'],
      sellingPrice: json['sellingPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      purchasePrice: purchasePrice,
      sellingPrice: purchasePrice,
    );
  }
}
