#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, СтатусЭД");
	
	Если НЕ Отказ И СтатусЭД <> РеквизитыСсылки.СтатусЭД Тогда

		Если ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ПОА И СтатусЭД <> РеквизитыСсылки.СтатусЭД Тогда
			ПараметрыВладельцаЭД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлектронныйДокументВладелец,
				"СтатусЭД, НаправлениеЭД");
			Если ПараметрыВладельцаЭД.СтатусЭД = Перечисления.СтатусыЭД.ПолученоПредложениеОбАннулировании
				ИЛИ ПараметрыВладельцаЭД.СтатусЭД = Перечисления.СтатусыЭД.СформированоПредложениеОбАннулировании Тогда
				Если (СтатусЭД = Перечисления.СтатусыЭД.ОтправленоПодтверждение
						ИЛИ СтатусЭД = Перечисления.СтатусыЭД.ПодготовленоПодтверждение
						ИЛИ СтатусЭД = Перечисления.СтатусыЭД.ПолученоПодтверждение) Тогда
					ОбменСКонтрагентамиСлужебныйВызовСервера.УстановитьСтатусЭД(ЭлектронныйДокументВладелец,
						Перечисления.СтатусыЭД.Аннулирован);
				ИначеЕсли (СтатусЭД = Перечисления.СтатусыЭД.ОтклоненПолучателем
						ИЛИ СтатусЭД = Перечисления.СтатусыЭД.Отклонен) Тогда
					НастройкиОбмена = ОбменСКонтрагентамиСлужебный.НастройкиОбменаЭД(ЭлектронныйДокументВладелец);
					МассивСтатусов = ОбменСКонтрагентамиСлужебный.ВернутьМассивСтатусовЭД(НастройкиОбмена);
					НовыйСтатусЭД = МассивСтатусов[МассивСтатусов.ВГраница()];
					СтруктураПараметров = Новый Структура("СтатусЭД, ПричинаОтклонения", НовыйСтатусЭД, "");
					Если СтатусЭД = Перечисления.СтатусыЭД.Отклонен
						Или СтатусЭД = Перечисления.СтатусыЭД.ОтклоненПолучателем Тогда
						СтруктураПараметров.Вставить("ОтклонениеАннулирования", Истина);
					КонецЕсли;

					ОбменСКонтрагентамиСлужебныйВызовСервера.ИзменитьПоСсылкеПрисоединенныйФайл(ЭлектронныйДокументВладелец,
						СтруктураПараметров, Ложь);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Установка пометки удаления производится только с дополнительным свойством объекта "ПомечатьНаУдалениеПодписанныеОбъекты".
	Если НЕ Отказ И НЕ ДополнительныеСвойства.Свойство("ПомечатьНаУдалениеПодписанныеОбъекты") Тогда
		Если ПометкаУдаления = Истина И РеквизитыСсылки.ПометкаУдаления = Ложь Тогда
			Если ЗначениеЗаполнено(ЭлектронныйДокументВладелец) Тогда
				ПодписанЭПЭлектронныйДокументВладелец = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлектронныйДокументВладелец, "ПодписанЭП");
			Иначе
				ПодписанЭПЭлектронныйДокументВладелец = Неопределено;
			КонецЕсли;
			Если ПодписанЭП ИЛИ (ЗначениеЗаполнено(ПодписанЭПЭлектронныйДокументВладелец) И ПодписанЭПЭлектронныйДокументВладелец) Тогда
				ПометкаУдаления = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли