class PaginatedResponse<T> {
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final int? totalRows;
  final List<T> itemsList;

  bool get isEmpty => itemsList.isEmpty && totalRows == 0;
  double get progress => totalPages > 0 ? (currentPage) / totalPages : 0.0;
  bool get hasMore => currentPage < totalPages;

  PaginatedResponse({required this.totalPages, required this.currentPage, this.pageSize = 10, this.totalRows, required this.itemsList});

  PaginatedResponse<T> copyWith({int? totalPages, int? currentPage, int? pageSize, int? totalRows, List<T>? itemsList}) {
    return PaginatedResponse<T>(
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalRows: totalRows ?? this.totalRows,
      itemsList: itemsList ?? this.itemsList,
    );
  }

  PaginatedResponse<T> addPage({required List<T> newItemsList, required int newCurrentPage, required int newTotalPages}) {
    return PaginatedResponse<T>(
      itemsList: <T>[...itemsList, ...newItemsList],
      currentPage: newCurrentPage,
      totalPages: newTotalPages,
      pageSize: pageSize,
      totalRows: totalRows,
    );
  }

  static PaginatedResponse<T> empty<T>() {
    return PaginatedResponse<T>(totalPages: 0, currentPage: 0, pageSize: 10, totalRows: 0, itemsList: <T>[]);
  }
}
