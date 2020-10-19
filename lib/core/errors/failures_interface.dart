import 'package:equatable/equatable.dart';

abstract class IFailure with EquatableMixin {
  final List<dynamic> properties;

  IFailure({this.properties = const []});

  @override
  List<Object> get props {
    return properties;
  }
}
