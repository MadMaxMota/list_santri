import 'package:satri/domain/entities/base/paginated_response.dart';
import 'package:satri/domain/entities/product/product_entity.dart';

abstract class ProductRemoteDataSource {
  Future<PaginatedResponse<ProductEntity>> getProduct({required int currentPage});
  Future<void> addProduct({required ProductEntity product});
}
