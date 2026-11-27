import 'package:movie_discovery_app/core/database/database_helper.dart';
import 'package:movie_discovery_app/features/account_settings/data/models/account_profile_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AccountSettingsLocalDataSource {
  Future<AccountProfileModel?> getProfile(String userId);
  Future<void> saveProfile(AccountProfileModel profile);
  Future<void> deleteProfile(String userId);
}

class AccountSettingsLocalDataSourceImpl
    implements AccountSettingsLocalDataSource {
  final DatabaseHelper databaseHelper;

  const AccountSettingsLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<AccountProfileModel?> getProfile(String userId) async {
    final db = await databaseHelper.database;
    final rows = await db.query(
      DatabaseHelper.accountProfilesTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return AccountProfileModel.fromMap(rows.first);
  }

  @override
  Future<void> saveProfile(AccountProfileModel profile) async {
    final db = await databaseHelper.database;
    await db.insert(
      DatabaseHelper.accountProfilesTable,
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteProfile(String userId) async {
    final db = await databaseHelper.database;
    await db.delete(
      DatabaseHelper.accountProfilesTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
