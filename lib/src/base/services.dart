import 'package:agent_pet/src/services/pet-service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';

abstract class AppServices {
  static final pet = PetService();
  static final petType = PetTypeService();
}