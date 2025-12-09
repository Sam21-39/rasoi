/// Email validation utility
class EmailValidator {
  static final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  /// Validates email format
  static String? validate(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Checks if email is valid (returns bool)
  static bool isValid(String email) {
    return _emailRegex.hasMatch(email);
  }
}

/// Password validation utility
class PasswordValidator {
  static const int minLength = 8;
  static const int maxLength = 128;

  /// Validates password strength
  static String? validate(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (password.length > maxLength) {
      return 'Password must be less than $maxLength characters';
    }

    if (!_hasUpperCase(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!_hasLowerCase(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!_hasDigit(password)) {
      return 'Password must contain at least one number';
    }

    if (!_hasSpecialChar(password)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Calculates password strength (0-4)
  static int calculateStrength(String password) {
    int strength = 0;

    if (password.length >= minLength) strength++;
    if (_hasUpperCase(password) && _hasLowerCase(password)) strength++;
    if (_hasDigit(password)) strength++;
    if (_hasSpecialChar(password)) strength++;

    return strength;
  }

  /// Gets password strength label
  static String getStrengthLabel(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  static bool _hasUpperCase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  static bool _hasLowerCase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  static bool _hasDigit(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  static bool _hasSpecialChar(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}

/// Display name validation
class DisplayNameValidator {
  static const int minLength = 2;
  static const int maxLength = 50;

  static String? validate(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }

    final trimmed = name.trim();

    if (trimmed.length < minLength) {
      return 'Name must be at least $minLength characters';
    }

    if (trimmed.length > maxLength) {
      return 'Name must be less than $maxLength characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(trimmed)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }
}

/// Bio validation
class BioValidator {
  static const int maxLength = 500;

  static String? validate(String? bio) {
    if (bio == null || bio.isEmpty) {
      return null; // Bio is optional
    }

    if (bio.length > maxLength) {
      return 'Bio must be less than $maxLength characters';
    }

    return null;
  }
}

/// Recipe title validation
class RecipeTitleValidator {
  static const int minLength = 3;
  static const int maxLength = 100;

  static String? validate(String? title) {
    if (title == null || title.isEmpty) {
      return 'Recipe title is required';
    }

    final trimmed = title.trim();

    if (trimmed.length < minLength) {
      return 'Title must be at least $minLength characters';
    }

    if (trimmed.length > maxLength) {
      return 'Title must be less than $maxLength characters';
    }

    return null;
  }
}

/// Generic text field validation
class TextFieldValidator {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? minLength(String? value, int min, String fieldName) {
    if (value == null || value.trim().length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(String? value, int max, String fieldName) {
    if (value != null && value.length > max) {
      return '$fieldName must be less than $max characters';
    }
    return null;
  }
}
