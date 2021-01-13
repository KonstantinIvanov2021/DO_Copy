
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Проверка востребованности механизма
	ЗаписьЖурналаРегистрации(НСтр("ru='Проверка орфографии'", Метаданные.ОсновнойЯзык.КодЯзыка), 
		УровеньЖурналаРегистрации.Примечание, ПараметрыСеанса.ТекущийПользователь);
	
	ИсходнаяСтрока = Параметры.ИсходнаяСтрока;
	СловоЗамены = Параметры.СловоЗамены;
	СписокВариантов = Параметры.СписокВариантов.Скопировать();
	
	Если Параметры.Свойство("НеСовпадаетЧислоВхожденийВТекстеИHtml") Тогда
		НеСовпадаетЧислоВхожденийВТекстеИHtml = Параметры.НеСовпадаетЧислоВхожденийВТекстеИHtml;
	КонецЕсли;	
	
	Если НеСовпадаетЧислоВхожденийВТекстеИHtml Тогда
		Элементы.ЗаменитьСлово.Доступность = Ложь;
		Элементы.ЗаменитьВсе.Доступность = Ложь;
		Элементы.СловоЗамены.ТолькоПросмотр = Истина;
	КонецЕсли;	
	
	Элементы.ГруппаИнформация.Видимость = НеСовпадаетЧислоВхожденийВТекстеИHtml;
	
	СловоИзменено = Ложь;
	Завершить = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МОДУЛЯ

&НаКлиенте
// Процедура производит замену слова на правильное.
//
Процедура Заменить(СпособЗамены, Кнопка)
	
	Если СпособЗамены = 1 Тогда // замена по кнопке
		Если СловоИзменено или СписокВариантов.Количество() = 0 Тогда
		    СловоЗамены = СокрЛП(СловоЗамены);
		Иначе
			Попытка
				СловоЗамены = Элементы.СписокВариантов.ТекущиеДанные.Значение;
			Исключение
				СловоЗамены = СокрЛП(СловоЗамены);
			КонецПопытки;
			
		КонецЕсли;
		
	Иначе
		Попытка
			СловоЗамены = Элементы.СписокВариантов.ТекущиеДанные.Значение;
		Исключение
			СловоЗамены = СокрЛП(СловоЗамены);
		КонецПопытки;
		
	КонецЕсли;
	
	Завершить = Ложь;
	Если Открыта() Тогда
		СтруктураВозврата = Новый Структура("СловоЗамены, Кнопка", СловоЗамены, Кнопка);
		Закрыть(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры // Заменить()

&НаКлиенте
Процедура Пропустить(Команда)
		
	СтруктураВозврата = Новый Структура("СловоЗамены, Кнопка", СловоЗамены, "Пропустить");
	Закрыть(СтруктураВозврата);

КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьСлово(Команда)
		
	Заменить(1, "Заменить");

КонецПроцедуры

&НаКлиенте
Процедура СписокВариантовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НеСовпадаетЧислоВхожденийВТекстеИHtml Тогда
		Возврат;
	КонецЕсли;	
	
	Заменить(0, "Заменить");
	
КонецПроцедуры

&НаКлиенте
Процедура ПропуститьВсе(Команда)
	
	СтруктураВозврата = Новый Структура("СловоЗамены, Кнопка", СловоЗамены, "ПропуститьВсе");
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекущийЭлемент = Элементы.Пропустить;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИсключение(Команда)
	
	СтруктураВозврата = Новый Структура("СловоЗамены, Кнопка", СловоЗамены, "ДобавитьИсключение");
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьВсе(Команда)
	
	Заменить(1, "ЗаменитьВсе");
	
КонецПроцедуры
