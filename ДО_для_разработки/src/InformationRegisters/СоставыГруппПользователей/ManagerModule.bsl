#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет все данные регистра.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ЕстьИзменения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.Пользователи");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.РабочиеГруппы");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВнешниеПользователи");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ГруппыВнешнихПользователей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СоставыГруппПользователей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		// Обновление связей пользователей.
		УчастникиИзменений = Новый Соответствие;
		ИзмененныеГруппы   = Новый Соответствие;
		
		Выборка = Справочники.РабочиеГруппы.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПользователиСлужебный.ОбновитьСоставыГруппПользователей(
				Выборка.Ссылка, , УчастникиИзменений, ИзмененныеГруппы);
		КонецЦикла;
		
		// Обновление связей внешних пользователей.
		Выборка = Справочники.ГруппыВнешнихПользователей.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
				Выборка.Ссылка, , УчастникиИзменений, ИзмененныеГруппы);
		КонецЦикла;
		
		Если УчастникиИзменений.Количество() > 0
		 ИЛИ ИзмененныеГруппы.Количество() > 0 Тогда
		
			ЕстьИзменения = Истина;
			
			ПользователиСлужебный.ПослеОбновленияСоставовГруппПользователей(
				УчастникиИзменений, ИзмененныеГруппы);
		КонецЕсли;
		
		ПользователиСлужебный.ОбновитьРолиВнешнихПользователей();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли