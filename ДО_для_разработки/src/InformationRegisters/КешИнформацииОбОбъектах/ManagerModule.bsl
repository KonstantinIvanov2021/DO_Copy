// Устанавливает значение указанного ресурса регистра для переданного объекта.
//
Процедура УстановитьПризнак(Объект, Признак, Значение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.КешИнформацииОбОбъектах.СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Если Запись.Объект = Неопределено Тогда // Данный тип объекта не обрабатывается
		Возврат;
	КонецЕсли;
	
	Запись.Прочитать();
	
	Если Запись[Признак] <> Значение Тогда
		Запись.Объект = Объект;
		Запись[Признак] = Значение;
		Запись.Записать(Истина);
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект) Тогда 
		Если Признак = "СрокИсполнения" Тогда Ресурс = "СрокКонтроля";
		ИначеЕсли Признак = "СрокИсполненияОбщий" Тогда Ресурс = "СрокКонтроляОбщий";
		Иначе Ресурс = Признак;	КонецЕсли;	
		
		Делопроизводство.ЗаписатьДанныеДокумента(Объект, Ресурс, Значение);
	КонецЕсли;	
	
КонецПроцедуры

// Получает значение указанного ресурса регистра для переданного объекта.
//
Функция ПолучитьПризнак(Объект, Признак) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.КешИнформацииОбОбъектах.СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Если Запись.Объект = Неопределено Тогда // Данный тип объекта не обрабатывается
		Возврат Неопределено;
	КонецЕсли;
	
	Запись.Прочитать();
	
	Возврат Запись[Признак];
	
КонецФункции
