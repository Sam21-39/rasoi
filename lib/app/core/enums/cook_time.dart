/// Cook time ranges
enum CookTime { under15, under30, under60, over60 }

extension CookTimeExtension on CookTime {
  String get displayName {
    switch (this) {
      case CookTime.under15:
        return 'Under 15 min';
      case CookTime.under30:
        return '15-30 min';
      case CookTime.under60:
        return '30-60 min';
      case CookTime.over60:
        return 'Over 60 min';
    }
  }

  String get value {
    switch (this) {
      case CookTime.under15:
        return 'under15';
      case CookTime.under30:
        return 'under30';
      case CookTime.under60:
        return 'under60';
      case CookTime.over60:
        return 'over60';
    }
  }

  int get minutes {
    switch (this) {
      case CookTime.under15:
        return 15;
      case CookTime.under30:
        return 30;
      case CookTime.under60:
        return 60;
      case CookTime.over60:
        return 90;
    }
  }

  static CookTime fromString(String value) {
    switch (value.toLowerCase()) {
      case 'under15':
        return CookTime.under15;
      case 'under30':
        return CookTime.under30;
      case 'under60':
        return CookTime.under60;
      case 'over60':
        return CookTime.over60;
      default:
        return CookTime.under30;
    }
  }
}
