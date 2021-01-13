////////////////////////////////////////////////////////////////////////////////
// Бронирование помещений
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Добавляет значение в массив, если данного значения нет в массиве.
//
Процедура ДобавитьЗначениеВМассив(Значение, Массив) Экспорт
	
	Если ТипЗнч(Значение) = Тип("Структура")
		И Значение.Свойство("Бронь")
		И Значение.Свойство("ДатаИсключения") Тогда
		
		Для Каждого ЭлементМассива Из Массив Цикл
			
			Если ЭлементМассива.Бронь = Значение.Бронь
				И ЭлементМассива.ДатаИсключения = Значение.ДатаИсключения Тогда
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
		Массив.Добавить(Значение);
		
	Иначе
		
		Если Массив.Найти(Значение) = Неопределено Тогда
			Массив.Добавить(Значение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Показывает схему территории.
//
// Параметры:
//  Территория - СправочникСсылка.ТерриторииИПомещения - Территория, схему которой необходимо показать.
//
Процедура ПоказатьСхемуТерритории(Территория) Экспорт
	
	ПоказатьЗначение(, Территория);
	
КонецПроцедуры

// Устанавливает пометку удаления брони и оповещает другие формы.
//
// Параметры:
//  Бронь - ДокументСсылка.Бронь - Бронь.
//  ПометкаУдаления - Булево - Новая пометка удаления.
//
Процедура УстановитьПометкуУдаления(Бронь, ПометкаУдаления) Экспорт
	
	Если ТипЗнч(Бронь) <> Тип("ДокументСсылка.Бронь") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Бронь", Бронь);
	ПараметрыОбработчика.Вставить("ПометкаУдаления", ПометкаУдаления);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьПометкуУдаленияЗавершение",
		ЭтотОбъект, ПараметрыОбработчика);
	
	Если ПометкаУдаления Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить ""%1"" на удаление?'"),
			Бронь);
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
			Бронь);
	КонецЕсли;
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,
		, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

// Открывает форму настройки повторения события.
//
// Параметры:
//  Бронь - ДанныеФормыСтруктура - Данные брони.
//  ОписаниеОповещения - ОписаниеОповещения - Описание оповещения обработки после настройки повторения.
//
Процедура ОткрытьФормуНастройкиПовторения(Бронь, ОписаниеОповещения) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Бронь", Бронь);
	
	ОткрытьФорму("Документ.Бронь.Форма.ФормаНастройкиПовторения", ПараметрыФормы,
		, , , , ОписаниеОповещения);
	
КонецПроцедуры

// Открывает форму настройки.
//
Процедура ОткрытьФормуНастройкиПросмотраБроней() Экспорт
	
	ОткрытьФорму("Документ.Бронь.Форма.НастройкаПросмотраБроней");
	
КонецПроцедуры

// Обрабатывает редактирование элементов планировщика.
//
// Параметры:
//  Планировщик	 - ПолеФормы	 - Элемент планировщика.
//
Процедура ОбработкаОкончанияРедактирования(Планировщик) Экспорт
	
	ИзмененныеБрони = Новый Массив;
	Для Каждого ВыделенныйЭлемент Из Планировщик.ВыделенныеЭлементы Цикл
		
		Бронь = ВыделенныйЭлемент.Значение;
		Бронь.Помещение = ВыделенныйЭлемент.ЗначенияИзмерений["Помещение"];
		Бронь.ДатаНачала = ВыделенныйЭлемент.Начало;
		Бронь.ДатаОкончания = ВыделенныйЭлемент.Конец;
		
		ИзмененныеБрони.Добавить(Бронь);
		
	КонецЦикла;
	
	РезультатыБроней = БронированиеПомещенийВызовСервера.ИзменитьБрони(ИзмененныеБрони);
	
	КоличествоБроней = РезультатыБроней.Количество();
	Если КоличествоБроней = 1 Тогда
		ТекстОповещения = НСтр("ru = 'Изменена бронь'");
		Бронь = РезультатыБроней[0].Бронь;
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Бронь);
		Пояснение = Строка(Бронь);
	Иначе
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменены брони (%1)'"),
			КоличествоБроней);
		НавигационнаяСсылка = Неопределено;
		Пояснение = Неопределено;
	КонецЕсли;
	ПоказатьОповещениеПользователя(
		ТекстОповещения,
		НавигационнаяСсылка,
		Пояснение,
		БиблиотекаКартинок.Информация32);
	
	Оповестить("Запись_Бронь");
	
