////////////////////////////////////////////////////////////////////////////////
// Старт бизнес процессов: в модуле содержатся процедуры для работы
// со стартом бизнес-процессов на сервере.

////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс_КарточкиПроцессов

// Заполняет реквизит НастройкаСтарта в карточке процесса
//
// Параметры:
//  Форма - УправляемаяФорма - карточка процесса.
//
Процедура ЗаполнитьНастройкиСтартаВФормеПроцесса(Форма) Экспорт
	
	Форма.СтартоватьФоново = Не ОбщегоНазначения.ИнформационнаяБазаФайловая()
		И ПолучитьФункциональнуюОпцию("ИспользоватьФоновыйСтартПроцессов");
	
	Если Форма.Объект.Ссылка.Пустая() Тогда
		
		Если Форма.Объект.Свойство("Шаблон") И ЗначениеЗаполнено(Форма.Объект.Шаблон) Тогда
			
			СрокОтложенногоСтарта = 
				ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
					Форма.Объект.Шаблон, "СрокОтложенногоСтарта");
			
			Если ЗначениеЗаполнено(СрокОтложенногоСтарта) Тогда
				Форма.НастройкаСтарта = СтартПроцессовКлиентСервер.СтруктураНастройкиСтартаПроцессов();
				Форма.НастройкаСтарта.ДатаОтложенногоСтарта = ТекущаяДатаСеанса() + СрокОтложенногоСтарта;
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(Форма.Объект.ПроектнаяЗадача) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	СрокиПроектныхЗадач.ТекущийПланНачало
				|ИЗ
				|	РегистрСведений.СрокиПроектныхЗадач КАК СрокиПроектныхЗадач
				|ГДЕ
				|	СрокиПроектныхЗадач.ПроектнаяЗадача = &ПроектнаяЗадача";
			Запрос.УстановитьПараметр("ПроектнаяЗадача", Форма.Объект.ПроектнаяЗадача);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() И Выборка.ТекущийПланНачало > ТекущаяДатаСеанса() Тогда
				Форма.НастройкаСтарта = СтартПроцессовКлиентСервер.СтруктураНастройкиСтартаПроцессов();
				Форма.НастройкаСтарта.ДатаОтложенногоСтарта = Выборка.ТекущийПланНачало;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Форма.НастройкаСтарта = РегистрыСведений.ПроцессыДляЗапуска.ПолучитьСведенияОЗапускеПроцесса(
			Форма.Объект.Ссылка);
			
		Форма.СтартоватьФоново = Форма.СтартоватьФоново
			И (Не ЗначениеЗаполнено(Форма.НастройкаСтарта)
				Или Форма.НастройкаСтарта.Состояние <> 
				Перечисления.СостоянияПроцессовДляЗапуска.СтартОтменен);
	КонецЕсли;
	
КонецПроцедуры

