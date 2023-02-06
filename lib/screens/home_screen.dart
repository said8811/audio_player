import 'package:audio_player/cubit/player_cubit.dart';
import 'package:audio_player/cubit/player_states.dart';
import 'package:audio_player/screens/audio_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_player/widgets/second_to_min.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final _audio_query = OnAudioQuery();

  request() {
    Permission.storage.request();
  }

  @override
  void initState() {
    request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PLaY"),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: _audio_query.querySongs(
                      orderType: OrderType.ASC_OR_SMALLER),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              BlocProvider.of<PlayerCubit>(context)
                                  .playSong(snapshot.data!, index);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AudioPlayerScreen(
                                        audioModel: snapshot.data!,
                                        index: index),
                                  ));
                            },
                            child: ListTile(
                              leading: QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(Icons.music_note),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(snapshot.data![index].title.length > 20
                                      ? "${snapshot.data![index].title.substring(0, 20)}..."
                                      : snapshot.data![index].title),
                                  const Spacer(),
                                  Text(SecToMin(int.parse(snapshot
                                      .data![index].duration
                                      .toString()
                                      .substring(0, 3))))
                                ],
                              ),
                              subtitle: Text(snapshot.data![index].artist
                                          .toString()
                                          .length >
                                      20
                                  ? snapshot.data![index].artist
                                      .toString()
                                      .substring(0, 20)
                                  : snapshot.data![index].artist.toString()),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox(
                      child: Center(
                        child: Text("Get Permission"),
                      ),
                    );
                  },
                ),
              ),
              BlocBuilder<PlayerCubit, PlayerStates>(
                builder: (context, state) {
                  if (state is LoadSongSucces) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioPlayerScreen(
                                  audioModel: state.songs, index: state.index),
                            ));
                      },
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(color: Colors.grey[800]),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.songs[state.index].title.length > 30
                                      ? "${state.songs[state.index].title.substring(0, 30)}..."
                                      : state.songs[state.index].title,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    state.songs[state.index].artist.toString()),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                    "${state.currentPosition ~/ 60}:${state.currentPosition % 60 < 10 ? "0${state.currentPosition % 60}" : state.currentPosition % 60}"),
                                IconButton(
                                    onPressed: () async {
                                      BlocProvider.of<PlayerCubit>(context)
                                          .stopAndplay();
                                      setState(() {});
                                    },
                                    icon: PlayerCubit.isPlaying
                                        ? const Icon(Icons.pause)
                                        : const Icon(Icons.play_arrow)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              )
            ],
          )),
    );
  }
}
