# sqflite-migration
A small library to properly open a sqflite DB and handle the migrations.

Features:
* Uses transactions for all schema changes.
* Almost identical interface to sqflite.openDatabase()

## Example usage
```dart
import 'package:sqflite-migration/open.dart';
import 'package:sqflite/sqflite.dart';

Database db = openMigratedDatabase("path/to/db.db", 
  [
    """CREATE TABLE mytable (name varchar);""",
    """ALTER TABLE mytable RENAME TO users',
  ]
);
```