КонецПроцедуры

// Обрабатывает создание элемента планировщика.
//
// Параметры:
//  Планировщик			 - ПолеФормы - Планировщик.
//  Начало				 - Дата		 - Дата начала нового элемента.
//  Конец				 - Дата		 - Дата окончания нового элемента.
//  Значения			 - Массив	 - Значения измерений нового элемента.
//  Текст				 - Строка	 - Текст нового элемента.
//  СтандартнаяОбработка - Булево	 - Стандартная обработка.
//
Процедура ОбработкаПередСозданием(Планировщик, Начало, Конец, Значения, Текст, СтандартнаяОбработка, Вместимость) Экспорт
	
	СтандартнаяОбработка = Ложь;
	СоздатьБронь(
		Значения.Получить("Помещение"),
		Начало,
		Конец,
		Ложь,
		Текст,
		Вместимость);
	
КонецПроцедуры

// Обрабатывает выбора элемента планировщика.
//
// Параметры:
//  Планировщик			 - ПолеФормы - Планировщик.
//  СтандартнаяОбработка - Булево	 - Стандартная обработка.
//
Процедура ОбработкаВыбораЭлемента(Планировщик, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если Планировщик.ВыделенныеЭлементы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ВыделенныйЭлемент = Планировщик.ВыделенныеЭлементы[0];
	ЗначениеЭлемента = ВыделенныйЭлемент.Значение;
	Если ЗначениеЭлемента.ВидЭлемента =
		ПредопределенноеЗначение("Перечисление.ЭлементыРабочегоКалендаря.Событие") Тогда
		ПоказатьЗначение(, ЗначениеЭлемента.Ссылка);
	ИначеЕсли ЗначениеЭлемента.ВидЭлемента =
		ПредопределенноеЗначение("Перечисление.ЭлементыРабочегоКалендаря.СобытиеПовторяющееся") Тогда
		ОбработкаВыбораПовторяющейсяБрони(ЗначениеЭлемента.Ссылка, ВыделенныйЭлемент.Начало);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает окончание редактирования элемента планировщика.
//
// Параметры:
//  Планировщик			 - ПолеФормы - Планировщик.
//  НовыйЭлемент		 - Булево	 - Признак создания нового элемента.
//  ОтменаРедактирования - Булево	 - Отмена редактирования.
//
Процедура ОбработкаОкончанияРедактированияЭлемента(Планировщик, НовыйЭлемент, ОтменаРедактирования) Экспорт
	
	ОтменаРедактирования = Истина;
	Если НовыйЭлемент Тогда
		Если Планировщик.ВыделенныеЭлементы.Количество() <> 1 Тогда
			ОтменаРедактирования = Истина;
			Возврат;
		КонецЕсли;
		ОбработкаСозданиеЭлемента(Планировщик);
	Иначе
		ОбработкаОкончанияРедактирования(Планировщик);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает начало редактирования элемента планировщика.
//
// Параметры:
//  Планировщик			 - ПолеФормы - Планировщик.
//  НовыйЭлемент		 - Булево	 - Признак создания нового элемента.
//  СтандартнаяОбработка - Булево	 - Стандартная обработка.
//
Процедура ОбработкаПередНачаломРедактированиемЭлемента(Планировщик, НовыйЭлемент, СтандартнаяОбработка) Экспорт
	
	Если НовыйЭлемент Тогда
		СтандартнаяОбработка = Ложь;
		ОбработкаНачалаСозданияЭлемента(Планировщик);
		Возврат;
	КонецЕсли;
	
	ОбработкаВыбораЭлемента(Планировщик, СтандартнаяОбработка);
	
КонецПроцедуры

// Обрабатывает начало создания элемента планировщика.
//
// Параметры:
//  Планировщик	 - ПолеФормы	 - Планировщик.
//
Процедура ОбработкаНачалаСозданияЭлемента(Планировщик) Экспорт
	
	ВыделенныйЭлемент = Планировщик.ВыделенныеЭлементы[0];
	СоздатьБронь(
		ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Помещение"),
		ВыделенныйЭлемент.Начало,
		ВыделенныйЭлемент.Конец,
		Ложь,
		ВыделенныйЭлемент.Текст);
	
КонецПроцедуры

// Обрабатывает удаление элемента планировщика.
//
// Параметры:
//  Планировщик	 - ПолеФормы	 - Планировщик.
//  Отказ		 - Булево		 - Отказ.
//
Процедура ОбработкаПередУдалениемЭлемента(Планировщик, Отказ) Экспорт
	
	Отказ = Истина;
	
	ПометкаУдаления = Ложь;
	События = ПолучитьСобытияВВыделеннойОбласти(Планировщик, ПометкаУдаления, Ложь);
	ПовторяющиесяБрони = ПолучитьПовторяющиесяБрониВВыделеннойОбласти(Планировщик);
	Если События.Количество() = 0 И ПовторяющиесяБрони.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкиУдаления(События, ПовторяющиесяБрони, Не ПометкаУдаления);
	
КонецПроцедуры

// Создает и записывает бронь в базу данных.
//
// Параметры:
//  Помещение		 - СправочникСсылка.ТерриторииИПомещения - Помещение для брони.
//  ДатаНачала		 - Дата									 - Дата начала.
//  ДатаОкончания	 - Дата									 - Дата окончания.
//  Комментарий		 - Строка								 - Текстовый комментарий.
//
Процедура СоздатьИЗаписатьБронь(Помещение, ДатаНачала, ДатаОкончания, Комментарий = "") Экспорт
	
	Бронь = Новый Структура("Помещение, ДатаНачала, ДатаОкончания, Комментарий");
	Бронь.Помещение = Помещение;
	Бронь.ДатаНачала = ДатаНачала;
	Бронь.ДатаОкончания = ДатаОкончания;
	Бронь.Комментарий = Комментарий;
	
	РезультатБрони = БронированиеПомещенийВызовСервера.СоздатьБронь(Бронь);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Забронировано помещение'"),
		ПолучитьНавигационнуюСсылку(РезультатБрони.Бронь),
		Строка(РезультатБрони.Бронь),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("Создание_Бронь");
	Оповестить("Запись_Бронь");
	
КонецПроцедуры

// Открывает форму выбора времени брони.
//
// Параметры:
//  Бронь					 - ДанныеФормы - Данные брони.
//  БроньИсключение			 - ДокументСсылка.Бронь	 - Бронь, которая не будет учитываться при проверке.
//  ДатаИсключения			 - Дата	 - Дата брони, которая не будет учитываться при проверке.
//  ОписаниеОповещения		 - ОписаниеОповещения	 - Описание оповещения, выполняемое после выбора.
//  ВесьДень				 - Булево - Признак того что следует выбирать время за весь день.
//  ОтображатьПредупреждение - Булево - Признак того что следует отображать предупреждение.
//
Процедура ВыбратьВремяБрони(Бронь, БроньИсключение = Неопределено,
	ДатаИсключения = Неопределено, ОписаниеОповещения = Неопределено,
	ВесьДень = Истина, ОтображатьПредупреждение = Ложь) Экспорт
	
	ПараметрыФормы =
		Новый Структура("Бронь, БроньИсключение, ДатаИсключения, ВесьДень, ОтображатьПредупреждение");
	ПараметрыФормы.Бронь = Бронь;
	ПараметрыФормы.БроньИсключение = БроньИсключение;
	ПараметрыФормы.ДатаИсключения = ДатаИсключения;
	ПараметрыФормы.ВесьДень = ВесьДень;
	ПараметрыФормы.ОтображатьПредупреждение = ОтображатьПредупреждение;
	
	ОткрытьФорму("Документ.Бронь.Форма.ВыборРекомендованногоВремени", ПараметрыФормы,
		, , , , ОписаниеОповещения);
	
КонецПроцедуры

// Открывает форму создания новой брони.
//
// Параметры:
//  Помещение			 - СправочникСсылка.ТерриторииИПомещения - Помещение для брони.
//  ДатаНачала			 - Дата									 - Дата начала.
//  ДатаОкончания		 - Дата									 - Дата окончания.
//  ВесьДень			 - Булево								 - Признак того что бронь на весь день.
//  Комментарий			 - Строка								 - Текстовый комментарий.
//  КоличествоЧеловек	 - Число								 - Количество человек.
//
Процедура СоздатьБронь(Помещение, ДатаНачала, ДатаОкончания, ВесьДень = Ложь, Комментарий = "", КоличествоЧеловек = 0) Экспорт
	
	СтруктураОснование = Новый Структура("Помещение, ДатаНачала, ДатаОкончания, ВесьДень, Комментарий, КоличествоЧеловек");
	СтруктураОснование.Помещение = Помещение;
	СтруктураОснование.ДатаНачала = ДатаНачала;
	СтруктураОснование.ДатаОкончания = ДатаОкончания;
	СтруктураОснование.ВесьДень = ВесьДень;
	СтруктураОснование.Комментарий = Комментарий;
	СтруктураОснование.КоличествоЧеловек = КоличествоЧеловек;
	
	ПараметрыФормы = Новый Структура("Основание", СтруктураОснование);
	
	ОткрытьФорму("Документ.Бронь.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму выбора времени, а потом создания брони.
//
// Параметры:
//  Помещение		 - СправочникСсылка.ТерриторииИПомещения - Помещение для брони.
//  ДатаНачала		 - Дата									 - Дата начала.
//  ДатаОкончания	 - Дата									 - Дата окончания.
//
Процедура ВыбратьВремяИСоздатьБронь(Помещение, ДатаНачала, ДатаОкончания) Экспорт
	
	Бронь = Новый Структура;
	Бронь.Вставить("Ссылка", ПредопределенноеЗначение("Документ.Бронь.ПустаяСсылка"));
	Бронь.Вставить("Помещение", Помещение);
	Бронь.Вставить("ДатаНачала", ДатаНачала);
	Бронь.Вставить("ДатаОкончания", ДатаОкончания);
	Бронь.Вставить("ТипЗаписи", ПредопределенноеЗначение("Перечисление.ТипЗаписиКалендаря.Событие"));
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Помещение", Помещение);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВремяИСоздатьБроньЗавершение",
		ЭтотОбъект, ПараметрыОбработчика);
	
	ВыбратьВремяБрони(Бронь, , , ОписаниеОповещения, Ложь);
	
КонецПроцедуры

// Обрабатывает изменение признака весь день у брони.
// Если снимают признак - устанавливает длительность час с начала отображаемого времени в дне.
//
// Параметры:
//  Объект							 - ДанныеФормы	 - Бронь.
//  НачальноеЗначениеДатаНачала		 - Дата			 - Начальное значение даты начала.
//  НачальноеЗначениеДатаОкончания	 - Дата			 - Начальное значение даты окончания.
//  ОтображатьВремяС				 - Число		 - Настройка отображения времени в дне.
//
Процедура ПриИзмененииВесьДень(Объект,
	НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания, ОтображатьВремяС) Экспорт
	
	Если Объект.ВесьДень Тогда
		РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
			Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
			НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания, Ложь, Истина);
		Возврат;
	КонецЕсли;
	
	Объект.ДатаНачала = НачалоДня(Объект.ДатаНачала) + ОтображатьВремяС * 3600;
	Объект.ДатаОкончания = Объект.ДатаНачала + 3600;
	
	НачальноеЗначениеДатаНачала = Объект.ДатаНачала;
	НачальноеЗначениеДатаОкончания = Объект.ДатаОкончания;
	
