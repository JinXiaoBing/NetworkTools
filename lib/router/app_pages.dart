import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:turbo_network_tools/home/home_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () =>  HomePage(),
    ),
  ];
}
