import 'package:flutter_acrcloud_plugin/flutter_acrcloud_plugin.dart';

class RecognitionService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    await ACRCloud.setUp(const ACRCloudConfig(
      '56d6c04876e64379f785f33817b19920',
      'UeR2kvVFPtBszfVwSzLCXmBXIOGIQUxvVdLWN6Zs',
      'identify-eu-west-1.acrcloud.com',
    ));
    _initialized = true;
  }

  static Future<SongResult?> recognize() async {
    await init();
    final session = ACRCloud.startSession();
    final result = await session.result;
    if (result == null) return null;
    final music = result.metadata?.music;
    if (music == null || music.isEmpty) return null;
    final song = music.first;
    return SongResult(
      title: song.title ?? 'Unbekannt',
      artist: song.artists.isNotEmpty ? song.artists.first.name : 'Unbekannt',
      album: song.album?.name ?? '',
    );
  }
}

class SongResult {
  final String title;
  final String artist;
  final String album;
  const SongResult({
    required this.title,
    required this.artist,
    required this.album,
  });
}