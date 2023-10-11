import 'package:on_audio_query/on_audio_query.dart';

abstract class PlayerStates {}

class InitialState extends PlayerStates {}

class LoadSongLoading extends PlayerStates {}

class LoadSongError extends PlayerStates {}

class LoadSongSucces extends PlayerStates {
  LoadSongSucces(
      {required this.songs,
      required this.index,
      required this.seconds,
      required this.currentPosition,
      required this.image});
  List<SongModel> songs;
  int seconds;
  int currentPosition;
  int index;
  QueryArtworkWidget image;
}
