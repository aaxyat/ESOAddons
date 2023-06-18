-- Translated by: @mychaelo

ZO_CreateStringId("SI_LOOTLOG_TITLE"             , "Loot Log")

ZO_CreateStringId("SI_LOOTLOG_SUBTITLE_LIST"     , "Журнал добычи")
ZO_CreateStringId("SI_LOOTLOG_SUBTITLE_MATS"     , "Сводка по материалам")

ZO_CreateStringId("SI_LOOTLOG_SHOW_UNCOLLECTED"  , "Только не изученные")
ZO_CreateStringId("SI_LOOTLOG_TIME_LABEL"        , "Материалы собраны начиная с: %s")

ZO_CreateStringId("SI_LOOTLOG_HEADER_TIME"       , "Время")
ZO_CreateStringId("SI_LOOTLOG_HEADER_ITEM"       , "Предмет")
ZO_CreateStringId("SI_LOOTLOG_HEADER_TRAIT"      , "Особенность")
ZO_CreateStringId("SI_LOOTLOG_HEADER_COUNT"      , "К-во")
ZO_CreateStringId("SI_LOOTLOG_HEADER_RECIPIENT"  , "Получатель")
ZO_CreateStringId("SI_LOOTLOG_HEADER_CURTOTAL"   , "Текущий итог")

ZO_CreateStringId("SI_LOOTLOG_MODE0"             , "Нет")
ZO_CreateStringId("SI_LOOTLOG_MODE1"             , "Наборы предметов (свои)")
ZO_CreateStringId("SI_LOOTLOG_MODE2"             , "Наборы предметов")
ZO_CreateStringId("SI_LOOTLOG_MODE3"             , "Важная добыча (своя)")
ZO_CreateStringId("SI_LOOTLOG_MODE4"             , "Важная добыча")
ZO_CreateStringId("SI_LOOTLOG_MODE5"             , "Вся добыча (своя)")
ZO_CreateStringId("SI_LOOTLOG_MODE6"             , "Все предметы в журнале")

ZO_CreateStringId("SI_LOOTLOG_HISTORY_LABEL"     , "Данные хранятся: %dч (|c336699|l0:1:1:1:1:336699|lизменить/очистить|l|r)")

ZO_CreateStringId("SI_LOOTLOG_CHATCOMMANDS"      , "Чат-команды")
ZO_CreateStringId("SI_LOOTLOG_LINKTRADE"         , "Отправить ссылки на ненужные предметы")
ZO_CreateStringId("SI_LOOTLOG_BINDUNCOLLECTED"   , "Привязать неизученные предметы")

ZO_CreateStringId("SI_LOOTLOG_TRADE_REQUEST"     , "Запросить")
ZO_CreateStringId("SI_LOOTLOG_TRADE_LINKRESET"   , "Блокировка повторных ссылок от |c00CCFF/linktrade|r была снята.")
ZO_CreateStringId("SI_LOOTLOG_TRADE_NOLINKS"     , "Не нашлось ссылок на отправку.")
ZO_CreateStringId("SI_LOOTLOG_TRADE_NOLINKS_CD"  , "Отсутствуют новые предметы; для повторного сброса в чат старых ссылок (%d шт.) наберите команду |c00CCFF/linktrade reset|r.")
ZO_CreateStringId("SI_LOOTLOG_TRADE_OVERFLOW"    , "Осталось предметов: %d")
ZO_CreateStringId("SI_LOOTLOG_BIND_COMPLETED"    , "Привязано предметов: %d%s")
ZO_CreateStringId("SI_LOOTLOG_BIND_OVERFLOW"     , "Осталось предметов: %d; во избежание ошибки «спам сообщениями» чуть погодите перед повторным набором команды |c00CCFF/binduncollected|r, которая привяжет оставшиеся предметы.")
ZO_CreateStringId("SI_LOOTLOG_BIND_SHOW"         , "Показать предметы")

ZO_CreateStringId("SI_LOOTLOG_SECTION_HISTORY"   , "Исторические данные")
ZO_CreateStringId("SI_LOOTLOG_SECTION_CHAT"      , "Уведомления о добыче в чат")
ZO_CreateStringId("SI_LOOTLOG_SECTION_TRADE"     , "Функции обмена")
ZO_CreateStringId("SI_LOOTLOG_SECTION_UNCCOLORS" , "Цвета метки отсутствия в коллекции")
ZO_CreateStringId("SI_LOOTLOG_SECTION_MULTI"     , "Поддержка нескольких учётных записей")

