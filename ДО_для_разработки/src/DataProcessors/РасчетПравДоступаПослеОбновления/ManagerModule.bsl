#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет запуск фонового задания.
// 
// Возвращаемое значение:
//  ФоновоеЗадание - Фоновое задание.
//
Функция ЗапуститьФоновоеЗадание() Экспорт
	
	ФоновоеЗадание = ФоновоеЗадание();
	Если ФоновоеЗадание = Неопределено Тогда
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(
			"ОбновлениеИнформационнойБазыДокументооборот.РасчетПравДоступаПослеОбновления",
			Новый Массив,
			КлючФоновогоЗадания(),
			НСтр("ru = 'Расчет прав доступа после обновления'"));
	КонецЕсли;
	
	Возврат ФоновоеЗадание;
	
КонецФункции

// Очищает сообщения фонового задания.
//
Процедура ОчиститьСообщенияФоновогоЗадание() Экспорт
	
	ФоновоеЗадание = ФоновоеЗадание();
	Если ФоновоеЗадание <> Неопределено Тогда
		ФоновоеЗадание.ПолучитьСообщенияПользователю(Истина);
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует обработку.
//
Процедура Инициализировать() Экспорт
	
	Если ЗначениеЗаполнено(ТекущееСостояние()) Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ОчередьОбновленияПравДоступа.Очистить();
	
	УзелПланаОбмена = УзелПланаОбмена();
	Для Каждого Тип Из ДокументооборотПраваДоступаПовтИсп.ТипыСсылокИспользующихДоступПоДескрипторам() Цикл
		МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
		ПланыОбмена.ЗарегистрироватьИзменения(УзелПланаОбмена, МетаданныеТипа);
	КонецЦикла;
	
	УстановитьСостояние("Инициализировано");
	
КонецПроцедуры

// Фоновое задание.
//
Процедура ВыполнитьФоновоеЗадание() Экспорт
	
	Если Выполнена() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееСостояние = ТекущееСостояние();
	
	ВыполнитьОчисткуДескрипторовДоступаОбъектов(ТекущееСостояние);
	ВыполнитьРасчетПравШаг2(ТекущееСостояние);
	ВыполнитьРасчетПравШаг3(ТекущееСостояние);
	ПриЗавершенииОбработки(ТекущееСостояние);
	
КонецПроцедуры

// Возвращает признак того, что обработка выполнена.
//
// Возвращаемое значение:
//  Булево - Обработка выполнена.
//
Функция Выполнена() Экспорт
	
	Возврат ТекущееСостояниеСоответсвует("Выполнено");
	
КонецФункции

// Возвращает признак того, что вход в програму разерешн.
//
// Возвращаемое значение:
//  Булево - Обработка выполнена.
//
Функция ВходВПрограммуРазрешен() Экспорт
	
	Возврат ТекущееСостояниеСоответсвует("ВыполняетсяШаг3ВходВПрограммуРазрешен");
	
КонецФункции

// Возвращает признак того, что обработка инициализирована.
//
// Возвращаемое значение:
//  Булево - Обработка инициализирована.
//
Функция Инициализирована() Экспорт
	
	ТекущееСостояние = ТекущееСостояние();
	
	Возврат ТекущееСостояниеСоответсвует("Выполнено", ТекущееСостояние)
		Или ТекущееСостояниеСоответсвует("Инициализировано", ТекущееСостояние);
	
КонецФункции

// Возвращает признак того, что обработка выполнена с ошибками.
//
// Возвращаемое значение:
//  Булево - Обработка выполнена с ошибками.
//
Функция ВыполненаСОшибками() Экспорт
	
	ТекущееСостояние = ТекущееСостояние();
	
	Возврат ТекущееСостояниеСоответсвует("Выполнено", ТекущееСостояние) И ЕстьОшибки(ТекущееСостояние);
	
КонецФункции

