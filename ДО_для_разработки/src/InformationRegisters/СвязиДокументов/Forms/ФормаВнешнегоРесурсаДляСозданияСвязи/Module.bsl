#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВнешнийРесурс = Параметры.ВнешнийРесурс;
	Комментарий = Параметры.Комментарий;
	
	Документ = Параметры.Документ;
	Контрагент = Параметры.Контрагент;
	Организация = Параметры.Организация;
	
	ВидДокумента = Неопределено;
	Если Параметры.ОбязательныеСвязи.Количество() = 1 Тогда
		
		Строка = Параметры.ОбязательныеСвязи[0];
		
		ТипСвязи = Строка.ТипСвязи;
		СсылкаНа = Строка.СсылкаНа;
		ВидДокумента = СсылкаНа;
		
	КонецЕсли;	
	
	Элементы.ДекорацияОписание.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Чтобы завершить создание документа, необходимо указать связь ""%1"". 
			|Выберите файл для создания связи.'"),
			ТипСвязи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВнешнийРесурсОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(ВнешнийРесурс) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Введите адрес внешней ссылки.'"));
	Иначе
		ПерейтиПоНавигационнойСсылке(ВнешнийРесурс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнийРесурсПриИзменении(Элемент)
	
	Если СтрНачинаетсяС(ВнешнийРесурс, "e1cib") Тогда
		ТекстПредупреждения = 
			НСтр("ru = 'Для объектов в других информационных базах следует использовать внешние ссылки.'");
	Иначе
		ТекстПредупреждения = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ЗначениеЗаполнено(ВнешнийРесурс) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Введите адрес внешней ссылки.'"));
		Возврат;
	КонецЕсли;
	
	//Результат = Новый Структура;
	//Результат.Вставить("ВнешнийРесурс", ВнешнийРесурс);
	//Результат.Вставить("Комментарий", Комментарий);
	//Закрыть(Результат);
	
	ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйДокумент, Комментарий", 
		ТипСвязи, СсылкаНа, ВнешнийРесурс, Комментарий);
		
	МассивВозврата = Новый Массив;
	МассивВозврата.Добавить(ПараметрыВозврата);
	
	Закрыть(МассивВозврата);
	
	
КонецПроцедуры

#КонецОбласти