import 'package:satri/domain/entities/base/paginated_response.dart';
import 'package:satri/domain/entities/either_of/either_of.dart';
import 'package:satri/domain/entities/error/failure.dart';
import 'package:satri/domain/entities/product/product_entity.dart';

abstract class ProductRepository {
  Future<EitherOf<Failure, PaginatedResponse<ProductEntity>>> getProducts({required int page});
  Future<EitherOf<Failure, void>> addProduct({required ProductEntity product});
}
