#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьСхемыПомещений = ПолучитьФункциональнуюОпцию("ИспользоватьСхемыПомещений");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям")
		И Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) Тогда
		СписокОрганизаций = Новый СписокЗначений;
		СписокОрганизаций.Добавить(Параметры.Организация);
		СписокОрганизаций.Добавить(Справочники.Организации.ПустаяСсылка());
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Организация",
			СписокОрганизаций,
			ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") И ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		ПустоеИПодразделение = Новый СписокЗначений;
		ПустоеИПодразделение.Добавить(Параметры.Подразделение);
		ПустоеИПодразделение.Добавить(Справочники.СтруктураПредприятия.ПустаяСсылка());
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Подразделение",
			ПустоеИПодразделение,
			ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
	ПоказыватьУдаленные = Ложь;
	ИзменитьОтображениеУдаленных(ПоказыватьУдаленные, СписокТерриторий, Список, 
		Элементы.ПоказыватьУдаленные);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ЗапрещеноРазмещатьНовыеДела", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	Если Параметры.Свойство("ТекущаяСтрока") И ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		МестоХраненияПриОткрытии = Параметры.ТекущаяСтрока;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоХраненияПриОткрытии) Тогда  
		Если ИспользоватьСхемыПомещений Тогда 
			ТекущаяТерритория = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МестоХраненияПриОткрытии,
				"ТерриторияПомещение");
			Список.Параметры.УстановитьЗначениеПараметра("Территория", ТекущаяТерритория);
			Элементы.СписокТерриторий.ТекущаяСтрока = ТекущаяТерритория;
		КонецЕсли;
		
		Элементы.Список.ТекущаяСтрока = МестоХраненияПриОткрытии;
	КонецЕсли;
	
	СохранениеВводимыхЗначений.ЗагрузитьСписокВыбора(ЭтаФорма, "СтрокаПоиска");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		
		СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
		Если СтрДлина(СтрокаПоиска) < 3 И СтрокаПоиска <> "*" И СтрокаПоиска <> "**" Тогда			
			ЭтаФорма.ТекущийЭлемент = Элементы.СтрокаПоиска;
			ЭтаФорма.Активизировать();
			ПоказатьПредупреждение(, НСтр("ru = 'Необходимо ввести минимум 3 символа'"));
			Возврат;
		КонецЕсли;
		
		СохранениеВводимыхЗначенийКлиент.ОбновитьСписокВыбора(ЭтаФорма, "СтрокаПоиска", 10);
		
		ПустойРезультатПоиска = Ложь;
		
		Если ИспользоватьСхемыПомещений Тогда 
			НайтиТерриторииИМестаХранения();
		Иначе 
			НайтиМестаХранения();
		КонецЕсли;
		
		ПустойРезультатПоиска = ДеревоМестХранения.ПолучитьЭлементы().Количество() = 0;
		
		Если ПустойРезультатПоиска Тогда
			ТекущийЭлемент = Элементы.СтрокаПоиска;
			УстановитьВидимостьРезультатаПоиска(Ложь);
			ПоказатьПредупреждение(, НСтр("ru = 'По вашему запросу ничего не найдено'"));
			
		Иначе
			ТекущийЭлемент = Элементы.ДеревоМестХранения;
			УстановитьВидимостьРезультатаПоиска(Истина);
			РазвернутьДерево("ДеревоМестХранения");
			
		КонецЕсли;
		
		ПоискВключен = Истина;
	Иначе
		Если ПоискВключен Тогда
			ОчиститьПоиск();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтрокаПоиска = Неопределено;
	ОчиститьПоиск();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокТерриторий

