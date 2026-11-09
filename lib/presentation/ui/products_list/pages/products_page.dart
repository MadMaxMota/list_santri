import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santri/domain/entities/base/paginated_response.dart';
import 'package:santri/domain/entities/product/product_entity.dart';
import 'package:santri/domain/use_cases/sort_products_use_case.dart';
import 'package:santri/presentation/bloc/products_cubit.dart';
import 'package:santri/presentation/ui/add_product/pages/add_product_page.dart';
import 'package:santri/presentation/ui/products_list/widgets/adding_overlay_widget.dart';
import 'package:santri/presentation/ui/products_list/widgets/empty_view_widget.dart';
import 'package:santri/presentation/ui/products_list/widgets/error_view_widget.dart';
import 'package:santri/presentation/ui/products_list/widgets/product_list_widget.dart';
import 'package:santri/presentation/ui/products_list/widgets/sort_menu_button_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadInitialProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_shouldLoadMoreProducts()) {
      context.read<ProductsCubit>().loadMoreProducts();
    }
  }

  bool _shouldLoadMoreProducts() =>
      _scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 200;

  ProductSortCriteria _getCurrentCriteria(ProductsState state) {
    if (state is ProductsLoaded) return state.sortCriteria;
    return ProductSortCriteria.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ocorreu um erro ao carregar os produtos.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Produtos'),
          actions: [
            BlocBuilder<ProductsCubit, ProductsState>(
              buildWhen:
                  (previous, current) =>
                      _getCurrentCriteria(previous) !=
                      _getCurrentCriteria(current),
              builder: (context, state) {
                return SortMenuButtonWidget(
                  currentCriteria: _getCurrentCriteria(state),
                  onSelected:
                      (criteria) => context
                          .read<ProductsCubit>()
                          .changeSortCriteria(criteria),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder:
              (context, state) => _ProductsBodyWidget(
                state: state,
                scrollController: _scrollController,
              ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductPage()),
              ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _ProductsBodyWidget extends StatelessWidget {
  final ProductsState state;
  final ScrollController scrollController;

  const _ProductsBodyWidget({
    required this.state,
    required this.scrollController,
  });

  PaginatedResponse<ProductEntity>? _getResponseFromState() {
    if (state is ProductsLoaded)
      return (state as ProductsLoaded).currentResponse;
    if (state is ProductAdding) return (state as ProductAdding).currentResponse;
    if (state is ProductAddSuccess)
      return (state as ProductAddSuccess).currentResponse;
    if (state is ProductAddError)
      return (state as ProductAddError).currentResponse;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (state is ProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductsError) {
      return ErrorViewWidget(
        onRetry: () => context.read<ProductsCubit>().loadInitialProducts(),
      );
    }

    final PaginatedResponse<ProductEntity>? response = _getResponseFromState();

    if (response == null || response.itemsList.isEmpty) {
      return const EmptyViewWidget();
    }

    return Stack(
      children: [
        ProductListWidget(
          response: response,
          scrollController: scrollController,
        ),
        if (state is ProductAdding) const AddingOverlayWidget(),
      ],
    );
  }
}
