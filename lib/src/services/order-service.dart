
import 'package:agent_pet/src/models/order.dart';

import '_service.dart';

class OrderService extends Service<Order> {
  @override
  Order parse(Map<String, dynamic> item) => Order.fromJson(item);

  Future<List<Order>> fetchUserOrders(int id){
    return this.getAll("orders/$id");
  }
}