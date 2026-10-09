import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

enum VendorType {
  milk('litre', 60, 0.5),
  newspaper('piece', 8, 1),
  maid('visit', 0, 1),
  tiffin('piece', 80, 1),
  carCleaner('visit', 0, 1),
  vegetables('kilogram', 0, 0.5),
  fruits('kilogram', 0, 0.5),
  groceries('piece', 0, 1),
  waterDelivery('litre', 0, 1),
  eggs('piece', 0, 1),
  bread('piece', 0, 1),
  laundry('piece', 0, 1),
  ironing('piece', 0, 1),
  cook('visit', 0, 1),
  gardener('visit', 0, 1),
  houseCleaning('visit', 0, 1),
  cookingGas('piece', 0, 1),
  other('piece', 0, 1);

  const VendorType(this.unit, this.defaultRate, this.quantityStep);
  final String unit;
  final double defaultRate;
  final double quantityStep;
  double get defaultQuantity => 1;
}

String vendorTypeLabel(AppLocalizations strings, String type) => switch (type) {
  'milk' => strings.milk,
  'newspaper' => strings.newspaper,
  'maid' => strings.maid,
  'tiffin' => strings.tiffin,
  'carCleaner' => strings.carCleaner,
  'vegetables' => strings.vegetables,
  'fruits' => strings.fruits,
  'groceries' => strings.groceries,
  'waterDelivery' => strings.waterDelivery,
  'eggs' => strings.eggs,
  'bread' => strings.bread,
  'laundry' => strings.laundry,
  'ironing' => strings.ironing,
  'cook' => strings.cook,
  'gardener' => strings.gardener,
  'houseCleaning' => strings.houseCleaning,
  'cookingGas' => strings.cookingGas,
  _ => strings.other,
};
String vendorUnitLabel(AppLocalizations strings, String unit) => switch (unit) {
  'litre' => strings.litre,
  'visit' => strings.visit,
  'kilogram' => strings.kilogram,
  _ => strings.piece,
};

IconData vendorTypeIcon(String type) => switch (type) {
  'milk' => Icons.local_drink_outlined,
  'newspaper' => Icons.newspaper_outlined,
  'maid' => Icons.cleaning_services_outlined,
  'tiffin' => Icons.takeout_dining_outlined,
  'carCleaner' => Icons.directions_car_outlined,
  'vegetables' => Icons.eco_outlined,
  'groceries' => Icons.local_grocery_store_outlined,
  'waterDelivery' => Icons.water_drop_outlined,
  'eggs' => Icons.egg_outlined,
  'bread' => Icons.bakery_dining_outlined,
  'laundry' => Icons.local_laundry_service_outlined,
  'ironing' => Icons.iron_outlined,
  'cook' => Icons.soup_kitchen_outlined,
  'gardener' => Icons.yard_outlined,
  'houseCleaning' => Icons.home_outlined,
  'cookingGas' => Icons.propane_tank_outlined,
  _ => Icons.category_outlined,
};
