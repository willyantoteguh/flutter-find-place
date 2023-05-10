import 'package:get_it/get_it.dart';

import '../domains/place/di/dependency.dart';
import 'shared_dependency.dart';

final sl = GetIt.instance;

class Injections {
  Future<void> initialize() async {
    _registerDomains();
    await _registerSharedDependencies();
  }

  void _registerDomains() {
    PlaceDependency();
  }

  Future<void> _registerSharedDependencies() async {
    await SharedDependency().registerCore();
  }
}
