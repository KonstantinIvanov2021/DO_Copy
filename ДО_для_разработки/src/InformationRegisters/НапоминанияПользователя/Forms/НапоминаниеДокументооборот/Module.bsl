#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	ВариантНапоминания = 1;
	
	Если Параметры.Свойство("ИнтервалВремениСтрокой")
		И Параметры.Свойство("СпособУстановкиВремениНапоминания")
		И Параметры.СпособУстановкиВремениНапоминания =
			Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета Тогда
		ИнтервалВремениСтрокой = Параметры.ИнтервалВремениСтрокой;
	Иначе
		СрокНапоминанияПоУмолчанию =
			ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиНапоминаний",
			"СрокНапоминанияПоУмолчанию",
			15);
		ИнтервалВремениСтрокой = НапоминанияПользователяКлиентСервер.ПредставлениеВремениДокументооборот(СрокНапоминанияПоУмолчанию * 60);
	КонецЕсли;
	
	Если Параметры.Свойство("ВремяНапоминания") Тогда 
		ВремяНапоминания = Параметры.ВремяНапоминания;
	КонецЕсли;
	
	ЗаполнитьИнтервалыНапоминания();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВариантНапоминанияПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьНапоминание(Команда)
	
	ЭтаФорма.Модифицированность = Ложь;
	
	Результат = Новый Структура();
	
	Результат.Вставить("СпособУстановкиВремениНапоминания",
		?(ВариантНапоминания = 1,
			ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ВУказанноеВремя"),
			ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета")));
	Результат.Вставить("ИнтервалВремениСтрокой", ИнтервалВремениСтрокой);
	Результат.Вставить("ВремяНапоминания", ВремяНапоминания);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьИнтервалыНапоминания()
	
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Очистить();
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'при наступлении события'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 5 минут'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 10 минут'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 15 минут'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 20 минут'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 30 минут'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 45 минут'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 1 час'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 2 часа'"));
	Элементы.ИнтервалВремениСтрокой.СписокВыбора.Добавить(НСтр("ru = 'за 3 часа'"));
	
	Если Элементы.ИнтервалВремениСтрокой.СписокВыбора.НайтиПоЗначению(ИнтервалВремениСтрокой) = Неопределено Тогда
		Элементы.ИнтервалВремениСтрокой.СписокВыбора.Вставить(0, ИнтервалВремениСтрокой);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	Элементы.ИнтервалВремениСтрокой.Доступность = (ВариантНапоминания = 0);
	Элементы.ГруппаВремя.Доступность = (ВариантНапоминания = 1);
	
КонецПроцедуры

#КонецОбласти