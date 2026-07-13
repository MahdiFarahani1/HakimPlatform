import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/sounds/data/models/song.dart';
import 'package:just_audio/just_audio.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(const PlayerState()) {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _playerStateSub;

  List<Song> _playlist = [];

  void _init() {
    _positionSub = _player.positionStream.listen((pos) {
      emit(state.copyWith(position: pos));
    });

    _durationSub = _player.durationStream.listen((dur) {
      if (dur != null) emit(state.copyWith(duration: dur));
    });

    _playerStateSub = _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        emit(
          state.copyWith(
            status: PlaybackStatus.paused,
            position: Duration.zero,
          ),
        );
        _player.seek(Duration.zero);
      } else if (playerState.playing) {
        emit(state.copyWith(status: PlaybackStatus.playing));
      } else if (playerState.processingState != ProcessingState.completed) {
        emit(state.copyWith(status: PlaybackStatus.paused));
      }
    });
  }

  void setPlaylist(List<Song> songs) {
    _playlist = songs;
  }

  int get _currentIndex {
    if (state.currentSong == null) return -1;
    return _playlist.indexWhere((s) => s.id == state.currentSong!.id);
  }

  bool get hasNext =>
      _playlist.isNotEmpty && _currentIndex < _playlist.length - 1;

  bool get hasPrevious => _playlist.isNotEmpty && _currentIndex > 0;

  Future<void> playSong(Song song) async {
    final isSameSong = state.currentSong?.id == song.id;

    if (isSameSong) {
      await togglePlayPause();
      return;
    }

    try {
      emit(
        state.copyWith(
          currentSong: song,
          status: PlaybackStatus.loading,
          position: Duration.zero,
          duration: song.duration,
        ),
      );

      await _player.setUrl(song.audioUrl);
      await _player.setSpeed(state.speed);
      await _player.play();
    } catch (_) {
      emit(state.copyWith(status: PlaybackStatus.paused));
    }
  }

  Future<void> togglePlayPause() async {
    if (state.currentSong == null) return;

    if (state.isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> playNext() async {
    if (!hasNext) return;
    await playSong(_playlist[_currentIndex + 1]);
  }

  Future<void> playPrevious() async {
    if (state.position > const Duration(seconds: 3) || !hasPrevious) {
      await seekTo(Duration.zero);
      return;
    }
    await playSong(_playlist[_currentIndex - 1]);
  }

  Future<void> seekForward10() async {
    final target = state.position + const Duration(seconds: 10);
    final clamped = target > state.duration ? state.duration : target;
    await _player.seek(clamped);
  }

  Future<void> seekBackward10() async {
    final target = state.position - const Duration(seconds: 10);
    final clamped = target < Duration.zero ? Duration.zero : target;
    await _player.seek(clamped);
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> toggleSpeed() async {
    final newSpeed = state.speed == 1.0 ? 2.0 : 1.0;
    await _player.setSpeed(newSpeed);
    emit(state.copyWith(speed: newSpeed));
  }

  @override
  Future<void> close() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    return super.close();
  }
}
