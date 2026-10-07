import '../../domain/entities/pooja.dart';
import '../datasources/pooja_remote_datasource.dart';

class PoojaRepositoryImpl implements PoojaRepository {
  final PoojaRemoteDataSource remoteDataSource;

  PoojaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Pooja>> getPoojas() {
    return remoteDataSource.getPoojas();
  }

  @override
  Future<Pooja> getPoojaDetail(String id) {
    return remoteDataSource.getPoojaDetail(id);
  }

  @override
  Future<List<String>> getCategories() {
    return remoteDataSource.getCategories();
  }
}
