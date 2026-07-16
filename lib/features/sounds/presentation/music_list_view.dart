import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/custom_header.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/empty_widget.dart';
import 'package:flutter_application_1/features/sounds/data/models/song.dart';
import 'package:flutter_application_1/features/sounds/logic/cubit/player_cubit.dart';
import 'package:flutter_application_1/features/history/data/models/history_item.dart';
import 'package:flutter_application_1/features/history/logic/cubit/history_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/utils/extension.dart';

import '../../../core/logic/search/search_cubit.dart';
import '../widgets/mini_player.dart';
import '../widgets/song_tile.dart';

class MusicListScreen extends StatelessWidget {
  const MusicListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();
    cubit.setPlaylist(sampleSongs);

    return BlocProvider(
      create: (context) => SearchCubit<Song>()..clear(sampleSongs),
      child: const _MusicListView(),
    );
  }
}

class _MusicListView extends StatelessWidget {
  const _MusicListView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();
    final searchController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.appTheme.scaffoldGradient),
        child: BlocBuilder<SearchCubit<Song>, SearchState<Song>>(
          builder: (context, searchState) {
            final songCount = searchState.results.length;
            return Column(
              children: [
                CustomHeader(
                  title: 'الاستماع الآن',
                  subtitle: '$songCount ملف صوتي',
                  icon: Assets.icons.headphonesRhythm.image(
                    width: 26,
                    height: 26,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomSearchBar(
                    controller: searchController,
                    hintText: 'بحث في الأغاني...',
                    onChanged: (query) {
                      context.read<SearchCubit<Song>>().search(
                        query: query,
                        source: sampleSongs,
                        title: (song) => song.title,
                      );
                    },
                    onClear: () {
                      context.read<SearchCubit<Song>>().clear(sampleSongs);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: searchState.results.isEmpty
                      ? EmptySearchWidget(controller: searchController)
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          itemCount: searchState.results.length,
                          itemBuilder: (context, index) {
                            final song = searchState.results[index];
                            return SongTile(
                              song: song,
                              onTap: () {
                                context.read<HistoryCubit>().addItem(
                                  HistoryItem.fromSong(song),
                                );
                                cubit.playSong(song);
                              },
                            );
                          },
                        ),
                ),
                const MiniPlayer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
