////////////////////////////////////////////////////////////////////////////////
// Модуль общего обработчика ожидания.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Подключает общий обработчик ожидания с интервалом в 60 сек.
// Процедура-обработчик находится в глобальном модуле:
// ОбщийОбработчикОжиданияГлобальный.
//
Процедура ПодключитьОбщийОбработчикОжидания() Экспорт
	
	ИнициализироватьПеременныеОбработчика();
	ОбщийОбработчикОжидания(); // Для того что бы код обработчиков ожидания выполнялся сразу после старта.
	ПодключитьОбработчикОжидания("ОбщийОбработчикОжидания", 60);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует глобальные переменные механизма Общий
// обработчик ожидания.
// Переменные находятся в модуле управляемого приложения.
//
Процедура ИнициализироватьПеременныеОбработчика()
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	// Для проверки новых писем.
	ВстроеннаяПочтаКлиент.ВключитьПроверкуПоступленияНовыхПисем();
	
	// Для работы механизма уведомлений. Значение устанавливается на 1 минут
	// раньше текущей даты для того что бы проверка уведомлений была запущена
	// сразу после старта.
	Если ПараметрыРаботыКлиента.ИспользоватьУведомленияПользователя Тогда
		ДатаПоследнейПроверкиУведомлений = ТекущаяДата() - 60;
	КонецЕсли;
	
	ДатаПоследнейПроверкиОчисткиКешаФайлов = ТекущаяДата();
	
КонецПроцедуры

// Проверяет готовые к запуску обработчики.
//
// Возвращаемое значение:
//    Структура - содержит данные о обработчиках, срок исполнения которых уже пришел.
//                В качестве ключа указывается имя обработчика, в качестве значения
//                Истина. Если время исполнения обработчика не наступило, тогда 
//                ключ и значение по нему не добавляются в структуру.
//
Функция ОбработчикиКЗапуску() Экспорт
	
	ТекущаяДата = ТекущаяДата();
	
	ОбработчикиКЗапуску = Новый Структура;
	
	Если ЗначениеЗаполнено(ДатаПоследнейПроверкиПочты)
		И ЗначениеЗаполнено(ИнтервалПроверкиПочты)
		И (ТекущаяДата - ДатаПоследнейПроверкиПочты
			>= ИнтервалПроверкиПочты) Тогда
		
		ОбработчикиКЗапуску.Вставить("ПроверкаПочты", Истина);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаПоследнейПроверкиУведомлений)
		И (ТекущаяДата - ДатаПоследнейПроверкиУведомлений >= 60) Тогда
		
		ОбработчикиКЗапуску.Вставить("ПроверкаУведомленийПрограммы", Истина);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаПоследнегоСохраненияЗамеров)
		И ЗначениеЗаполнено(ИнтервалСохраненияЗамеров)
		И (ТекущаяДата - ДатаПоследнегоСохраненияЗамеров 
			>= ИнтервалСохраненияЗамеров) Тогда
		
		ОценкаПроизводительностиЗамерВремени = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"];
		Замеры = ОценкаПроизводительностиЗамерВремени["Замеры"];
		ОбработчикиКЗапуску.Вставить("СохранениеЗамеровПроизводительности", Истина);
		ОбработчикиКЗапуску.Вставить("СохранениеЗамеровПроизводительностиЗамеры", Замеры);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПоследнейЗаписиЖурналаРегистрации)
		Или (ЗначениеЗаполнено(ДатаПоследнейЗаписиЖурналаРегистрации)
		И (ТекущаяДата - ДатаПоследнейЗаписиЖурналаРегистрации >= 600)) Тогда
		
		ДатаПоследнейЗаписиЖурналаРегистрации = ТекущаяДата();
		
		ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
		Если ПараметрыПриложения[ИмяПараметра] <> Неопределено Тогда
		
			Если ПараметрыПриложения[ИмяПараметра].Количество() <> 0 Тогда
				ЖурналРегистрацииВызовСервера.ЗаписатьСобытияВЖурналРегистрации(
					ПараметрыПриложения[ИмяПараметра]);
			КонецЕсли;
				
		КонецЕсли;	
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаПоследнейПроверкиОчисткиКешаФайлов)
		И (ТекущаяДата - ДатаПоследнейПроверкиОчисткиКешаФайлов >= 600) Тогда // 10 минут
		
		ОбработчикиКЗапуску.Вставить("ПроверкаОчисткиКешаФайлов", Истина);
		
	КонецЕсли;
	
	Возврат ОбработчикиКЗапуску;
	
КонецФункции

