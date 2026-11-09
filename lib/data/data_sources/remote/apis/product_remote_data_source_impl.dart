import 'package:dio/dio.dart';
import 'package:santri/data/data_sources/remote/apis/product_remote_data_source.dart';
import 'package:santri/data/data_sources/remote/clients/http_client.dart';
import 'package:santri/data/model/product_model.dart';

import 'package:santri/domain/entities/base/paginated_response.dart';
import 'package:santri/domain/entities/error/exceptions.dart';
import 'package:santri/domain/entities/product/product_entity.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final HttpClient httpClient;

  ProductRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<PaginatedResponse<ProductEntity>> getProduct({
    int currentPage = 1,
  }) async {
    try {
      final String path = 'https://domain.com/api/get/products';
      final Response<dynamic> response = await httpClient.get(
        path,
        queryParameters: <String, dynamic>{'page': currentPage},
      );

      Map<String, dynamic> json = Map<String, dynamic>.from(response.data);
      final List<dynamic> list = List.from(json['results']);

      final List<ProductEntity> itemsList =
          list.map((e) => ProductModel.fromJson(e).toEntity()).toList();
      final int pages = json['pages'];
      final int totalRows = json['rows'];

      return PaginatedResponse(
        currentPage: currentPage,
        totalPages: pages,
        totalRows: totalRows,
        itemsList: itemsList,
      );
    } catch (e) {
      throw ProductException();
    }
  }

  @override
  Future<void> addProduct({required ProductEntity product}) async {
    try {
      const String path = 'https://domain.com/api/add/products';

      final data = <String, dynamic>{
        'id': product.id,
        'name': product.name,
        'purchasePrice': product.purchasePrice,
        'sellingPrice': product.sellingPrice,
      };

      await httpClient.post(path, data: data);
    } catch (e) {
      throw ProductException();
    }
  }
}
