import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpWithLocalization {

  // PLANT TYPE
  static String getLocalizedPlantType(String type, AppLocalizations localizations) {
    switch (type) {
      case 'Cacti/Succulents':
        return localizations.cacti;
      case 'Tropical Plants':
        return localizations.tropicalPlants;
      case 'Climbing Plants':
        return localizations.climbingPlants;
      case 'Flowering Plants':
        return localizations.floweringPlants;
      case 'Trees/Palms':
        return localizations.trees;
      case 'Herbs':
        return localizations.herbs;
      case 'Others':
        return localizations.others;
      default:
        return type;  // Fallback
    }
  }

  static String getEnglishPlantType(String localizedType, AppLocalizations localizations) {
    if (localizedType == localizations.cacti) return 'Cacti/Succulents';
    if (localizedType == localizations.tropicalPlants) return 'Tropical Plants';
    if (localizedType == localizations.climbingPlants) return 'Climbing Plants';
    if (localizedType == localizations.floweringPlants) return 'Flowering Plants';
    if (localizedType == localizations.trees) return 'Trees/Palms';
    if (localizedType == localizations.herbs) return 'Herbs';
    if (localizedType == localizations.others) return 'Others';
    return localizedType;  // Fallback
  }

  // WATER REQUIREMENTS
  static String getLocalizedWater(String water, AppLocalizations localizations) {
    switch (water) {
      case 'Low':
        return localizations.low;
      case 'Medium':
        return localizations.medium;
      case 'High':
        return localizations.high;
      case 'Custom':
        return localizations.custom;
      default:
        return water;
    }
  }

  static String getEnglishWater(String localizedWater, AppLocalizations localizations) {
    if (localizedWater == localizations.low) return 'Low';
    if (localizedWater == localizations.medium) return 'Medium';
    if (localizedWater == localizations.high) return 'High';
    if (localizedWater == localizations.custom) return 'Custom';
    return localizedWater;  // Fallback
  }

  // LIGHT REQUIREMENTS
  static String getLocalizedLight(String light, AppLocalizations localizations) {
    switch (light) {
      case 'Direct Light':
        return localizations.directLight;
      case 'Indirect Light':
        return localizations.indirectLight;
      case 'Partial Shade':
        return localizations.partialShade;
      case 'Low Light':
        return localizations.lowLight;
      default:
        return light;
    }
  }

  static String getEnglishLight(String localizedLight, AppLocalizations localizations) {
    if (localizedLight == localizations.directLight) return 'Direct Light';
    if (localizedLight == localizations.indirectLight) return 'Indirect Light';
    if (localizedLight == localizations.partialShade) return 'Partial Shade';
    if (localizedLight == localizations.lowLight) return 'Low Light';
    return localizedLight;  // Fallback
  }

  // DIFFICULTY (Schwierigkeitsgrad)
  static String getLocalizedDifficulty(String difficulty, AppLocalizations localizations) {
    switch (difficulty) {
      case 'Easy':
        return localizations.easy;
      case 'Medium':
        return localizations.medium;
      case 'Difficult':
        return localizations.difficult;
      default:
        return difficulty;  // Fallback
    }
  }

  static String getEnglishDifficulty(String localizedDifficulty, AppLocalizations localizations) {
    if (localizedDifficulty == localizations.easy) return 'Easy';
    if (localizedDifficulty == localizations.medium) return 'Medium';
    if (localizedDifficulty == localizations.difficult) return 'Hard';
    return localizedDifficulty;  // Fallback
  }

}
