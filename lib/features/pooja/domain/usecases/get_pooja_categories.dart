import '../../data/datasources/pooja_remote_datasource.dart';

class GetPoojaCategories {
  final PoojaRepository repository;

  GetPoojaCategories(this.repository);
  Future<List<String>> call() {
    return repository.getCategories();
  }
}
