
// Удаляет все данные регистра и заполняет заново
// 
Процедура ОбновитьВсеДанные(Немедленно = Ложь) Экспорт
	
	Если Немедленно <> Истина
		И ДокументооборотПраваДоступаПовтИсп.ОтложенноеОбновлениеПравДоступа() Тогда
		
		РегистрыСведений.ОчередьОбновленияПравДоступа.Добавить(
			Перечисления.ЗаданияОчередиОбновленияПрав.ЗаполнитьСоставСубъектовПравДоступа, Дата(1, 1, 1), 2);
		
		Возврат;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Роли исполнителей
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИсполнителиЗадач.РольИсполнителя КАК Субъект,
	|	ИсполнителиЗадач.Исполнитель КАК Пользователь
	|ИЗ
	|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	|ГДЕ
	|	ИсполнителиЗадач.РольИсполнителя <> ЗНАЧЕНИЕ(Справочник.ПолныеРоли.ПустаяСсылка)");
	
	СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
	СоставСубъектов.Загрузить(Запрос.Выполнить().Выгрузить());
	СоставСубъектов.Записать();
	
	// Пользователи
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Субъект,
	|	Пользователи.Ссылка КАК Пользователь,
	|	Неопределено КАК ОбъектОснование
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
		СоставСубъектов.Отбор.Субъект.Установить(Выборка.Субъект);
		СоставСубъектов.Отбор.Пользователь.Установить(Выборка.Пользователь);
		СоставСубъектов.Отбор.ОбъектОснование.Установить(Выборка.ОбъектОснование);
		ЗаполнитьЗначенияСвойств(СоставСубъектов.Добавить(), Выборка);
		СоставСубъектов.Записать();
	КонецЦикла;
	
	// Проекты
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Проекты.Ссылка КАК Субъект,
	|	Проекты.Руководитель КАК Пользователь
	|ИЗ
	|	Справочник.Проекты КАК Проекты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО Проекты.Руководитель = Пользователи.Ссылка");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
		СоставСубъектов.Отбор.Субъект.Установить(Выборка.Субъект);
		ЗаполнитьЗначенияСвойств(СоставСубъектов.Добавить(), Выборка);
		СоставСубъектов.Записать();
	КонецЦикла;
	
	// Руководители
	Если Константы.ДобавлятьРуководителямДоступПодчиненных.Получить() Тогда
		ЗаполнитьВсехРуководителей();
	КонецЕсли;
	
	// Делегаты
	ЗаполнитьВсехДелегатов();
	
КонецПроцедуры

