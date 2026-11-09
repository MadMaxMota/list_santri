import 'package:santri/data/data_sources/local/product_local_data_source.dart';
import 'package:santri/domain/entities/base/paginated_response.dart';
import 'package:santri/domain/entities/product/product_entity.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Map<int, _CacheEntry<PaginatedResponse<ProductEntity>>> _cacheMap =
      <int, _CacheEntry<PaginatedResponse<ProductEntity>>>{};

  @override
  Future<PaginatedResponse<ProductEntity>?> getProducts({required int page}) {
    final _CacheEntry<PaginatedResponse<ProductEntity>>? entry =
        _cacheMap[page];

    if (_hasNoCacheEntry(entry)) {
      return Future.value(null);
    }

    if (entry!.isExpired()) {
      _cacheMap.remove(page);
      return Future.value(null);
    }

    return Future.value(entry.data);
  }

  bool _hasNoCacheEntry(_CacheEntry<PaginatedResponse<ProductEntity>>? entry) =>
      entry == null;

  @override
  Future<void> saveProducts({
    required int page,
    required PaginatedResponse<ProductEntity> response,
  }) {
    _cacheMap[page] = _CacheEntry<PaginatedResponse<ProductEntity>>(
      data: response,
      cachedAt: DateTime.now(),
    );

    return Future.value();
  }

  @override
  Future<void> clear() {
    _cacheMap.clear();

    return Future.value();
  }
}

class _CacheEntry<T> {
  final T data;
  final DateTime cachedAt;

  _CacheEntry({required this.data, required this.cachedAt});

  final Duration _cacheDuration = Duration(minutes: 2);

  bool isExpired() => DateTime.now().difference(cachedAt) >= _cacheDuration;
}
