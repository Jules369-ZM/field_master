import 'package:auth_repo/auth_repo.dart';
import 'package:field_master/app/app.dart';
import 'package:field_master/bootstrap.dart';
import 'package:field_master/utils/app_config.dart';
import 'package:services_repo/services_repo.dart';

void main() {
  bootstrap(
    () async => App(
      authRepo: await AuthRepo.init(kConfig),
      servicesRepo: await ServicesRepo.init(kConfig),
    ),
  );
}