// Возвращает количество объектов к обработке.
//
// Параметры:
//  Тип - Тип - Тип объекта.
//
// Возвращаемое значение:
//  Число - Количество объектов к обработке.
//
Функция КоличествоОбъектовКОбработке(Тип) Экспорт
	
	МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
	ПолноеИмяОбъекта = МетаданныеТипа.ПолноеИмя();
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТаблицаТипа.Ссылка) КАК Количество
		|ИЗ
		|	#ПолноеИмяОбъекта КАК ТаблицаТипа
		|ГДЕ
		|	ТаблицаТипа.Узел = &Узел";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПолноеИмяОбъекта", ПолноеИмяОбъекта + ".Изменения");
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Узел", УзелПланаОбмена());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Число(Выборка.Количество);
	
КонецФункции

// Возвращает количество дескрипторов к удалению.
//
// Возвращаемое значение:
//  Число - Количество дескрипторов к удалению.
//
Функция КоличествоДескрипторовКУдалению() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТаблицаТипа.Ссылка) КАК Количество
		|ИЗ
		|	Справочник.ДескрипторыДоступаОбъектов КАК ТаблицаТипа
		|ГДЕ
		|	ТаблицаТипа.ОбъектДоступа = НЕОПРЕДЕЛЕНО");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Число(Выборка.Количество);
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий.
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента при запуске.
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Выполнена = Выполнена();
	Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		
		ВходВПрограммуРазрешен = ВходВПрограммуРазрешен();
		ВыполненаСОшибками = ВыполненаСОшибками();
		ЕстьПраваНаОбновлениеИнформационнойБазы = 
			ОбновлениеИнформационнойБазыСлужебный.ЕстьПраваНаОбновлениеИнформационнойБазы();
		ОткрытьРасчетПравДоступаПослеОбновления =
			(Не Выполнена
				Или ВыполненаСОшибками)
			И ЕстьПраваНаОбновлениеИнформационнойБазы
			И Не ВходВПрограммуРазрешен;
		ЗапретРасчетПравДоступаПослеОбновления =
			Не Выполнена
			И Не ЕстьПраваНаОбновлениеИнформационнойБазы
			И Не ВходВПрограммуРазрешен;
		ПредупреждениеРасчетПравДоступаПослеОбновления =
			Не Выполнена
			И Не ЕстьПраваНаОбновлениеИнформационнойБазы
			И ВходВПрограммуРазрешен;
		
	Иначе
		
		Если Не Выполнена Тогда
			УстановитьСостояние("Выполнено");
		КонецЕсли;
		ОткрытьРасчетПравДоступаПослеОбновления = Ложь;
		ЗапретРасчетПравДоступаПослеОбновления = Ложь;
		ПредупреждениеРасчетПравДоступаПослеОбновления = Ложь;
		
	КонецЕсли;
	
	Параметры.Вставить("ОткрытьРасчетПравДоступаПослеОбновления", ОткрытьРасчетПравДоступаПослеОбновления);
	Параметры.Вставить("ЗапретРасчетПравДоступаПослеОбновления", ЗапретРасчетПравДоступаПослеОбновления);
	Параметры.Вставить("ПредупреждениеРасчетПравДоступаПослеОбновления", ПредупреждениеРасчетПравДоступаПослеОбновления);
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий.
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента при запуске.
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
//
Процедура ПараметрыРаботыКлиента(Параметры) Экспорт
	
	Выполнена = Выполнена();
	Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		
		ВходВПрограммуРазрешен = ВходВПрограммуРазрешен();
		ВыполненаСОшибками = ВыполненаСОшибками();
		ЕстьПраваНаОбновлениеИнформационнойБазы = 
			ОбновлениеИнформационнойБазыСлужебный.ЕстьПраваНаОбновлениеИнформационнойБазы();
		ОткрытьРасчетПравДоступаПослеОбновления =
			(Не Выполнена
				Или ВыполненаСОшибками)
			И ЕстьПраваНаОбновлениеИнформационнойБазы
			И ВходВПрограммуРазрешен;
		
	Иначе
		
		Если Не Выполнена Тогда
			УстановитьСостояние("Выполнено");
		КонецЕсли;
		ОткрытьРасчетПравДоступаПослеОбновления = Ложь;
		
	КонецЕсли;
	
	Параметры.Вставить("ОткрытьРасчетПравДоступаПослеОбновления", ОткрытьРасчетПравДоступаПослеОбновления);
	
