import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stream_builder/view/home_page/home_page_viewmodel.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePageViewmodel>.reactive(
        viewModelBuilder: () => HomePageViewmodel(),
        onModelReady: (model) => model.initStream(),
        builder: (context, model, child) {
          return model.isBusy
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
                  backgroundColor: Colors.yellow.shade400,
                  appBar: AppBar(
                    backgroundColor: Colors.yellow.shade600,
                    title: const Text(
                      "Dictioniction",
                      style: TextStyle(color: Colors.black),
                    ),
                    centerTitle: true,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(60.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 12.0, bottom: 8.0, right: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Enter Your Word ....",
                                  contentPadding: EdgeInsets.only(left: 24.0),
                                  border: InputBorder.none,
                                ),
                                onChanged: (String val) {
                                  model.searchFor = val;
                                  print(model.searchFor);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  model.search();
                                },
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.black,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  body: StreamBuilder(
                      stream: model.stream,
                      builder: (context, AsyncSnapshot snapshot) {
                        return snapshot.data == "waiting"
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              )
                            : snapshot.data[0] == null
                                ? Center(child: Text('Sorry no data found'))
                                : Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              model.searchFor! +
                                                  "(" +
                                                  snapshot.data[0]['meanings']
                                                      [0]['partOfSpeech'] +
                                                  ")",
                                              style:
                                                  const TextStyle(fontSize: 30),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Meaning : ',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(snapshot.data[0]['meanings'][0]
                                            ['definitions'][0]['definition']),
                                        const SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Example : ',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(snapshot.data[0]['meanings'][0]
                                                        ['definitions'][0]
                                                    ['example'] ==
                                                null
                                            ? "Sorry no examples"
                                            : snapshot.data[0]['meanings'][0]
                                                ['definitions'][0]['example']),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Origin : ',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(snapshot.data[0]['origin'] == null
                                            ? "Sorry no origin data"
                                            : snapshot.data[0]['origin'])
                                      ],
                                    ),
                                  );
                      }),
                );
        });
  }
}
