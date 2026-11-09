import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santri/presentation/bloc/products_cubit.dart';
import 'package:santri/presentation/ui/add_product/widgets/product_form_fields_widget.dart';
import 'package:santri/presentation/ui/add_product/widgets/submit_button_widget.dart';

class AddProductBodyWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController purchasePriceController;
  final TextEditingController sellingPriceController;
  final VoidCallback onSubmit;

  const AddProductBodyWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.purchasePriceController,
    required this.sellingPriceController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ProductsCubit>().resetProductAddState();
          Navigator.pop(context);
        }

        if (state is ProductAddError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
          context.read<ProductsCubit>().resetProductAddState();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductFormFieldsWidget(
                nameController: nameController,
                purchasePriceController: purchasePriceController,
                sellingPriceController: sellingPriceController,
              ),
              const SizedBox(height: 24),
              SubmitButtonWidget(onPressed: onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
