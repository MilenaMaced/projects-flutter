import 'dart:convert';

import 'package:buscador_gifs/pages/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
class BuscadorGif extends StatefulWidget {
  const BuscadorGif({Key? key}) : super(key: key);

  @override
  State<BuscadorGif> createState() => _BuscadorGifState();
}

class _BuscadorGifState extends State<BuscadorGif> {
  String? buscar;
  int contImagens = 0;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Pesquise aqui o seu gif!',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              onSubmitted: (text) {
                setState(() {
                  buscar = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return criarTabelaGif(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Map> getGifs() async {
    http.Response response;

    String melhoresGifs =
        'https://api.giphy.com/v1/gifs/trending?api_key=SlfuNE1wLGZA9VnEtzViF4k23XhzVdYR&limit=19&rating=g';
    String pesquisaGif =
        'https://api.giphy.com/v1/gifs/search?api_key=SlfuNE1wLGZA9VnEtzViF4k23XhzVdYR&q=$buscar&limit=19&offset=$contImagens&rating=g&lang=pt';

    if (buscar == null) {
      response = await http.get(Uri.parse(melhoresGifs));
    } else {
      response = await http.get(Uri.parse(pesquisaGif));
    }
    return json.decode(response.body);
  }

  int getCount(List data) {
    if (buscar == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget criarTabelaGif(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: getCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if (buscar == null || index < snapshot.data['data'].length) {
          return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300,
                fit: BoxFit.cover,
              ),
              /*child: Image.network(
                snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover,
              ),*/
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GifPage(gifData: snapshot.data['data'][index]),
                  ),
                );
              },
              onLongPress: () async {
                await FlutterShare.share(
                    title: 'Compartilhar Gif',
                    text: 'Compartilhe com quem desejar essa gif...',
                    linkUrl: snapshot.data["images"]["fixed_height"]["url"],
                    chooserTitle: snapshot.data["title"]);
              });
        } else {
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 70,
                ),
                Text(
                  "Carregar mais..",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                contImagens += 19;
              });
            },
          );
        }
      },
    );
  }
}
