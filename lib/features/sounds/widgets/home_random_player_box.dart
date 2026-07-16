import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/features/sounds/data/models/song.dart';
import 'package:flutter_application_1/features/sounds/logic/cubit/player_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeRandomPlayerBox extends StatelessWidget {
  HomeRandomPlayerBox({super.key})
    : _song = sampleSongs[Random().nextInt(sampleSongs.length)];

  final Song _song;

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        final cubit = context.read<PlayerCubit>();
        final isThisSong = state.currentSong?.id == _song.id;
        final isPlaying = isThisSong && state.isPlaying;
        final isLoading = isThisSong && state.status == PlaybackStatus.loading;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryBlue.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _song.coverUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, e, s) => Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.music_note_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _song.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColor.primaryBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _song.artist,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.55)
                                : AppColor.primaryBlue.withOpacity(0.55),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  ZoomTapAnimation(
                    onTap: isLoading ? null : () => cubit.playSong(_song),
                    beginDuration: const Duration(milliseconds: 120),
                    endDuration: const Duration(milliseconds: 120),
                    enableLongTapRepeatEvent: false,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.primaryBlue,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primaryBlue.withOpacity(0.30),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) => ScaleTransition(
                            scale: anim,
                            child: FadeTransition(opacity: anim, child: child),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  key: ValueKey('loading'),
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  key: ValueKey(isPlaying),
                                  color: Colors.white,
                                  size: 28,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: isThisSong
                    ? Column(
                        children: [
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                activeTrackColor: AppColor.primaryOrange,
                                inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.12)
                                    : AppColor.primaryBlue.withOpacity(0.12),
                                thumbColor: AppColor.primaryOrange,
                                overlayColor: AppColor.primaryOrange
                                    .withOpacity(0.18),
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 5,
                                ),
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                min: 0,
                                max: state.duration.inMilliseconds
                                    .toDouble()
                                    .clamp(1, double.infinity),
                                value: state.position.inMilliseconds
                                    .toDouble()
                                    .clamp(
                                      0,
                                      state.duration.inMilliseconds
                                          .toDouble()
                                          .clamp(1, double.infinity),
                                    ),
                                onChanged: (v) => cubit.seekTo(
                                  Duration(milliseconds: v.round()),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _fmt(state.position),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.5)
                                      : AppColor.primaryBlue.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                _fmt(state.duration),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.5)
                                      : AppColor.primaryBlue.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