// Перезаполняет данные по всем руководителям подразделений
// 
Процедура ЗаполнитьВсехРуководителей(Знач Подразделения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Получение подразделений верхнего уровня
	Если ТипЗнч(Подразделения) = Тип("Массив") Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ЕСТЬNULL(ПодразделенияРодители.Ссылка, Подразделения.Ссылка) КАК Ссылка,
			|	ВЫБОР
			|		КОГДА ПодразделенияРодители.Ссылка ЕСТЬ NULL 
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК ЕстьРодители
			|ИЗ
			|	Справочник.СтруктураПредприятия КАК Подразделения
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК ПодразделенияРодители
			|		ПО Подразделения.Родитель = ПодразделенияРодители.Ссылка
			|ГДЕ
			|	Подразделения.Ссылка В(&Подразделения)");
		
		ЕстьРодители = Истина;
		Пока ЕстьРодители Цикл
			Запрос.УстановитьПараметр("Подразделения", Подразделения);
			Результат = Запрос.Выполнить();
			ТаблицаПодразделений = Результат.Выгрузить();
			ЕстьРодители = ТаблицаПодразделений.Найти(Истина, "ЕстьРодители") <> Неопределено;
			Подразделения = ТаблицаПодразделений.ВыгрузитьКолонку("Ссылка");
		КонецЦикла;
		
	КонецЕсли;
	
	УдалитьВсехРуководителей(Подразделения);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПодчиненностьСотрудников.Подчиненный КАК Субъект,
		|	ПодчиненностьСотрудников.Руководитель КАК Пользователь,
		|	ПодчиненностьСотрудников.Подразделение КАК ОбъектОснование
		|ИЗ
		|	РегистрСведений.ПодчиненностьСотрудников КАК ПодчиненностьСотрудников
		|ГДЕ
		|	ПодчиненностьСотрудников.Подчиненный <> ПодчиненностьСотрудников.Руководитель
		|	И (&ПоВсемПодразделениям
		|			ИЛИ ПодчиненностьСотрудников.Подразделение В ИЕРАРХИИ (&Подразделения))
		|ИТОГИ ПО
		|	ОбъектОснование");
	
	Запрос.УстановитьПараметр("Подразделения", Подразделения);
	Запрос.УстановитьПараметр("ПоВсемПодразделениям", Подразделения = Неопределено);
	ВыборкаПоПодразделениям = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоПодразделениям.Следующий() Цикл
		
		СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
		СоставСубъектов.Отбор.ОбъектОснование.Установить(ВыборкаПоПодразделениям.ОбъектОснование);
		ТаблицаНабора = СоставСубъектов.ВыгрузитьКолонки();
		
		Выборка = ВыборкаПоПодразделениям.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ТаблицаНабора.Добавить(), Выборка);
		КонецЦикла;
		
		РасширитьТаблицуНабораСоставомСубъектовНижнихУровней(ТаблицаНабора, Ложь);
		
		Для Каждого СтрокаТаблицы Из ТаблицаНабора Цикл
			Запись = СоставСубъектов.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, СтрокаТаблицы);
		КонецЦикла;
		
		СоставСубъектов.Записать();
		РасширитьСоставСубъектовВерхнихУровней(ТаблицаНабора, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

// Удаляет всех руководителей из состава субъектов-пользователей
// 
Процедура УдалитьВсехРуководителей(Подразделения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставСубъектовПравДоступа.ОбъектОснование
		|ИЗ
		|	РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|ГДЕ
		|	СоставСубъектовПравДоступа.ОбъектОснование ССЫЛКА Справочник.СтруктураПредприятия
		|	И (&ПоВсемПодразделениям
		|		ИЛИ СоставСубъектовПравДоступа.ОбъектОснование В ИЕРАРХИИ (&Подразделения))");
	
	Запрос.УстановитьПараметр("Подразделения", Подразделения);
	Запрос.УстановитьПараметр("ПоВсемПодразделениям", Подразделения = Неопределено);
	ВыборкаПоПодразделениям = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаПоПодразделениям.Следующий() Цикл
		СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
		СоставСубъектов.Отбор.ОбъектОснование.Установить(ВыборкаПоПодразделениям.ОбъектОснование);
		СоставСубъектов.Записать();
	КонецЦикла;
	
	УдалитьНеактуальныеЗаписиВерхнихУровней();
	
КонецПроцедуры

// Перезаполняет все записи регистра, относящиеся к делегированию прав
// 
Процедура ЗаполнитьВсехДелегатов()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДелегированиеПрав.Ссылка
		|ИЗ
		|	Справочник.ДелегированиеПрав КАК ДелегированиеПрав
		|ГДЕ
		|	ДелегированиеПрав.Действует");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаписьДелегирования(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

// Отрабатывает изменения в регистре при изменении руководителя подразделения
//
// Параметры:
//	Источник - СправочникОбъект.СтруктураПредприятия
//
Процедура ИзменениеРуководителяПодразделения(Источник) Экспорт
	
	СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
	СоставСубъектов.Отбор.ОбъектОснование.Установить(Источник.Ссылка);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СоставСубъектовПравДоступа.Субъект,
		|	&НовыйРуководитель КАК Пользователь,
		|	СоставСубъектовПравДоступа.ОбъектМетаданных,
		|	СоставСубъектовПравДоступа.ОбъектОснование,
		|	СоставСубъектовПравДоступа.ПользовательОснование,
		|	СоставСубъектовПравДоступа.ОбластьДелегирования,
		|	СоставСубъектовПравДоступа.ИмяОбластиДелегирования
		|ИЗ
		|	РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|ГДЕ
		|	СоставСубъектовПравДоступа.ОбъектОснование = &Подразделение");
		
	Запрос.УстановитьПараметр("Подразделение", Источник.Ссылка);
	Запрос.УстановитьПараметр("НовыйРуководитель", Источник.Руководитель);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		ТаблицаНабора = Результат.Выгрузить();
		СоставСубъектов.Загрузить(ТаблицаНабора);
		СоставСубъектов.Записать();
		
		РасширитьСоставСубъектовВерхнихУровней(ТаблицаНабора, Ложь);
		УдалитьНеактуальныеЗаписиВерхнихУровней();
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет/удаляет руководителей в состав субъектов
//
// Параметры:
//	НаборИсточник - РегистрСведенийНаборЗаписей.СведенияОПользователяхДокументооборот
//
Процедура ЗаписьСведенийОПользователях(НаборИсточник) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не Константы.ДобавлятьРуководителямДоступПодчиненных.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	Пользователь = НаборИсточник.Отбор.Пользователь.Значение;
	
	// Наборы без отбора по пользователю не должны попадать в эту процедуру
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		ТекстОшибки = НСтр("ru = 'Не заполнен отбор по пользователю'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставСубъектовПравДоступа.Субъект КАК Пользователь,
		|	СоставСубъектовПравДоступа.ОбъектОснование КАК Подразделение,
		|	NULL КАК Руководитель,
		|	ЛОЖЬ КАК Актуальна
		|ИЗ
		|	РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодчиненностьСотрудников КАК ПодчиненностьСотрудников
		|		ПО СоставСубъектовПравДоступа.Субъект = ПодчиненностьСотрудников.Подчиненный
		|			И СоставСубъектовПравДоступа.ОбъектОснование = ПодчиненностьСотрудников.Подразделение
		|ГДЕ
		|	СоставСубъектовПравДоступа.Субъект = &Пользователь
		|	И СоставСубъектовПравДоступа.ОбъектОснование Ссылка Справочник.СтруктураПредприятия
		|	И ПодчиненностьСотрудников.Подчиненный ЕСТЬ NULL 
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодчиненностьСотрудников.Подчиненный,
		|	ПодчиненностьСотрудников.Подразделение,
		|	ПодчиненностьСотрудников.Руководитель,
		|	ИСТИНА
		|ИЗ
		|	РегистрСведений.ПодчиненностьСотрудников КАК ПодчиненностьСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|		ПО (СоставСубъектовПравДоступа.Субъект = ПодчиненностьСотрудников.Подчиненный)
		|			И (СоставСубъектовПравДоступа.ОбъектОснование = ПодчиненностьСотрудников.Подразделение)
		|ГДЕ
		|	ПодчиненностьСотрудников.Подчиненный = &Пользователь
		|	И СоставСубъектовПравДоступа.Субъект ЕСТЬ NULL ");
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
		СоставСубъектов.Отбор.Субъект.Установить(Выборка.Пользователь);
		СоставСубъектов.Отбор.ОбъектОснование.Установить(Выборка.Подразделение);
		
		Если Выборка.Актуальна Тогда
			
			Запись = СоставСубъектов.Добавить();
			Запись.Субъект = Выборка.Пользователь;
			Запись.Пользователь = Выборка.Руководитель;
			Запись.ОбъектОснование = Выборка.Подразделение;
			
			СоставСубъектов.Записать();
			
			// Записи верхнего уровня
			ТаблицаНабора = СоставСубъектов.Выгрузить();
			РасширитьСоставСубъектовВерхнихУровней(ТаблицаНабора, Ложь);
			
			// Записи нижнего уровня
			ЗапросНижнегоУровня = Новый Запрос(
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	СоставСубъектовПравДоступа.Субъект,
				|	&Руководитель КАК Пользователь,
				|	СоставСубъектовПравДоступа.ОбъектМетаданных,
				|	&ОбъектОснование,
				|	СоставСубъектовПравДоступа.Пользователь КАК ПользовательОснование,
				|	СоставСубъектовПравДоступа.ОбластьДелегирования,
				|	СоставСубъектовПравДоступа.ИмяОбластиДелегирования
				|ИЗ
				|	РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
				|ГДЕ
				|	СоставСубъектовПравДоступа.Пользователь = &Пользователь
				|	И СоставСубъектовПравДоступа.Субъект <> СоставСубъектовПравДоступа.Пользователь");
			
			ЗапросНижнегоУровня.УстановитьПараметр("Пользователь", Выборка.Пользователь);
			ЗапросНижнегоУровня.УстановитьПараметр("Руководитель", Выборка.Руководитель);
			ЗапросНижнегоУровня.УстановитьПараметр("ОбъектОснование", Выборка.Подразделение);
			
			СоставСубъектовНижнегоУровня = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
			СоставСубъектовНижнегоУровня.Отбор.Пользователь.Установить(Выборка.Руководитель);
			СоставСубъектовНижнегоУровня.Отбор.ОбъектОснование.Установить(Выборка.Подразделение);
			СоставСубъектовНижнегоУровня.Отбор.ПользовательОснование.Установить(Выборка.Пользователь);
			
			СоставСубъектовНижнегоУровня.Загрузить(ЗапросНижнегоУровня.Выполнить().Выгрузить());
			СоставСубъектовНижнегоУровня.Записать();
			
		Иначе
			
			СоставСубъектов.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
	УдалитьНеактуальныеЗаписиВерхнихУровней();
	
КонецПроцедуры

// Добавляет/удаляет исполнителей ролей в состав субъектов
//
// Параметры:
//	НаборИсточник - РегистрСведенийНаборЗаписей.ИсполнителиЗадач
//
Процедура ЗаписьИсполнителейРолей(НаборИсточник) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтоУдаление = НаборИсточник.Количество() = 0;
	Роль = НаборИсточник.Отбор.РольИсполнителя.Значение;
	
	Если Не ЗначениеЗаполнено(Роль) Тогда
		Если ЭтоУдаление Тогда
			Возврат;
		Иначе
			ВызватьИсключение НСтр("ru = 'Не заполнен отбор по роли исполнителей'");
		КонецЕсли;
	КонецЕсли;
	
	СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
	СоставСубъектов.Отбор.Субъект.Установить(Роль);
	СоставСубъектов.Отбор.ОбъектОснование.Установить(Неопределено);
	СоставСубъектов.Отбор.ПользовательОснование.Установить(Справочники.Пользователи.ПустаяСсылка());
	
	ОтборИсточника = НаборИсточник.Отбор.Исполнитель;
	Если ОтборИсточника.Использование Тогда
		СоставСубъектов.Отбор.Пользователь.Установить(ОтборИсточника.Значение);
	КонецЕсли;
	
	ТаблицаИсточник = НаборИсточник.Выгрузить();
	ТаблицаИсточник.Свернуть("Исполнитель");
	
	Для Каждого СтрИсточника Из ТаблицаИсточник Цикл
		Запись = СоставСубъектов.Добавить();
		Запись.Субъект = Роль;
		Запись.Пользователь = СтрИсточника.Исполнитель;
	КонецЦикла;
	
	СоставСубъектов.Записать();
	ТаблицаНабора = СоставСубъектов.Выгрузить();
	РасширитьСоставСубъектовВерхнихУровней(ТаблицаНабора);
		
	УдалитьНеактуальныеЗаписиВерхнихУровней();
	
КонецПроцедуры

// Добавляет самого пользователя как строку состава субъекта
// 
Процедура ДобавлениеПользователя(Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписьСоставаСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьМенеджерЗаписи();
	ЗаписьСоставаСубъектов.Субъект = Пользователь;
	ЗаписьСоставаСубъектов.Пользователь = Пользователь;
	ЗаписьСоставаСубъектов.Записать();
	
КонецПроцедуры

// Вызывается при записи делегирования
// Добавляет/удаляет делегата как строку состава субъекта
// 
// Параметры:
//  Делегирование - СправочникСсылка.ДелегированиеПрав
//
Процедура ЗаписьДелегирования(Знач Делегирование) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РеквизитыДелегирования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Делегирование, 
		"Действует, ВариантДелегирования, ОтКого, Кому");
	
	СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
	СоставСубъектов.Отбор.ОбъектОснование.Установить(Делегирование);
	
	Если РеквизитыДелегирования.Действует Тогда
		
		ТаблицаНабора = СоставСубъектов.ВыгрузитьКолонки();
		
		Если РеквизитыДелегирования.ВариантДелегирования = Перечисления.ВариантыДелегированияПрав.ВсеПрава Тогда
			
			Запись = ТаблицаНабора.Добавить();
			Запись.Субъект = РеквизитыДелегирования.ОтКого;
			Запись.Пользователь = РеквизитыДелегирования.Кому;
			Запись.ОбъектОснование = Делегирование;
			
		Иначе
			
			Запрос = Новый Запрос(
				"ВЫБРАТЬ
				|	ДелегированиеПрав.ОтКого КАК Субъект,
				|	ДелегированиеПрав.Кому КАК Пользователь,
				|	ДелегированиеПрав.Ссылка КАК ОбъектОснование,
				|	ДелегированиеПравОбластиДелегирования.ОбластьДелегирования КАК ОбластьДелегирования,
				|	ОбластиДелегированияПрав.ИмяПредопределенныхДанных КАК ИмяОбластиДелегирования,
				|	ОбластиДелегированияПравСостав.ОбъектМетаданных КАК ОбъектМетаданных,
				|	ИдентификаторыОбъектовМетаданных.ПолноеИмя КАК ИмяОбъектаМетаданных
				|ИЗ
				|	Справочник.ДелегированиеПрав КАК ДелегированиеПрав
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДелегированиеПрав.ОбластиДелегирования КАК ДелегированиеПравОбластиДелегирования
				|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбластиДелегированияПрав.Состав КАК ОбластиДелегированияПравСостав
				|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
				|				ПО ОбластиДелегированияПравСостав.ОбъектМетаданных = ИдентификаторыОбъектовМетаданных.Ссылка
				|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбластиДелегированияПрав КАК ОбластиДелегированияПрав
				|				ПО ОбластиДелегированияПравСостав.Ссылка = ОбластиДелегированияПрав.Ссылка
				|			ПО ДелегированиеПравОбластиДелегирования.ОбластьДелегирования = ОбластиДелегированияПравСостав.Ссылка
				|		ПО ДелегированиеПрав.Ссылка = ДелегированиеПравОбластиДелегирования.Ссылка
				|ГДЕ
				|	ДелегированиеПрав.Ссылка = &Делегирование
				|	И НЕ ОбластиДелегированияПрав.ПометкаУдаления
				|	И НЕ ИдентификаторыОбъектовМетаданных.ПометкаУдаления");
				
			Запрос.УстановитьПараметр("Делегирование", Делегирование);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(ТаблицаНабора.Добавить(), Выборка);
			КонецЦикла;
			
		КонецЕсли;
		
		РасширитьТаблицуНабораСоставомСубъектовНижнихУровней(ТаблицаНабора, Истина);
		СоставСубъектов.Загрузить(ТаблицаНабора);
		
	КонецЕсли;
	
	СоставСубъектов.Записать();
	
КонецПроцедуры

// Вызывается при записи области делегирования
// Актуализирует состав строки субъектов, связанных с переданной областью
// 
// Параметры:
//  ОбластьДелегирования - СправочникОбъект.ОбластиДелегированияПрав
//
Процедура ЗаписьОбластиДелегирования(Знач ОбластьДелегирования) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставСубъектовПравДоступа.Субъект,
		|	СоставСубъектовПравДоступа.Пользователь,
		|	СоставСубъектовПравДоступа.ОбъектОснование,
		|	СоставСубъектовПравДоступа.ПользовательОснование,
		|	СоставСубъектовПравДоступа.ОбластьДелегирования,
		|	СоставСубъектовПравДоступа.ИмяОбластиДелегирования
		|ПОМЕСТИТЬ ЗаписиПоОбластиБезРасшифровки
		|ИЗ
		|	РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|ГДЕ
		|	СоставСубъектовПравДоступа.ОбластьДелегирования = &ОбластьДелегирования
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаписиПоОбластиБезРасшифровки.Субъект,
		|	ЗаписиПоОбластиБезРасшифровки.Пользователь,
		|	ЗаписиПоОбластиБезРасшифровки.ОбъектОснование КАК ОбъектОснование,
		|	ЗаписиПоОбластиБезРасшифровки.ПользовательОснование,
		|	ЗаписиПоОбластиБезРасшифровки.ОбластьДелегирования,
		|	ЗаписиПоОбластиБезРасшифровки.ИмяОбластиДелегирования,
		|	ИдентификаторыОбъектовМетаданных.Ссылка КАК ОбъектМетаданных
		|ИЗ
		|	ЗаписиПоОбластиБезРасшифровки КАК ЗаписиПоОбластиБезРасшифровки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбластиДелегированияПрав.Состав КАК ОбластиДелегированияПравСостав
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
		|			ПО ОбластиДелегированияПравСостав.ОбъектМетаданных = ИдентификаторыОбъектовМетаданных.Ссылка
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбластиДелегированияПрав КАК ОбластиДелегированияПрав
		|			ПО ОбластиДелегированияПравСостав.Ссылка = ОбластиДелегированияПрав.Ссылка
		|		ПО ЗаписиПоОбластиБезРасшифровки.ОбластьДелегирования = ОбластиДелегированияПравСостав.Ссылка
		|ГДЕ
		|	ЗаписиПоОбластиБезРасшифровки.ОбластьДелегирования = &ОбластьДелегирования
		|	И НЕ ОбластиДелегированияПрав.ПометкаУдаления
		|	И НЕ ИдентификаторыОбъектовМетаданных.ПометкаУдаления
		|ИТОГИ ПО
		|	ОбъектОснование");
		
	Запрос.УстановитьПараметр("ОбластьДелегирования", ОбластьДелегирования.Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		Если ОбластьДелегирования.ПометкаУдаления Тогда
			
			СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
			СоставСубъектов.Отбор.ОбластьДелегирования.Установить(ОбластьДелегирования.Ссылка);
			СоставСубъектов.Записать();			
			
		Иначе
			
			// Если записей по этой области в базе нет - выполняется поиск элементов делегирования, 
			// использующих область, и перезаполняются данные регистра по этим элементам.
			
			Запрос = Новый Запрос(
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ДелегированиеПравОбластиДелегирования.Ссылка КАК Делегирование
				|ИЗ
				|	Справочник.ДелегированиеПрав.ОбластиДелегирования КАК ДелегированиеПравОбластиДелегирования
				|ГДЕ
				|	ДелегированиеПравОбластиДелегирования.ОбластьДелегирования = &ОбластьДелегирования");
				
			Запрос.УстановитьПараметр("ОбластьДелегирования", ОбластьДелегирования.Ссылка);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаписьДелегирования(Выборка.Делегирование);
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		ВыборкаПоДелегированиям = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоДелегированиям.Следующий() Цикл
			
			СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
			СоставСубъектов.Отбор.ОбластьДелегирования.Установить(ОбластьДелегирования.Ссылка);
			СоставСубъектов.Отбор.ОбъектОснование.Установить(ВыборкаПоДелегированиям.ОбъектОснование);
			
			Выборка = ВыборкаПоДелегированиям.Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(СоставСубъектов.Добавить(), Выборка);
			КонецЦикла;
			
			СоставСубъектов.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при записи проекта - нового, или с измененным руководителем
// Добавляет/удаляет руководителя проекта как строку состава субъекта
// 
// Параметры:
//  Проект - СправочникОбъект.Проекты
//
Процедура ЗаписьПроекта(Проект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СоставСубъектов = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьНаборЗаписей();
	СоставСубъектов.Отбор.Субъект.Установить(Проект.Ссылка);
	
	Если ЗначениеЗаполнено(Проект.Руководитель) Тогда
		Запись = СоставСубъектов.Добавить();
		Запись.Субъект = Проект.Ссылка;
		Запись.Пользователь = Проект.Руководитель;
	КонецЕсли;
	
	СоставСубъектов.Записать();
	
	ТаблицаНабора = СоставСубъектов.Выгрузить();
	РасширитьСоставСубъектовВерхнихУровней(ТаблицаНабора);
	
КонецПроцедуры

Процедура РасширитьТаблицуНабораСоставомСубъектовНижнихУровней(ТаблицаНабора, ОбрабатыватьРуководителей = Истина)
	
	// Дополнение таблицы набора составом субъектов нижних уровней
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Таб.Субъект,
		|	Таб.Пользователь,
		|	Таб.ОбъектОснование,
		|	Таб.ПользовательОснование,
		|	Таб.ОбластьДелегирования,
		|	Таб.ИмяОбластиДелегирования,
		|	Таб.ОбъектМетаданных
		|ПОМЕСТИТЬ ТаблицаНабора
		|ИЗ
		|	&ТаблицаНабора КАК Таб
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставСубъектовПравДоступа.Субъект,
		|	ТаблицаНабора.Пользователь,
		|	ТаблицаНабора.ОбъектОснование,
		|	ТаблицаНабора.Субъект КАК ПользовательОснование,
		|	ТаблицаНабора.ОбластьДелегирования,
		|	ТаблицаНабора.ИмяОбластиДелегирования,
		|	ТаблицаНабора.ОбъектМетаданных
		|ИЗ
		|	ТаблицаНабора КАК ТаблицаНабора
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДелегированиеПрав КАК ДелегированиеПрав
		|			ПО СоставСубъектовПравДоступа.ОбъектОснование = ДелегированиеПрав.Ссылка
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|			ПО СоставСубъектовПравДоступа.ОбъектОснование = СтруктураПредприятия.Ссылка
		|		ПО ТаблицаНабора.Субъект = СоставСубъектовПравДоступа.Пользователь
		|ГДЕ
		|	(СтруктураПредприятия.Ссылка ЕСТЬ NULL 
		|			ИЛИ &ОбрабатыватьРуководителей = ИСТИНА)
		|	И ДелегированиеПрав.Ссылка ЕСТЬ NULL 
		|	И СоставСубъектовПравДоступа.Субъект <> СоставСубъектовПравДоступа.Пользователь
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ТаблицаНабора.Субъект,
		|	ТаблицаНабора.Пользователь,
		|	ТаблицаНабора.ОбъектОснование,
		|	ТаблицаНабора.ПользовательОснование,
		|	ТаблицаНабора.ОбластьДелегирования,
		|	ТаблицаНабора.ИмяОбластиДелегирования,
		|	ТаблицаНабора.ОбъектМетаданных
		|ИЗ
		|	ТаблицаНабора КАК ТаблицаНабора");
	
	Запрос.УстановитьПараметр("ТаблицаНабора", ТаблицаНабора);
	Запрос.УстановитьПараметр("ОбрабатыватьРуководителей", ОбрабатыватьРуководителей);
	ТаблицаНабора = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры
	
Процедура РасширитьСоставСубъектовВерхнихУровней(ТаблицаНабора, ОбрабатыватьРуководителей = Истина)
	
	// Расширение по руководителям и делегатам	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Таб.Субъект,
		|	Таб.Пользователь,
		|	Таб.ОбъектОснование,
		|	Таб.ПользовательОснование,
		|	Таб.ОбластьДелегирования,
		|	Таб.ИмяОбластиДелегирования,
		|	Таб.ОбъектМетаданных
		|ПОМЕСТИТЬ ТаблицаНабора
		|ИЗ
		|	&ТаблицаНабора КАК Таб
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаНабора.Субъект,
		|	СоставСубъектовПравДоступа.Пользователь,
		|	СоставСубъектовПравДоступа.ОбъектОснование,
		|	СоставСубъектовПравДоступа.Субъект КАК ПользовательОснование,
		|	СоставСубъектовПравДоступа.ОбластьДелегирования,
		|	СоставСубъектовПравДоступа.ИмяОбластиДелегирования,
		|	СоставСубъектовПравДоступа.ОбъектМетаданных
		|ПОМЕСТИТЬ ТаблицаСРуководителями
		|ИЗ
		|	ТаблицаНабора КАК ТаблицаНабора
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|			ПО СоставСубъектовПравДоступа.ОбъектОснование = СтруктураПредприятия.Ссылка
		|		ПО ТаблицаНабора.Пользователь = СоставСубъектовПравДоступа.Субъект
		|ГДЕ
		|	&ОбрабатыватьРуководителей = ИСТИНА
		|	И ТаблицаНабора.Субъект <> ТаблицаНабора.Пользователь
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ТаблицаНабора.Субъект,
		|	ТаблицаНабора.Пользователь,
		|	ТаблицаНабора.ОбъектОснование,
		|	ТаблицаНабора.ПользовательОснование,
		|	ТаблицаНабора.ОбластьДелегирования,
		|	ТаблицаНабора.ИмяОбластиДелегирования,
		|	ТаблицаНабора.ОбъектМетаданных
		|ИЗ
		|	ТаблицаНабора КАК ТаблицаНабора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаНабораСРуководителями.Субъект,
		|	СоставСубъектовПравДоступа.Пользователь,
		|	СоставСубъектовПравДоступа.ОбъектОснование,
		|	СоставСубъектовПравДоступа.Субъект КАК ПользовательОснование,
		|	СоставСубъектовПравДоступа.ОбластьДелегирования,
		|	СоставСубъектовПравДоступа.ИмяОбластиДелегирования,
		|	СоставСубъектовПравДоступа.ОбъектМетаданных
		|ПОМЕСТИТЬ ТаблицаСДелегатами
		|ИЗ
		|	ТаблицаСРуководителями КАК ТаблицаНабораСРуководителями
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДелегированиеПрав КАК ДелегированиеПрав
		|			ПО СоставСубъектовПравДоступа.ОбъектОснование = ДелегированиеПрав.Ссылка
		|				И СоставСубъектовПравДоступа.Субъект = ДелегированиеПрав.ОтКого
		|		ПО ТаблицаНабораСРуководителями.Пользователь = СоставСубъектовПравДоступа.Субъект
		|ГДЕ
		|	ТаблицаНабораСРуководителями.Субъект <> ТаблицаНабораСРуководителями.Пользователь
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ТаблицаСРуководителями.Субъект,
		|	ТаблицаСРуководителями.Пользователь,
		|	ТаблицаСРуководителями.ОбъектОснование,
		|	ТаблицаСРуководителями.ПользовательОснование,
		|	ТаблицаСРуководителями.ОбластьДелегирования,
		|	ТаблицаСРуководителями.ИмяОбластиДелегирования,
		|	ТаблицаСРуководителями.ОбъектМетаданных
		|ИЗ
		|	ТаблицаСРуководителями КАК ТаблицаСРуководителями
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаСДелегатами.Субъект,
		|	ТаблицаСДелегатами.Пользователь,
		|	ТаблицаСДелегатами.ОбъектОснование,
		|	ТаблицаСДелегатами.ПользовательОснование,
		|	ТаблицаСДелегатами.ОбластьДелегирования,
		|	ТаблицаСДелегатами.ИмяОбластиДелегирования,
		|	ТаблицаСДелегатами.ОбъектМетаданных
		|ИЗ
		|	ТаблицаСДелегатами КАК ТаблицаСДелегатами
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаНабора КАК ТаблицаНабора
		|		ПО ТаблицаСДелегатами.Субъект = ТаблицаНабора.Субъект
		|			И ТаблицаСДелегатами.Пользователь = ТаблицаНабора.Пользователь
		|			И ТаблицаСДелегатами.ОбъектОснование = ТаблицаНабора.ОбъектОснование
		|			И ТаблицаСДелегатами.ПользовательОснование = ТаблицаНабора.ПользовательОснование
		|			И ТаблицаСДелегатами.ОбластьДелегирования = ТаблицаНабора.ОбластьДелегирования
		|			И ТаблицаСДелегатами.ОбъектМетаданных = ТаблицаНабора.ОбъектМетаданных
		|ГДЕ
		|	ТаблицаНабора.Субъект ЕСТЬ NULL ");
	
	Запрос.УстановитьПараметр("ТаблицаНабора", ТаблицаНабора);
	Запрос.УстановитьПараметр("ОбрабатыватьРуководителей", ОбрабатыватьРуководителей);
	ТаблицаДопЗаписей = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаблицы Из ТаблицаДопЗаписей Цикл
		Запись = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, СтрокаТаблицы);
		Запись.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Удаляет неактуальные записи верхних уровней.
// Запись неактуальна, если ПользовательОснование не входит в состав субъекта.
// 
Процедура УдалитьНеактуальныеЗаписиВерхнихУровней(НомерИтерации = 1) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СоставСубъектов_ВерхнийУровень.Субъект,
		|	СоставСубъектов_ВерхнийУровень.Пользователь,
		|	СоставСубъектов_ВерхнийУровень.ОбъектОснование,
		|	СоставСубъектов_ВерхнийУровень.ПользовательОснование,
		|	СоставСубъектов_ВерхнийУровень.ОбластьДелегирования,
		|	СоставСубъектов_ВерхнийУровень.ИмяОбластиДелегирования,
		|	СоставСубъектов_ВерхнийУровень.ОбъектМетаданных
		|ИЗ
		|	РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектов_ВерхнийУровень
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО СоставСубъектов_ВерхнийУровень.ПользовательОснование = Пользователи.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектов_НижнийУровень
		|		ПО СоставСубъектов_ВерхнийУровень.Субъект = СоставСубъектов_НижнийУровень.Субъект
		|			И СоставСубъектов_ВерхнийУровень.ПользовательОснование = СоставСубъектов_НижнийУровень.Пользователь
		|ГДЕ
		|	СоставСубъектов_НижнийУровень.Пользователь ЕСТЬ NULL ");
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.СоставСубъектовПравДоступа.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		Запись.Удалить();
	КонецЦикла;
	
	// Выполнение второго прохода - на первом этапе могли не удалиться записи самого верхнего уровня, 
	// т.е. делегаты руководителей
	//
	НеобходимоеКоличествоИтераций = 2;
	Если НомерИтерации < НеобходимоеКоличествоИтераций Тогда
		УдалитьНеактуальныеЗаписиВерхнихУровней(НомерИтерации + 1);
	КонецЕсли;
	
КонецПроцедуры
