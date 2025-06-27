enum ServerType { synology, qbittorrent, transmission }

class ServerInfo {
  final String id;
  final String name;
  final ServerType type;
  final String address;
  final int port;
  final String username;
  final String password;
  final String? downloadFolder;
  final bool? isConnected; // 연결 상태 추가
  final String? sessionId; // 세션 ID 추가 (특히 Synology용)

  ServerInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.port,
    required this.username,
    required this.password,
    this.downloadFolder,
    this.isConnected, // 생성자에 추가
    this.sessionId, // 생성자에 추가
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'address': address,
        'port': port,
        'username': username,
        'password': password,
        'downloadFolder': downloadFolder,
        'isConnected': isConnected, // 직렬화에 추가
        'sessionId': sessionId, // 직렬화에 추가
      };

  factory ServerInfo.fromJson(Map<String, dynamic> json) => ServerInfo(
        id: json['id'],
        name: json['name'],
        type: ServerType.values.firstWhere((e) => e.name == json['type'],
            orElse: () => ServerType.qbittorrent),
        address: json['address'],
        port: json['port'],
        username: json['username'],
        password: json['password'],
        downloadFolder: json['downloadFolder'],
        isConnected: json['isConnected'], // 역직렬화에 추가
        sessionId: json['sessionId'], // 역직렬화에 추가
      );

  ServerInfo copyWith({
    String? id,
    String? name,
    ServerType? type,
    String? address,
    int? port,
    String? username,
    String? password,
    String? downloadFolder,
    bool? isConnected, // copyWith에 추가
    String? sessionId, // copyWith에 추가
  }) {
    return ServerInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      downloadFolder: downloadFolder ?? this.downloadFolder,
      isConnected: isConnected ?? this.isConnected, // copyWith 로직 추가
      sessionId: sessionId ?? this.sessionId, // copyWith 로직 추가
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServerInfo &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.address == address &&
        other.port == port &&
        other.username == username &&
        other.password == password &&
        other.downloadFolder == downloadFolder &&
        other.isConnected == isConnected && // 동등성 비교에 추가
        other.sessionId == sessionId; // 동등성 비교에 추가
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        address.hashCode ^
        port.hashCode ^
        username.hashCode ^
        password.hashCode ^
        downloadFolder.hashCode ^
        (isConnected?.hashCode ?? 0) ^ // hashCode에 추가 (null 가능성 고려)
        (sessionId?.hashCode ?? 0); // hashCode에 추가 (null 가능성 고려)
  }
}
