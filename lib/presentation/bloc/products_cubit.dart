import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:satri/domain/entities/base/paginated_response.dart';
import 'package:satri/domain/entities/either_of/either_of.dart';
import 'package:satri/domain/entities/error/failure.dart';
import 'package:satri/domain/entities/product/product_entity.dart';
import 'package:satri/domain/use_cases/add_product_use_case.dart';
import 'package:satri/domain/use_cases/get_products_use_case.dart';
import 'package:satri/domain/use_cases/sort_products_use_case.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final AddProductUseCase addProductUseCase;
  final GetProductsUseCase getProducts;
  final SortProductsUseCase sortProducts;

  ProductsCubit({required this.addProductUseCase, required this.getProducts, required this.sortProducts}) : super(ProductsInitial());

  ProductSortCriteria get _currentCriteria {
    if (state is ProductsLoaded) {
      return (state as ProductsLoaded).sortCriteria;
    }
    return ProductSortCriteria.name;
  }

  Future<void> addProduct({required ProductEntity product}) async {
    if (state is ProductAdding) {
      return;
    }

    final PaginatedResponse<ProductEntity>? currentResponse = _getCurrentProductsResponse();

    if (currentResponse == null) {
      return;
    }

    emit(ProductAdding(currentResponse: currentResponse));

    final EitherOf<Failure, void> result = await addProductUseCase.call(product: product);

    result.fold(
      (Failure failure) {
        emit(ProductAddError(currentResponse: currentResponse, message: failure.message ?? 'Não foi possível adicionar o produto.'));
      },
      (_) {
        emit(ProductAddSuccess(currentResponse: currentResponse));
      },
    );
  }

  Future<void> resetProductAddState() async {
    final ProductsState currentState = state;

    if (currentState is ProductAddSuccess) {
      await loadInitialProducts();
      return;
    }

    if (currentState is ProductAddError) {
      emit(ProductsLoaded(currentResponse: currentState.currentResponse, isLoadingMore: false));
    }
  }

  PaginatedResponse<ProductEntity>? _getCurrentProductsResponse() {
    final ProductsState currentState = state;

    if (currentState is ProductsLoaded) {
      return currentState.currentResponse;
    }

    if (currentState is ProductAddError) {
      return currentState.currentResponse;
    }

    if (currentState is ProductAddSuccess) {
      return currentState.currentResponse;
    }

    return null;
  }

  Future<void> loadInitialProducts() async {
    emit(ProductsLoading());

    final EitherOf<Failure, PaginatedResponse<ProductEntity>> result = await getProducts.call(page: 1);

    result.fold(
      (Failure failure) {
        emit(ProductsError());
      },
      (PaginatedResponse<ProductEntity> response) {
        final sortedItems = sortProducts(productsList: response.itemsList, sortCriteria: _currentCriteria);
        final sortedResponse = response.copyWith(itemsList: sortedItems);

        emit(ProductsLoaded(currentResponse: sortedResponse, isLoadingMore: false, sortCriteria: _currentCriteria));
      },
    );
  }

  Future<void> loadMoreProducts() async {
    if (state is! ProductsLoaded) return;

    final ProductsLoaded currentState = state as ProductsLoaded;

    if (currentState.isLoadingMore || !currentState.currentResponse.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final int nextPage = currentState.currentResponse.currentPage + 1;

    final EitherOf<Failure, PaginatedResponse<ProductEntity>> result = await getProducts.call(
      page: nextPage,
      currentResponse: currentState.currentResponse,
    );

    result.fold(
      (Failure failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (PaginatedResponse<ProductEntity> response) {
        final List<ProductEntity> sortedItemsList = sortProducts(productsList: response.itemsList, sortCriteria: currentState.sortCriteria);

        final PaginatedResponse<ProductEntity> sortedResponse = response.copyWith(itemsList: sortedItemsList);

        emit(ProductsLoaded(currentResponse: sortedResponse, isLoadingMore: false, sortCriteria: currentState.sortCriteria));
      },
    );
  }

  void changeSortCriteria(ProductSortCriteria criteria) {
    if (state is! ProductsLoaded) return;

    final currentState = state as ProductsLoaded;

    if (currentState.sortCriteria == criteria) return;

    final List<ProductEntity> sortedItemsList = sortProducts(productsList: currentState.currentResponse.itemsList, sortCriteria: criteria);

    final PaginatedResponse<ProductEntity> sortedResponse = currentState.currentResponse.copyWith(itemsList: sortedItemsList);

    emit(ProductsLoaded(currentResponse: sortedResponse, isLoadingMore: currentState.isLoadingMore, sortCriteria: criteria));
  }
}
