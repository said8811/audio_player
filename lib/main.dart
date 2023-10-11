import 'package:audio_player/cubit/player_cubit.dart';
import 'package:audio_player/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => PlayerCubit(player: AudioPlayer()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const HomeScreens(),
    );
  }
}
