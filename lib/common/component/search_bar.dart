import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFriends extends ConsumerWidget {
  const SearchFriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("친구 검색"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "친구 검색",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    // 친구 검색 기능 호출
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
              onChanged: (value) {
                // 검색 결과 업데이트하는 기능 호출
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20, // 검색 결과의 길이로 변경
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(),
                  title: const Text("사용자 이름"),
                  trailing: IconButton(
                    onPressed: () {
                      // 친구 추가 기능 호출
                    },
                    icon: const Icon(Icons.person_add),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
