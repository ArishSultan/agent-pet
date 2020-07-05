import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverSectionHeader extends SliverToBoxAdapter {
  SliverSectionHeader(String text, [Widget other]): super(
    child: SectionHeader(text, other)
  );
}