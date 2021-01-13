// Устанавливает значение указанного ресурса регистра для переданного объекта.
//
Процедура УстановитьПризнак(Файл, Признак, Значение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.СведенияОФайлах.СоздатьМенеджерЗаписи();
	Запись.Файл = Файл;
	Если Запись.Файл = Неопределено Тогда // Данный тип объекта не обрабатывается
		Возврат;
	КонецЕсли;
	
	Запись.Прочитать();
	
	Если Запись[Признак] <> Значение Тогда
		Запись.Файл = Файл;
		Запись[Признак] = Значение;
		Запись.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

// Получает значение указанного ресурса регистра для переданного объекта.
//
Функция ПолучитьПризнак(Файл, Признак) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.СведенияОФайлах.СоздатьМенеджерЗаписи();
	Запись.Файл = Файл;
	Если Запись.Файл = Неопределено Тогда // Данный тип объекта не обрабатывается
		Возврат Неопределено;
	КонецЕсли;
	
	Запись.Прочитать();
	
	Возврат Запись[Признак];
	
КонецФункции
