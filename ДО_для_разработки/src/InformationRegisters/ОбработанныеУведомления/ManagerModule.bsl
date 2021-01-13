#Область ПрограммныйИнтерфейс

// Устанавливает факт обработки уведомления
Процедура ДобавитьОбработанноеУведомление(ВидСобытия, ОбъектУведомления, Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.ОбработанныеУведомления.СоздатьМенеджерЗаписи();
	Запись.ВидСобытия = ВидСобытия;
	Запись.ОбъектУведомления = ОбъектУведомления;
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.ВидСобытия = ВидСобытия;
	Запись.ОбъектУведомления = ОбъектУведомления;
	Запись.Пользователь = Пользователь;
	Запись.ДатаОбработки = ТекущаяДата();
	Запись.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

