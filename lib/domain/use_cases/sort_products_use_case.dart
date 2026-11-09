import 'package:satri/domain/entities/product/product_entity.dart';

enum ProductSortCriteria { name, purchasePrice, sellingPrice }

class SortProductsUseCase {
  List<ProductEntity> call({required List<ProductEntity> productsList, required ProductSortCriteria sortCriteria}) {
    final List<ProductEntity> sortedProducts = List<ProductEntity>.of(productsList);

    if (sortedProducts.length <= 1) {
      return sortedProducts;
    }

    _quickSort(sortedProducts, 0, sortedProducts.length - 1, sortCriteria);

    return sortedProducts;
  }

  void _quickSort(List<ProductEntity> products, int startIndex, int endIndex, ProductSortCriteria sortCriteria) {
    if (startIndex >= endIndex) {
      return;
    }

    final int pivotIndex = _partition(products, startIndex, endIndex, sortCriteria);

    _quickSort(products, startIndex, pivotIndex - 1, sortCriteria);

    _quickSort(products, pivotIndex + 1, endIndex, sortCriteria);
  }

  int _partition(List<ProductEntity> products, int startIndex, int endIndex, ProductSortCriteria sortCriteria) {
    final ProductEntity pivotProduct = products[endIndex];

    int smallerOrEqualIndex = startIndex - 1;

    for (int currentIndex = startIndex; currentIndex < endIndex; currentIndex++) {
      final int comparisonResult = _compareProducts(products[currentIndex], pivotProduct, sortCriteria);

      if (comparisonResult <= 0) {
        smallerOrEqualIndex++;

        _swap(products, smallerOrEqualIndex, currentIndex);
      }
    }

    final int pivotIndex = smallerOrEqualIndex + 1;

    _swap(products, pivotIndex, endIndex);

    return pivotIndex;
  }

  void _swap(List<ProductEntity> products, int firstIndex, int secondIndex) {
    final ProductEntity temporaryProduct = products[firstIndex];

    products[firstIndex] = products[secondIndex];
    products[secondIndex] = temporaryProduct;
  }

  int _compareProducts(ProductEntity firstProduct, ProductEntity secondProduct, ProductSortCriteria sortCriteria) {
    switch (sortCriteria) {
      case ProductSortCriteria.name:
        return firstProduct.name.toLowerCase().compareTo(secondProduct.name.toLowerCase());

      case ProductSortCriteria.purchasePrice:
        return firstProduct.purchasePrice.compareTo(secondProduct.purchasePrice);

      case ProductSortCriteria.sellingPrice:
        return firstProduct.sellingPrice.compareTo(secondProduct.sellingPrice);
    }
  }
}
