// Записывает статьи ДДС указанного документа в привилегированном режиме.
//
// Параметры:
//   Документ - СправочникСсылка.ВнутреннийДокумент - документ, статьи которого записываются.
//   СтатьиДвиженияДенежныхСредств - ДанныеФормыКоллекция или ТаблицаЗначений - записываемые статьи.
//
Процедура ЗаписатьСтатьиДокумента(Документ, СтатьиДвиженияДенежныхСредств) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.СтатьиДвиженияДенежныхСредствДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	
	Для каждого СтрокаСтатьи Из СтатьиДвиженияДенежныхСредств Цикл
		Запись = НаборЗаписей.Добавить();
		Запись.Документ = Документ;
		Запись.СтатьяДвиженияДенежныхСредств = СтрокаСтатьи.СтатьяДвиженияДенежныхСредств;
		Запись.Сумма = СтрокаСтатьи.Сумма;
		Запись.СуммаНДС = СтрокаСтатьи.СуммаНДС;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Читает статьи ДДС указанного документа в привилегированном режиме.
//
// Параметры:
//   Документ - СправочникСсылка.ВнутреннийДокумент - документ, статьи которого записываются.
//   СтатьиДвиженияДенежныхСредств - ДанныеФормыКоллекция или ТаблицаЗначений - неявно возвращаемый параметр.
//
Процедура ПрочитатьСтатьиДокумента(Документ, СтатьиДвиженияДенежныхСредств) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.СтатьиДвиженияДенежныхСредствДокументов.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Прочитать();
	
	СтатьиДвиженияДенежныхСредств.Очистить();
	Для каждого Запись Из НаборЗаписей Цикл
		СтрокаСтатьи = СтатьиДвиженияДенежныхСредств.Добавить();
		СтрокаСтатьи.СтатьяДвиженияДенежныхСредств = Запись.СтатьяДвиженияДенежныхСредств;
		СтрокаСтатьи.Сумма = Запись.Сумма;
		СтрокаСтатьи.СуммаНДС = Запись.СуммаНДС;
	КонецЦикла;
	
КонецПроцедуры