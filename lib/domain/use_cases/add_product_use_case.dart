import 'package:satri/domain/entities/either_of/either_of.dart';
import 'package:satri/domain/entities/error/failure.dart';
import 'package:satri/domain/entities/product/product_entity.dart';
import 'package:satri/domain/repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase({required this.repository});

  Future<EitherOf<Failure, void>> call({required ProductEntity product}) async {
    return repository.addProduct(product: product);
  }
}
