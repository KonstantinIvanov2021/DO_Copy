
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаЗаписи" Тогда
		
		Если Параметры.Свойство("Ключ")
			И (
				Не Параметры.Свойство("ПодписьПроверена")
				Или Не Параметры.Свойство("ПодписьВерна")
				Или Не Параметры.Свойство("СертификатДействителен")
			) Тогда
			
			МенеджерЗаписи = РегистрыСведений.ЭлектронныеПодписи.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Параметры.Ключ);
			МенеджерЗаписи.Прочитать();
			
			Если МенеджерЗаписи.Выбран() 
				И ЗначениеЗаполнено(МенеджерЗаписи.ДатаПроверкиПодписи) // Подпись проходила проверку.
				И (
					Не МенеджерЗаписи.ПодписьВерна
					Или Не МенеджерЗаписи.СертификатДействителен
				) Тогда
				
				ВыбраннаяФорма = "ФормаЗаписиСТекстомПричины";
				СтандартнаяОбработка = Ложь;
			КонецЕсли;
			
		Иначе
			
			Если Параметры.ПодписьПроверена
				И (
					Не Параметры.ПодписьВерна
					Или Не Параметры.СертификатДействителен
				) Тогда
				
				ВыбраннаяФорма = "ФормаЗаписиСТекстомПричины";
				СтандартнаяОбработка = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли
	
КонецПроцедуры
