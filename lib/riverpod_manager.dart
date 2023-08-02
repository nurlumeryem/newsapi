import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapi/pages/home/viewmodel/home_viewmodel.dart';

final homeViewModelProvider = ChangeNotifierProvider((ref) => HomeViewModel());