// Обновляется настройки старта из формы процесса.
//
// В зависимости от переданных параметров записи (ФоновыйСтартПроцесса, ОтложенныйСтартПроцесса)
// процесс помещается в очередь для фонового или отложенного старта.
//
// Если этих параметров записи нет, то обновляется настройка старта по переданному
// параметру НастройкаСтарта.
//
// Параметры:
//  Процесс - БизнесПроцессСсылка - ссылка на процесс.
//  ПараметрыЗаписи - Структура - параметры процесса в форме.
//  НастройкаСтарта - Структура - см. СтартПроцессовКлиентСервер.СтруктураНастройкиСтартаПроцессов
//
Процедура ОбновитьНастройкиСтартаПроцессаИзФормы(Процесс, ПараметрыЗаписи, НастройкаСтарта) Экспорт
	
	// Фоновый старт
	
	Если ПараметрыЗаписи.Свойство("ФоновыйСтартПроцесса") И ПараметрыЗаписи.ФоновыйСтартПроцесса Тогда
		
		РегистрыСведений.ПроцессыДляЗапуска.ДобавитьПроцессДляФоновогоСтарта(Процесс);
		
		Возврат;
		
	КонецЕсли;
	
	// Отложенный старт
	
	Если ПараметрыЗаписи.Свойство("ОтложенныйСтартПроцесса")
		И ПараметрыЗаписи.ОтложенныйСтартПроцесса Тогда
		
		РегистрыСведений.ПроцессыДляЗапуска.ДобавитьПроцессДляОтложенногоСтарта(
			Процесс,
			НастройкаСтарта.ДатаОтложенногоСтарта,
			Ложь);
		
		Возврат;
		
	КонецЕсли;
	
	// Обновление настройки отложенного старта
	
	СохраненныеНастройки = 
		РегистрыСведений.ПроцессыДляЗапуска.ПолучитьСведенияОЗапускеПроцесса(Процесс);
	
	Если ОбщегоНазначения.ДанныеСовпадают(СохраненныеНастройки, НастройкаСтарта) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкаСтарта)
		И ЗначениеЗаполнено(НастройкаСтарта.ДатаОтложенногоСтарта) Тогда
		
		РегистрыСведений.ПроцессыДляЗапуска.ДобавитьПроцессДляОтложенногоСтарта(
			Процесс,
			НастройкаСтарта.ДатаОтложенногоСтарта,
			Истина);
			
	ИначеЕсли ЗначениеЗаполнено(СохраненныеНастройки) Тогда
		
		РегистрыСведений.ПроцессыДляЗапуска.УдалитьПроцессИзОчередиДляЗапуска(Процесс);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_КарточкаШаблонаПроцесса

Процедура КарточкаШаблонаПриСозданииНаСервере(Форма) Экспорт
	
	Форма.ОтложенныйСтартДни = Цел(Форма.Объект.СрокОтложенногоСтарта/86400);
	
	Форма.ОтложенныйСтартЧасы = 
		(Форма.Объект.СрокОтложенногоСтарта - Форма.ОтложенныйСтартДни * 86400)/3600;
		
	Форма.ОписаниеОтложенногоСтарта = СтартПроцессовКлиентСервер.УстановитьОписанияОтложенногоСтарта(
			Форма.ОтложенныйСтартДни, Форма.ОтложенныйСтартЧасы);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура СтартоватьПроцесс(БизнесПроцесс) Экспорт
	
	КлючеваяОперация = "";
	
	ТипПроцесса = ТипЗнч(БизнесПроцесс);
	Если ТипПроцесса = Тип("БизнесПроцессОбъект.Исполнение") Тогда
		КлючеваяОперация = "ИсполнениеСтартовать";
	ИначеЕсли ТипПроцесса = Тип("БизнесПроцессОбъект.Ознакомление") Тогда
		КлючеваяОперация = "ОзнакомлениеСтартовать";
	ИначеЕсли ТипПроцесса = Тип("БизнесПроцессОбъект.Поручение") Тогда
		КлючеваяОперация = "ПоручениеСтартовать";
	ИначеЕсли ТипПроцесса = Тип("БизнесПроцессОбъект.Приглашение") Тогда
		КлючеваяОперация = "ПриглашениеСтартовать";
	ИначеЕсли ТипПроцесса = Тип("БизнесПроцессОбъект.Рассмотрение") Тогда
		КлючеваяОперация = "РассмотрениеСтартовать";
	ИначеЕсли ТипПроцесса = Тип("БизнесПроцессОбъект.Регистрация") Тогда
		КлючеваяОперация = "РегистрацияСтартовать";
	ИначеЕсли ТипПроцесса = Тип("БизнесПроцессОбъект.Согласование") Тогда
		КлючеваяОперация = "СогласованиеСтартовать";
	ИначеЕсли ТипПроцесса = Тип("БизнесПроцессОбъект.Утверждение") Тогда
		КлючеваяОперация = "УтверждениеСтартовать";
	КонецЕсли;
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности()
		И ЗначениеЗаполнено(КлючеваяОперация) Тогда
		ВремяНачала = ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени();
		БизнесПроцесс.Старт();
		ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала);
	Иначе
		БизнесПроцесс.Старт();
	КонецЕсли;
	
КонецПроцедуры

// Записывает в настройку отложенного старта признак готовности процесса к отложенному старту
// и перезаписывает сам бизнес-процесс. Процедура предназначена для вызова из процедур
// ОтложенныйСтарт модуля объекта бизнес-процесса. В случае если процесса уже стартован или у
// процесса отсутствует настройка отложенного старта будет вызвано исключение.
//
// Параметры:
//   - БизнесПроцесс - БизнесПроцессОбъект - процесс, который следует запустить отложенно.
//
Процедура СтартоватьПроцессОтложенно(БизнесПроцесс) Экспорт
	
	Если БизнесПроцесс.Стартован Тогда
		ОписаниеОшибки = 
			НСтр("ru = 'Процесс уже стартован.'");
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	Настройка = РегистрыСведений.ПроцессыДляЗапуска.ПолучитьСведенияОЗапускеПроцесса(
		БизнесПроцесс.Ссылка);
	
	Если НЕ ЗначениеЗаполнено(Настройка) Тогда
		ОписаниеОшибки = 
			НСтр("ru = 'Нельзя стартовать процесс отложенно без настройки отложенного старта.'");
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	// При добавлении будет заблокирована соответствующая запись настройки в РС ПроцессыДляЗапуска.
	РегистрыСведений.ПроцессыДляЗапуска.ДобавитьПроцессДляОтложенногоСтарта(
		Настройка.БизнесПроцесс, Настройка.ДатаОтложенногоСтарта);
		
	БизнесПроцесс.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Отключает действие настройки отложенного старта, сбрасывая признак готовности к отложенному
// старту и перезаписывает сам бизнес-процесс. Процедура предназначена для вызова из процедур
// ОтключитьОтложенныйСтарт модуля объекта бизнес-процесса. В случае если процесса уже стартован или у
// процесса отсутствует настройка отложенного старта будет вызвано исключение.
//
// Параметры:
//   - БизнесПроцесс - БизнесПроцессОбъект - процесс, который следует запустить отложенно.
//
Процедура ОтключитьОтложенныйСтарт(БизнесПроцесс) Экспорт
	
	Если БизнесПроцесс.Стартован Тогда
		ОписаниеОшибки = 
			НСтр("ru = 'Нельзя отключить отложенный старт по уже стартованному процессу.'");
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	Настройка = РегистрыСведений.ПроцессыДляЗапуска.ПолучитьСведенияОЗапускеПроцесса(
		БизнесПроцесс.Ссылка);
	
	Если НЕ ЗначениеЗаполнено(Настройка) Тогда
		ОписаниеОшибки = 
			НСтр("ru = 'Нельзя отключить отложенный старт по процессу без настроек.'");
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	// При отключении будет заблокирована соответствующая запись настройки в РС ПроцессыДляЗапуска.
	РегистрыСведений.ПроцессыДляЗапуска.ОтключитьОтложенныйСтартПроцесса(Настройка.БизнесПроцесс);
		
	БизнесПроцесс.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Процедура предназначена для вызова из процедуры ПриЗаписи
