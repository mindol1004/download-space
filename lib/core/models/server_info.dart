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

  ServerInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.port,
    required this.username,
    required this.password,
    this.downloadFolder,
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
    );
  }
}
