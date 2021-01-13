
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ОткрытаПоСценарию") Тогда
		ВызватьИсключение НСтр("ru='Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	ПропуститьЗавершениеРаботы = Параметры.ПропуститьЗавершениеРаботы;
	
	Элементы.ТекстСообщения.Заголовок = Параметры.ТекстСообщения;
	Элементы.РекомендуемаяВерсияПлатформы.Заголовок = Параметры.РекомендуемаяВерсияПлатформы;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	ТекстУсловие = ?(Параметры.ЗавершитьРаботу, НСтр("ru = 'необходимо'"), НСтр("ru = 'рекомендуется'"));
	Элементы.Версия.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.Версия.Заголовок, ТекстУсловие, СистемнаяИнформация.ВерсияПриложения);
	
	Если Параметры.ЗавершитьРаботу Тогда
		Элементы.ТекстВопроса.Видимость = Ложь;
		Элементы.ФормаНет.Видимость     = Ложь;
		Заголовок = НСтр("ru = 'Необходимо обновить версию платформы'");
	КонецЕсли;
	
	Если (ТекущийВариантИнтерфейсаКлиентскогоПриложения() <> ВариантИнтерфейсаКлиентскогоПриложения.Такси) Тогда
		Элементы.РекомендуемаяВерсияПлатформы.Шрифт = Новый Шрифт(,, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ДействиеОпределено Тогда
		ДействиеОпределено = Истина;
		
		Если НЕ ПропуститьЗавершениеРаботы Тогда
			ПрекратитьРаботуСистемы();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстСсылкиНажатие(Элемент)
	
	ОткрытьФорму("Обработка.НерекомендуемаяВерсияПлатформы.Форма.ПорядокОбновленияПлатформы",,ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьРаботу(Команда)
	
	ДействиеОпределено = Истина;
	Закрыть("Продолжить");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	ДействиеОпределено = Истина;
	Если НЕ ПропуститьЗавершениеРаботы Тогда
		ПрекратитьРаботуСистемы();
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
