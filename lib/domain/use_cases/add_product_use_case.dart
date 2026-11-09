import 'package:santri/domain/entities/either_of/either_of.dart';
import 'package:santri/domain/entities/error/failure.dart';
import 'package:santri/domain/entities/product/product_entity.dart';
import 'package:santri/domain/repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase({required this.repository});

  Future<EitherOf<Failure, void>> call({required ProductEntity product}) async {
    return repository.addProduct(product: product);
  }
}
