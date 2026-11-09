import 'package:flutter/material.dart';
import 'package:satri/domain/entities/base/paginated_response.dart';
import 'package:satri/domain/entities/product/product_entity.dart';
import 'package:satri/presentation/ui/products_list/widgets/product_card_widget.dart';

class ProductListWidget extends StatelessWidget {
  final PaginatedResponse<ProductEntity> response;
  final ScrollController scrollController;

  const ProductListWidget({super.key, required this.response, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: response.itemsList.length + (response.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == response.itemsList.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final ProductEntity product = response.itemsList[index];

        return ProductCardWidget(key: ValueKey(product.id), product: product);
      },
    );
  }
}