КонецПроцедуры

// Формирует типы для обновления на шаге 2.
//
// Возвращаемое значение:
//  Массив - Типы для обновления на шаге 2.
//
Функция ТипыШаг2() Экспорт
	
	ТипыШаг3 = ТипыШаг3();
	
	ТипыШаг2 = Новый Массив;
	Для Каждого ТипОбъекта Из ДокументооборотПраваДоступаПовтИсп.ТипыСсылокИспользующихДоступПоДескрипторам() Цикл
		Если ТипыШаг3.Найти(ТипОбъекта) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ТипыШаг2.Добавить(ТипОбъекта);
	КонецЦикла;
	
	ТипыШаг2 = СортироватьПоКоличествуОбъектовКОбработке(ТипыШаг2);
	
	Возврат ТипыШаг2;
	
КонецФункции

// Формирует типы для обновления на шаге 3.
//
// Возвращаемое значение:
//  Массив - Типы для обновления на шаге 3.
//
Функция ТипыШаг3() Экспорт
	
	ТипыШаг3 = Новый Массив;
	ТипыШаг3.Добавить(Тип("СправочникСсылка.ШаблоныВнутреннихДокументов"));
	ТипыШаг3.Добавить(Тип("СправочникСсылка.ВнутренниеДокументы"));
	ТипыШаг3.Добавить(Тип("СправочникСсылка.ВходящиеДокументы"));
	ТипыШаг3.Добавить(Тип("СправочникСсылка.ЗаписиРабочегоКалендаря"));
	ТипыШаг3.Добавить(Тип("СправочникСсылка.ИсходящиеДокументы"));
	ТипыШаг3.Добавить(Тип("СправочникСсылка.Мероприятия"));
	ТипыШаг3.Добавить(Тип("СправочникСсылка.Проекты"));
	ТипыШаг3.Добавить(Тип("СправочникСсылка.СообщенияОбсуждений"));
	ТипыШаг3.Добавить(Тип("СправочникСсылка.ТемыОбсуждений"));
	ТипыШаг3.Добавить(Тип("ДокументСсылка.ВходящееПисьмо"));
	ТипыШаг3.Добавить(Тип("ДокументСсылка.ИсходящееПисьмо"));
	ТипыШаг3.Добавить(Тип("ДокументСсылка.ЕжедневныйОтчет"));
	
	ТипыШаг3 = СортироватьПоКоличествуОбъектовКОбработке(ТипыШаг3);
	
	Возврат ТипыШаг3;
	
КонецФункции

// Сортирует типы ссылок.
//
// Возвращаемое значение:
//  Массив - Типы объектов.
//
Функция СортироватьПоКоличествуОбъектовКОбработке(ТипыСсылок)
	
	Сортировщик = Новый ТаблицаЗначений;
	Сортировщик.Колонки.Добавить("Ссылка");
	Сортировщик.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Сортировщик.Колонки.Добавить("КоличествоОбъектовКОбработке", Новый ОписаниеТипов("Число"));
	
	Для Каждого ТипСсылки Из ТипыСсылок Цикл
		НоваяСтрока = Сортировщик.Добавить();
		НоваяСтрока.Ссылка = ТипСсылки;
		НоваяСтрока.Представление = ТипСсылки;
		НоваяСтрока.КоличествоОбъектовКОбработке =
			Обработки.РасчетПравДоступаПослеОбновления.КоличествоОбъектовКОбработке(ТипСсылки);
	КонецЦикла;
	Сортировщик.Сортировать("КоличествоОбъектовКОбработке Убыв, Представление");
	
	ТипыСсылокСортированные = Сортировщик.ВыгрузитьКолонку("Ссылка");
	
	Возврат ТипыСсылокСортированные;
	
КонецФункции

