#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтображатьСписокАктивныхЗадач = Истина;
	Если ТипЗнч(Параметры.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ОтображатьСписокАктивныхЗадач = Ложь;
	КонецЕсли;
	
	РаботаСБизнесПроцессамиВызовСервера.ДеревоПроцессовИЗадач_ПриСозданииНаСервере(
		ЭтаФорма, Параметры.Предмет, Истина, ОтображатьСписокАктивныхЗадач);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	РаботаСБизнесПроцессамиКлиент.ОбработкаОповещенияДляДереваЗадач(
		ИмяСобытия, Параметр, Источник, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДеревоЗадач

&НаКлиенте
Процедура ДеревоЗадачПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ДеревоЗадачПриАктивизацииСтроки(Элемент, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ДеревоЗадачВыбор(
		Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗадачПередНачаломИзменения(Элемент, Отказ)
	
	РаботаСБизнесПроцессамиКлиент.ДеревоЗадачПередНачаломИзменения(Элемент, Отказ, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_СписокАктивныхЗадач

&НаКлиенте
Процедура СписокАктивныхЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		СписокАктивныхЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.СписокАктивныхЗадачПриАктивизацииСтроки(Элемент, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачПередНачаломИзменения(Элемент, Отказ)
	
	РаботаСБизнесПроцессамиКлиент.СписокАктивныхЗадачПередНачаломИзменения(
		Элемент, Отказ, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"),
		"ДеревоЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"),
		"ДеревоЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"),
		"ДеревоЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"),
		"ДеревоЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"),
		"ДеревоЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"),
		"ДеревоЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		Неопределено,
		"ДеревоЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачЖелтыйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"),
		"СписокАктивныхЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачЗеленыйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"),
		"СписокАктивныхЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачКрасныйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"),
		"СписокАктивныхЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачЛиловыйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"),
		"СписокАктивныхЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачОранжевыйФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"),
		"СписокАктивныхЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачОчиститьФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		Неопределено,
		"СписокАктивныхЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхЗадачСинийФлаг(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьФлаги(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"),
		"СписокАктивныхЗадач");
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДеревоПроцессовЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВДеревеЗадач(Команда)
	
	Если Элементы.СписокАктивныхЗадач.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НайтиВДеревеЗадачНаСервере(Элементы.СписокАктивныхЗадач.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКТекущемуОбъекту(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПерейтиКТекущемуОбъекту(Параметры.Предмет, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновляет и разворачивает дерево процессов и задач.
//
&НаКлиенте
Процедура ОбновитьДеревоПроцессовЗадач() Экспорт
	
	ЗаполнитьДеревоПроцессовИЗадач();
	РаботаСБизнесПроцессамиКлиент.РазвернутьДеревоПроцессовИЗадач(ЭтаФорма);
	
КонецПроцедуры

// Заполняет дерево процессов и задач.
//
&НаСервере
Процедура ЗаполнитьДеревоПроцессовИЗадач() Экспорт
	
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьПроцессыИЗадачиПоПредмету(ЭтаФорма, Параметры.Предмет);
	
КонецПроцедуры

// Находит текущую списка СписокАктивныхЗадач в дереве задач.
//
&НаСервере
Процедура НайтиВДеревеЗадачНаСервере(Задача)
	
	ТекущаяСтрокаВДереве = Задача;
	
	РаботаСБизнесПроцессамиКлиентСервер.УстановитьТекущуюСтроку(ДеревоЗадач.ПолучитьЭлементы(), ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
