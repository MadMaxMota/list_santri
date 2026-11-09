import 'package:flutter/material.dart';
import 'package:santri/domain/use_cases/sort_products_use_case.dart';

class SortMenuButtonWidget extends StatelessWidget {
  final ProductSortCriteria currentCriteria;
  final ValueChanged<ProductSortCriteria> onSelected;

  const SortMenuButtonWidget({
    super.key,
    required this.currentCriteria,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProductSortCriteria>(
      icon: const Icon(Icons.sort),
      initialValue: currentCriteria,
      onSelected: onSelected,
      itemBuilder:
          (context) => const [
            PopupMenuItem(
              value: ProductSortCriteria.name,
              child: Text('Ordenar por Nome'),
            ),
            PopupMenuItem(
              value: ProductSortCriteria.purchasePrice,
              child: Text('Ordenar por Preço de Compra'),
            ),
            PopupMenuItem(
              value: ProductSortCriteria.sellingPrice,
              child: Text('Ordenar por Preço de Venda'),
            ),
          ],
    );
  }
}