// Устанавливает текущее состояние.
//
// Параметры:
//  НовоеСостояние - Строка - Состояние.
//  ТекущееСостояние - Строка - Текущее состояние.
//  СохранятьФлагЕстьОшибки - Булево - Сохранять флаг есть ошибки.
//
Процедура УстановитьСостояние(
	Знач НовоеСостояние,
	ТекущееСостояние = Неопределено,
	СохранятьФлагЕстьОшибки = Истина) Экспорт
	
	Если ТекущееСостояние = Неопределено Тогда
		ТекущееСостояние = ТекущееСостояние();
	КонецЕсли;
	
	Если СохранятьФлагЕстьОшибки И ЕстьОшибки(ТекущееСостояние) Тогда
		НовоеСостояние = НовоеСостояние + "ЕстьОшибки";
	КонецЕсли;
	
	Константы.СостояниеОбновленияПравДоступаПослеОбновления.Установить(НовоеСостояние);
	ТекущееСостояние = НовоеСостояние;
	
КонецПроцедуры

// Проверяет что переданное состояние соответсвует переданному состоянию.
//
// Параметры:
//  Состояние - Строка - Состояние.
//  ТекущееСостояние - Строка - Текущее состояние.
// 
// Возвращаемое значение:
//  Булево - Текущее состояние соответствует переданному состоянию.
//
Функция ТекущееСостояниеСоответсвует(Состояние, ТекущееСостояние = Неопределено) Экспорт
	
	Если ТекущееСостояние = Неопределено Тогда
		ТекущееСостояние = ТекущееСостояние();
	КонецЕсли;
	
	Возврат СтрНачинаетсяС(ТекущееСостояние, Состояние);
	
КонецФункции

// Возвращает текущее состояние.
//
// Возвращаемое значение:
//  Строка - Текущее состояние.
//
Функция ТекущееСостояние() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.СостояниеОбновленияПравДоступаПослеОбновления.Получить();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует ключ фонового задания.
//
// Возвращаемое значение:
//  Строка - Ключ фонового задания.
//
Функция КлючФоновогоЗадания()
	
	Возврат "8a1bfb39-6e86-479f-964a-feb9c36cd331";
	
КонецФункции

// Возвращает узел плана обмена обработки.
//
// Возвращаемое значение:
//  УзелПланаОбмена - Узел плана обмена.
//
Функция УзелПланаОбмена()
	
	Возврат ПланыОбмена.ОбновлениеИнформационнойБазы.УзелПоОчереди(НомерОчереди());
	
КонецФункции

// Возвращает номер очереди узла плана обмена.
//
// Возвращаемое значение:
//  Число - Номер очереди.
//
Функция НомерОчереди()
	
	Возврат 9999;
	
КонецФункции

// Выполняет обработку объекта.
//
// Параметры:
//  Ссылка - Произвольный - Ссылка на объект.
//  УзелПланаОбмена - ПланОбменаСсылка.ОбновлениеИнформационнойБазы - Узел план обмена.
//  НомерШага - Число - Номер шага.
//  ТекущееСостояние - Строка - Текущее состояние.
//
Процедура ОбработатьОбъект(
	Ссылка,
	Дата,
	УзелПланаОбмена,
	НомерШага,
	ТекущееСостояние,
	ВремяОбработкиОдного,
	ДополнительныеПараметры)
	
	Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
	УдалитьРегистрациюИзменений = Истина;
	
	НачатьТранзакцию();
	Попытка
		
		ОбновитьПраваОбъекта(Ссылка, ДополнительныеПараметры);
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелПланаОбмена, Ссылка);
		УдалитьРегистрациюИзменений = Ложь;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Ошибка при расчете прав доступа после обновления: %1'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Расчет прав доступа после обновления'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,
			Ссылка,
			ТекстОшибки);
		УстановитьЕстьОшибки(ТекущееСостояние);
		
	КонецПопытки;
	
	Если УдалитьРегистрациюИзменений Тогда
		Попытка
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелПланаОбмена, Ссылка);
		Исключение
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при удалении регистрации изменений: %1'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Расчет прав доступа после обновления'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,
				Ссылка,
				ТекстОшибки);
			УстановитьЕстьОшибки(ТекущееСостояние);
		КонецПопытки;
	КонецЕсли;
	
	Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ВремяОбработки = Конец - Начало + ВремяОбработкиОдного;
	Текст = СтрШаблон(
		"{РасчетПравДоступаПослеОбновленияШаг%1}%2/%3",
		НомерШага,
		ОбщегоНазначения.СтроковоеПредставлениеТипа(ТипЗнч(Ссылка)),
		Формат(ВремяОбработки, "ЧН=0; ЧГ=0"));
	Если Дата <> Неопределено Тогда
		Текст = Текст + "/" + Формат(Дата, "ДФ=ггггММддЧЧммсс; ДП=00010101000000")
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	
КонецПроцедуры

