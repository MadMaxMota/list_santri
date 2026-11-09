import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:satri/data/data_sources/local/product_local_data_source_impl.dart';
import 'package:satri/data/data_sources/remote/apis/product_remote_data_source_impl.dart';
import 'package:satri/data/data_sources/remote/clients/http_client.dart';

import 'package:satri/data/repositories/product_repository_impl.dart';

import 'package:satri/domain/use_cases/add_product_use_case.dart';
import 'package:satri/domain/use_cases/get_products_use_case.dart';
import 'package:satri/domain/use_cases/sort_products_use_case.dart';

import 'package:satri/presentation/bloc/products_cubit.dart';
import 'package:satri/presentation/ui/products_list/pages/products_page.dart';

void main() {
  final remoteDataSource = ProductRemoteDataSourceImpl(httpClient: HttpClient(dio: Dio()));
  final localDataSource = ProductLocalDataSourceImpl();
  final productRepository = ProductRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource);

  final getProductsUseCase = GetProductsUseCase(repository: productRepository);
  final addProductUseCase = AddProductUseCase(repository: productRepository);
  final sortProductsUseCase = SortProductsUseCase();

  runApp(MyApp(getProductsUseCase: getProductsUseCase, addProductUseCase: addProductUseCase, sortProductsUseCase: sortProductsUseCase));
}

class MyApp extends StatelessWidget {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final SortProductsUseCase sortProductsUseCase;

  const MyApp({super.key, required this.getProductsUseCase, required this.addProductUseCase, required this.sortProductsUseCase});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsCubit(getProducts: getProductsUseCase, addProductUseCase: addProductUseCase, sortProducts: sortProductsUseCase),
      child: MaterialApp(
        title: 'Satri App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const ProductsPage(),
      ),
    );
  }
}