&НаКлиенте
Процедура ДеревоМестХраненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоМестХранения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоМестоХранения Тогда
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМестХраненияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМестХраненияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.ДеревоМестХранения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
		
		Если ТекущиеДанные.ЭтоМестоХранения Тогда
			ОткрытьФорму("Справочник.МестаХраненияДел.ФормаОбъекта", ПараметрыФормы,,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе			
			ОткрытьФорму("Справочник.ТерриторииИПомещения.ФормаОбъекта", ПараметрыФормы,,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМестХраненияПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокТерриторий

&НаКлиенте
Процедура СписокТерриторийПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СписокТерриторий.ТекущаяСтрока <> Неопределено 
		И ТекущаяТерритория <> Элементы.СписокТерриторий.ТекущаяСтрока Тогда
		ПодключитьОбработчикОжидания("ОбновитьСписки", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТерриторийПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТерриторийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ПеретаскиваемоеЗначение = ПараметрыПеретаскивания.Значение;
	Если Строка = Неопределено Тогда
		Возврат;
	Иначе
		ТерриторияНазначения = Строка;
	КонецЕсли;
	
	Если ТекущаяТерритория = ТерриторияНазначения Тогда 
		Возврат;
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	
	Если Не ПереместитьМестаХранения(ПеретаскиваемоеЗначение, ТерриторияНазначения, СообщениеОбОшибке) Тогда
		ПоказатьПредупреждение(, СообщениеОбОшибке);
	Иначе 
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыФормы = Новый Структура;
	
	Если Копирование Тогда 
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
	ИначеЕсли ИспользоватьСхемыПомещений Тогда 
		
		ТекущаяСтрока = Элементы.СписокТерриторий.ТекущаяСтрока;
		Если ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли; 
		
		ПараметрыФормы.Вставить("СхемаПомещения", ТекущаяСтрока);
	КонецЕсли;
	
	Открытьформу("Справочник.МестаХраненияДел.ФормаОбъекта", ПараметрыФормы,
		Элементы.Список, Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьТолькоСМестамиХранения(Команда)
	
	ПоказыватьТолькоСМестамиХранения = Не ПоказыватьТолькоСМестамиХранения;
	Элементы.ПоказыватьТолькоСМестамиХранения.Пометка = ПоказыватьТолькоСМестамиХранения;
	Элементы.КонтекстноеМенюПоказыватьТолькоСМестамиХранения.Пометка = ПоказыватьТолькоСМестамиХранения;
	
	Если ПоказыватьТолькоСМестамиХранения Тогда 
		СписокТерриторий.Параметры.УстановитьЗначениеПараметра("ПоказыватьТолькоСМестамиХранения", Истина);
	Иначе 
		СписокТерриторий.Параметры.УстановитьЗначениеПараметра("ПоказыватьТолькоСМестамиХранения", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	ИзменитьОтображениеУдаленных(ПоказыватьУдаленные, СписокТерриторий, Список, 
		Элементы.ПоказыватьУдаленные);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Элементы.СписокТерриторий.Обновить();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ПоискВключен Тогда 
		ТекущиеДанные = Элементы.ДеревоМестХранения.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Или Не ТекущиеДанные.ЭтоМестоХранения Тогда
			Возврат;
		КонецЕсли;
		
		ТекущаяСтрока = ТекущиеДанные.Ссылка;
		
	Иначе 
		ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
		Если ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИсторию(Команда)
	
	СохранениеВводимыхЗначенийКлиент.ОчиститьСписокВыбора(ЭтаФорма, "СтрокаПоиска");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОтображениеУдаленных(ПоказыватьУдаленные, СписокТерриторий, Список, СписокПоказыватьУдаленные)
	
	Если Не ПоказыватьУдаленные Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьУдаленные);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокТерриторий, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьУдаленные);
	Иначе		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокТерриторий, "ПометкаУдаления");
	КонецЕсли;
	
	СписокПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписки()
	
	Если ИспользоватьСхемыПомещений И ТекущаяТерритория <> Элементы.СписокТерриторий.ТекущаяСтрока Тогда 
		ТекущаяТерритория = Элементы.СписокТерриторий.ТекущаяСтрока;
		Список.Параметры.УстановитьЗначениеПараметра("Территория", ТекущаяТерритория);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПереместитьМестаХранения(МассивМестХранения, ТерриторияНазначения, СообщениеОбОшибке)
	
	Для Каждого МестоХранения Из МассивМестХранения Цикл  
		Территория = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МестоХранения, "ТерриторияПомещение");
		Если Территория = ТерриторияНазначения Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			МестоХраненияОбъект = МестоХранения.ПолучитьОбъект();
			МестоХраненияОбъект.Заблокировать();
		Исключение
			СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Возврат Ложь;
		КонецПопытки;
		
		МестоХраненияОбъект.ТерриторияПомещение = ТерриторияНазначения;
		
		Попытка
			МестоХраненияОбъект.Записать();
		Исключение
			СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Возврат Ложь;
		КонецПопытки;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура РазвернутьДерево(ИмяРеквизитаДерева)
		
	Для каждого СтрокаДерева Из ЭтаФорма[ИмяРеквизитаДерева].ПолучитьЭлементы() Цикл
		Элементы[ИмяРеквизитаДерева].Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;                                                                               	
		
КонецПроцедуры

// Процедуры работы с полем поиска

&НаСервере
Процедура ДобавитьОтборы(Запрос)
	
	Если ЗначениеЗаполнено(ПустоеИПодразделение) И ЗначениеЗаполнено(СписокОрганизаций) Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%1", 
		"	И МестаХраненияДел.Организация В (&СписокОрганизаций)
		|	И МестаХраненияДел.Подразделение В (&СписокПодразделений)");
		
		Запрос.УстановитьПараметр("СписокОрганизаций", СписокОрганизаций);
		Запрос.УстановитьПараметр("СписокПодразделений", ПустоеИПодразделение);
		
	ИначеЕсли ЗначениеЗаполнено(ПустоеИПодразделение) Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%1", 
		"	И МестаХраненияДел.Подразделение В (&СписокПодразделений)");
		
		Запрос.УстановитьПараметр("СписокПодразделений", ПустоеИПодразделение);
		
	ИначеЕсли ЗначениеЗаполнено(СписокОрганизаций) Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%1", 
		"	И МестаХраненияДел.Организация В (&СписокОрганизаций)");
		
		Запрос.УстановитьПараметр("СписокОрганизаций", СписокОрганизаций);
		
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%1", "");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НайтиМестаХранения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	МестаХраненияДел.Ссылка,
		|	МестаХраненияДел.Наименование + ""~"" + МестаХраненияДел.Сокращение,
		|	МестаХраненияДел.Наименование
		|ИЗ
		|	Справочник.МестаХраненияДел КАК МестаХраненияДел
		|ГДЕ
		|	НЕ МестаХраненияДел.ЗапрещеноРазмещатьНовыеДела
		|	И НЕ МестаХраненияДел.ПометкаУдаления
		|	И МестаХраненияДел.Наименование + ""~"" + МестаХраненияДел.Сокращение ПОДОБНО &СтрокаПоиска
		|	%1
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
		
	ДобавитьОтборы(Запрос);
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	КореньДерева = ДеревоМестХранения.ПолучитьЭлементы();
	КореньДерева.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не Элементы.ДеревоМестХранения.Видимость Тогда 
			Элементы.ДеревоМестХранения.Видимость = Истина;
		КонецЕсли;
		
		НовоеМесто = КореньДерева.Добавить();
		НовоеМесто.НомерКартинки = 1;
		НовоеМесто.Наименование = Выборка.Наименование;
		НовоеМесто.Ссылка = Выборка.Ссылка;
		НовоеМесто.ЭтоМестоХранения = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НайтиТерриторииИМестаХранения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТерриторииИПомещения.Ссылка КАК ВладелецОбъекта,
		|	МестаХраненияДел.Ссылка КАК ОбъектПоиска,
		|	ТерриторииИПомещения.Наименование КАК ЗначениеПоиска,
		|	ТерриторииИПомещения.Наименование КАК НаименованиеВладельца,
		|	МестаХраненияДел.Наименование КАК НаименованиеОбъекта
		|ИЗ
		|	Справочник.ТерриторииИПомещения КАК ТерриторииИПомещения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.МестаХраненияДел КАК МестаХраненияДел
		|		ПО (ТерриторииИПомещения.Ссылка = МестаХраненияДел.ТерриторияПомещение)
		|ГДЕ
		|	НЕ МестаХраненияДел.ЗапрещеноРазмещатьНовыеДела
		|	И НЕ ТерриторииИПомещения.ПометкаУдаления
		|	И ТерриторииИПомещения.Наименование ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	МестаХраненияДел.ТерриторияПомещение,
		|	МестаХраненияДел.Ссылка,
		|	МестаХраненияДел.Наименование + ""~"" + МестаХраненияДел.Сокращение,
		|	МестаХраненияДел.ТерриторияПомещение.Наименование,
		|	МестаХраненияДел.Наименование
		|ИЗ
		|	Справочник.МестаХраненияДел КАК МестаХраненияДел
		|ГДЕ
		|	НЕ МестаХраненияДел.ЗапрещеноРазмещатьНовыеДела
		|	И НЕ МестаХраненияДел.ПометкаУдаления
		|	И МестаХраненияДел.Наименование + ""~"" + МестаХраненияДел.Сокращение ПОДОБНО &СтрокаПоиска
		|	%1
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеВладельца,
		|	НаименованиеОбъекта
		|ИТОГИ ПО
		|	ВладелецОбъекта";
		
	ДобавитьОтборы(Запрос);
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	КореньДерева = ДеревоМестХранения.ПолучитьЭлементы();
	КореньДерева.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не Элементы.ДеревоМестХранения.Видимость Тогда 
			Элементы.ДеревоМестХранения.Видимость = Истина;
		КонецЕсли;
		
		НовоеПомещение = КореньДерева.Добавить();
		
		Если ТипЗнч(Выборка.ВладелецОбъекта) = Тип("СправочникСсылка.МестаХраненияДел") Тогда 
			НовоеПомещение.НомерКартинки = 1;
		Иначе 
			НовоеПомещение.НомерКартинки = 0;
		КонецЕсли;
		
		НовоеПомещение.Наименование = Выборка.НаименованиеВладельца;
		НовоеПомещение.Ссылка = Выборка.ВладелецОбъекта;
		
		ВыборкаПоМестамХранения = Выборка.Выбрать();
		Пока ВыборкаПоМестамХранения.Следующий() Цикл
			
			ТипОбъекта = ТипЗнч(ВыборкаПоМестамХранения.ОбъектПоиска);
			Если ТипОбъекта <> Тип("СправочникСсылка.МестаХраненияДел") Тогда
				Продолжить;
			КонецЕсли;
			
			НовоеМестоХранения = НовоеПомещение.ПолучитьЭлементы().Добавить();
			НовоеМестоХранения.Наименование = ВыборкаПоМестамХранения.НаименованиеОбъекта;
			НовоеМестоХранения.Ссылка = ВыборкаПоМестамХранения.ОбъектПоиска;
			НовоеМестоХранения.ЭтоМестоХранения = Истина;
			НовоеМестоХранения.НомерКартинки = 1;
		
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПоиск()

	ПоискВключен = Ложь;
	УстановитьВидимостьРезультатаПоиска(ПоискВключен);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьРезультатаПоиска(Видимость);
	
	Если Видимость Тогда	
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаДерево;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСписки;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

