part of 'products_cubit.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsError extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final PaginatedResponse<ProductEntity> currentResponse;
  final bool isLoadingMore;
  final ProductSortCriteria sortCriteria;

  ProductsLoaded({required this.currentResponse, required this.isLoadingMore, this.sortCriteria = ProductSortCriteria.name});

  ProductsLoaded copyWith({PaginatedResponse<ProductEntity>? currentResponse, bool? isLoadingMore, ProductSortCriteria? sortCriteria}) {
    return ProductsLoaded(
      currentResponse: currentResponse ?? this.currentResponse,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      sortCriteria: sortCriteria ?? this.sortCriteria,
    );
  }
}

class ProductAdding extends ProductsState {
  final PaginatedResponse<ProductEntity> currentResponse;

  ProductAdding({required this.currentResponse});
}

class ProductAddSuccess extends ProductsState {
  final PaginatedResponse<ProductEntity> currentResponse;

  ProductAddSuccess({required this.currentResponse});
}

class ProductAddError extends ProductsState {
  final PaginatedResponse<ProductEntity> currentResponse;
  final String message;

  ProductAddError({required this.currentResponse, required this.message});
}
