////////////////////////////////////////////////////////////////////////////////
// Модуль общего обработчика ожидания.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет действия обработчика ожидания на клиенте.
// Процедура предназначена для вызова из ОбщийОбработчикОжиданияГлобальный.ОбщийОбработчикОжидания.
// 
// Параметры:
//  Обработчики - Структура - Содержит обработчики, готовые к выполнению.
//
// Возвращаемое значение:
//  Структура - содержит данные обработчиков для последующей обработки на клиенте.
//
Функция ВыполнитьДействияОбработчикаОжидания(Обработчики) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ЕстьУведомленияПрограммы", Ложь);
	Результат.Вставить("УведомленияПрограммы", Новый Массив);
	Результат.Вставить("РезультатыПроверкиПочты",Неопределено);
	Результат.Вставить("РезультатыСохраненияЗамеров",Неопределено);
	
	Результат.Вставить("НужнаОчисткаКешаФайлов", Ложь);
	Результат.Вставить("ПроверенаДатаОчисткиКешаФайлов", Ложь);
	
	Если Обработчики.Свойство("ПроверкаПочты")
		И Обработчики.ПроверкаПочты Тогда
		
		РезультатыПроверкиПочты = Неопределено;
		ВстроеннаяПочтаСервер.ПроверитьНаличиеНовыхПисем(РезультатыПроверкиПочты);
		
		Если РезультатыПроверкиПочты.НужноОбновитьСписок Тогда
			Результат.РезультатыПроверкиПочты = РезультатыПроверкиПочты;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Обработчики.Свойство("ПроверкаУведомленийПрограммы")
		И Обработчики.ПроверкаУведомленийПрограммы Тогда
		
		УведомленияПрограммы = Справочники.УведомленияПрограммы.ПолучитьУведомления();
		КоличествоУведомлений = УведомленияПрограммы.Количество();
		Результат.ЕстьУведомленияПрограммы = КоличествоУведомлений <> 0;
		Если КоличествоУведомлений = 1 Тогда
			Результат.УведомленияПрограммы = УведомленияПрограммы;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Обработчики.Свойство("СохранениеЗамеровПроизводительности")
		И Обработчики.СохранениеЗамеровПроизводительности
		И Обработчики.Свойство("СохранениеЗамеровПроизводительностиЗамеры") Тогда
		
		Замеры = Обработчики.СохранениеЗамеровПроизводительностиЗамеры;
		Результат.РезультатыСохраненияЗамеров = 
			ОценкаПроизводительностиВызовСервераДокументооборот.ЗаписатьРезультатыЗамеров(Замеры);
		
	КонецЕсли;
	
	Если Обработчики.Свойство("ПроверкаОчисткиКешаФайлов")
		И Обработчики.ПроверкаОчисткиКешаФайлов Тогда
		
		Результат.ПроверенаДатаОчисткиКешаФайлов = Истина;
		
		ОчищатьПериодически 
			= ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", 
				"ОчищатьПериодически", Ложь);
				
		ПериодХранения 
			= ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", 
				"ПериодХранения", 1); //  в днях
				
		ДатаПоследнейОчистки 
			= ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", 
				"ДатаПоследнейОчистки", Дата('00010101'));
		Если ТипЗнч(ДатаПоследнейОчистки) <> Тип("Дата") Тогда	
			ДатаПоследнейОчистки = ТекущаяДатаСеанса();
		КонецЕсли;	
		
		Если ОчищатьПериодически = Истина И ПериодХранения <> 0 Тогда
			Если ДатаПоследнейОчистки < ТекущаяДатаСеанса() - ПериодХранения * 86400 Тогда
				
				Результат.НужнаОчисткаКешаФайлов = Истина;
				
				ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
					"ЛокальныйКэшФайлов",
					"ДатаПоследнейОчистки",
					ТекущаяДатаСеанса());
						
			КонецЕсли;		
		КонецЕсли;	
				
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти