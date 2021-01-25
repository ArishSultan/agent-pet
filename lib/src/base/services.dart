import 'package:agent_pet/src/services/pet-service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppServices {
  static final pet = PetService();
  static final petType = PetTypeService();

  static String makeImageUrl(String src) => 'https://www.agentpet.com/$src';

  static final scaffoldMessenger = GlobalKey<ScaffoldMessengerState>();
}