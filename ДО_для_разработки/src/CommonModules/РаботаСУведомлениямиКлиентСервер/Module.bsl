////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с уведомлениями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет количество частей исходя из размера уведомления и использования транслитерации.
//
// Параметры:
//  РазмерУведомления - Число - Размер уведомления.
//  ИспользоватьТранслитерацию - Булево - Использовать транслитерацию.
// 
// Возвращаемое значение:
//  Число - Колчество частей.
//
Функция КоличествоЧастейSMS(РазмерУведомления, ИспользоватьТранслитерацию) Экспорт
	
	КоличествоЧастей = 1;
	Если ИспользоватьТранслитерацию Тогда
		РазмерОднойЧасти = 160;
		РазмерЧасти = 153;
	Иначе
		РазмерОднойЧасти = 70;
		РазмерЧасти = 67;
	КонецЕсли;
	
	Если РазмерУведомления <= РазмерОднойЧасти Тогда
		КоличествоЧастей = 1;
	Иначе
		КоличествоЧастей = Цел(РазмерУведомления / РазмерЧасти);
		Если РазмерУведомления > КоличествоЧастей * РазмерЧасти Тогда
			КоличествоЧастей = КоличествоЧастей + 1;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КоличествоЧастей;
	
КонецФункции

// Нормализует номер телефона.
//
// Параметры:
//  НомерТелефона - Строка - Номер телефона.
//
// Возвращаемое значение:
//  Строка - Нормализованный номер телефона.
//
Функция НормализоватьНомерТелефона(Знач НомерТелефона) Экспорт
	
	НомерТелефона = СтрЗаменить(НомерТелефона, " ", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, "(", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, ")", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, "+", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, "-", "");
	
	ПерваяЦифраНомера = Сред(НомерТелефона, 1, 1);
	Если ПерваяЦифраНомера = "8" Тогда
		НомерТелефона = "+7" + Сред(НомерТелефона, 2);
	ИначеЕсли ПерваяЦифраНомера = "7" Тогда
		НомерТелефона = "+" + НомерТелефона;
	Иначе
		НомерТелефона = "+7" + НомерТелефона;
	КонецЕсли;
	
	Возврат НомерТелефона;
	
КонецФункции

// Определяет размер сообщения исходя из количества частей и использования транслитерации.
//
// Параметры:
//  КоличествоЧастей - Число - Количество частей уведомления.
//  ИспользоватьТранслитерацию - Булево - Использовать транслитерацию.
// 
// Возвращаемое значение:
//  Число - Размер сообщения в символах.
//
Функция РазмерSMS(КоличествоЧастей, ИспользоватьТранслитерацию) Экспорт
	
	Если КоличествоЧастей = 0 Тогда
		КоличествоЧастей = 1;
	КонецЕсли;
	
	Если КоличествоЧастей = 1 И ИспользоватьТранслитерацию Тогда
		РазмерЧасти = 160;
	ИначеЕсли КоличествоЧастей = 1 И Не ИспользоватьТранслитерацию Тогда
		РазмерЧасти = 70;
	ИначеЕсли КоличествоЧастей > 1 И ИспользоватьТранслитерацию Тогда
		РазмерЧасти = 153;
	ИначеЕсли КоличествоЧастей > 1 И Не ИспользоватьТранслитерацию Тогда
		РазмерЧасти = 67;
	КонецЕсли;
	
	РазмерУведомления = РазмерЧасти * КоличествоЧастей;
	
	Возврат РазмерУведомления;
	
КонецФункции

// Проверяет, что данные способа уведомления являются корректными для уведомления по SMS.
//
// Параметры:
//  ДанныеСпособа - Строка - Данные способа уведомления.
//
// Возвращаемое значение:
//  Булево - Способ уведомления корректный.
//
Функция ЭтоКорректныйСпособУведомленияПоSMS(ДанныеСпособа) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеСпособа) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаНомера = 0;
	ЦифрыНомераТелефона = "0123456789";
	ДопустимыеСимволы = " ()+-" + ЦифрыНомераТелефона;
	Для НомерСимвола = 1 По СтрДлина(ДанныеСпособа) Цикл
		ТекущийСимвол = Сред(ДанныеСпособа, НомерСимвола, 1);
		Если Найти(ДопустимыеСимволы, ТекущийСимвол) = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
		Если Найти(ЦифрыНомераТелефона, ТекущийСимвол) <> 0 Тогда
			ДлинаНомера = ДлинаНомера + 1;
		КонецЕсли;
	КонецЦикла;
	
	ЭтоКорректныйСпособУведомленияПоSMS = (ДлинаНомера = 11);
	
	Возврат ЭтоКорректныйСпособУведомленияПоSMS;
	
КонецФункции

// Проверяет, что данные способа уведомления являются корректными для уведомления по почте.
//
// Параметры:
//  ДанныеСпособа - Строка - Данные способа уведомления.
//
// Возвращаемое значение:
//  Булево - Способ уведомления корректный.
//
Функция ЭтоКорректныйСпособУведомленияПоПочте(ДанныеСпособа) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеСпособа) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЭтоКорректныйСпособУведомленияПоПочте = РаботаСоСтроками.ЭтоАдресЭлектроннойПочты(ДанныеСпособа);
	
	Возврат РаботаСоСтроками.ЭтоАдресЭлектроннойПочты(ДанныеСпособа);
	
КонецФункции

#КонецОбласти