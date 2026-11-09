import 'package:satri/domain/entities/base/paginated_response.dart';
import 'package:satri/domain/entities/product/product_entity.dart';

abstract class ProductLocalDataSource {
  Future<PaginatedResponse<ProductEntity>?> getProducts({required int page});
  Future<void> saveProducts({required int page, required PaginatedResponse<ProductEntity> response});
  Future<void> clear();
}