Процедура ОбновитьПраваОбъекта(Ссылка, ДополнительныеПараметры);
	
	// Актуализация рабочей группы.
	ТаблицаРабочихГрупп = Неопределено;
	Если ДополнительныеПараметры.Свойство("ТаблицаРабочихГрупп", ТаблицаРабочихГрупп)
		И ТаблицаРабочихГрупп <> Неопределено Тогда
		
		НайденныеСтроки = ТаблицаРабочихГрупп.НайтиСтроки(Новый Структура("Объект", Ссылка));
		Для Каждого СтрокаРГ Из НайденныеСтроки Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаРГ.Участник) Тогда
				Продолжить;
			КонецЕсли;
			
			Набор = РегистрыСведений.РабочиеГруппы.СоздатьНаборЗаписей();
			Набор.Отбор.Объект.Установить(СтрокаРГ.Объект);
			Набор.Отбор.Участник.Установить(СтрокаРГ.Участник);
			
			НоваяСтрока = Набор.Добавить();
			НоваяСтрока.Объект = СтрокаРГ.Объект;
			НоваяСтрока.Участник = СтрокаРГ.Участник;
			НоваяСтрока.Изменение = Истина;
			
			РегистрыСведений.РабочиеГруппы.ЗаполнитьУстаревшиеИзмерения(НоваяСтрока);
			
			Набор.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Определение дескрипторов.
	ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(Ссылка);
	
КонецПроцедуры

// Вызывается при завершении обработки.
//
// Параметры:
//  ТекущееСостояние - Строка - Текущее состояние.
//
Процедура ПриЗавершенииОбработки(ТекущееСостояние)
	
	УстановитьСостояние("Выполнено");
	
	ЛегкаяПочтаСервер.УведомитьОтветственныхПоЛегкойПочте(НСтр("ru = 'Расчет прав доступа завершен'"), "");
	
КонецПроцедуры

// Выполняет поиск фонового задания.
// 
// Возвращаемое значение:
//  ФоновоеЗадание - Фоновое задание.
//
Функция ФоновоеЗадание()
	
	ФоновоеЗадание = Неопределено;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Ключ", КлючФоновогоЗадания());
	СтруктураОтбора.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	МассивЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(СтруктураОтбора);
	Если МассивЗаданий.Количество() <> 0 Тогда
		ФоновоеЗадание = МассивЗаданий[0];
		Возврат ФоновоеЗадание;
	КонецЕсли;
	
	Возврат ФоновоеЗадание;
	
КонецФункции

// Выполняет очистку дескрипторов доступа объектов.
//
// Параметры:
//  ТекущееСостояние - Строка - Текущее состояние.
//
Процедура ВыполнитьОчисткуДескрипторовДоступаОбъектов(ТекущееСостояние)
	
	Если Не (ТекущееСостояниеСоответсвует("Инициализировано", ТекущееСостояние)
			Или ТекущееСостояниеСоответсвует("ВыполняетсяШаг1", ТекущееСостояние)) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьСостояние("ВыполняетсяШаг1", ТекущееСостояние);
	
	ДополнительноеВремя = 0;
	Выборка = Справочники.ДескрипторыДоступаОбъектов.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
		Попытка
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Если Объект.ОбъектДоступа <> Неопределено Тогда
				Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();
				ДополнительноеВремя = Конец - Начало + ДополнительноеВремя;
				Продолжить;
			КонецЕсли;
			Объект.Удалить();
		Исключение
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при расчете прав доступа после обновления: %1'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Расчет прав доступа после обновления'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,
				Выборка.Ссылка,
				ТекстОшибки);
			УстановитьЕстьОшибки(ТекущееСостояние);
		КонецПопытки;
		
		Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ВремяОбработки = Конец - Начало + ДополнительноеВремя;
		ДополнительноеВремя = 0;
		Текст = "{РасчетПравДоступаПослеОбновленияШаг1}"
			+ Формат(ВремяОбработки, "ЧН=0; ЧГ=0");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
		
	КонецЦикла;
	
	УстановитьСостояние("ВыполненШаг1", ТекущееСостояние);
	
