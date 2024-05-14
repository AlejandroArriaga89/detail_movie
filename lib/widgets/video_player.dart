import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:detail_movie/providers/movies_provider.dart';
import 'package:detail_movie/models/models.dart';
import 'package:provider/provider.dart';

class VideoPlayer extends StatelessWidget {
  final int movieId;

  const VideoPlayer({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieVideo(movieId),
      builder: (_, AsyncSnapshot<List<Video>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'No se encontraron videos para esta película.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          );
        } else {
          final List<Video> videos = snapshot.data!;

          return Container(
            height: 300,
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 30),
            child: ListView.builder(
              itemCount: videos.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) {
                return _VideoItem(
                  video: videos[index],
                );
              },
            ),
          );
        }
      },
    );
  }
}

class _VideoItem extends StatelessWidget {
  final Video video;

  const _VideoItem({
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            YoutubePlayer(
              controller: YoutubePlayerController(initialVideoId: video.key),
              showVideoProgressIndicator: true,
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
