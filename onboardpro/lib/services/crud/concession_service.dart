// import 'dart:async';
// import 'package:onboardpro/extensions/list/filter.dart';
// import 'package:onboardpro/services/crud/crud_exceptions.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class ConcessionService {
//   Database? _db2;
//   List<DatabaseConcession> _concessions = [];
//   DatabaseUser? _user;

//   static final ConcessionService _shared = ConcessionService._sharedInstance();
//   ConcessionService._sharedInstance() {
//     _concessionsStreamController =
//         StreamController<List<DatabaseConcession>>.broadcast(
//       onListen: () {
//         _concessionsStreamController.sink.add(_concessions);
//       },
//     );
//   }
//   factory ConcessionService() => _shared;

//   late final StreamController<List<DatabaseConcession>>
//       _concessionsStreamController;

//   Stream<List<DatabaseConcession>> get allConcessions =>
//       _concessionsStreamController.stream.filter((concession) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return concession.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });

//   Stream<List<DatabaseConcession>> get allTrueConcessions =>
//       _concessionsStreamController.stream.filter((concession) {
//         return (concession.completedStatus == "false" &&
//             concession.receivedStatus == "true");
//       });

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheConcessions() async {
//     final allConcessions = await getAllConcession();
//     _concessions = allConcessions.toList();
//     _concessionsStreamController.add(_concessions);
//   }

//   Future<DatabaseConcession> updateConcession({
//     required DatabaseConcession concession,
//     required String trainClass,
//     required String period,
//     required String dateOfApplication,
//     required String receivedStatus,
//     required String completedStatus,
//   }) async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();

//     // make sure note exists
//     await getConcession(id: concession.id);

//     // update DB
//     final updatesCount = await db2.update(
//       concessionTable,
//       {
//         trainClassColumn: trainClass,
//         periodColumn: period,
//         dateOfApplicationColumn: dateOfApplication,
//         receivedStatusColumn: receivedStatus,
//         completedStatusColumn: completedStatus,
//       },
//       where: 'id = ?',
//       whereArgs: [concession.id],
//     );

//     if (updatesCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updatedConcession = await getConcession(id: concession.id);
//       _concessions
//           .removeWhere((concession) => concession.id == updatedConcession.id);
//       _concessions.add(updatedConcession);
//       _concessionsStreamController.add(_concessions);
//       return updatedConcession;
//     }
//   }

//   Future<Iterable<DatabaseConcession>> getAllConcession() async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();
//     final concessions = await db2.query(concessionTable);

//     return concessions
//         .map((concessionRow) => DatabaseConcession.fromRow(concessionRow));
//   }

//   Future<DatabaseConcession> getConcession({required int id}) async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();
//     final concessions = await db2.query(
//       concessionTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (concessions.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final concession = DatabaseConcession.fromRow(concessions.first);
//       _concessions.removeWhere((concession) => concession.id == id);
//       _concessions.add(concession);
//       _concessionsStreamController.add(_concessions);
//       return concession;
//     }
//   }

//   Future<int> deleteAllConcessions() async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();
//     final numberOfDeletions = await db2.delete(concessionTable);
//     _concessions = [];
//     _concessionsStreamController.add(_concessions);
//     return numberOfDeletions;
//   }

//   Future<void> deleteConcession({required int id}) async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();
//     final deletedCount = await db2.delete(
//       concessionTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _concessions.removeWhere((note) => note.id == id);
//       _concessionsStreamController.add(_concessions);
//     }
//   }

//   Future<DatabaseConcession> createConcession({
//     required DatabaseUser owner,
//     required String name,
//     required String gender,
//     required String email,
//     required String nearestStation,
//     required String address,
//     required String dob,
//     required String destinationStation,
//   }) async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();

//     // make sure owner exists in the database with the correct id
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }

//     // create the note
//     final concessionId = await db2.insert(concessionTable, {
//       userIdColumn: owner.id,
//       nameColumn: name,
//       genderColumn: gender,
//       emailColumn: owner.email,
//       nearestStationColumn: nearestStation,
//       addressColumn: address,
//       dobColumn: dob,
//       destinationStationColumn: destinationStation,
//       trainClassColumn: "",
//       periodColumn: "",
//       dateOfApplicationColumn: "",
//       receivedStatusColumn: "false",
//       completedStatusColumn: "false",
//     });

