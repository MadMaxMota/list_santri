import 'package:santri/domain/entities/base/paginated_response.dart';
import 'package:santri/domain/entities/either_of/either_of.dart';
import 'package:santri/domain/entities/error/failure.dart';
import 'package:santri/domain/entities/product/product_entity.dart';

abstract class ProductRepository {
  Future<EitherOf<Failure, PaginatedResponse<ProductEntity>>> getProducts({
    required int page,
  });
  Future<EitherOf<Failure, void>> addProduct({required ProductEntity product});
}
