class MuseumQuests {
  static const List<Map<String, String>> cheeseMuseumQuests = [
    {
      'id': 'cheese_1',
      'name': 'Самый старый сырный пресс',
      'description': 'Определи его вес по маркировке',
      'type': 'text',
      'answer': 'ok',
    },
    {
      'id': 'cheese_2',
      'name': 'Пазл-этикетка',
      'description': 'Восстанови старинную упаковку костромского сыра',
      'type': 'text',
      'answer': 'ok',
    },
    {
      'id': 'cheese_3',
      'name': 'Секретный ингредиент',
      'description': 'Отыщи необычную добавку в сыр среди экспонатов',
      'type': 'text',
      'answer': 'ok',
    },
    {
      'id': 'cheese_4',
      'name': 'Определи сорт сыра',
      'description': 'Угадай сыр в дегустационной зоне вслепую',
      'type': 'text',
      'answer': 'ok',
    },
  ];

  static const List<Map<String, String>> natureMuseumQuests = [
    {
      'id': 'nature_1',
      'name': 'Самый крупный экспонат',
      'description': 'Найди самый крупный экспонат и отсканируй QR-код рядом с ним',
      'type': 'qr',
      'answer': '',
    },
    {
      'id': 'nature_2',
      'name': 'Найди настоящего махаона',
      'description': 'Найди крупную бабочку с жёлтыми крыльями, синими узорами и красными "глазками" с хвостиками на задних крыльях. Напиши её латинское название',
      'type': 'text',
      'answer': 'Papilio machaon',
    },
    {
      'id': 'nature_3',
      'name': 'Лесной свин',
      'description': 'Найди дикого кабана. Сколько пальцев у него на каждой ноге?',
      'type': 'text',
      'answer': '4',
    },
    {
      'id': 'nature_4',
      'name': 'Косолапый экспонат',
      'description': 'Найди бурого медведя и сфотографируй его',
      'type': 'photo',
      'answer': 'bear',
    },
    {
      'id': 'nature_5',
      'name': 'Дикие кошки',
      'description': 'Найди дикую кошку, обитающую в наших лесах, и сфотографируй её',
      'type': 'photo',
      'answer': 'cat',
    },
  ];

  static const List<Map<String, String>> guardMuseumQuests = [
    {
      'id': 'military_1',
      'name': 'Самое старое оружие',
      'description': 'Запиши его тип и год изготовления',
      'type': 'text',
      'answer': 'ok',
    },
    {
      'id': 'military_2',
      'name': 'Шифр донесения',
      'description': 'Расшифруй сообщение с помощью ключа из экспоната №14',
      'type': 'text',
      'answer': 'ok',
    },
    {
      'id': 'military_3',
      'name': 'Нарушитель устава',
      'description': 'Определи по уставу, за что арестовали солдата',
      'type': 'text',
      'answer': 'ok',
    },
    {
      'id': 'military_4',
      'name': 'Караульный график',
      'description': 'Распредели смены караула на сутки',
      'type': 'text',
      'answer': 'ok',
    },
  ];
}
