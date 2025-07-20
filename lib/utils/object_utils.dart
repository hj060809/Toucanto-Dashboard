class VEnum {
  VEnum({
    required this.enumName,
    required this.index,
    required this.code,
    this.description,
  });

  final String enumName;
  final int index;
  final String code;
  final String? description;
}

class VariableEnumerator {
  VariableEnumerator({
    required this.enumName,
    required this.codeList,
    this.descriptions,
  });

  final String enumName;
  final List<String> codeList;
  final List<String>? descriptions;

  VEnum getVEnumFromIndex(int index) {
    return VEnum(
      enumName: enumName,
      index: index,
      code: codeList[index],
      description: descriptions?[index],
    );
  }

  VEnum? getVEnumFromCode(String code) {
    int index = codeList.indexOf(code);
    if (index == -1) {
      return null;
    }
    return VEnum(
      enumName: enumName,
      index: index,
      code: code,
      description: descriptions?[index],
    );
  }
}
