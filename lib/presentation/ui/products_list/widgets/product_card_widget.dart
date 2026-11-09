import 'package:flutter/material.dart';
import 'package:satri/domain/entities/product/product_entity.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductEntity product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final double profit = product.sellingPrice - product.purchasePrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('Compra: R\$ ${product.purchasePrice.toStringAsFixed(2)} | Venda: R\$ ${product.sellingPrice.toStringAsFixed(2)}'),
        trailing: Text(
          'Lucro: R\$ ${profit.toStringAsFixed(2)}',
          style: TextStyle(color: profit >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
