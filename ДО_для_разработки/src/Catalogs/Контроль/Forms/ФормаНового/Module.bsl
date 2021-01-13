
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", "ГруппаКомПанельИсполнители");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПредметПроцессЗадача = Ложь;
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда 
		Если ОбщегоНазначения.ЭтоБизнесПроцесс(Объект.Предмет.Метаданные())
		 Или ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
			ПредметПроцессЗадача = Истина; 
		КонецЕсли; 
	КонецЕсли;
	
	ПроцессЗадачаЗавершен = Ложь;	
	Если ПредметПроцессЗадача Тогда 
		Если ОбщегоНазначения.ЭтоБизнесПроцесс(Объект.Предмет.Метаданные()) Тогда 
			ПроцессЗадачаЗавершен = Объект.Предмет.Завершен 
				Или Объект.Предмет.Состояние = Перечисления.СостоянияБизнесПроцессов.Прерван;
		ИначеЕсли ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
			ПроцессЗадачаЗавершен = Объект.Предмет.Выполнена;
		КонецЕсли;	
	КонецЕсли;		
	
	// Заполнение готовых вариантов контрольных сроков
	СписокВыбора = Элементы.СрокИсполнения.СписокВыбора;
	Элементы.СрокИсполнения.СписокВыбора.Добавить(ТекущаяДата() + 24*3600,			НСтр("ru = 'Завтра'"));
	Элементы.СрокИсполнения.СписокВыбора.Добавить(ТекущаяДата() + 2*24*3600, 		НСтр("ru = '2 дня'"));	
	Элементы.СрокИсполнения.СписокВыбора.Добавить(ТекущаяДата() + 3*24*3600, 		НСтр("ru = '3 дня'"));	
	Элементы.СрокИсполнения.СписокВыбора.Добавить(ТекущаяДата() + 7*24*3600, 		НСтр("ru = 'Неделя'"));
	Элементы.СрокИсполнения.СписокВыбора.Добавить(ДобавитьМесяц(ТекущаяДата(), 1), 	НСтр("ru = 'Месяц'"));
	
	ЦветЗеленый = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
	ЦветКрасный = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ТипЗнч(Объект.Предмет) = Тип("СправочникСсылка.ВеткиПереписки") Тогда 
		ПредметСсылка = Объект.Предмет.КорневоеПисьмо;
	Иначе	
		ПредметСсылка = Объект.Предмет;
	КонецЕсли;	
	ПредметСтрокой = Контроль.СформироватьПредставлениеПредмета(ПредметСсылка);
	
	// Видимость поля "Предмет"
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда 
		Элементы.ГруппаОписаниеСтраницы.ТекущаяСтраница = Элементы.ГруппаОписаниеИПредмет;
	Иначе
		Элементы.ГруппаОписаниеСтраницы.ТекущаяСтраница = Элементы.ГруппаОписание;
	КонецЕсли;
			
	Элементы.ГруппаИсполнителиПодписьКомПанель.ТекущаяСтраница = Элементы.СтраницаНадписьКомПанель;
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда 
		Если ПредметПроцессЗадача Тогда 
			Элементы.Исполнители.ИзменятьСоставСтрок = Ложь;
			Элементы.Исполнители.ИзменятьПорядокСтрок = Ложь;
			Элементы.Исполнители.ТолькоПросмотр = Истина;
			Элементы.ГруппаИсполнителиПодписьКомПанель.ТекущаяСтраница = Элементы.СтраницаТолькоНадпись;
		ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ПредметСсылка) Тогда 
			Элементы.Исполнители.ИзменятьСоставСтрок = Ложь;
			Элементы.ИсполнителиИсполнитель.ТолькоПросмотр = Истина;
			Элементы.Подобрать.Видимость = Ложь;
			Элементы.Добавить.Видимость = Ложь;
			Элементы.Удалить.Видимость = Ложь;
			Если Объект.Исполнители.Количество() = 1 Тогда
				Элементы.Исполнители.ИзменятьПорядокСтрок = Ложь;
				Элементы.ГруппаИсполнителиПодписьКомПанель.ТекущаяСтраница = Элементы.СтраницаТолькоНадпись;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// возможные контролеры
	Контроль.ЗаполнитьСписокКонтролеров(Контролеры, 
		Элементы.Контролер,
		Элементы.КонтролерБезПользовательскойВидимости);
	
	Если ЗначениеЗаполнено(Объект.Описание) И Не ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда
		Элементы.СрокИсполнения.АктивизироватьПоУмолчанию = Истина;
	КонецЕсли;
	
	// Сохранение вводимых значений
	СохранениеВводимыхЗначений.ЗаполнитьСписокВыбора(ЭтаФорма, ЭлементыДляСохранения(), "Справочник.Контроль.ФормаЭлементаИФормаНового");
	
	ПроверятьОтсутствие = Отсутствия.ПредупреждатьОбОтсутствии();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПроцессЗадачаЗавершен Тогда 
		Если ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			ТекстСообщения = НСтр("ru = 'Нельзя поставить на контроль выполненную задачу.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Нельзя поставить на контроль завершенный или прерванный процесс.'");
		КонецЕсли;	
		
		ПоказатьПредупреждение(, ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	ВывестиПодписьЧислаДней();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(Объект.Исполнители, "Исполнитель");
	НазначитьОтветственногоИсполнителя();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ПоставленНаКонтроль = Истина;
	ТекущийОбъект.ДатаПостановкиНаКонтроль = ТекущаяДата();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Сохранение вводимых значений
	СохранениеВводимыхЗначений.ОбновитьСпискиВыбора(ЭтаФорма, ЭлементыДляСохранения(), "Справочник.Контроль.ФормаЭлементаИФормаНового");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	КонтрольКлиент.ОповеститьОЗаписиКонтроля(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ПустаяСтрока(Объект.Описание) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( 
		    НСтр("ru = 'Не заполнено поле ""Что контролировать"".'"), 
			, 
			"Описание", 
			"Объект", 
			Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Контролер) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( 
		    НСтр("ru = 'Не заполнено поле ""Контролер"".'"), 
			, 
			"Контролер", 
			"Объект", 
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	
	ВывестиПодписьЧислаДней();
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВывестиПодписьЧислаДней();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Контролеры.Количество() = 0 Тогда 
		РаботаСАдреснойКнигойКлиент.ВыбратьПользователяДляКонтроля(
			ЭтаФорма, Элемент, Объект.Контролер);
	ИначеЕсли Контролеры.Количество() > 10 Тогда
		РаботаСАдреснойКнигойКлиент.ВыбратьПользователяДляКонтроля(
			ЭтаФорма, Элемент, Объект.Контролер, Контролеры);
	Иначе
		ДанныеВыбора = Контролеры;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораКонтролера(Текст, Контролеры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораКонтролера(Текст, Контролеры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьДанныеВыбораКонтролера(Текст, Контролеры)
	
	Если Контролеры.Количество() = 0 Тогда 
		
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
		
	Иначе
		
		ДанныеВыбора = Новый СписокЗначений;
		Для Каждого Строка Из Контролеры Цикл
			Если Текст <> "" И НРег(Лев(Строка.Значение, СтрДлина(Текст))) <> НРег(Текст) Тогда 
				Продолжить;
			КонецЕсли;
			ДанныеВыбора.Добавить(Строка.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ДанныеВыбора;
	
КонецФункции

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(, ПредметСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсполнители

&НаКлиенте
Процедура ИсполнителиПриИзменении(Элемент)
	
	НазначитьОтветственногоИсполнителя();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда 
		Элементы.Исполнители.ТекущиеДанные.Исполнитель = ПользователиПустаяСсылка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
	
	РаботаСАдреснойКнигойКлиент.ВыбратьПользователяДляКонтроля(
		ЭтаФорма, Элемент, ТекущиеДанные.Исполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьПодборКонтролируемыхПользователей", ЭтаФорма);
		
	РаботаСАдреснойКнигойКлиент.ПодобратьПользователейДляКонтроля(ЭтаФорма, Объект.Исполнители, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПодборКонтролируемыхПользователей(
	ВыбранныеПользователи, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеПользователи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Исполнители.Очистить();
	
	Для Каждого ВыбранныйПользователь Из ВыбранныеПользователи Цикл
		
		НоваяСтрока = Объект.Исполнители.Добавить();
		НоваяСтрока.Исполнитель = ВыбранныйПользователь;
		
	КонецЦикла;
	
	НазначитьОтветственногоИсполнителя();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьНаКонтроль(Команда)
	
	ОчиститьСообщения();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоставитьНаКонтрольПродолжение", ЭтотОбъект);
	Если Не ОтсутствияКлиент.ПроверитьОтсутствиеПоКонтролю(ЭтаФорма,
			Объект.Исполнители, Объект.СрокИсполнения, ОписаниеОповещения) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьНаКонтрольЗавершение(Результат, Параметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	Если Записать() Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция РазностьДат(Дата1, Дата2)
	
	Возврат (НачалоДня(Дата2) - НачалоДня(Дата1)) / (24 * 3600);
	
КонецФункции	

&НаКлиенте
Процедура ВывестиПодписьЧислаДней()
	
	Если Не ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда 
		Элементы.ДекорацияСрок.Заголовок = "";
	Иначе	
		ЧислоДней = РазностьДат(ТекущаяДата(), Объект.СрокИсполнения);
		Если ЧислоДней = 0 Тогда 
			Элементы.ДекорацияСрок.Заголовок = НСтр("ru = '(сегодня)'");
			Элементы.ДекорацияСрок.ЦветТекста = ЦветЗеленый;
		ИначеЕсли ЧислоДней > 0 Тогда 
			ПодписьДней = ДелопроизводствоКлиентСервер.ПолучитьПодписьДней(ЧислоДней);
			Элементы.ДекорацияСрок.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '(осталось %1 %2)'"),
				ЧислоДней,
				ПодписьДней);
			Элементы.ДекорацияСрок.ЦветТекста = ЦветЗеленый;
		Иначе
			ПодписьДней = ДелопроизводствоКлиентСервер.ПолучитьПодписьДней(-ЧислоДней);
			Элементы.ДекорацияСрок.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '(просрочено %1 %2)'"),
				-ЧислоДней,
				ПодписьДней);
			Элементы.ДекорацияСрок.ЦветТекста = ЦветКрасный;
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура НазначитьОтветственногоИсполнителя()
	
	Если ПредметПроцессЗадача Тогда 
		Возврат;
	КонецЕсли;	
	
	Для Номер = 0 По Объект.Исполнители.Количество() - 1 Цикл 
		Объект.Исполнители[Номер].Ответственный = Ложь;
	КонецЦикла;
	
	Если Объект.Исполнители.Количество() > 1 Тогда 
		Объект.Исполнители[0].Ответственный = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьНаКонтрольПродолжение(Результат, Параметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоставитьНаКонтрольЗавершение", ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Объект.Предмет)
		И Контроль.ПредметНаКонтролеУКонтролера(Объект.Предмет, Объект.Контролер, Объект.Ссылка) Тогда
		
		Если Объект.Контролер = ТекущийПользователь Тогда
			ТекстВопроса = НСтр("ru = 'Предмет уже находится у вас на контроле.
								|Поставить на контроль еще раз?'");
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Предмет уже находится на контроле у %1.
					|Поставить на контроль еще раз?'"),
				Объект.Контролер);
		КонецЕсли;
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет);
		
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЭлементыДляСохранения()
	
	СохраняемыеЭлементы = Новый Структура;
	СохраняемыеЭлементы.Вставить("Контролер", Объект.Контролер);
		
	Возврат СохранениеВводимыхЗначений.СформироватьТаблицуСохраняемыхЭлементов(СохраняемыеЭлементы);
	
КонецФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