// Выполняет действия обработчика ожидания на клиенте.
// Процедура предназначена для вызова из ОбщийОбработчикОжиданияГлобальный.ОбщийОбработчикОжидания.
// 
// Параметры:
//    - ПараметрыВыполнения - Структура - содержащая параметры периодических обработчиков.
//
Процедура ВыполнитьДействияОбработчикаОжидания(ПараметрыВыполнения) Экспорт
	
	ТекущаяДата = ТекущаяДата();
	
	Если ЗначениеЗаполнено(ПараметрыВыполнения.РезультатыПроверкиПочты) Тогда
		
		// Обновление форм писем
		
		РезультатыПроверкиПочты = ПараметрыВыполнения.РезультатыПроверкиПочты;
		
		Если ЗначениеЗаполнено(РезультатыПроверкиПочты.СписокОповещений)
			И (РезультатыПроверкиПочты.ЧислоНовыхПисем <> 0 
			ИЛИ РезультатыПроверкиПочты.ЧислоНовыхПисемСписка <> 0)Тогда 
						
				Оповестить("ЗакрытьФормуОповещения");
				
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("СписокОповещений", РезультатыПроверкиПочты.СписокОповещений);
				ОткрытьФорму("Документ.ВходящееПисьмо.Форма.ОповещенияОНовыхПисьмах", ПараметрыФормы,,,
					ВариантОткрытияОкна.ОтдельноеОкно);
			
		КонецЕсли;	

		Если РезультатыПроверкиПочты.НужноОбновитьСписок Тогда
		
			#Если Не ВебКлиент Тогда 
				
				Если РезультатыПроверкиПочты.ЧислоНовыхПисем <> 0 Тогда
					
					СправочникСсылка =
						ПредопределенноеЗначение("Справочник.СправочникДляОткрытияСпискаПисем.Умолчательный");
					НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(СправочникСсылка);
					
					ТекстОповещения = "";
					
					Если РезультатыПроверкиПочты.ЧислоНовыхПисем = 1 Тогда
						ТекстОповещения = НСтр("ru='Получено новое письмо.'");
					Иначе	
						ТекстОповещения = НСтр("ru='Получены новые письма.'");
					КонецЕсли;	
					
					ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
						"ВстроеннаяПочта/ОповещениеПользователя",
						"ЧислоНовыхПисем",
						РезультатыПроверкиПочты.ЧислоНовыхПисем);
					
					ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
						"ВстроеннаяПочта/ОповещениеПользователя",
						"ПоследнееПисьмо",
						РезультатыПроверкиПочты.ПоследнееПисьмо);
					
					ПоказатьОповещениеПользователя(
						ТекстОповещения, 
						НавигационнаяСсылка, 
						РезультатыПроверкиПочты.Описание, 
						БиблиотекаКартинок.ОповещениеОНовыхПисьмах);
					
					КонецЕсли;
					
			#КонецЕсли
			
			ПараметрыОповещения = Новый Структура("МожноОбновитьСписокПисем", Истина);	
			Оповестить("ПришлиНовыеПисьма_ПроверкаВозможностиОбновленияСписка", ПараметрыОповещения);
			
			Если ПараметрыОповещения.МожноОбновитьСписокПисем Тогда
				Оповестить("ПисьмаИзменены"); // чтобы обновить список писем
			КонецЕсли;
			
		КонецЕсли;	
		
		ДатаПоследнейПроверкиПочты = ТекущаяДата;
		
	КонецЕсли;
	
	Если ПараметрыВыполнения.ЕстьУведомленияПрограммы Тогда
		
		Если ПараметрыВыполнения.УведомленияПрограммы.Количество() = 0 Тогда
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("РежимРаботы", "ПоказУведомлений");
			ОткрытьФорму("Справочник.УведомленияПрограммы.ФормаСписка",
				ПараметрыФормы,,,
				ВариантОткрытияОкна.ОтдельноеОкно);
		Иначе
			Для Каждого УведомлениеПрограммы Из ПараметрыВыполнения.УведомленияПрограммы Цикл
				ПараметрыФормы = Новый Структура();
				ПараметрыФормы.Вставить("РежимРаботы", "ПоказУведомлений");
				ПараметрыФормы.Вставить("Ключ", УведомлениеПрограммы);
				ОткрытьФорму("Справочник.УведомленияПрограммы.ФормаОбъекта",
					ПараметрыФормы,,,
					ВариантОткрытияОкна.ОтдельноеОкно);
			КонецЦикла;
		КонецЕсли;
		ДатаПоследнейПроверкиУведомлений = ТекущаяДата;
		
	КонецЕсли;
	
	Если ПараметрыВыполнения.РезультатыСохраненияЗамеров <> Неопределено Тогда
		
		РезультатыСохраненияЗамеров = ПараметрыВыполнения.РезультатыСохраненияЗамеров;
		Замеры = РезультатыСохраненияЗамеров.Замеры;
		ОценкаПроизводительностиКлиент.ОчиститьБуферЗамеров(Замеры);
		ДатаПоследнегоСохраненияЗамеров = ТекущаяДата;
		
	КонецЕсли;
	
	Если ПараметрыВыполнения.ПроверенаДатаОчисткиКешаФайлов Тогда
		
		ДатаПоследнейПроверкиОчисткиКешаФайлов = ТекущаяДата;
		
	КонецЕсли;
	
	Если ПараметрыВыполнения.НужнаОчисткаКешаФайлов Тогда
		
		// выполняем очистку
		РаботаСФайламиКлиент.ОчиститьРабочийКаталогПриУстаревании();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти