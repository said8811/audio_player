import 'package:audio_player/cubit/player_states.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerCubit extends Cubit<PlayerStates> {
  PlayerCubit({required this.player}) : super(InitialState());
  final AudioPlayer player;
  static bool isPlaying = true;

  playSong(List<SongModel> songModel, int index) {
    emit(LoadSongLoading());
    int duration = 0;
    try {
      isPlaying = true;
      player.setAudioSource(AudioSource.uri(Uri.parse(songModel[index].uri!)));
      player.play();
      player.durationStream.listen((state2) {
        duration = state2!.inSeconds;
      });
      player.positionStream.listen((state2) {
        var img = QueryArtworkWidget(
          id: songModel[index].id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.music_note),
          ),
        );
        emit(LoadSongSucces(
            image: img,
            songs: songModel,
            index: index,
            seconds: duration,
            currentPosition: state2.inSeconds));
      });
    } catch (e) {
      emit(LoadSongError());
    }
  }

  stopAndplay() async {
    isPlaying = !isPlaying;
    if (isPlaying) {
      player.play();
    } else {
      await player.pause();
    }
  }

  nextSong(int index, List<SongModel> songs) {
    if (index != songs.length - 1) {
      int duration = 0;
      index++;
      player.setAudioSource(AudioSource.uri(Uri.parse(songs[index].uri!)));
      player.play();
      player.durationStream.listen((state2) {
        duration = state2!.inSeconds;
      });
      player.positionStream.listen((state2) {
        var img = QueryArtworkWidget(
          id: songs[index].id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.music_note),
          ),
        );
        emit(LoadSongSucces(
            image: img,
            songs: songs,
            index: index,
            seconds: duration,
            currentPosition: state2.inSeconds));
      });
    }
  }

  change(int index, List<SongModel> songs, int current) {
    player.seek(Duration(seconds: current));
    var img = QueryArtworkWidget(
      id: songs[index].id,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(Icons.music_note),
      ),
    );
    emit(LoadSongSucces(
        image: img,
        songs: songs,
        index: index,
        seconds: player.position.inSeconds,
        currentPosition: current));
  }

  previus(int index, List<SongModel> songs) {
    if (index != 0) {
      int duration = 0;
      index--;
      player.setAudioSource(AudioSource.uri(Uri.parse(songs[index].uri!)));
      player.play();
      player.durationStream.listen((state2) {
        duration = state2!.inSeconds;
      });
      player.positionStream.listen((state2) {
        var img = QueryArtworkWidget(
          id: songs[index].id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.music_note),
          ),
        );

        emit(LoadSongSucces(
            image: img,
            songs: songs,
            index: index,
            seconds: duration,
            currentPosition: state2.inSeconds));
      });
    }
  }
}