КонецПроцедуры

// Устанавливает пометку отображения подчиненных территорий.
//
// Параметры:
//  ЭлементДерева - ДанныеФормыДерево, ДанныеФормыЭлементДерева - Обрабатываемая территория.
//  Пометка - Булево - Устанавливаемая пометка отображения.
//
Процедура УстановитьПометкуОтображенияПодчиненныхТерриторий(ЭлементДерева, Пометка) Экспорт
	
	ПодчиненныеЭлементыДерева = ЭлементДерева.ПолучитьЭлементы();
	Для Каждого ПодчиненныйЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
		ПодчиненныйЭлементДерева.ОтображатьТерриторию = Пометка;
		УстановитьПометкуОтображенияПодчиненныхТерриторий(ПодчиненныйЭлементДерева, Пометка);
	КонецЦикла;
	
КонецПроцедуры

// Обрабатывает изменение пометки отображения территорий в дереве территорий.
//
// Параметры:
//  ЭлементТерритории - ДанныеФормыДерево - Элемент территории.
//  Территории - ДанныеФормыКоллекция - Реквизит территории.
//  ЭлементДерева - ДанныеФормыДерево, ДанныеФормыЭлементДерева - Текущий элемент дерева.
//  Пометка - Булево - Устанавливаемая пометка отображения.
//
Процедура ПриИзмененииПометкиОтображенияТерриторий(ЭлементТерритории, Территории, ЭлементДерева, Пометка) Экспорт
	
	УстановитьПометкуОтображенияПодчиненныхТерриторий(ЭлементДерева, Пометка);
	
	Если Пометка Тогда
		
		// Установили пометку - следует установить пометку всем территориям верхнего уровня.
		ЭлементРодителя = ЭлементДерева.ПолучитьРодителя();
		Пока ЭлементРодителя <> Неопределено Цикл
			
			// Если пометка уже установлена то обработка не требуется.
			Если ЭлементРодителя.ОтображатьТерриторию Тогда
				Прервать;
			КонецЕсли;
			
			ЭлементРодителя.ОтображатьТерриторию = Истина;
			ЭлементРодителя = ЭлементРодителя.ПолучитьРодителя();
			
		КонецЦикла;
		
	Иначе
		
		// Сняли пометку - следует снять пометку всем родителям,
		// у которых не осталось помеченных территорий подчиненных.
		ЭлементРодителя = ЭлементДерева.ПолучитьРодителя();
		Пока ЭлементРодителя <> Неопределено Цикл
			
			// Если пометка уже снята то обработка не требуется.
			Если Не ЭлементРодителя.ОтображатьТерриторию Тогда
				Прервать;
			КонецЕсли;
			
			// Если среди подчиненных есть установленная пометка то обработка не требуется.
			ПометкаПодчиненных = Ложь;
			ПодчиненныеЭлементы = ЭлементРодителя.ПолучитьЭлементы();
			Для Каждого ПодчиненныйЭлемент Из ПодчиненныеЭлементы Цикл
				Если ПодчиненныйЭлемент.ОтображатьТерриторию Тогда
					ПометкаПодчиненных = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ПометкаПодчиненных Тогда
				Прервать;
			КонецЕсли;
			
			ЭлементРодителя.ОтображатьТерриторию = Ложь;
			ЭлементРодителя = ЭлементРодителя.ПолучитьРодителя();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обрабатывает создание элементов планировщика.
