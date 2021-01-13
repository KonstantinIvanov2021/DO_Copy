#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.ФормироватьСразу = Истина;
	Настройки.ВыводитьСуммуВыделенныхЯчеек = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийОбъекта

// Вызывается при выполнении отчета с помощью метода СкомпоноватьРезультат().
//
// Параметры:
//  ДокументРезультат - ТабличныйДокумент - документ, в который выводится результат,
//  ДанныеРасшифровки - Произвольный - переменная, в которую необходимо поместить
//    данные расшифровки,
//  СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения
//    стандартной (системной) обработки события.
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДокументРезультат.Очистить();
	
	НачатьТранзакцию();
	
	Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
	Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Истина);
	
	Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ОчиститьПредоставленныеРазрешения();
	
	ЗапросыРазрешений = РаботаВБезопасномРежимеСлужебный.ЗапросыОбновленияРазрешенийКонфигурации();
	
	Менеджер = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.МенеджерПримененияРазрешений(ЗапросыРазрешений);
	
	ОтменитьТранзакцию();
	
	ДокументРезультат.Вывести(Менеджер.Представление(Истина));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
