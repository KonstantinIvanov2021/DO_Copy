
// Обновляет данные в регистре для данного шаблона
Процедура ОбновитьЧислоВидовДокументов(ШаблонПроцесса) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НастройкаШаблоновБизнесПроцессов.ВидДокумента), 0) КАК ЧислоВидовДокументов
		|ИЗ
		|	РегистрСведений.НастройкаШаблоновБизнесПроцессов КАК НастройкаШаблоновБизнесПроцессов
		|ГДЕ
		|	НастройкаШаблоновБизнесПроцессов.ШаблонБизнесПроцесса = &ШаблонБизнесПроцесса";
		
	Запрос.УстановитьПараметр("ШаблонБизнесПроцесса", ШаблонПроцесса);	
		
	Выборка = Запрос.Выполнить().Выбрать();	
	Выборка.Следующий();
		
	ЗаписатьЧислоВидовДокументов(ШаблонПроцесса, Выборка.ЧислоВидовДокументов);
	
КонецПроцедуры	

// Записывает данные (число видов документов) в регистр для данного шаблона
Процедура ЗаписатьЧислоВидовДокументов(ШаблонПроцесса, ЧислоВидовДокументов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ИспользованиеШаблоновПроцессовВВидахДокументов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ШаблонПроцесса = ШаблонПроцесса;
	МенеджерЗаписи.ЧислоВидовДокументов = ЧислоВидовДокументов;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры	