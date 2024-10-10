import 'package:net_source/net_source.dart';

final initialScript = [
  '''
CREATE TABLE users(id INTEGER, name TEXT, phoneNumber TEXT, email TEXT, photoURL TEXT, displayName TEXT, uid TEXT, emailVerified INTEGER, isAnonymous INTEGER, details TEXT, otherData TEXT, PRIMARY KEY(id, uid, email, displayName, phoneNumber, details, otherData ))
        ''',
];
final migrations = <String>[
  '''
    ALTER TABLE users ADD COLUMN role TEXT;
    ''',
  '''
    ALTER TABLE users ADD COLUMN password TEXT;
    ''',
];
final kConfig = Config(
  baseUrl: '',
  socketUrl: '',
  host: '',
  dbName: 'field_master.prod.db',
  initScript: initialScript,
  migrations: migrations,
);

final kDevConfig = Config(
  baseUrl: '',
  socketUrl: '',
  host: '',
  dbName: 'field_master.dev.db',
  initScript: initialScript,
  migrations: migrations,
);
