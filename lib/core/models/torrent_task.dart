class TorrentTask {
  final String id;
  final String name;
  final String status;
  final int size;
  final double progress;
  final int downloadSpeed;
  final int uploadSpeed;

  TorrentTask({
    required this.id,
    required this.name,
    required this.status,
    required this.size,
    required this.progress,
    required this.downloadSpeed,
    required this.uploadSpeed,
  });

  factory TorrentTask.fromJson(Map<String, dynamic> json) {
    return TorrentTask(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      status: json['status'] ?? 'unknown',
      size: json['size'] ?? 0,
      progress: (json['progress'] ?? 0.0).toDouble(),
      downloadSpeed: json['downloadSpeed'] ?? 0,
      uploadSpeed: json['uploadSpeed'] ?? 0,
    );
  }

  factory TorrentTask.fromSynologyJson(Map<String, dynamic> json) {
    String status = json['status'] ?? 'unknown';
    int totalSize = json['additional']?['detail']?['total_size'] ?? 0;
    int downloaded = json['additional']?['transfer']?['size_downloaded'] ?? 0;
    double progress = (totalSize > 0) ? (downloaded / totalSize * 100) : 0.0;

    return TorrentTask(
      id: json['id'],
      name: json['title'],
      status: status,
      size: totalSize,
      progress: progress,
      downloadSpeed: json['additional']?['transfer']?['speed_download'] ?? 0,
      uploadSpeed: json['additional']?['transfer']?['speed_upload'] ?? 0,
    );
  }

  factory TorrentTask.fromQBittorrentJson(Map<String, dynamic> json) {
    return TorrentTask(
      id: json['hash'],
      name: json['name'],
      status: json['state'],
      size: json['size'],
      progress: (json['progress'] * 100).toDouble(),
      downloadSpeed: json['dlspeed'],
      uploadSpeed: json['upspeed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'size': size,
        'progress': progress,
        'downloadSpeed': downloadSpeed,
        'uploadSpeed': uploadSpeed,
      };
}
