import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:satri/domain/entities/product/product_entity.dart';
import 'package:satri/presentation/bloc/products_cubit.dart';
import 'package:satri/presentation/ui/add_product/widgets/add_product_body_widget.dart';
import 'package:uuid/uuid.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Produto')),
      body: AddProductBodyWidget(
        formKey: _formKey,
        nameController: _nameController,
        purchasePriceController: _purchasePriceController,
        sellingPriceController: _sellingPriceController,
        onSubmit: _submit,
      ),
    );
  }

  void _submit() {
    if (!_isFormValid()) {
      return;
    }

    final ProductEntity? product = _createProductFromForm();
    if (hasNoProduct(product)) {
      _showInvalidPricesMessage();
      return;
    }

    context.read<ProductsCubit>().addProduct(product: product!);
  }

  bool hasNoProduct(ProductEntity? product) => product == null;

  bool _isFormValid() => _formKey.currentState?.validate() ?? false;

  void _showInvalidPricesMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Por favor, insira valores numéricos válidos.'), backgroundColor: Colors.red));
  }

  ProductEntity? _createProductFromForm() {
    final double? purchasePrice = _parsePrice(_purchasePriceController.text);
    final double? sellingPrice = _parsePrice(_sellingPriceController.text);

    if (_hasInvalidPrices(purchasePrice, sellingPrice)) {
      return null;
    }

    return ProductEntity(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      purchasePrice: purchasePrice!,
      sellingPrice: sellingPrice!,
    );
  }

  double? _parsePrice(String value) => double.tryParse(value.replaceAll(',', '.'));

  bool _hasInvalidPrices(double? purchasePrice, double? sellingPrice) => purchasePrice == null || sellingPrice == null;
}
