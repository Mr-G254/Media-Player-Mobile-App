import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:media_player/FrontEnd/Components.dart';
import '../BackEnd/App.dart';

class Internet extends StatefulWidget{
  const Internet({super.key});

  @override
  State<Internet> createState() => _DashboardState();
}

class _DashboardState extends State<Internet>{
  ValueNotifier<List<Widget>> searchSuggestion = ValueNotifier([]);
  ValueNotifier<String> searchText = ValueNotifier("");


  @override
  Widget build(BuildContext context){
    final window = Column(
      children: [
        ValueListenableBuilder(
          valueListenable: App.searchTerm,
          builder: (context,value,child){
            return Visibility(
              visible: value.isNotEmpty,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: "Orelega",
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: App.ytVideoWidgets,
            builder: (context,value,child){
              return ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: value
              );
            }
          )
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          window,
          Container(
            padding: const EdgeInsets.all(5),
            child: FloatingSearchBar(
              hint: "Search...",
              hintStyle: const TextStyle(
                fontFamily: "Orelega",
                fontSize: 18,
                color: Colors.white
              ),
              queryStyle: const TextStyle(
                fontFamily: "Orelega",
                fontSize: 20,
                color: Colors.white,
                height: 0.8
              ),
              backdropColor: Colors.transparent,
              transition: CircularFloatingSearchBarTransition(),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              elevation: 5,
              border: const BorderSide(color: Colors.white,width: 2),
              borderRadius: BorderRadius.circular(10),
              backgroundColor: const Color(0xff5C1C14),
              debounceDelay: const Duration(seconds: 1),
              onQueryChanged: (query)async{
                searchText.value = query;
                searchSuggestion.value = [];

                if(query.isNotEmpty){
                  List<String> results  = await App.get_Search_Suggestions(query);
                  List<SearchSuggestions> resultsWidgets = [];

                  for(final i in results){
                    resultsWidgets.add(SearchSuggestions(suggestion: i, searchText: searchText.value));
                  }

                  searchSuggestion.value = resultsWidgets;
                }
              },
              builder: (context,transition){
                return Container(
                  padding: const EdgeInsets.all(0),
                  width: double.infinity,
                  child: ValueListenableBuilder(
                    valueListenable: searchSuggestion,
                    builder: (context,value,child){
                      if(searchSuggestion.value.isNotEmpty){
                        return Card(
                          color: const Color(0xff5C1C14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(top: 5,bottom: 5),
                            child: Column(
                              children: value,
                            ),
                          )
                        );
                      }else if(searchSuggestion.value.isEmpty && searchText.value.isNotEmpty){
                        return Card(
                          color: const Color(0xff5C1C14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                color: Colors.white,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          )
                        );
                      }else{
                        return SizedBox();
                      }
                    }
                  )
                );
            }),
          )
        ],
      ),
    );
  }
}