КонецПроцедуры

// Выполняет расчет прав папок.
//
// Параметры:
//  ТекущееСостояние - Строка - Текущее состояние.
//
Процедура ВыполнитьРасчетПравШаг2(ТекущееСостояние)
	
	Если Не (ТекущееСостояниеСоответсвует("ВыполненШаг1", ТекущееСостояние)
			Или ТекущееСостояниеСоответсвует("ВыполняетсяШаг2", ТекущееСостояние)) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьСостояние("ВыполняетсяШаг2", ТекущееСостояние);
	
	ВыполнитьРасчетПрав(ТипыШаг2(), 2, ТекущееСостояние);
	РегистрыСведений.ОчередьОбновленияПравДоступа.Очистить();
	
	УстановитьСостояние("ВыполненШаг2", ТекущееСостояние);
	
КонецПроцедуры

// Выполняет расчет прав объектов.
//
// Параметры:
//  ТекущееСостояние - Строка - Текущее состояние.
//
Процедура ВыполнитьРасчетПравШаг3(ТекущееСостояние)
	
	Если Не (ТекущееСостояниеСоответсвует("ВыполненШаг2", ТекущееСостояние)
			Или ТекущееСостояниеСоответсвует("ВыполняетсяШаг3", ТекущееСостояние)) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ТекущееСостояниеСоответсвует("ВыполняетсяШаг3", ТекущееСостояние) Тогда
		УстановитьСостояние("ВыполняетсяШаг3", ТекущееСостояние);
	КонецЕсли;
	
	ВыполнитьРасчетПрав(ТипыШаг3(), 3, ТекущееСостояние);
	
	УстановитьСостояние("ВыполненШаг3", ТекущееСостояние);
	
КонецПроцедуры

