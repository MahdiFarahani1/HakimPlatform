import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/features/sounds/logic/cubit/player_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:flutter_application_1/core/utils/extension.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        final cubit = context.read<PlayerCubit>();
        final hasSong = state.currentSong != null;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final offset = Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offset, child: child),
            );
          },
          child: !hasSong
              ? const SizedBox.shrink(key: ValueKey('empty'))
              : _PlayerCard(
                  key: ValueKey(state.currentSong!.id),
                  state: state,
                  cubit: cubit,
                  formatDuration: _formatDuration,
                ),
        );
      },
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final PlayerState state;
  final PlayerCubit cubit;
  final String Function(Duration) formatDuration;

  const _PlayerCard({
    super.key,
    required this.state,
    required this.cubit,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final song = state.currentSong!;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryBlue.withOpacity(0.16),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
            decoration: BoxDecoration(
              color: context.theme.brightness == Brightness.dark
                  ? context.appTheme.cardBackgroundColor.withOpacity(0.72)
                  : Colors.white.withOpacity(0.72),
              border: Border.all(
                color: context.theme.brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.white.withOpacity(0.6),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _AnimatedCover(coverUrl: song.coverUrl),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.25),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Column(
                          key: ValueKey('${song.id}-text'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              song.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                                color: context.theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColor.primaryBlue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              song.artist,
                              style: TextStyle(
                                fontSize: 12,
                                color: context.theme.brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.55)
                                    : AppColor.primaryBlue.withOpacity(0.55),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _SpeedChip(speed: state.speed, onTap: cubit.toggleSpeed),
                  ],
                ),
                const SizedBox(height: 2),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.5,
                    activeTrackColor: AppColor.primaryOrange,
                    inactiveTrackColor: context.theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.12)
                        : AppColor.primaryBlue.withOpacity(0.12),
                    thumbColor: AppColor.primaryOrange,
                    overlayColor: AppColor.primaryOrange.withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: state.duration.inMilliseconds.toDouble().clamp(
                      1,
                      double.infinity,
                    ),
                    value: state.position.inMilliseconds.toDouble().clamp(
                      0,
                      state.duration.inMilliseconds.toDouble().clamp(
                        1,
                        double.infinity,
                      ),
                    ),
                    onChanged: (v) {
                      cubit.seekTo(Duration(milliseconds: v.round()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDuration(state.position),
                        style: TextStyle(
                          fontSize: 11,
                          color: context.theme.brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.5)
                              : AppColor.primaryBlue.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        formatDuration(state.duration),
                        style: TextStyle(
                          fontSize: 11,
                          color: context.theme.brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.5)
                              : AppColor.primaryBlue.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ControlButton(
                      icon: Icons.skip_next_rounded,
                      size: 24,
                      onTap: cubit.playPrevious,
                    ),
                    _ControlButton(
                      icon: Icons.replay_10_rounded,
                      size: 22,
                      onTap: cubit.seekBackward10,
                    ),
                    _PlayPauseButton(
                      state: state,
                      onTap: cubit.togglePlayPause,
                    ),
                    _ControlButton(
                      icon: Icons.forward_10_rounded,
                      size: 22,
                      onTap: cubit.seekForward10,
                    ),
                    _ControlButton(
                      icon: Icons.skip_previous_rounded,
                      size: 24,
                      onTap: cubit.playNext,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedCover extends StatelessWidget {
  final String coverUrl;

  const _AnimatedCover({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(anim),
            child: child,
          ),
        ),
        child: Image.network(
          coverUrl,
          key: ValueKey(coverUrl),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 48,
            height: 48,
            color: context.theme.brightness == Brightness.dark
                ? Colors.grey[800]
                : AppColor.bgColor,
            child: Icon(
              Icons.music_note,
              size: 18,
              color: context.theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.5)
                  : AppColor.primaryBlue.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final PlayerState state;
  final VoidCallback onTap;

  const _PlayPauseButton({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLoading = state.status == PlaybackStatus.loading;

    return ZoomTapAnimation(
      onTap: isLoading ? null : onTap,
      beginDuration: const Duration(milliseconds: 120),
      endDuration: const Duration(milliseconds: 120),

      enableLongTapRepeatEvent: false,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.primaryBlue,
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryBlue.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
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
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    state.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    key: ValueKey(state.isPlaying),
                    color: Colors.white,
                    size: 30,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      beginDuration: const Duration(milliseconds: 100),
      endDuration: const Duration(milliseconds: 100),

      enableLongTapRepeatEvent: false,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: size,
          color: context.theme.brightness == Brightness.dark
              ? Colors.white
              : AppColor.primaryBlue,
        ),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final double speed;
  final VoidCallback onTap;

  const _SpeedChip({required this.speed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFast = speed == 2.0;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isFast
              ? AppColor.primaryOrange.withOpacity(0.18)
              : (context.theme.brightness == Brightness.dark
                  ? context.appTheme.cardBackgroundColor
                  : AppColor.bgColor),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFast ? AppColor.primaryOrange : Colors.transparent,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: Text(
            isFast ? '2x' : '1x',
            key: ValueKey(isFast),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isFast
                  ? AppColor.primaryOrange
                  : (context.theme.brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.5)
                      : AppColor.primaryBlue.withOpacity(0.5)),
            ),
          ),
        ),
      ),
    );
  }
}
