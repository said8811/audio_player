import 'package:audio_player/cubit/player_cubit.dart';
import 'package:audio_player/cubit/player_states.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class AudioPlayerScreen extends StatefulWidget {
  final List<SongModel> audioModel;
  late int index;
  AudioPlayerScreen({super.key, required this.audioModel, required this.index});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer player = AudioPlayer();
  double currentPosition = 0.0;
  QueryArtworkWidget? queryArtworkWidget;
  playSong() {
    queryArtworkWidget = QueryArtworkWidget(
      id: widget.audioModel[widget.index].id,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(
          Icons.music_note,
          size: 120,
        ),
      ),
    );
  }

  @override
  void initState() {
    playSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AudioPlayer"),
      ),
      body: Container(
          decoration: const BoxDecoration(),
          width: double.infinity,
          child: BlocConsumer<PlayerCubit, PlayerStates>(
            builder: (context, state) {
              if (state is LoadSongLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LoadSongSucces) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(),
                      width: 300,
                      height: 400,
                      child: queryArtworkWidget,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      state.songs[state.index].title.length > 20
                          ? "${state.songs[state.index].title.substring(0, 20)}..."
                          : state.songs[state.index].title,
                      style: const TextStyle(fontSize: 22),
                    ),
                    Text(
                      state.songs[state.index].artist.toString().length > 30
                          ? state.songs[state.index].artist
                              .toString()
                              .substring(0, 30)
                          : state.songs[state.index].artist.toString(),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: const SliderThemeData(
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 6)),
                      child: Slider(
                        value: state.currentPosition.toDouble(),
                        max: state.seconds.toDouble(),
                        onChanged: (double value) {
                          BlocProvider.of<PlayerCubit>(context)
                              .change(state.index, state.songs, value.toInt());
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Text(
                              "${state.currentPosition ~/ 60}:${state.currentPosition % 60 < 10 ? "0${state.currentPosition % 60}" : state.currentPosition % 60}"),
                          const Spacer(),
                          Text("${state.seconds ~/ 60}:${state.seconds % 60}"),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              widget.index--;
                              queryArtworkWidget = QueryArtworkWidget(
                                id: widget.audioModel[widget.index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.music_note,
                                    size: 120,
                                  ),
                                ),
                              );
                              BlocProvider.of<PlayerCubit>(context)
                                  .previus(state.index, state.songs);
                              setState(() {});
                            },
                            icon: const Icon(Icons.skip_previous_rounded)),
                        const SizedBox(width: 20),
                        IconButton(
                            onPressed: () async {
                              BlocProvider.of<PlayerCubit>(context)
                                  .stopAndplay();
                              setState(() {});
                            },
                            icon: PlayerCubit.isPlaying
                                ? const Icon(Icons.pause)
                                : const Icon(Icons.play_arrow)),
                        const SizedBox(width: 20),
                        IconButton(
                            onPressed: () {
                              BlocProvider.of<PlayerCubit>(context)
                                  .nextSong(state.index, state.songs);
                              widget.index++;
                              queryArtworkWidget = QueryArtworkWidget(
                                id: widget.audioModel[widget.index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.music_note,
                                    size: 120,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            icon: const Icon(Icons.skip_next_rounded)),
                      ],
                    )
                  ],
                );
              }
              return const SizedBox();
            },
            listener: (context, state) {},
          )),
    );
  }
}
