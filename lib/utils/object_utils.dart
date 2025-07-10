class VEnum {
  VEnum({
    required this.enumName,
    required this.index,
    required this.code,
    this.description
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
    this.descriptions
  });

  final String enumName;
  final List<String> codeList;
  final List<String>? descriptions;

  VEnum generateVEnum(int index){
    return VEnum(
      enumName: enumName,
      index: index,
      code: codeList[index],
      description: descriptions?[index]
    );
  }
}