// Выполняет расчет прав.
//
// Параметры:
//  ТипыСсылок - Массив - Обрабатываемые типы ссылок.
//  НомерШага - Число - Номер шага.
//  ТекущееСостояние - Строка - Текущее состояние.
//
Процедура ВыполнитьРасчетПрав(ТипыСсылок, НомерШага, ТекущееСостояние)
	
	УзелПланаОбмена = УзелПланаОбмена();
	
	ПолныеИменаОбъектов = Новый Массив;
	Для Каждого Тип Из ТипыСсылок Цикл
		МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
		ПолноеИмяОбъекта = МетаданныеТипа.ПолноеИмя();
		ПолныеИменаОбъектов.Добавить(ПолноеИмяОбъекта);
	КонецЦикла;
	
	Пока ПолныеИменаОбъектов.Количество() <> 0 Цикл
		
		НовыйПолныеИменаОбъектов = Новый Массив;
		Для Каждого ПолноеИмяОбъекта Из ПолныеИменаОбъектов Цикл
			
			Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
			Выборка = ВыбратьСсылкиДляОбработки(ПолноеИмяОбъекта);
			Если Выборка.Количество() <> 0 Тогда
				НовыйПолныеИменаОбъектов.Добавить(ПолноеИмяОбъекта);
			КонецЕсли;
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить(
				"ТаблицаРабочихГрупп", ТаблицаРабочихГрупп(ПолноеИмяОбъекта, Выборка));
			
			Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();
			ВремяОбработки = Конец - Начало;
			РазмерВыборки = Выборка.Количество();
			ВремяОбработкиОдного = ?(РазмерВыборки <> 0, Цел(ВремяОбработки / РазмерВыборки), 0);
			
			Выборка.Сбросить();
			Пока Выборка.Следующий() Цикл
				ОбработатьОбъект(
					Выборка.Ссылка,
					Выборка.Дата,
					УзелПланаОбмена,
					НомерШага,
					ТекущееСостояние,
					ВремяОбработкиОдного,
					ДополнительныеПараметры);
			КонецЦикла;
			
		КонецЦикла;
		
		ПолныеИменаОбъектов = НовыйПолныеИменаОбъектов;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТаблицаРабочихГрупп(ПолноеИмяОбъекта, Выборка)
	
	// Поиск записей рабочих групп, для которых нужно установить флаг "Изменение".
	
	Если Выборка.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТипыОбъектовСРабочейГруппой = Метаданные.РегистрыСведений.РабочиеГруппы.Измерения.Объект.Тип.Типы();
	Выборка.Следующий();
	ТипСсылки = ТипЗнч(Выборка.Ссылка);
	
	Если ТипыОбъектовСРабочейГруппой.Найти(ТипСсылки) = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СсылкиКОбработке = Новый Массив;
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		СсылкиКОбработке.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	// Выбираются записи рабочей группы, участники которых должны иметь права на изменение.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.Объект,
		|	ВложенныйЗапрос.Участник
		|ИЗ
		|	(ВЫБРАТЬ
		|		РабочиеГруппы.Объект КАК Объект,
		|		РабочиеГруппы.Участник КАК Участник,
		|		ПользователиВКонтейнерах.Пользователь КАК Пользователь,
		|		МАКСИМУМ(УдалитьПраваПоДескрипторамДоступа.Изменение) КАК Изменение
		|	ИЗ
		|		РегистрСведений.РабочиеГруппы КАК РабочиеГруппы
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиВКонтейнерах КАК ПользователиВКонтейнерах
		|			ПО РабочиеГруппы.Участник = ПользователиВКонтейнерах.Контейнер
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьДескрипторыДоступаДляОбъектов КАК УдалитьДескрипторыДоступаДляОбъектов
		|			ПО РабочиеГруппы.Объект = УдалитьДескрипторыДоступаДляОбъектов.Объект
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьПраваПоДескрипторамДоступа КАК УдалитьПраваПоДескрипторамДоступа
		|			ПО УдалитьДескрипторыДоступаДляОбъектов.Дескриптор = УдалитьПраваПоДескрипторамДоступа.Дескриптор
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|			ПО УдалитьПраваПоДескрипторамДоступа.Пользователь = СоставСубъектовПравДоступа.Субъект
		|			И ПользователиВКонтейнерах.Пользователь = СоставСубъектовПравДоступа.Пользователь
		|	ГДЕ
		|		РабочиеГруппы.Объект В(&СсылкиКОбработке)
		|	
		|	СГРУППИРОВАТЬ ПО
		|		РабочиеГруппы.Объект,
		|		РабочиеГруппы.Участник,
		|		ПользователиВКонтейнерах.Пользователь) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.Объект,
		|	ВложенныйЗапрос.Участник
		|
		|ИМЕЮЩИЕ
		|	МИНИМУМ(ВложенныйЗапрос.Изменение) = ИСТИНА");
		
	Запрос.УстановитьПараметр("СсылкиКОбработке", СсылкиКОбработке);
	
	ТаблицаРабочихГрупп = Запрос.Выполнить().Выгрузить();
	ТаблицаРабочихГрупп.Индексы.Добавить("Объект");
	
	Возврат ТаблицаРабочихГрупп;
	
КонецФункции

// Проверяет есть ли ошибки во время обработки.
//
// Параметры:
//  ТекущееСостояние - Строка - Текущее состояние.
// 
// Возвращаемое значение:
//  Булево - Есть ошибки.
//
Функция ЕстьОшибки(ТекущееСостояние = Неопределено)
	
	Если ТекущееСостояние = Неопределено Тогда
		ТекущееСостояние = ТекущееСостояние();
	КонецЕсли;
	
	Возврат СтрЗаканчиваетсяНа(ТекущееСостояние, "ЕстьОшибки");
	
КонецФункции

// Устанавливает состояние ЕстьОшибки.
//
// Параметры:
//  ТекущееСостояние - Строка - Текущее состояние.
//
Процедура УстановитьЕстьОшибки(ТекущееСостояние = Неопределено)
	
	Если ТекущееСостояние = Неопределено Тогда
		ТекущееСостояние = ТекущееСостояние();
	КонецЕсли;
	
	Если Не ЕстьОшибки(ТекущееСостояние) Тогда
		УстановитьСостояние(ТекущееСостояние + "ЕстьОшибки", ТекущееСостояние);
	КонецЕсли;
	