//
// Параметры:
//  Планировщик	 - ПолеФормы - Планировщик.
//
Процедура ОбработкаСозданиеЭлемента(Планировщик)
	
	ВыделенныйЭлемент = Планировщик.ВыделенныеЭлементы[0];
	Помещение = ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Помещение");
	Если Помещение = Неопределено Тогда
		ОбработкаНачалаСозданияЭлемента(Планировщик);
		Возврат;
	КонецЕсли;
	
	СоздатьИЗаписатьБронь(
		Помещение,
		ВыделенныйЭлемент.Начало,
		ВыделенныйЭлемент.Конец,
		ВыделенныйЭлемент.Текст);
	
КонецПроцедуры

// Завершение выбора времени при создании брони.
//
Процедура ВыбратьВремяИСоздатьБроньЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Помещение", ДополнительныеПараметры.Помещение);
	ЗначенияЗаполнения.Вставить("ДатаНачала", Результат.ДатаНачала);
	ЗначенияЗаполнения.Вставить("ДатаОкончания", Результат.ДатаОкончания);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.Бронь.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Завершение установки пометки удаления после вопроса.
//
Процедура УстановитьПометкуУдаленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УстановленаПометкаУдаления = БронированиеПомещенийВызовСервера.УстановитьПометкуУдаления(
		ДополнительныеПараметры.Бронь,
		ДополнительныеПараметры.ПометкаУдаления);
	
	Если УстановленаПометкаУдаления Тогда
		
		Если ДополнительныеПараметры.ПометкаУдаления Тогда
			ТекстОповещения = НСтр("ru = 'Пометка удаления установлена'");
		Иначе
			ТекстОповещения = НСтр("ru = 'Пометка удаления снята'");
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			ТекстОповещения,
			ПолучитьНавигационнуюСсылку(ДополнительныеПараметры.Бронь),
			Строка(ДополнительныеПараметры.Бронь),
			БиблиотекаКартинок.Информация32);
		Оповестить("Запись_Бронь", ДополнительныеПараметры.Бронь);
		ОповеститьОбИзменении(ДополнительныеПараметры.Бронь);
		
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает выбор исключения повторения.
//
Процедура ОбработкаВыбораПовторяющейсяБрони(Бронь, ДатаИсключения)
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Бронь", Бронь);
	ПараметрыОбработчика.Вставить("ДатаИсключения", ДатаИсключения);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораПовторяющегосяСобытияЗавершение",
		ЭтотОбъект, ПараметрыОбработчика);
	
	ТекстВопроса = НСтр("ru = 'Это повторяющаяся бронь.'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("ИзменитьОдно", НСтр("ru = 'Изменить одно событие'"));
	Кнопки.Добавить("ИзменитьВсе", НСтр("ru = 'Изменить все'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , "ИзменитьОдно");
	
КонецПроцедуры

// Обрабатывает выбор исключения повторения.
//
Процедура ОбработкаВыбораПовторяющегосяСобытияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "ИзменитьОдно" Тогда 
		СоздатьИсключениеПовторения(
			ДополнительныеПараметры.Бронь,
			ДополнительныеПараметры.ДатаИсключения);
	ИначеЕсли Результат = "ИзменитьВсе" Тогда 
		ПоказатьЗначение(, ДополнительныеПараметры.Бронь);
	КонецЕсли;
	
КонецПроцедуры

// Создает элемент повторяющейся брони на конкретную дату.
//
Процедура СоздатьИсключениеПовторения(Бронь, ДатаИсключения)
	
	СтруктураОснование = Новый Структура("ПовторяющаясяБронь, ДатаИсключения");
	СтруктураОснование.ПовторяющаясяБронь = Бронь;
	СтруктураОснование.ДатаИсключения = ДатаИсключения;
	
	ПараметрыФормы = Новый Структура("Основание, ПовторяющаясяБронь, ДатаИсключения");
	ПараметрыФормы.Основание = СтруктураОснование;
	ПараметрыФормы.ПовторяющаясяБронь = Бронь;
	ПараметрыФормы.ДатаИсключения = ДатаИсключения;
	
	ОткрытьФорму("Документ.Бронь.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Возвращает массив записей календаря, содержащихся в выделенной области.
//
Функция ПолучитьСобытияВВыделеннойОбласти(Планировщик, ПометкаУдаления = Ложь, ВключаяПовторяющиеся = Истина) Экспорт
	
	События = Новый Массив;
	
	Для Каждого ВыделенныйЭлемент Из Планировщик.ВыделенныеЭлементы Цикл
		
		ЗначениеЭлемента = ВыделенныйЭлемент.Значение;
		
		Если Не ВключаяПовторяющиеся
			И ЗначениеЭлемента.ВидЭлемента =
				ПредопределенноеЗначение("Перечисление.ЭлементыРабочегоКалендаря.СобытиеПовторяющееся") Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавитьЗначениеВМассив(ЗначениеЭлемента.Ссылка, События);
		ПометкаУдаления = ПометкаУдаления Или ЗначениеЭлемента.ПометкаУдаления;
		
	КонецЦикла;
	
	Возврат События;
	
КонецФункции

// Возвращает массив повторяющихся событий, содержащихся в выделенной области.
//
Функция ПолучитьПовторяющиесяБрониВВыделеннойОбласти(Планировщик) Экспорт
	
	ПовторяющиесяБрони = Новый Массив;
	
	Для Каждого ВыделенныйЭлемент Из Планировщик.ВыделенныеЭлементы Цикл
		
		ЗначениеЭлемента = ВыделенныйЭлемент.Значение;
		
		Если ЗначениеЭлемента.ВидЭлемента <>
			ПредопределенноеЗначение("Перечисление.ЭлементыРабочегоКалендаря.СобытиеПовторяющееся") Тогда
			Продолжить;
		КонецЕсли;
		
		ПовторяющаясяБронь = Новый Структура("Бронь, ДатаИсключения");
		ПовторяющаясяБронь.Бронь = ЗначениеЭлемента.Ссылка;
		ПовторяющаясяБронь.ДатаИсключения = ВыделенныйЭлемент.Начало;
		
		ДобавитьЗначениеВМассив(ПовторяющаясяБронь, ПовторяющиесяБрони);
		
	КонецЦикла;
	
	Возврат ПовторяющиесяБрони;
	
КонецФункции

// Устанавливает пометки удаления броней и оповещает другие формы.
//
Процедура УстановитьПометкиУдаления(Брони, ПовторяющиесяБрони,
	ПометкаУдаления, ОбработанныеВопросы = Неопределено) Экспорт
	
	Если ТипЗнч(Брони) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбработанныеВопросы = Неопределено Тогда
		ОбработанныеВопросы = Новый Структура;
	КонецЕсли;
	
	Если Не ОбработанныеВопросы.Свойство("ИзмененаПометкаУдаления") Тогда
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Брони", Брони);
		ПараметрыОбработчика.Вставить("ПовторяющиесяБрони", ПовторяющиесяБрони);
		ПараметрыОбработчика.Вставить("ПометкаУдаления", ПометкаУдаления);
		ПараметрыОбработчика.Вставить("ОбработанныеВопросы", ОбработанныеВопросы);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"УстановитьПометкиУдаленияПослеВопросаОбИзмененииПометкиУдаления",
			ЭтотОбъект,
			ПараметрыОбработчика);
		
		Если ПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru = 'Пометить выделенные элементы на удаление?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Снять с выделенных элементов пометку на удаление?'");
		КонецЕсли;
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,
			, КодВозвратаДиалога.Нет);
		Возврат;
		
	КонецЕсли;
	
	УстановленаПометкаУдаления = БронированиеПомещенийВызовСервера.УстановитьПометкиУдаления(
		Брони, ПовторяющиесяБрони, ПометкаУдаления);
	
	Если УстановленаПометкаУдаления Тогда
		
		КоличествоБроней = Брони.Количество();
		КоличествоПовторяющихсяБроней = ПовторяющиесяБрони.Количество();
		КоличествоОбъектов = КоличествоБроней + КоличествоПовторяющихсяБроней;
		Если КоличествоОбъектов = 1 Тогда
			Если ПометкаУдаления Тогда
				ТекстОповещения = НСтр("ru = 'Пометка удаления установлена'");
			Иначе
				ТекстОповещения = НСтр("ru = 'Пометка удаления снята'");
			КонецЕсли;
			Если КоличествоБроней = 1 Тогда
				Бронь = Брони[0];
			ИначеЕсли КоличествоПовторяющихсяБроней = 1 Тогда
				Бронь = ПовторяющиесяБрони[0];
			КонецЕсли;
			НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Бронь);
			Пояснение = Строка(Бронь);
		Иначе
			Если ПометкаУдаления Тогда
				ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Пометки удаления установлены (%1)'"),
					КоличествоОбъектов);
			Иначе
				ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Пометки удаления сняты (%1)'"),
					КоличествоОбъектов);
			КонецЕсли;
			НавигационнаяСсылка = Неопределено;
			Пояснение = Неопределено;
		КонецЕсли;
		ПоказатьОповещениеПользователя(
			ТекстОповещения,
			НавигационнаяСсылка,
			Пояснение,
			БиблиотекаКартинок.Информация32);
		
		Оповестить("Запись_Бронь");
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает пометки удаления записей и оповещает другие формы.
//
Процедура УстановитьПометкиУдаленияПослеВопросаОбИзмененииПометкиУдаления(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.ОбработанныеВопросы.Вставить("ИзмененаПометкаУдаления", Истина);
	УстановитьПометкиУдаления(
		ДополнительныеПараметры.Брони,
		ДополнительныеПараметры.ПовторяющиесяБрони,
		ДополнительныеПараметры.ПометкаУдаления,
		ДополнительныеПараметры.ОбработанныеВопросы);
	
КонецПроцедуры

#КонецОбласти