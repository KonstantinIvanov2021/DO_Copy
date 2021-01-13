#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет уведомление по задаче.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
//  Задача - ЗадачаСсылка.ЗадачаИсполнителя - Задача.
//  ДополнительноеОписание - Строка - Дополнительное описание.
//
Процедура ДобавитьУведомлениеПоЗадаче(
	ВидСобытия,
	Объект,
	Задача,
	ДополнительноеОписание = "") Экспорт
	
	Если ТипЗнч(Задача.ТекущийИсполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
		
		ДобавитьУведомлениеПоСобытию(
			Задача.ТекущийИсполнитель,
			ВидСобытия,
			Объект,
			Задача,
			ДополнительноеОписание);
		ДобавитьУведомлениеПоОбъекту(
			ВидСобытия,
			Объект,
			Задача.ТекущийИсполнитель,
			ДополнительноеОписание);
		
	ИначеЕсли ТипЗнч(Задача.ТекущийИсполнитель) = Тип("СправочникСсылка.ПолныеРоли") Тогда
		
		ИсполнителиРоли = РегистрыСведений.ИсполнителиЗадач.ИсполнителиРоли(
			Задача.ТекущийИсполнитель);
		Для Каждого СтрокаИсполнитель Из ИсполнителиРоли Цикл
			ДобавитьУведомлениеПоСобытию(
				СтрокаИсполнитель,
				ВидСобытия,
				Объект,
				Задача,
				ДополнительноеОписание);
			ДобавитьУведомлениеПоОбъекту(
				ВидСобытия,
				Объект,
				СтрокаИсполнитель,
				ДополнительноеОписание);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет уведомление по задаче.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
//  ОбъектПодписки - ЛюбаяСсылка - Объект подписки.
//  ДополнительноеОписание - Строка - Дополнительное описание.
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//
Процедура ДобавитьУведомлениеПоОбъекту(
	ВидСобытия,
	Объект,
	ОбъектПодписки,
	ДополнительноеОписание = "",
	Пользователь = Неопределено) Экспорт
	
	Подписчики = РегистрыСведений.НастройкиУведомлений.ПодписчикиПоОбъекту(ВидСобытия, ОбъектПодписки);
	Для Каждого Подписчик Из Подписчики Цикл
		Если ЗначениеЗаполнено(Пользователь) И Подписчик.Пользователь <> Пользователь Тогда
			Продолжить;
		КонецЕсли;
		ДобавитьУведомление(
			Подписчик.Пользователь,
			ВидСобытия,
			Подписчик.СпособУведомления,
			Объект,
			ОбъектПодписки,
			ДополнительноеОписание);
	КонецЦикла;
	
КонецПроцедуры

// Добавляет уведомление по событию.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
//  ОбъектПодписки - ЛюбаяСсылка - Объект подписки.
//  ДополнительноеОписание - Строка - Дополнительное описание.
//  ВключаяДелегатов - Булево - Добавлять уведомление для делегатов.
//
Процедура ДобавитьУведомлениеПоСобытию(
	Пользователь,
	ВидСобытия,
	Объект,
	ОбъектПодписки,
	ДополнительноеОписание = "",
	ВключаяДелегатов = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Пользователь) <> Тип("СправочникСсылка.Пользователи") Тогда
		Возврат;
	КонецЕсли;
	
	ВозможныеПодписчики = Новый Массив;
	ВозможныеПодписчики.Добавить(Пользователь);
	Если ВключаяДелегатов Тогда
		Делегаты = Справочники.ДелегированиеПрав.ПолучитьДелегатовДляУведомления(Пользователь, Объект);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВозможныеПодписчики, Делегаты);
	КонецЕсли;
	
	Подписчики = РегистрыСведений.НастройкиУведомлений.ПодписчикиПоСобытию(ВозможныеПодписчики, ВидСобытия, Объект);
	Для Каждого Подписчик Из Подписчики Цикл
		ДобавитьУведомление(
			Подписчик.Пользователь,
			ВидСобытия,
			Подписчик.СпособУведомления,
			Объект,
			ОбъектПодписки,
			ДополнительноеОписание);
	КонецЦикла;
	
КонецПроцедуры

// Добавляет уведомление по состоянию.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
//  ОбъектПодписки - ЛюбаяСсылка - Объект подписки.
//  ДополнительноеОписание - Строка - Дополнительное описание.
//
Процедура ДобавитьУведомлениеПоСостоянию(
	Пользователь,
	ВидСобытия,
	Объект,
	ОбъектПодписки,
	ДополнительноеОписание = "") Экспорт
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		ДобавитьУведомлениеПоСобытию(
			Пользователь,
			ВидСобытия,
			Объект,
			ОбъектПодписки,
			ДополнительноеОписание,
			Ложь);
		
		РегистрыСведений.ОбработанныеУведомления.ДобавитьОбработанноеУведомление(
			ВидСобытия,
			Объект,
			Пользователь);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает все уведомления из очереди, отправку которых необходимо выполнить.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Уведомления.
