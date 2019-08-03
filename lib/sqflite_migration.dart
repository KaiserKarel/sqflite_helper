import 'package:sqflite/sqflite.dart';

Future<Database> openMigratedDatabase(
  String path,
  List<String> migrations, {
  bool readOnly = false,
  bool singleInstance = true,
  OnDatabaseCreateFn onCreate,
  OnDatabaseConfigureFn onConfigure,
  OnDatabaseVersionChangeFn onUpgrade,
  OnDatabaseVersionChangeFn onDowngrade,
  OnDatabaseOpenFn onOpen,
}) async {
  return openDatabase(path,
      version: migrations.length,
      readOnly: readOnly,
      singleInstance: singleInstance,
      onConfigure: onConfigure,
      onDowngrade: onDowngrade,
      onOpen: onOpen,

      onCreate: (Database db, int version) async {
        if (onCreate != null) {
          onCreate(db, version);
        } else {
          await db.transaction((txn) async {
            migrations.forEach((String migration) {
              txn.execute(migration);
            });
          });
        }
    },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (onUpgrade != null) {
          onUpgrade(db, oldVersion, newVersion);
        } else {
          await db.transaction((txn) async {
            migrations.asMap().forEach((index, migration) {
              if (index > oldVersion) {
                txn.execute(migration);
              }
            });
          });
      }
  });
}
