part of 'player_cubit.dart';

enum PlaybackStatus { idle, loading, playing, paused }

class PlayerState extends Equatable {
  final Song? currentSong;
  final PlaybackStatus status;
  final Duration position;
  final Duration duration;
  final double speed;

  const PlayerState({
    this.currentSong,
    this.status = PlaybackStatus.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
  });

  bool get isPlaying => status == PlaybackStatus.playing;

  double get progress {
    if (duration.inMilliseconds == 0) return 0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  PlayerState copyWith({
    Song? currentSong,
    PlaybackStatus? status,
    Duration? position,
    Duration? duration,
    double? speed,
  }) {
    return PlayerState(
      currentSong: currentSong ?? this.currentSong,
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [currentSong, status, position, duration, speed];
}
