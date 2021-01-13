#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("ДляБронирования") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	// Стандартные данные выбора.
	Параметры.Отбор.Удалить("ДляБронирования");
	Параметры.Отбор.Вставить("ДоступноБронирование", Истина);
	СтандартныеДанныеВыбора = Справочники.ТерриторииИПомещения.ПолучитьДанныеВыбора(Параметры);
	
	// Разбор строки поиска по словам.
	СловаПоиска = СтрРазделить(Параметры.СтрокаПоиска, " ", Ложь);
	КоличествоЭлементов = СловаПоиска.Количество();
	Для Инд = 1 По КоличествоЭлементов Цикл
		
		ПроверяемоеСловоПоиска = СловаПоиска[КоличествоЭлементов - Инд];
		
		ЯвляетсяПодстрокойДругогоСлова = Ложь;
		Инд2 = 0;
		Для Каждого СловоПоиска Из СловаПоиска Цикл
			Если Инд2 = (КоличествоЭлементов - Инд) Тогда
				Инд2 = Инд2 + 1;
				Продолжить;
			КонецЕсли;
			Если СтрНайти(СловоПоиска, ПроверяемоеСловоПоиска) <> 0 Тогда
				ЯвляетсяПодстрокойДругогоСлова = Истина;
				Прервать;
			КонецЕсли;
			Инд2 = Инд2 + 1;
		КонецЦикла;
		
		Если ЯвляетсяПодстрокойДругогоСлова Тогда
			СловаПоиска.Удалить(КоличествоЭлементов - Инд);
		КонецЕсли;
		
	КонецЦикла;
	
	// Получаем данные выбранных территорий и помещений.
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТерриторииИПомещения.Ссылка КАК Ссылка,
		|	ТерриторииИПомещения.Наименование КАК Наименование,
		|	ТерриторииИПомещения.Вместимость КАК Вместимость,
		|	ПРЕДСТАВЛЕНИЕ(ТерриторииИПомещения.Родитель) КАК РодительПредставление
		|ИЗ
		|	Справочник.ТерриторииИПомещения КАК ТерриторииИПомещения
		|ГДЕ
		|	ТерриторииИПомещения.Ссылка В(&ВыбранныеТерриторииИПомещения)";
	Запрос.УстановитьПараметр("ВыбранныеТерриторииИПомещения", СтандартныеДанныеВыбора.ВыгрузитьЗначения());
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Формируем данные выбора.
	Пока Выборка.Следующий() Цикл
		ПредставлениеПомещения = БронированиеПомещений.ФорматированноеПредставлениеПомещения(
			Выборка.Наименование, Выборка.Вместимость, Выборка.РодительПредставление, СловаПоиска);
		ДанныеВыбора.Добавить(Выборка.Ссылка, ПредставлениеПомещения);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Определяет ответственного за техническое обеспечение.
//
// Параметры:
//  Помещение - СправочникСсылка.ТерриторииИПомещения - Помещение.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи - Ответственный за техническое обеспечение.
//
Функция ОтветственныйТехническоеОбеспечение(Помещение) Экспорт
	
	ОтветственныйТехническоеОбеспечение = Справочники.Пользователи.ПустаяСсылка();
	
	ТекущееПомещение = Помещение;
	Пока Не ЗначениеЗаполнено(ОтветственныйТехническоеОбеспечение) И ЗначениеЗаполнено(ТекущееПомещение) Цикл
		РеквизитыПомещения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ТекущееПомещение,
			"Родитель, ОтветственныйТехническоеОбеспечение");
		ОтветственныйТехническоеОбеспечение = РеквизитыПомещения.ОтветственныйТехническоеОбеспечение;
		ТекущееПомещение = РеквизитыПомещения.Родитель;
	КонецЦикла;
	
	Возврат ОтветственныйТехническоеОбеспечение;
	
КонецФункции

// Определяет ответственного за техническое обеспечение.
//
// Параметры:
//  Помещение - СправочникСсылка.ТерриторииИПомещения - Помещение.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи - Ответственный за техническое обеспечение.
//
Функция ОтветственныйХозяйственноеОбеспечение(Помещение) Экспорт
	
	ОтветственныйХозяйственноеОбеспечение = Справочники.Пользователи.ПустаяСсылка();
	
	ТекущееПомещение = Помещение;
	Пока Не ЗначениеЗаполнено(ОтветственныйХозяйственноеОбеспечение) И ЗначениеЗаполнено(ТекущееПомещение) Цикл
		РеквизитыПомещения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ТекущееПомещение,
			"Родитель, ОтветственныйХозяйственноеОбеспечение");
		ОтветственныйХозяйственноеОбеспечение = РеквизитыПомещения.ОтветственныйХозяйственноеОбеспечение;
		ТекущееПомещение = РеквизитыПомещения.Родитель;
	КонецЦикла;
	
	Возврат ОтветственныйХозяйственноеОбеспечение;
	
КонецФункции

#КонецОбласти

#КонецЕсли