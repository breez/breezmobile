class NetworkData {
  String peer = '';
  bool isDefault = false;

  NetworkData(this.peer, this.isDefault);

  NetworkData.initial() : this('', false);

  NetworkData copyWith({String peer, bool isDefault}) =>
      NetworkData(peer ?? this.peer, isDefault ?? this.isDefault);
}
