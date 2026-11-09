// HTTP / Request errors / Network
class BadRequestException implements Exception {}

class NotFoundException implements Exception {}

class ServerException implements Exception {}

// Authentication & Authorization
class UnauthorizedException implements Exception {}

// Network & Connectivity
class NetworkException implements Exception {}

// Database & Storage
class LocalDataBaseException implements Exception {}

class RemoteDataBaseException implements Exception {}

// Search
class ProductException implements Exception {}

// Misc / Fallback
class UnmappedException implements Exception {}
