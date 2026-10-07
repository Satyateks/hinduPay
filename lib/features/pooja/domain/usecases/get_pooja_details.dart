import '../../data/datasources/pooja_remote_datasource.dart';
import '../entities/pooja.dart';

class GetPoojaDetail {
  final PoojaRepository repository;
  GetPoojaDetail(this.repository);
  Future<Pooja> call(String id) {
    return repository.getPoojaDetail(id);
  }
}
