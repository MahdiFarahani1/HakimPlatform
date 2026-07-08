import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/logic/search/search_cubit.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/empty_widget.dart';
import 'package:flutter_application_1/features/sounds/data/models/song.dart';
import 'package:flutter_application_1/features/sounds/logic/cubit/player_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        decoration: const BoxDecoration(gradient: AppColor.primaryGradientBG),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: SizedBox(
                  width: context.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الاستماع الآن',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColor.primaryBlue.withOpacity(0.55),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'أغانيّ',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomSearchBar(
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<SearchCubit<Song>, SearchState<Song>>(
                  builder: (context, searchState) {
                    final songs = searchState.results;

                    if (songs.isEmpty) {
                      return EmptySearchWidget(controller: searchController);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return SongTile(
                          song: song,
                          onTap: () => cubit.playSong(song),
                        );
                      },
                    );
                  },
                ),
              ),
              const MiniPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}