//
Функция ПолучитьУведомления() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОчередьУведомлений.Пользователь КАК Пользователь,
		|	Пользователи.ПометкаУдаления КАК ПользовательПометкаУдаления,
		|	Пользователи.Недействителен КАК ПользовательНедействителен,
		|	ОчередьУведомлений.ВидСобытия КАК ВидСобытия,
		|	ОчередьУведомлений.СпособУведомления КАК СпособУведомления,
		|	ОчередьУведомлений.Объект КАК Объект,
		|	ОчередьУведомлений.ОбъектПодписки КАК ОбъектПодписки,
		|	ОчередьУведомлений.ДополнительноеОписание КАК ДополнительноеОписание
		|ИЗ
		|	РегистрСведений.ОчередьУведомлений КАК ОчередьУведомлений
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО ОчередьУведомлений.Пользователь = Пользователи.Ссылка
		|ГДЕ
		|	ОчередьУведомлений.КоличествоПопытокОтправки < 3";
	Уведомления = Запрос.Выполнить().Выгрузить();
	
	КоличествоЭлементов = Уведомления.Количество();
	Для Индекс = 1 По КоличествоЭлементов Цикл
		Уведомление = Уведомления[КоличествоЭлементов - Индекс];
		
		Если Уведомление.ПользовательПометкаУдаления Или Уведомление.ПользовательНедействителен Тогда
			ПричинаУдаления = НСтр("ru = 'Пользователь помечен на удаление или является недействительным.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			УдалитьУведомление(
				Уведомление.Пользователь,
				Уведомление.ВидСобытия,
				Уведомление.СпособУведомления,
				Уведомление.Объект,
				Уведомление.ОбъектПодписки,
				ПричинаУдаления);
			Уведомления.Удалить(Уведомление);
			Продолжить;
		КонецЕсли;
		
		ЕстьПраваНаОбъект = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(
			Уведомление.Объект,
			Уведомление.Пользователь).Чтение;
		Если Не ЕстьПраваНаОбъект Тогда
			ПричинаУдаления = НСтр("ru = 'Недостаточно прав для получения уведомления.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			УдалитьУведомление(
				Уведомление.Пользователь,
				Уведомление.ВидСобытия,
				Уведомление.СпособУведомления,
				Уведомление.Объект,
				Уведомление.ОбъектПодписки,
				ПричинаУдаления);
			Уведомления.Удалить(Уведомление);
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Уведомления;
	
КонецФункции

// Увеличивает число попыток отправки уведомления.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//  ОбъектПодписки - ЛюбаяСсылка - Объект подписки.
//
Процедура УвеличитьЧислоПопытокОтправки(
	Пользователь,
	ВидСобытия,
	СпособУведомления,
	Объект,
	ОбъектПодписки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.ОчередьУведомлений.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.ВидСобытия = ВидСобытия;
	Запись.СпособУведомления = СпособУведомления;
	Запись.Объект = Объект;
	Запись.ОбъектПодписки = ОбъектПодписки;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.ВидСобытия = ВидСобытия;
	Запись.СпособУведомления = СпособУведомления;
	Запись.Объект = Объект;
	Запись.ОбъектПодписки = ОбъектПодписки;
	Запись.ДополнительноеОписание = Запись.ДополнительноеОписание;
	Запись.КоличествоПопытокОтправки = Запись.КоличествоПопытокОтправки + 1;
	Запись.Записать();
	
КонецПроцедуры

// Удаляет уведомление из очереди уведомлений.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//  ОбъектПодписки - ЛюбаяСсылка - Объект подписки.
//  ПричинаУдаления - Строка - Причина удаления уведомления из очереди.
//
Процедура УдалитьУведомление(
	Пользователь,
	ВидСобытия,
	СпособУведомления,
	Объект,
	ОбъектПодписки,
	ПричинаУдаления = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.ОчередьУведомлений.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.ВидСобытия = ВидСобытия;
	Запись.СпособУведомления = СпособУведомления;
	Запись.Объект = Объект;
	Запись.ОбъектПодписки = ОбъектПодписки;
	Запись.Удалить();
	
	Если ЗначениеЗаполнено(ПричинаУдаления) Тогда
		ТекстЗаписи = СтрШаблон(
			НСтр("ru = 'Уведомление не было отправлено
				|Пользователь: %1
				|Вид события: %2
				|Способ уведомления: %3
				|Объект: %4
				|Объект подписки: %5
				|Причина: %6'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			Пользователь,
			ВидСобытия,
			СпособУведомления,
			Объект,
			ОбъектПодписки,
			ПричинаУдаления);
		ЗаписьЖурналаРегистрации(
			РаботаСУведомлениями.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,,,
			ТекстЗаписи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет уведомление в очередь уведомлений. Уведомление добавляет только для дейстительных пользователей.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//  ОбъектПодписки - ЛюбаяСсылка - Объект подписки.
//  ДополнительноеОписание - Строка - Дополнительное описание.
//
Процедура ДобавитьУведомление(
	Пользователь,
	ВидСобытия,
	СпособУведомления,
	Объект,
	ОбъектПодписки,
	ДополнительноеОписание)
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат;
	КонецЕсли;
	
	Если Пользователь.Недействителен Или Пользователь.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительнаяПроверкаПодписки = Перечисления.СобытияУведомлений.ДополнительнаяПроверкаПодписки(
		Пользователь,
		ВидСобытия,
		Объект);
	Если Не ДополнительнаяПроверкаПодписки Тогда
		Возврат;
	КонецЕсли;
	
	Если СпособУведомления = Перечисления.СпособыУведомления.ПоPush
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьPushУведомления") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.ОчередьУведомлений.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.ВидСобытия = ВидСобытия;
	Запись.СпособУведомления = СпособУведомления;
	Запись.Объект = Объект;
	Запись.ОбъектПодписки = ОбъектПодписки;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.ВидСобытия = ВидСобытия;
	Запись.СпособУведомления = СпособУведомления;
	Запись.Объект = Объект;
	Запись.ОбъектПодписки = ОбъектПодписки;
	Если ЗначениеЗаполнено(Запись.ДополнительноеОписание) Тогда
		Запись.ДополнительноеОписание = Запись.ДополнительноеОписание + Символы.ПС + Символы.ПС + ДополнительноеОписание;
	Иначе
		Запись.ДополнительноеОписание = ДополнительноеОписание;
	КонецЕсли;
	Запись.КоличествоПопытокОтправки = 0;
	Запись.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли