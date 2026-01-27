import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _propertyIdKey = 'property_id';
  static const _propertyNameKey = 'property_name';
static const _tenantIdKey = 'tenant_id';


  static const _unitIdKey = 'unit_id';
  static const _unitNameKey = 'unit_name';


  static const _isUnitSelectedKey = 'is_unit_selected';


  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

 static Future<void> clearToken() async {
  await _storage.deleteAll(); 
}


  static Future<void> savePropertyId(int id) async {
    await _storage.write(key: _propertyIdKey, value: id.toString());
  }

  static Future<int?> getPropertyId() async {
    final value = await _storage.read(key: _propertyIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  static Future<void> savePropertyName(String name) async {
    await _storage.write(key: _propertyNameKey, value: name);
  }

  static Future<String?> getPropertyName() async {
    return await _storage.read(key: _propertyNameKey);
  }

  static Future<void> saveUnitId(int id) async {
    await _storage.write(key: _unitIdKey, value: id.toString());
  }

  static Future<int?> getUnitId() async {
    final value = await _storage.read(key: _unitIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  static Future<void> saveUnitName(String name) async {
    await _storage.write(key: _unitNameKey, value: name);
  }

  static Future<String?> getUnitName() async {
    return await _storage.read(key: _unitNameKey);
  }


  static Future<void> saveIsUnitSelected(bool value) async {
    await _storage.write(key: _isUnitSelectedKey, value: value ? 'true' : 'false');
  }

  static Future<bool> getIsUnitSelected() async {
    final value = await _storage.read(key: _isUnitSelectedKey);
    return value == 'true';
  }


  static Future<void> saveTenantId(int tenantId) async {
  await _storage.write(
    key: _tenantIdKey,
    value: tenantId.toString(),
  );
}

static Future<int?> getTenantId() async {
  final value = await _storage.read(key: _tenantIdKey);
  return value != null ? int.tryParse(value) : null;
}


  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
