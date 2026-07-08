class Song {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String audioUrl;
  final Duration duration;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.audioUrl,
    required this.duration,
  });
}

/// نمونه لیست آهنگ‌ها برای تست UI
final List<Song> sampleSongs = [
  Song(
    id: '1',
    title: 'Night Drive',
    artist: 'Kavir Sounds',
    coverUrl: 'https://picsum.photos/seed/1/400',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    duration: const Duration(minutes: 3, seconds: 45),
  ),
  Song(
    id: '2',
    title: 'Golden Hour',
    artist: 'Nour Band',
    coverUrl: 'https://picsum.photos/seed/2/400',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    duration: const Duration(minutes: 4, seconds: 12),
  ),
  Song(
    id: '3',
    title: 'City Lights',
    artist: 'Tehran Waves',
    coverUrl: 'https://picsum.photos/seed/3/400',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    duration: const Duration(minutes: 3, seconds: 58),
  ),
  Song(
    id: '4',
    title: 'Desert Wind',
    artist: 'Kavir Sounds',
    coverUrl: 'https://picsum.photos/seed/4/400',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    duration: const Duration(minutes: 5, seconds: 2),
  ),
  Song(
    id: '5',
    title: 'Midnight Cafe',
    artist: 'Nour Band',
    coverUrl: 'https://picsum.photos/seed/5/400',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    duration: const Duration(minutes: 2, seconds: 51),
  ),
];
