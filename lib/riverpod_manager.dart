import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapi/viewmodels/base_viewmodel.dart';

final homeViewModelProvider = ChangeNotifierProvider((ref) => HomeViewModel());