ZO_CreateStringId("SI_LOOTLOG_SETTING_HISTORY"   , "Срок хранения данных журнала (в часах)")
ZO_CreateStringId("SI_LOOTLOG_SETTING_CLEAR"     , "Очистить журнал")
ZO_CreateStringId("SI_LOOTLOG_SETTING_CHATMODE"  , "Режим уведомлений")
ZO_CreateStringId("SI_LOOTLOG_SETTING_CHATICONS" , "Показывать значки")
ZO_CreateStringId("SI_LOOTLOG_SETTING_CHATSTOCK" , "Показывать запасы материалов")
ZO_CreateStringId("SI_LOOTLOG_SETTING_CHATUNC"   , "Отмечать неизученные предметы")
ZO_CreateStringId("SI_LOOTLOG_SETTING_CHATUNCTT" , "Кроме того, не полученные в коллекцию предметы других игроков будут выводиться даже при режимах уведомлений «только своё».")
ZO_CreateStringId("SI_LOOTLOG_SETTING_TRADEITLS" , "Отмечать неизученные предметы в списках")
ZO_CreateStringId("SI_LOOTLOG_SETTING_TRADEILTT" , "В том числе это список предметов в инвентаре, банках, у торговцев и в окне забора добычи.")
ZO_CreateStringId("SI_LOOTLOG_SETTING_TRADELINK" , "Отмечать неизученные предметы в чужих ссылках")
ZO_CreateStringId("SI_LOOTLOG_SETTING_TRADEREQ"  , "Добавлять кнопку запроса предмета")
ZO_CreateStringId("SI_LOOTLOG_SETTING_TRADEREQM" , "Текст просьбы")
ZO_CreateStringId("SI_LOOTLOG_SETTING_TRADEBE"   , "Включать в список /linktrade «BoE»-предметы (привязываемые при надевании)")
ZO_CreateStringId("SI_LOOTLOG_SETTING_TRADEBETT" , "Чат-команда |c00CCFF/linktrade|r (или |c00CCFF/lt|r) скинет в чат ссылки на привязываемые при подборе (BoP) предметы, которые у вас уже изучены, а при активации этого параметра ещё и привязываемые при надевании (BoE).")
ZO_CreateStringId("SI_LOOTLOG_SETTING_UCLRPERS"  , "Полученное вами")
ZO_CreateStringId("SI_LOOTLOG_SETTING_UCLRGRP"   , "Полученное другими")
ZO_CreateStringId("SI_LOOTLOG_SETTING_UCLRCHAT"  , "Чужие ссылки")
ZO_CreateStringId("SI_LOOTLOG_SETTING_UCLRITLS"  , "Списки предметов")

ZO_CreateStringId("SI_LOOTLOG_MULTI_DESCRIPTION" , "Если включить, Loot Log будет отмечать предметы, пригодные для обмена и не изученные другими вашими учётными записями.\n\nДля нормального функционирования вам необходимо настроить раздел «Приоритетность учётных записей» ниже, чтобы аддон знал, для каких записей требуется сбор.\n\nЕщё не забудьте установить библиотеку LibMultiAccountSets/LibMultiAccountCollectibles.")
ZO_CreateStringId("SI_LOOTLOG_MULTI_ACCOUNTS"    , "Приоритетность учётных записей")
ZO_CreateStringId("SI_LOOTLOG_MULTI_PRIORITY"    , "Уровень приоритета %d")

ZO_CreateStringId("SI_LOOTLOG_SELF_IDENTIFIER"   , "себе")

ZO_CreateStringId("SI_LOOTLOG_WELCOME"           , "Вы установили |cCC33FFLoot Log 4|r, добавляющий в игру |c00FFCC|H0:lootlog|hжурнал всей добычи со строкой поиска и фильтром неизученного|h|r. Вызвать его можно командой |c00CCFF/lootlog|r в чат или назначенной клавишей. Дополнительную информацию см. на |c00FFCC|H0:llweb|hвеб-странице модификации Loot Log|h|r.")
