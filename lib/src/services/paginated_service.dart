import 'package:agent_pet/src/models/_model.dart';

abstract class PaginatedService<T extends Model> {
  int _totalItems;
  List<T> data;
  int _currentPage = 0;
  int _totalPages = 0;

  final Future<List<T>> Function(int pageNo) fetcher;

  PaginatedService(this.fetcher);

  fetchNext() async {
    this.data.addAll(await this.fetcher(++this._currentPage));
  }
}
