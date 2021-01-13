#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВариантРасчетаТекст = Справочники.ПоказателиПроцессов.ПредставлениеВариантаРасчета(ВариантРасчета());
	ВариантОтбораТекст = Справочники.ПоказателиПроцессов.ПредставлениеНабораВариантовОтбора(НаборВариантовОтбора());
	УстановитьРасширенноеРедактирование(Не ЗначениеЗаполнено(ВариантОтбораТекст));
	
	ТекущееЗначение = РегистрыСведений.ЗначенияПоказателейПроцессов.ТекущееЗначение(Объект.Ссылка);
	
	ОбновитьНаименование();
	ОбновитьОтслеживать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьТекущуюСтраницуПериодРасчета();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	КоличествоОтборов = ТекущийОбъект.ОтборыДанных.Количество();
	Для Инд = 1 По КоличествоОтборов Цикл
		Строка = ТекущийОбъект.ОтборыДанных[КоличествоОтборов - Инд];
		Если Не ЗначениеЗаполнено(Строка.ВидПредмета)
			И Не ЗначениеЗаполнено(Строка.Ответственный)
			И Не ЗначениеЗаполнено(Строка.Проект)
			И Не ЗначениеЗаполнено(Строка.ТипПредмета)
			И Не ЗначениеЗаполнено(Строка.ТипПроцесса)
			И Не ЗначениеЗаполнено(Строка.Шаблон)
			И Не ЗначениеЗаполнено(Строка.ЭтапОбработкиПредмета) Тогда
			ТекущийОбъект.ОтборыДанных.Удалить(Строка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ДополнительныеСвойства.Свойство("ИзменилсяСпособРасчета") Тогда
		ПараметрыЗаписи.Вставить("ИзменилсяСпособРасчета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ИзменилсяСпособРасчета") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Изменился способ расчета показателя. Пересчитать показатель?'");
		ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АвтоНаименованиеПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРасчетаТекстНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	МониторингПроцессовКлиент.ВыбратьВариантРасчета(Объект, ЭтаФорма, "ВариантРасчетаТекст", ВариантРасчета());
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРасчетаТекстОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРасчетаТекстОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	МониторингПроцессовКлиент.ВыбратьВариантРасчета(Объект, ЭтаФорма, "ВариантРасчетаТекст", ВариантРасчета());
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтбораТекстНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	МониторингПроцессовКлиент.ВыбратьВариантОтбора(
		Объект,
		ЭтаФорма,
		"ВариантОтбораТекст",
		ВариантРасчета(),
		НаборВариантовОтбора());
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтбораТекстОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтбораТекстОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	МониторингПроцессовКлиент.ВыбратьВариантОтбора(
		Объект,
		ЭтаФорма,
		"ВариантОтбораТекст",
		ВариантРасчета(),
		НаборВариантовОтбора());
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРасчетаПриИзменении(Элемент)
	
	УстановитьТекущуюСтраницуПериодРасчета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтборыДанных

&НаКлиенте
Процедура ОтборыДанныхПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отслеживать(Команда)
	
	ПоказателиПроцессов = Новый Массив;
	ПоказателиПроцессов.Добавить(Объект.Ссылка);
	
	МониторингПроцессовКлиент.Отслеживать(ПоказателиПроцессов);
	
КонецПроцедуры

&НаКлиенте
Процедура РасширенноеРедактирование(Команда)
	
	УстановитьРасширенноеРедактирование(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВариантРасчета()
	
	ВариантРасчета = Справочники.ПоказателиПроцессов.ВариантРасчета();
	ЗаполнитьЗначенияСвойств(ВариантРасчета, Объект);
	
	Возврат ВариантРасчета;
	
КонецФункции

&НаСервере
Функция НаборВариантовОтбора()
	
	НаборВариантовОтбора = Новый Массив;
	
	Для Каждого ОтборДанных Из Объект.ОтборыДанных Цикл
		ВариантОтбора = Справочники.ПоказателиПроцессов.ВариантОтбора();
		ЗаполнитьЗначенияСвойств(ВариантОтбора, ОтборДанных);
		НаборВариантовОтбора.Добавить(ВариантОтбора);
	КонецЦикла;
	
	Возврат НаборВариантовОтбора;
	
КонецФункции

&НаСервере
Функция НастройкиОтбора()
	
	НастройкиОтбора = Справочники.ПоказателиПроцессов.НастройкиОтбора();
	ЗаполнитьЗначенияСвойств(НастройкиОтбора, ЭтотОбъект);
	НастройкиОтбора.НаборВариантовОтбора = НаборВариантовОтбора();
	
	Возврат НастройкиОтбора;
	
КонецФункции

&НаКлиенте
Процедура УстановитьТекущуюСтраницуПериодРасчета()
	
	Если Объект.ПериодРасчета =
		ПредопределенноеЗначение("Перечисление.ПериодыРасчетаПоказателейПроцессов.ПоДням") Тогда
		
		Элементы.СтраницыПараметрыПериодаРасчета.ТекущаяСтраница = Элементы.СтраницаПериодРасчетаПоДням;
		
	ИначеЕсли Объект.ПериодРасчета =
		ПредопределенноеЗначение("Перечисление.ПериодыРасчетаПоказателейПроцессов.Произвольный") Тогда
		
		Элементы.СтраницыПараметрыПериодаРасчета.ТекущаяСтраница = Элементы.СтраницаПериодРасчетаПроизвольный;
		
	ИначеЕсли Объект.ПериодРасчета =
		ПредопределенноеЗначение("Перечисление.ПериодыРасчетаПоказателейПроцессов.Актуальный") Тогда
		
		Элементы.СтраницыПараметрыПериодаРасчета.ТекущаяСтраница = Элементы.СтраницаПериодРасчетаАктуальный;
		
	Иначе
		
		Элементы.СтраницыПараметрыПериодаРасчета.ТекущаяСтраница = Элементы.СтраницаПериодРасчетаБезПараметров;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	МониторингПроцессовКлиент.ПересчитатьПоказатель(Объект.Ссылка, Неопределено, Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасширенноеРедактирование(РасширенноеРедактирование)
	
	Элементы.ФормаРасширенноеРедактирование.Видимость = Не РасширенноеРедактирование;
	Элементы.ВариантОтбораТекст.Видимость = Не РасширенноеРедактирование;
	Элементы.СтраницаОтборы.Видимость = РасширенноеРедактирование;
	Элементы.Страницы.ОтображениеСтраниц =
		?(РасширенноеРедактирование, ОтображениеСтраницФормы.ЗакладкиСверху, ОтображениеСтраницФормы.Нет);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименование()
	
	Если Объект.АвтоНаименование Тогда
		Объект.Наименование = Справочники.ПоказателиПроцессов.ПредставлениеПоказателя(ВариантРасчета(), НастройкиОтбора());
	КонецЕсли;
	Элементы.Наименование.ТолькоПросмотр = Объект.АвтоНаименование И ЗначениеЗаполнено(Объект.Наименование);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтслеживать()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отслеживать = Истина;
	Иначе
		Отслеживать = РегистрыСведений.ПодпискиНаПоказателиПроцессов.ПодпискаАктивна(Объект.Ссылка);
	КонецЕсли;
	Элементы.ФормаОтслеживать.Пометка = Отслеживать;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПодпискиНаПоказателиПроцессов" И Параметр = Объект.Ссылка Тогда
		ОбновитьОтслеживать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти