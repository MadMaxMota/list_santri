import 'package:flutter/material.dart';

class ProductFormFieldsWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController purchasePriceController;
  final TextEditingController sellingPriceController;

  const ProductFormFieldsWidget({
    super.key,
    required this.nameController,
    required this.purchasePriceController,
    required this.sellingPriceController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nome do Produto', border: OutlineInputBorder()),
          validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: purchasePriceController,
          decoration: const InputDecoration(labelText: 'Preço de Compra (R\$)', border: OutlineInputBorder()),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => value == null || value.isEmpty ? 'Informe o preço' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: sellingPriceController,
          decoration: const InputDecoration(labelText: 'Preço de Venda (R\$)', border: OutlineInputBorder()),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => value == null || value.isEmpty ? 'Informe o preço' : null,
        ),
      ],
    );
  }
}
