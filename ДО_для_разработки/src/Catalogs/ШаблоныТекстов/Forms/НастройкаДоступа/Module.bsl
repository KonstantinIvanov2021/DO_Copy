
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Пользователи") Тогда
	
		Для Каждого Пользователь Из Параметры.Пользователи Цикл
			Строка = Пользователи.Добавить();
			Строка.ПользовательИлиГруппа = Пользователь;
		КонецЦикла;	
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	
	ПользователиВозврат = Новый Массив;
	Для Каждого Строка Из Пользователи Цикл
		ПользователиВозврат.Добавить(Строка.ПользовательИлиГруппа);
	КонецЦикла;	
	
	Закрыть(ПользователиВозврат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользователиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ПользовательИлиГруппа = 
			ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательИлиГруппаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьПользователей(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ВыбратьПользователей(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователей(МножественныйВыбор)
	
	РабочаяГруппа = Новый Массив;
	
	Если МножественныйВыбор Тогда
		Для Каждого ТаблицаСтрока Из Пользователи Цикл
			Участник = Новый Структура("Контакт", ТаблицаСтрока.ПользовательИлиГруппа);
			РабочаяГруппа.Добавить(Участник);
		КонецЦикла;
		
		РежимРаботыФормы = 2;
		ЗаголовокФормы = НСтр("ru = 'Подбор пользователей общего шаблона текста'");
		ЗаголовокСпискаВыбранных = НСтр("ru = 'Выбранные пользователи/группы:'");
		ЗаголовокСпискаАдреснойКниги = НСтр("ru = 'Все пользователи/группы:'");
	Иначе
		РежимРаботыФормы = 1;
		ЗаголовокФормы = НСтр("ru = 'Выбор участника группы доступа'");
		ЗаголовокСпискаВыбранных = "";
		ЗаголовокСпискаАдреснойКниги = "";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", ЗаголовокСпискаВыбранных);
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", ЗаголовокСпискаАдреснойКниги);
	ПараметрыФормы.Вставить("РежимРаботыФормы", РежимРаботыФормы);
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", РабочаяГруппа);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершениеПодбораПользователей", ЭтотОбъект, МножественныйВыбор);
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеПодбораПользователей(ВыбранныеПользователи, МножественныйВыбор) Экспорт
	
	Если ВыбранныеПользователи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если МножественныйВыбор Тогда
		Пользователи.Очистить();
		Для Каждого ГруппаСтрока Из ВыбранныеПользователи Цикл
			Строка = Пользователи.Добавить();
			Строка.ПользовательИлиГруппа = ГруппаСтрока.Контакт;
		КонецЦикла;
	Иначе
		ТекущаяСтрока = Элементы.Пользователи.ТекущаяСтрока;
		Если ТекущаяСтрока <> Неопределено Тогда
			ТекущиеДанные = Пользователи.НайтиПоИдентификатору(ТекущаяСтрока);
			ТекущиеДанные.ПользовательИлиГруппа = ВыбранныеПользователи[0].Контакт;
		КонецЕсли;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательИлиГруппаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ТекущийДанные = Элементы.Пользователи.ТекущиеДанные;
		ТекущийДанные.ПользовательИлиГруппа = ВыбранноеЗначение.РольИсполнителя;
		Модифицированность = Истина;
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") 
		Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.РабочиеГруппы") Тогда
		ТекущийДанные = Элементы.Пользователи.ТекущиеДанные;
		ТекущийДанные.ПользовательИлиГруппа = ВыбранноеЗначение;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательИлиГруппаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь; 
		ДанныеВыбора = ПодобратьПользователя(Текст);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПодобратьПользователя(Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Пользователи.Ссылка КАК Ссылка,
		|	СведенияОПользователяхДокументооборот.Подразделение КАК Подразделение
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
		|		ПО Пользователи.Ссылка = СведенияОПользователяхДокументооборот.Пользователь
		|ГДЕ
		|	Пользователи.Наименование ПОДОБНО &Текст
		|	И Пользователи.ПометкаУдаления = ЛОЖЬ
		|	И Пользователи.Недействителен = ЛОЖЬ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РабочиеГруппы.Ссылка,
		|	&Группа
		|ИЗ
		|	Справочник.РабочиеГруппы КАК РабочиеГруппы
		|ГДЕ
		|	РабочиеГруппы.Наименование ПОДОБНО &Текст
		|	И Не РабочиеГруппы.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка,
		|	&Подразделение
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Наименование ПОДОБНО &Текст
		|	И Не СтруктураПредприятия.ПометкаУдаления
		|");
		
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("Группа", НСтр("ru = 'группа'"));
	Запрос.УстановитьПараметр("Подразделение", НСтр("ru = 'подразделение'"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Подразделение) Тогда 
			ДанныеВыбора.Добавить(Выборка.Ссылка, Строка(Выборка.Ссылка) + " (" + Строка(Выборка.Подразделение) + ")");
		Иначе
			ДанныеВыбора.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции	

#КонецОбласти