//     final concession = DatabaseConcession(
//       id: concessionId,
//       userId: owner.id,
//       name: name,
//       gender: gender,
//       email: owner.email,
//       nearestStation: nearestStation,
//       address: address,
//       dob: dob,
//       destinationStation: destinationStation,
//       trainClass: "",
//       period: "",
//       dateOfApplication: "",
//       receivedStatus: "false",
//       completedStatus: "false",
//     );

//     _concessions.add(concession);
//     _concessionsStreamController.add(_concessions);

//     return concession;
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();

//     final results = await db2.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();
//     final results = await db2.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }

//     final userId = await db2.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });

//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db2 = _getDatabaseOrThrow();
//     final deletedCount = await db2.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db2 = _db2;
//     if (db2 == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db2;
//     }
//   }

//   Future<void> close() async {
//     final db2 = _db2;
//     if (db2 == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db2.close();
//       _db2 = null;
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       // empty
//     }
//   }

//   Future<void> open() async {
//     if (_db2 != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db2 = await openDatabase(dbPath);
//       _db2 = db2;
//       // create the user table
//       await db2.execute(createUserTable);
//       // // create note table
//       await db2.execute(createConcessiontable);
//       await _cacheConcessions();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID = $id, email = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseConcession {
//   final int id;
//   final int userId;
//   final String name;
//   final String gender;
//   final String email;
//   final String nearestStation;
//   final String address;
//   final String dob;
//   final String destinationStation;
//   final String trainClass;
//   final String period;
//   final String dateOfApplication;
//   final String receivedStatus;
//   final String completedStatus;

//   DatabaseConcession({
//     required this.id,
//     required this.userId,
//     required this.name,
//     required this.gender,
//     required this.email,
//     required this.nearestStation,
//     required this.address,
//     required this.dob,
//     required this.destinationStation,
//     required this.trainClass,
//     required this.period,
//     required this.dateOfApplication,
//     required this.completedStatus,
//     required this.receivedStatus,
//   });

//   DatabaseConcession.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String,
//         userId = map[userIdColumn] as int,
//         name = map[nameColumn] as String,
//         gender = map[genderColumn] as String,
//         nearestStation = map[nearestStationColumn] as String,
//         address = map[addressColumn] as String,
//         dob = map[dobColumn] as String,
//         destinationStation = map[destinationStationColumn] as String,
//         trainClass = map[trainClassColumn] as String,
//         period = map[periodColumn] as String,
//         dateOfApplication = map[dateOfApplicationColumn] as String,
//         receivedStatus = map[receivedStatusColumn] as String,
//         completedStatus = map[completedStatusColumn] as String;

//   @override
//   String toString() =>
//       'Concession, ID = $id, email = $email, name = $name, gender = $gender, nearest Station = $nearestStation, address= $address, dob = $dob, class = $trainClass, period = $period, Application Date = $dateOfApplication, received = $receivedStatus, completed = $completedStatus';

//   @override
//   bool operator ==(covariant DatabaseConcession other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'concession2.db';
// const concessionTable = 'concession';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const nameColumn = 'name';
// const genderColumn = 'gender';
// const nearestStationColumn = 'nearest_station';
// const addressColumn = 'address';
// const dobColumn = 'dob';
// const destinationStationColumn = 'destination_station';
// const trainClassColumn = 'class';
// const periodColumn = 'period';
// const dateOfApplicationColumn = 'date';
// const receivedStatusColumn = 'received';
// const completedStatusColumn = 'completed';

// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
// 	"id"	INTEGER NOT NULL,
// 	"email"	TEXT NOT NULL UNIQUE,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );''';

// const createConcessiontable = '''CREATE TABLE IF NOT EXISTS "concession" (
// 	"id"	INTEGER NOT NULL,
// 	"user_id"	INTEGER NOT NULL,
// 	"name"	TEXT,
// 	"gender"	TEXT,
// 	"email"	TEXT NOT NULL,
// 	"nearest_station"	TEXT,
// 	"address"	TEXT,
// 	"dob"	TEXT,
// 	"destination_station"	TEXT DEFAULT 'Andheri',
// 	"class"	TEXT,
// 	"period"	TEXT,
// 	"date"	TEXT,
// 	"received"	TEXT,
// 	"completed"	TEXT,
// 	PRIMARY KEY("id" AUTOINCREMENT),
// 	FOREIGN KEY("user_id") REFERENCES "user"("id")
// );''';
// // time  18:39:51 of  yt
// // time 19:30 of yt
// // timr 20>39