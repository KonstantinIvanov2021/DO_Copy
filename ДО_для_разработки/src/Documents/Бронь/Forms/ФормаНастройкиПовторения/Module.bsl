#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеБронь = ДанныеФормыВЗначение(Параметры.Бронь, Тип("ДокументОбъект.Бронь"));
	ЗначениеВРеквизитФормы(ЗначениеБронь, "Бронь");
	
	Если Бронь.ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия Тогда
		ТекстОшибки = НСтр("ru = 'Невозможно настроить повторение для исключения повторяющегося события.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Бронь.ДатаНачалаПовторения = Бронь.ДатаНачала;
	
	Если Не ЗначениеЗаполнено(Бронь.ЧастотаПовторения) Тогда
		Бронь.ЧастотаПовторения = Перечисления.ЧастотаПовторения.Еженедельно;
	КонецЕсли;
	
	Если Бронь.ИнтервалПовторения < 1 Тогда
		Бронь.ИнтервалПовторения = 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Бронь.ПравилоОкончанияПовторения) Тогда
		Бронь.ПравилоОкончанияПовторения = Перечисления.ПравилаОкончанияПовторения.Никогда;
	КонецЕсли;
	
	Если Бронь.КоличествоПовторов = 0 Тогда
		Бронь.КоличествоПовторов = 5;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Бронь.ДатаОкончанияПовторения) Тогда
		Бронь.ДатаОкончанияПовторения = ТекущаяДатаСеанса() + 604800; // 604800 - число секунд в неделе
	КонецЕсли;
	
	ЗаполненыДниНедели = Ложь;
	Для Каждого ПовторениеПоДню Из Бронь.ПовторениеПоДням Цикл
		Если ПовторениеПоДню.НомерВхождения = 0 Тогда
			ВключитьПовторениеПоДнюНедели(ПовторениеПоДню.ДеньНедели);
			ЗаполненыДниНедели = Истина;
		Иначе
			НастройкаСпособаПовторенияВМесяце = 1;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗаполненыДниНедели Тогда
		ДеньНеделиНачала = ДеньНедели(Бронь.ДатаНачалаПовторения);
		ВключитьПовторениеПоДнюНедели(ДеньНеделиНачала);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Бронь.ПовторениеПоДнямМесяца) Тогда
		НастройкаСпособаПовторенияВМесяце = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьОтображение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЧастотаПовторенияПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалПовторенияПриИзменении(Элемент)
	
	Если Бронь.ИнтервалПовторения < 1 Тогда
		Бронь.ИнтервалПовторения = 1;
	КонецЕсли;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПовторовПриИзменении(Элемент)
	
	Если Бронь.КоличествоПовторов < 1 Тогда
		Бронь.КоличествоПовторов = 5;
		Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.Никогда");
		ТекущийЭлемент = Элементы.ПравилоОкончанияПовторения;
	Иначе
		Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов");
	КонецЕсли;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПовторенияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Бронь.ДатаОкончанияПовторения) Тогда
		Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты");
	Иначе
		Бронь.ДатаОкончанияПовторения = ТекущаяДата() + 604800; // 604800 - число секунд в неделе
		Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.Никогда");
		ТекущийЭлемент = Элементы.ПравилоОкончанияПовторения;
	КонецЕсли;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОкончанияПовторенияПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОкончанияПовторенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Бронь.ПравилоОкончанияПовторения =
		ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.Никогда");
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиПонедельникПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиВторникПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиСредаПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиЧетвергПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиПятницаПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиСубботаПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиВоскресеньеПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпособаПовторенияВМесяцеПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ПроверитьКорректностьНастройкиПовторения() Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьПараметрыПовторения();
	
	Закрыть(Бронь);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОтображение()
	
	Если Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.Никогда") Тогда
		Элементы.СтраницыНастройкиПравилОкончанияПовторения.ТекущаяСтраница =
			Элементы.СтраницаПравилоОкончаниеНикогда;
	ИначеЕсли Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов") Тогда
		Элементы.СтраницыНастройкиПравилОкончанияПовторения.ТекущаяСтраница =
			Элементы.СтраницаПравилоОкончанияПосле;
	ИначеЕсли Бронь.ПравилоОкончанияПовторения =
		ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты") Тогда
		Элементы.СтраницыНастройкиПравилОкончанияПовторения.ТекущаяСтраница =
			Элементы.СтраницаПравилоОкончанияПоДате;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Бронь.ЧастотаПовторения) Тогда
		
		Элементы.СтраницыПовторение.ТекущаяСтраница = Элементы.СтраницаПовторение;
		
		Если Бронь.ЧастотаПовторения =
				ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежедневно") Тогда
			Элементы.СтраницыНастройки.ТекущаяСтраница =
				Элементы.СтраницаНастройкиДень;
		ИначеЕсли Бронь.ЧастотаПовторения =
				ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Еженедельно") Тогда
			Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкиНеделя;
		ИначеЕсли Бронь.ЧастотаПовторения =
				ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежемесячно") Тогда
			Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкиМесяц;
		ИначеЕсли Бронь.ЧастотаПовторения =
				ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежегодно") Тогда
			Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкиГод;
		КонецЕсли;
		
	Иначе
		
		Элементы.СтраницыПовторение.ТекущаяСтраница = Элементы.СтраницаНеЗаданоПовторение;
		
	КонецЕсли;
	
	НастройкиПовторения = ПолучитьНастройкиПовторения();
	
	ПовторениеСтрокой =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьТекстовоеПредставлениеПовторения(НастройкиПовторения);
	
	ИнтервалЕдиницаИзмерения =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьТекстовоеПредставлениеЕдиницыИзмеренияИнтервалаПовторения(
			НастройкиПовторения);
	
	Если Бронь.КоличествоПовторов = 1 Тогда
		КоличествоПовторовЕдиницаИзмерения = НСтр("ru = 'повтора'");
	Иначе
		КоличествоПовторовЕдиницаИзмерения = НСтр("ru = 'повторов'");
	КонецЕсли;
	
	Элементы.КоличествоПовторов.Доступность =
		(Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов"));
	Элементы.КоличествоПовторовЕдиницаИзмерения.Доступность =
		(Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов"));
	
	Элементы.ДатаОкончанияПовторения.Доступность =
		(Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты"));
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПовторениеПоДнямНедели()
	
	ПовторениеПоДням = Новый Соответствие;
	Если Бронь.ЧастотаПовторения =
			ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Еженедельно") Тогда
		ПовторениеПоДням.Вставить(1, ДеньНеделиПонедельник);
		ПовторениеПоДням.Вставить(2, ДеньНеделиВторник);
		ПовторениеПоДням.Вставить(3, ДеньНеделиСреда);
		ПовторениеПоДням.Вставить(4, ДеньНеделиЧетверг);
		ПовторениеПоДням.Вставить(5, ДеньНеделиПятница);
		ПовторениеПоДням.Вставить(6, ДеньНеделиСуббота);
		ПовторениеПоДням.Вставить(7, ДеньНеделиВоскресенье);
	Иначе
		ПовторениеПоДням.Вставить(1, Ложь);
		ПовторениеПоДням.Вставить(2, Ложь);
		ПовторениеПоДням.Вставить(3, Ложь);
		ПовторениеПоДням.Вставить(4, Ложь);
		ПовторениеПоДням.Вставить(5, Ложь);
		ПовторениеПоДням.Вставить(6, Ложь);
		ПовторениеПоДням.Вставить(7, Ложь);
	КонецЕсли;
	
	Возврат ПовторениеПоДням;
	
КонецФункции

&НаКлиенте
Функция ПолучитьНастройкиПовторения()
	
	ПовторениеПоДнямНедели = ПолучитьПовторениеПоДнямНедели();
	
	ПовторениеПоДнямМесяца = 0;
	ПовторениеПоДнямНеделиВМесяце = Неопределено;
	ПовторениеПоМесяцам = 0;
	ПовторениеКоличествоПовторов = 0;
	ПовторениеДатаОкончанияПовторения = Дата(1,1,1);
	
	Если Бронь.ЧастотаПовторения =
			ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежемесячно") Тогда
		
		Если НастройкаСпособаПовторенияВМесяце = 0 Тогда
			ПовторениеПоДнямМесяца = День(Бронь.ДатаНачалаПовторения);
		ИначеЕсли НастройкаСпособаПовторенияВМесяце = 1 Тогда
			ПовторениеПоДнямНеделиВМесяце =
				РаботаСРабочимКалендаремКлиентСервер.ПолучитьДеньНеделиВМесяце(Бронь.ДатаНачалаПовторения);
		КонецЕсли;
		
	ИначеЕсли Бронь.ЧастотаПовторения =
			ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежегодно") Тогда
		
		ПовторениеПоДнямМесяца = День(Бронь.ДатаНачалаПовторения);
		ПовторениеПоМесяцам = Месяц(Бронь.ДатаНачалаПовторения);
		
	КонецЕсли;
	
	Если Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов") Тогда
		ПовторениеКоличествоПовторов = Бронь.КоличествоПовторов;
	ИначеЕсли Бронь.ПравилоОкончанияПовторения =
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты") Тогда
		ПовторениеДатаОкончанияПовторения = Бронь.ДатаОкончанияПовторения;
	КонецЕсли;
	
	НастройкиПовторения = РаботаСРабочимКалендаремКлиентСервер.ПолучитьСтруктуруНастройкиПовторения(
		Бронь.ЧастотаПовторения, Бронь.ИнтервалПовторения, Бронь.ПравилоОкончанияПовторения,
		ПовторениеКоличествоПовторов, ПовторениеДатаОкончанияПовторения, ПовторениеПоДнямНедели,
		ПовторениеПоДнямМесяца, ПовторениеПоДнямНеделиВМесяце, ПовторениеПоМесяцам);
	
	Возврат НастройкиПовторения;
	
КонецФункции

&НаСервере
Процедура ВключитьПовторениеПоДнюНедели(ДеньНедели)
	
	Если ДеньНедели = 1 Тогда
		ДеньНеделиПонедельник = Истина;
	ИначеЕсли ДеньНедели = 2 Тогда
		ДеньНеделиВторник = Истина;
	ИначеЕсли ДеньНедели = 3 Тогда
		ДеньНеделиСреда = Истина;
	ИначеЕсли ДеньНедели = 4 Тогда
		ДеньНеделиЧетверг = Истина;
	ИначеЕсли ДеньНедели = 5 Тогда
		ДеньНеделиПятница = Истина;
	ИначеЕсли ДеньНедели = 6 Тогда
		ДеньНеделиСуббота = Истина;
	ИначеЕсли ДеньНедели = 7 Тогда
		ДеньНеделиВоскресенье = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьКорректностьНастройкиПовторения()
	
	Если Бронь.ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Еженедельно")
		И Не ДеньНеделиПонедельник И Не ДеньНеделиВторник И Не ДеньНеделиСреда И Не ДеньНеделиЧетверг
		И Не ДеньНеделиПятница И Не ДеньНеделиСуббота И Не ДеньНеделиВоскресенье Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Не указаны дни повторения.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьПараметрыПовторения()
	
	Если Бронь.ПравилоОкончанияПовторения <>
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов") Тогда
		Бронь.КоличествоПовторов = 0;
	КонецЕсли;
	
	Если Бронь.ПравилоОкончанияПовторения <>
			ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты") Тогда
		Бронь.ДатаОкончанияПовторения = Дата(1,1,1);
	КонецЕсли;
	
	Бронь.ПовторениеПоДнямМесяца = 0;
	Бронь.ПовторениеПоМесяцам = 0;
	Бронь.ПовторениеПоДням.Очистить();
	Если Бронь.ЧастотаПовторения =
			ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Еженедельно") Тогда
		
		Если ДеньНеделиПонедельник Тогда
			НоваяСтрока = Бронь.ПовторениеПоДням.Добавить();
			НоваяСтрока.ДеньНедели = 1;
		КонецЕсли;
		
		Если ДеньНеделиВторник Тогда
			НоваяСтрока = Бронь.ПовторениеПоДням.Добавить();
			НоваяСтрока.ДеньНедели = 2;
		КонецЕсли;
		
		Если ДеньНеделиСреда Тогда
			НоваяСтрока = Бронь.ПовторениеПоДням.Добавить();
			НоваяСтрока.ДеньНедели = 3;
		КонецЕсли;
		
		Если ДеньНеделиЧетверг Тогда
			НоваяСтрока = Бронь.ПовторениеПоДням.Добавить();
			НоваяСтрока.ДеньНедели = 4;
		КонецЕсли;
		
		Если ДеньНеделиПятница Тогда
			НоваяСтрока = Бронь.ПовторениеПоДням.Добавить();
			НоваяСтрока.ДеньНедели = 5;
		КонецЕсли;
		
		Если ДеньНеделиСуббота Тогда
			НоваяСтрока = Бронь.ПовторениеПоДням.Добавить();
			НоваяСтрока.ДеньНедели = 6;
		КонецЕсли;
		
		Если ДеньНеделиВоскресенье Тогда
			НоваяСтрока = Бронь.ПовторениеПоДням.Добавить();
			НоваяСтрока.ДеньНедели = 7;
		КонецЕсли;
		
	ИначеЕсли Бронь.ЧастотаПовторения =
			ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежемесячно") Тогда
		
		Если НастройкаСпособаПовторенияВМесяце = 0 Тогда
			Бронь.ПовторениеПоДнямМесяца = День(Бронь.ДатаНачалаПовторения);
		ИначеЕсли НастройкаСпособаПовторенияВМесяце = 1 Тогда
			ПовторениеПоДнямНеделиВМесяце =
				РаботаСРабочимКалендаремКлиентСервер.ПолучитьДеньНеделиВМесяце(Бронь.ДатаНачалаПовторения);
			НоваяСтрока = Бронь.ПовторениеПоДням.Добавить();
			ЗаполнитьЗначенияСвойств(
				НоваяСтрока,
				ПовторениеПоДнямНеделиВМесяце);
		КонецЕсли;
		
	ИначеЕсли Бронь.ЧастотаПовторения =
			ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежегодно") Тогда
		
		Бронь.ПовторениеПоДнямМесяца = День(Бронь.ДатаНачалаПовторения);
		Бронь.ПовторениеПоМесяцам = Месяц(Бронь.ДатаНачалаПовторения);
		
	КонецЕсли;
	
	Если Бронь.ЧастотаПовторения <>
			ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.ПустаяСсылка") Тогда
		Бронь.ТипЗаписи =
			ПредопределенноеЗначение("Перечисление.ТипЗаписиКалендаря.ПовторяющеесяСобытие");
	Иначе
		Бронь.ТипЗаписи = ПредопределенноеЗначение("Перечисление.ТипЗаписиКалендаря.Событие");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти