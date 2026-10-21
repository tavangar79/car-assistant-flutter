import 'package:flutter/material.dart';

/// The [IconData] for a Material Symbols [name] sent by the API (service items, intervals, due
/// items). Unknown names fall back to a wrench.
IconData materialSymbolIcon(String name) => switch (name) {
  'oil_barrel' => Icons.oil_barrel,
  'filter_alt' => Icons.filter_alt,
  'air' => Icons.air,
  'hvac' => Icons.hvac,
  'ac_unit' => Icons.ac_unit,
  'opacity' => Icons.opacity,
  'local_gas_station' => Icons.local_gas_station,
  'disc_full' => Icons.disc_full,
  'tire_repair' => Icons.tire_repair,
  'album' => Icons.album,
  'troubleshoot' => Icons.troubleshoot,
  'trip_origin' => Icons.trip_origin,
  'sync_alt' => Icons.sync_alt,
  'tune' => Icons.tune,
  'expand' => Icons.expand,
  'donut_large' => Icons.donut_large,
  'battery_charging_full' => Icons.battery_charging_full,
  'flash_on' => Icons.flash_on,
  'electric_bolt' => Icons.electric_bolt,
  'lightbulb' => Icons.lightbulb,
  'settings' => Icons.settings,
  // Not in Flutter's Material icons; the closest wheel-like glyph.
  'swap_driving_apps_wheel' => Icons.swap_horizontal_circle,
  'schedule' => Icons.schedule,
  'all_inclusive' => Icons.all_inclusive,
  'cleaning_services' => Icons.cleaning_services,
  'handyman' => Icons.handyman,
  'sync' => Icons.sync,
  _ => Icons.build,
};
