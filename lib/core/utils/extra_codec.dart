// import 'dart:convert';

// class ExtraCodec extends Codec<dynamic, String> {
//   const ExtraCodec();

//   @override
//   Converter<String, dynamic> get decoder => const _ExtraDecoder();
//   @override
//   Converter<dynamic, String> get encoder => const _ExtraEncoder();
// }

// class _ExtraDecoder extends Converter<String, dynamic> {
//   const _ExtraDecoder();

//   @override
//   dynamic convert(String input) {
//     final data = jsonDecode(input);
//     switch (data['type']) {
//       case 'ActivityEntity':
//         return ActivityEntity.fromJson(data['data']);
//       default:
//         throw ArgumentError('Unknown type: ${data['type']}');
//     }
//   }
// }

// class _ExtraEncoder extends Converter<dynamic, String> {
//   const _ExtraEncoder();

//   @override
//   String convert(dynamic input) {
//     if (input is ActivityEntity) {
//       return jsonEncode({'type': 'ActivityEntity', 'data': input.toJson()});
//     } else {
//       return jsonEncode({'type': 'null', 'data': 'null'});
//     }
//   }
// }
