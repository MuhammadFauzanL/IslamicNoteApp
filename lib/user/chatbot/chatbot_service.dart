import '../doa/models/doa.dart';
import '../doa/data/doa_dummy.dart';

class ChatbotService {
  Doa? findDoa(String input) {
    final query = input.toLowerCase();

    return doaList.cast<Doa?>().firstWhere(
      (doa) =>
          doa!.judul.toLowerCase().contains(query) ||
          doa.keywords.any((k) => query.contains(k.toLowerCase())),
      orElse: () => null,
    );
  }

  String buildResponse(Doa doa) {
    return '''
📖 ${doa.judul}

🕌 Arab:
${doa.arab}

📘 Latin:
${doa.latin}

📝 Arti:
${doa.arti}
''';
  }
}
