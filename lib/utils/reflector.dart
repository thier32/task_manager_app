import 'package:reflectable/reflectable.dart';

class ModelReflector extends Reflectable {
  const ModelReflector()
      : super(
          invokingCapability,
          newInstanceCapability,
          typeCapability,
          declarationsCapability,
        );
}

const reflector = ModelReflector();