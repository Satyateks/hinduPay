import '../../data/datasources/pooja_remote_datasource.dart';
import '../entities/pooja.dart';

class GetPoojas {
  final PoojaRepository repository;

  GetPoojas(this.repository);

  Future<List<Pooja>> call() {
    return repository.getPoojas();
  }
}