// всех бизнес-процессов, за исключением РешениеВопросовВыполненияЗадач объектов.
// В процедуре производится заполнение настроек отложенного старта для БизнесПроцесса
// на основе шаблона этого бизнес-процесса.
//
// Параметры:
//   - БизнесПроцесс - БизнесПроцессОбъект
//   - Отказ - Булево - ссылка на параметр Отказ в процедуре ПриЗаписи модуля объекта БП.
//
Процедура ПроцессПриЗаписи(БизнесПроцесс, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не БизнесПроцесс.ДополнительныеСвойства.Свойство("ШаблонДляОтложенногоСтарта") Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонДляОтложенногоСтарта = БизнесПроцесс.ДополнительныеСвойства.ШаблонДляОтложенногоСтарта;
	
	НастройкаСтарта = РегистрыСведений.ПроцессыДляЗапуска.ПолучитьСведенияОЗапускеПроцесса(
		БизнесПроцесс.Ссылка);
	
	Если ЗначениеЗаполнено(НастройкаСтарта) Тогда
		Возврат;
	КонецЕсли;
		
	РеквизитыШаблона = 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ШаблонДляОтложенногоСтарта, "СрокОтложенногоСтарта");
	
	Если ЗначениеЗаполнено(РеквизитыШаблона)
		И РеквизитыШаблона.СрокОтложенногоСтарта > 0 Тогда
		
		ДатаОтложенногоСтарта = ТекущаяДатаСеанса() + РеквизитыШаблона.СрокОтложенногоСтарта;
		
		РегистрыСведений.ПроцессыДляЗапуска.ДобавитьПроцессДляОтложенногоСтарта(
			БизнесПроцесс.Ссылка, ДатаОтложенногоСтарта, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик регламентного задания СтартОтложенныхПроцессов
//
Процедура СтартОтложенныхПроцессов() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтотУзелОбмена = РаботаСБизнесПроцессами.ЭтотУзелОбменаДляОбработкиПроцессов();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроцессыДляЗапуска.БизнесПроцесс,
		|	ПроцессыДляЗапуска.ДатаОтложенногоСтарта,
		|	ПроцессыДляЗапуска.Состояние,
		|	ПроцессыДляЗапуска.БизнесПроцесс.Автор КАК Автор,
		|	ПроцессыДляЗапуска.КоличествоПопытокОбработки,
		|	ПроцессыДляЗапуска.АвтоДобавленияЗаписи
		|ИЗ
		|	РегистрСведений.ПроцессыДляЗапуска КАК ПроцессыДляЗапуска
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
		|		ПО ПроцессыДляЗапуска.БизнесПроцесс = ДанныеБизнесПроцессов.БизнесПроцесс
		|ГДЕ
		|	ПроцессыДляЗапуска.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияПроцессовДляЗапуска.ГотовКСтарту)
		|	И ПроцессыДляЗапуска.КоличествоПопытокОбработки <= 3
		|	И ПроцессыДляЗапуска.ДатаОтложенногоСтарта <= &ТекущаяДата
		|	И ПроцессыДляЗапуска.ДатаОтложенногоСтарта <> ДАТАВРЕМЯ(1, 1, 1)
		|	И ДанныеБизнесПроцессов.ПометкаУдаления = ЛОЖЬ
		|	И ДанныеБизнесПроцессов.УзелОбмена = &ЭтотУзелОбмена
		|	И ДанныеБизнесПроцессов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Активен)";
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ЭтотУзелОбмена", ЭтотУзелОбмена);
	
	Выборка  = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПроцессыДляЗапуска");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("БизнесПроцесс", Выборка.БизнесПроцесс);
		
		НачатьТранзакцию();
		
		// Пытаемся заблокировать процесс и запись в регистре ПроцессыДляЗапуска.
		// Если не удается, то пропускаем процесс и пробуем выполнить при след. обработке.
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.БизнесПроцесс);
			Блокировка.Заблокировать();
		Исключение
			ОтменитьТранзакцию();
			Продолжить;
		КонецПопытки;
		
		Попытка
			
			РегистрыСведений.ПроцессыДляЗапуска.ЗарегистрироватьСтартПроцесса(Выборка.БизнесПроцесс);
			
			БизнесПроцессОбъект = Выборка.БизнесПроцесс.ПолучитьОбъект();
			
			// Проверка прав участников процесса на предметы
			МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(
				БизнесПроцессОбъект, Выборка.АвтоДобавленияЗаписи);
			
			СтартоватьПроцесс(БизнесПроцессОбъект);
			
			РазблокироватьДанныеДляРедактирования(Выборка.БизнесПроцесс);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			Если Выборка.КоличествоПопытокОбработки < 3 Тогда
				РегистрыСведений.ПроцессыДляЗапуска.ЗарегистрироватьПопыткуСтартаПроцесса(Выборка.БизнесПроцесс);
			Иначе
				ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				
				Описание = НСтр("ru = 'Во время отложенного старта этого процесса произошла ошибка:
					|%1
					|Попробуйте запустить процесс вручную, а не отложенно.'");
					
				Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					Описание,
					ОписаниеОшибки);
				
				РегистрыСведений.ПроцессыДляЗапуска.ЗарегистрироватьОтменуСтарта(
					Выборка.БизнесПроцесс, Описание);
					
				РаботаСУведомлениями.ОбработатьУведомлениеПрограммы(
					Описание,
					Выборка.Автор,
					Выборка.БизнесПроцесс);
			КонецЕсли;
				
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик регламентного задания СтартПроцессов
//
Процедура СтартПроцессов() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьФоновыйСтартПроцессов") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотУзелОбмена = РаботаСБизнесПроцессами.ЭтотУзелОбменаДляОбработкиПроцессов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроцессыДляЗапуска.БизнесПроцесс,
		|	ПроцессыДляЗапуска.Состояние,
		|	ПроцессыДляЗапуска.КоличествоПопытокОбработки,
		|	ДанныеБизнесПроцессов.Автор КАК Автор,
		|	ПроцессыДляЗапуска.АвтоДобавленияЗаписи
		|ИЗ
		|	РегистрСведений.ПроцессыДляЗапуска КАК ПроцессыДляЗапуска
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
		|		ПО ПроцессыДляЗапуска.БизнесПроцесс = ДанныеБизнесПроцессов.БизнесПроцесс
		|ГДЕ
		|	ПроцессыДляЗапуска.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияПроцессовДляЗапуска.ГотовКСтарту)
		|	И ПроцессыДляЗапуска.КоличествоПопытокОбработки <= 3
		|	И ПроцессыДляЗапуска.ДатаОтложенногоСтарта = ДАТАВРЕМЯ(1, 1, 1)
		|	И ДанныеБизнесПроцессов.ПометкаУдаления = ЛОЖЬ
		|	И ДанныеБизнесПроцессов.УзелОбмена = &ЭтотУзелОбмена
		|	И ДанныеБизнесПроцессов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Активен)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПроцессыДляЗапуска.МоментВремени";
		
	Запрос.УстановитьПараметр("ЭтотУзелОбмена", ЭтотУзелОбмена);
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПроцессыДляЗапуска");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("БизнесПроцесс", Выборка.БизнесПроцесс);
		
		НачатьТранзакцию();
		
		// Пытаемся заблокировать процесс и запись в регистре ПроцессыДляЗапуска.
		// Если не удается, то пропускаем процесс и пробуем выполнить при след. обработке.
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.БизнесПроцесс);
			Блокировка.Заблокировать();
		Исключение
			ОтменитьТранзакцию();
			Продолжить;
		КонецПопытки;
		
		Попытка
			
			РегистрыСведений.ПроцессыДляЗапуска.УдалитьПроцессИзОчередиДляЗапуска(
				Выборка.БизнесПроцесс);
			
			БизнесПроцессОбъект = Выборка.БизнесПроцесс.ПолучитьОбъект();
			
			// Проверка прав участников процесса на предметы
			МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(
				БизнесПроцессОбъект, Выборка.АвтоДобавленияЗаписи);
			
			СтартоватьПроцесс(БизнесПроцессОбъект);
			
			РазблокироватьДанныеДляРедактирования(Выборка.БизнесПроцесс);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			Если Выборка.КоличествоПопытокОбработки < 3 Тогда
				РегистрыСведений.ПроцессыДляЗапуска.ЗарегистрироватьПопыткуСтартаПроцесса(Выборка.БизнесПроцесс);
			Иначе
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				
				Описание = НСтр("ru = 'Во время старта этого процесса произошла ошибка:
					|%1
					|Попробуйте стартовать процесс еще раз.'");
					
				Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					Описание,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
				
				РегистрыСведений.ПроцессыДляЗапуска.ЗарегистрироватьОтменуСтарта(
					Выборка.БизнесПроцесс, Описание);
					
				РаботаСУведомлениями.ОбработатьУведомлениеПрограммы(
					Описание,
					Выборка.Автор,
					Выборка.БизнесПроцесс);
			КонецЕсли;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Выбирает из списка шаблонов процессов шаблоны с настройками отложенного старта.
//
// Параметры:
//   - Шаблоны - СписокЗначений - с шаблонами процессов.
//                  - СправочникСсылка.ШаблоныИсполнения
//                  - СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов
//                  - СправочникСсылка.ШаблоныОзнакомления
//                  - СправочникСсылка.ШаблоныПоручения
//                  - СправочникСсылка.ШаблоныПриглашения
//                  - СправочникСсылка.ШаблоныРассмотрения
//                  - СправочникСсылка.ШаблоныРегистрации
//                  - СправочникСсылка.ШаблоныСогласования
//                  - СправочникСсылка.ШаблоныСоставныхБизнесПроцессов
//                  - СправочникСсылка.ШаблоныУтверждения
//
// Возвращаемое значение:
//   - СписокЗначений
//
Функция СписокШаблоновСНастройкамиОтложенногоСтарта(Шаблоны) Экспорт
	
	Результат = Новый СписокЗначений;
	
	СписокШаблонов = Новый СписокЗначений;
	СписокШаблонов.Добавить("ШаблоныИсполнения");
	СписокШаблонов.Добавить("ШаблоныКомплексныхБизнесПроцессов");
	СписокШаблонов.Добавить("ШаблоныОзнакомления");
	СписокШаблонов.Добавить("ШаблоныПоручения");
	СписокШаблонов.Добавить("ШаблоныПриглашения");
	СписокШаблонов.Добавить("ШаблоныРассмотрения");
	СписокШаблонов.Добавить("ШаблоныРегистрации");
	СписокШаблонов.Добавить("ШаблоныСогласования");
	СписокШаблонов.Добавить("ШаблоныСоставныхБизнесПроцессов");
	СписокШаблонов.Добавить("ШаблоныУтверждения");
		
	ТекстОбъединить = "";
	ТекстЗапроса = "";
	
	УстановитьПривилегированныйРежим(Истина);
		
	Для Каждого ШаблонПодпроцесса Из СписокШаблонов Цикл
		
		ТекстЗапросаПоТекущемуШаблону = 
			"ВЫБРАТЬ
			|	ШаблоныБП.Ссылка
			|ИЗ
			|	Справочник.%1 КАК ШаблоныБП
			|ГДЕ
			|	ШаблоныБП.Ссылка В(&Шаблоны)
			|	И ШаблоныБП.СрокОтложенногоСтарта > 0";
		
		ТекстЗапросаПоТекущемуШаблону = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстЗапросаПоТекущемуШаблону,
				ШаблонПодпроцесса.Значение);
		
		ТекстЗапроса = ТекстЗапроса + ТекстОбъединить + ТекстЗапросаПоТекущемуШаблону;
		
		ТекстОбъединить = "
			|
			|ОБЪЕДИНИТЬ
			|";
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Шаблоны", Шаблоны);
	ТаблицаШаблонов = Запрос.Выполнить().Выгрузить();
	
	Результат.ЗагрузитьЗначения(ТаблицаШаблонов.ВыгрузитьКолонку("Ссылка"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти



