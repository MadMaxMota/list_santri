import 'package:santri/domain/entities/base/paginated_response.dart';
import 'package:santri/domain/entities/either_of/either_of.dart';
import 'package:santri/domain/entities/error/failure.dart';
import 'package:santri/domain/entities/product/product_entity.dart';
import 'package:santri/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<EitherOf<Failure, PaginatedResponse<ProductEntity>>> call({
    required int page,
    PaginatedResponse<ProductEntity>? currentResponse,
  }) async {
    final EitherOf<Failure, PaginatedResponse<ProductEntity>> paginatedResult =
        await repository.getProducts(page: page);

    if (_isInitialRequest(currentResponse)) {
      return paginatedResult;
    }

    return paginatedResult.fold(
      (Failure failure) => left(failure),
      (PaginatedResponse<ProductEntity> newResponse) => right(
        _mergePages(
          currentResponse: currentResponse!,
          newResponse: newResponse,
        ),
      ),
    );
  }

  bool _isInitialRequest(PaginatedResponse<ProductEntity>? currentResponse) {
    return currentResponse == null;
  }

  PaginatedResponse<ProductEntity> _mergePages({
    required PaginatedResponse<ProductEntity> currentResponse,
    required PaginatedResponse<ProductEntity> newResponse,
  }) {
    return currentResponse.addPage(
      newItemsList: newResponse.itemsList,
      newCurrentPage: newResponse.currentPage,
      newTotalPages: newResponse.totalPages,
    );
  }
}
