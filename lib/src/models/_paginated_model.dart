import 'package:agent_pet/src/models/_model.dart';

class PaginatedModel<T extends Model> {
  T data;

  int total = 0;
  int currentPage = 0;
}