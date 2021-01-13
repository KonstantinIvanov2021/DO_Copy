
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"ПредставлениеГруппировкиОбщихСвойств",
		НСтр("ru = 'Общие (для нескольких наборов)'"),
		Истина);
	
	// Группировка свойств по наборам.
	ГруппировкаДанных = Список.КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаДанных.ИдентификаторПользовательскойНастройки = "ГруппировкаСвойствПоНаборам";
	ГруппировкаДанных.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ПоляГруппировки = ГруппировкаДанных.ПоляГруппировки;
	
	ЭлементГруппировкиДанных = ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировкиДанных.Поле = Новый ПолеКомпоновкиДанных("НаборСвойствГруппировка");
	ЭлементГруппировкиДанных.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти
