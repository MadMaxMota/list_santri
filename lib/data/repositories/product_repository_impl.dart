import 'package:santri/data/data_sources/local/product_local_data_source.dart';
import 'package:santri/data/data_sources/remote/apis/product_remote_data_source.dart';
import 'package:santri/domain/entities/base/paginated_response.dart';
import 'package:santri/domain/entities/either_of/either_of.dart';
import 'package:santri/domain/entities/error/exceptions.dart';
import 'package:santri/domain/entities/error/failure.dart';
import 'package:santri/domain/entities/product/product_entity.dart';
import 'package:santri/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<EitherOf<Failure, PaginatedResponse<ProductEntity>>> getProducts({
    required int page,
  }) async {
    try {
      final PaginatedResponse<ProductEntity>? cachedResponse =
          await localDataSource.getProducts(page: page);

      if (cachedResponse != null) {
        return right(cachedResponse);
      }

      final PaginatedResponse<ProductEntity> remoteResponse =
          await remoteDataSource.getProduct(currentPage: page);

      await localDataSource.saveProducts(page: page, response: remoteResponse);

      return right(remoteResponse);
    } on ProductException catch (exception, stackTrace) {
      return left(
        SearchFailure(
          message: 'Não foi possível carregar os produtos.',
          stackTrace: stackTrace,
          originalException: exception,
        ),
      );
    }
  }

  @override
  Future<EitherOf<Failure, void>> addProduct({
    required ProductEntity product,
  }) async {
    try {
      await remoteDataSource.addProduct(product: product);

      // ignore: void_checks
      return right(voidSuccess);
    } on ProductException catch (exception, stackTrace) {
      return left(
        SearchFailure(
          message: 'Não foi possível adicionar o produto.',
          stackTrace: stackTrace,
          originalException: exception,
        ),
      );
    }
  }
}
