// to hold the variables that are needed on the lifetime of the app.
import 'package:online_shop_app/comm/backend_api.dart';
import 'package:online_shop_app/core/app_manager.dart';


class Constants {
  static final  api = BackendApi();
  static final appMan = AppManager();
  static var arabic = false;
}