КонецПроцедуры

// Выбирает ссылки для обработки по полному имени объекта.
//
// Параметры:
//  ПолноеИмяОбъекта - Строка - Полное имя объекта.
//
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса - Выборка ссылок для обработки.
//
Функция ВыбратьСсылкиДляОбработки(ПолноеИмяОбъекта)
	
	ИмяОбъекта = СтрРазделить(ПолноеИмяОбъекта, ".", Ложь)[1];
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	ТаблицаОбъектаИзменения = ПолноеИмяОбъекта + ".Изменения";
	ТаблицаОбъекта = Неопределено;
	Если ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		ТаблицаОбъекта = ПолноеИмяОбъекта;
		ДатаОбъекта = "Дата";
		РеквизитОбъекта = "Ссылка";
		
	ИначеЕсли ПолноеИмяОбъекта = "Справочник.ТемыОбсуждений"
		Или ПолноеИмяОбъекта = "Справочник.СообщенияОбсуждений" Тогда
		ТаблицаОбъекта = ПолноеИмяОбъекта;
		ДатаОбъекта = "ДатаСоздания";
		РеквизитОбъекта = "Ссылка";
		
	ИначеЕсли ПолноеИмяОбъекта = "Справочник.ЗаписиРабочегоКалендаря"
		Или ПолноеИмяОбъекта = "Справочник.Мероприятия" Тогда
		ТаблицаОбъекта = ПолноеИмяОбъекта;
		ДатаОбъекта = "ДатаНачала";
		РеквизитОбъекта = "Ссылка";
		
	ИначеЕсли ПолноеИмяОбъекта = "Справочник.ВнутренниеДокументы" Тогда
		ТаблицаОбъекта = "РегистрСведений.ДанныеВнутреннихДокументов";
		ДатаОбъекта = "ДатаСортировки";
		РеквизитОбъекта = "Документ";
		
	ИначеЕсли ПолноеИмяОбъекта = "Справочник.ВходящиеДокументы" Тогда
		ТаблицаОбъекта = "РегистрСведений.ДанныеВходящихДокументов";
		ДатаОбъекта = "ДатаСортировки";
		РеквизитОбъекта = "Документ";
		
	ИначеЕсли ПолноеИмяОбъекта = "Справочник.ИсходящиеДокументы" Тогда
		ТаблицаОбъекта = "РегистрСведений.ДанныеИсходящихДокументов";
		ДатаОбъекта = "ДатаСортировки";
		РеквизитОбъекта = "Документ";
		
	КонецЕсли;
	
	ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 500
		|	ТаблицаИзменения.Ссылка КАК Ссылка,
		|	ЕСТЬNULL(#ДатаОбъекта, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК Дата
		|ИЗ
		|	#ТаблицаОбъектаИзменения КАК ТаблицаИзменения";
	Если ТаблицаОбъекта <> Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|		ЛЕВОЕ СОЕДИНЕНИЕ #ТаблицаОбъекта КАК ТаблицаОбъекта
			|		ПО ТаблицаИзменения.Ссылка = ТаблицаОбъекта.#РеквизитОбъекта";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + "
	|ГДЕ
	|	ТаблицаИзменения.Узел = &ТекущаяОчередь";
	Если ТаблицаОбъекта <> Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|
		|УПОРЯДОЧИТЬ ПО
		|	#ДатаОбъекта УБЫВ";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"#ТаблицаОбъектаИзменения", ТаблицаОбъектаИзменения);
	Если ТаблицаОбъекта <> Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"#ТаблицаОбъекта", ТаблицаОбъекта);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"#ДатаОбъекта", "ТаблицаОбъекта." + ДатаОбъекта);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"#РеквизитОбъекта", РеквизитОбъекта);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"#ДатаОбъекта", "НЕОПРЕДЕЛЕНО");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ТекущаяОчередь", УзелПланаОбмена());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
КонецФункции

#КонецОбласти

#КонецЕсли