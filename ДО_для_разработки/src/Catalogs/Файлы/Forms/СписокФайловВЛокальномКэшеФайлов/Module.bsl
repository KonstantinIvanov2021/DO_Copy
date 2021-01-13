&НаКлиенте
Процедура ЗаполнитьСписокФайловВФорме()
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ПутьКЛокальномуКэшуФайлов = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	СписокФайлов.Очистить();
	
	Для Каждого Строка Из СписокЗначенийФайловВРегистре Цикл
		
		ПолныйПуть = ПутьКЛокальномуКэшуФайлов + Строка.Значение.ЧастичныйПуть;
		Файл = Новый Файл(ПолныйПуть);
		Если Файл.Существует() Тогда
			НоваяСтрока = СписокФайлов.Добавить();
			
			ДатаФайлаВКеше = Строка.Значение.ДатаМодификацииУниверсальная;
			ДатаФайлаВКеше = РаботаСФайламиКлиентСервер.ПолучитьМестноеВремя(ДатаФайлаВКеше);
			НоваяСтрока.ДатаИзмененияФайла = ДатаФайлаВКеше;
			
			НоваяСтрока.ИмяФайла = Строка.Значение.ПолноеНаименование;
			НоваяСтрока.ИндексКартинки  = Строка.Значение.ИндексКартинки;
			НоваяСтрока.Размер = Формат(Строка.Значение.Размер / 1024, "ЧЦ=10; ЧН=0"); // в КБ
			НоваяСтрока.Версия = Строка.Значение.Ссылка;
			НоваяСтрока.Редактирует = Строка.Значение.Редактирует;
			НоваяСтрока.НаРедактирование = НЕ Строка.Значение.НаЧтение;
		КонецЕсли;
	
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокФайловВФорме();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПоСсылке(СсылкаДляУдаления)
	КоличествоЭлементов = СписокФайлов.Количество();
	
	Для Номер = 0 По КоличествоЭлементов - 1 Цикл
		Строка = СписокФайлов[Номер];
		Ссылка = Строка.Версия;
		Если Ссылка = СсылкаДляУдаления Тогда
			СписокФайлов.Удалить(Номер);
			Возврат;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьВыполнить()
	
	Обработчик = Новый ОписаниеОповещения("ОсвободитьПослеУстановкиРасширения", ЭтотОбъект);
	ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьПослеУстановкиРасширения(Результат, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("МассивСсылок", Новый Массив);
	
	Для Каждого Элемент Из Элементы.СписокФайлов.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СписокФайлов.ДанныеСтроки(Элемент);
		Ссылка = ДанныеСтроки.Версия;
		ПараметрыВыполнения.МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	ПараметрыВыполнения.Вставить("Индекс", 0);
	ПараметрыВыполнения.Вставить("ВГраница", ПараметрыВыполнения.МассивСсылок.ВГраница());
	
	ОсвободитьВЦикле(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьВЦикле(ПараметрыВыполнения)
	
	РаботаСФайламиКлиент.ЗарегистрироватьОписаниеОбработчика(
		ПараметрыВыполнения, ЭтотОбъект, "ОсвободитьВЦиклеПродолжить");
	
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("ОбработчикРезультата",           ПараметрыВыполнения);
	ПараметрыВызова.Вставить("ОбъектСсылка",                   Неопределено);
	ПараметрыВызова.Вставить("Версия",                         Неопределено);
	ПараметрыВызова.Вставить("ХранитьВерсии",                  Неопределено);
	ПараметрыВызова.Вставить("РедактируетТекущийПользователь", Неопределено);
	ПараметрыВызова.Вставить("Редактирует",                    Неопределено);
	ПараметрыВызова.Вставить("УникальныйИдентификатор",        Неопределено);
	ПараметрыВызова.Вставить("НеЗадаватьВопрос",               Ложь);
	
	Для Индекс = ПараметрыВыполнения.Индекс По ПараметрыВыполнения.ВГраница Цикл
		ПараметрыВыполнения.Индекс = Индекс;
		ПараметрыВызова.Версия = ПараметрыВыполнения.МассивСсылок[Индекс];
		
		РаботаСФайламиКлиент.ОсвободитьФайлПослеУстановкиРасширения(
			Неопределено, ПараметрыВызова);
		
		Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Истина Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьСписокФайлов();
	ЗаполнитьСписокФайловВФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьВЦиклеПродолжить(Результат, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	ПараметрыВыполнения.Индекс = ПараметрыВыполнения.Индекс + 1;
	ОсвободитьВЦикле(ПараметрыВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокФайлов()
	
	СписокФайловВРегистре = РаботаСФайламиВызовСервера.СписокФайловВРегистре();
	СписокЗначенийФайловВРегистре.Очистить();
	
	Для Каждого Строка Из СписокФайловВРегистре Цикл
		СписокЗначенийФайловВРегистре.Добавить(Строка);
	КонецЦикла; 	

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайлаВыполнить()
	Если Элементы.СписокФайлов.ТекущиеДанные <> Неопределено Тогда
		Ссылка = Элементы.СписокФайлов.ТекущиеДанные.Версия;
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Неопределено, Ссылка);
		РаботаСФайламиКлиент.КаталогФайла(Неопределено, ДанныеФайла);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайловВыполнить()
	
	ТекстВопроса = НСтр("ru = 'Удалить выбранные файлы из основного рабочего каталога?'");
	Обработчик = Новый ОписаниеОповещения("УдалитьИзЛокальногоКэшаПослеОтветаНаВопрос", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаПослеОтветаНаВопрос(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("МассивСсылок", Новый Массив);
	Для Каждого НомерЦикла Из Элементы.СписокФайлов.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СписокФайлов.ДанныеСтроки(НомерЦикла);
		ПараметрыВыполнения.МассивСсылок.Добавить(ДанныеСтроки.Версия);
	КонецЦикла;
	
	ПараметрыВыполнения.Вставить("Индекс", 0);
	ПараметрыВыполнения.Вставить("ВГраница", ПараметрыВыполнения.МассивСсылок.ВГраница());
	ПараметрыВыполнения.Вставить("Ссылка", Неопределено);
	ПараметрыВыполнения.Вставить("ЕстьЗанятыеФайлы", Ложь);
	ПараметрыВыполнения.Вставить("ИмяКаталога", ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя());

	УдалитьИзЛокальногоКэшаФайловВЦикле(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайловВЦикле(ПараметрыВыполнения)
	
	РаботаСФайламиКлиент.ЗарегистрироватьОписаниеОбработчика(ПараметрыВыполнения, ЭтотОбъект, "УдалитьИзЛокальногоКэшаФайловВЦиклеПродолжить");
	
	Для Индекс = ПараметрыВыполнения.Индекс По ПараметрыВыполнения.ВГраница Цикл
		ПараметрыВыполнения.Индекс = Индекс;
		ПараметрыВыполнения.Ссылка = ПараметрыВыполнения.МассивСсылок[Индекс];
		
		Если ФайлЗанят(ПараметрыВыполнения.Ссылка) Тогда
			Строки = СписокФайлов.НайтиСтроки(Новый Структура("Версия", ПараметрыВыполнения.Ссылка));
			Строки[0].НаРедактирование = Истина;
			ПараметрыВыполнения.ЕстьЗанятыеФайлы = Истина;
			ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
			ПараметрыВыполнения.Индекс = ПараметрыВыполнения.Индекс + 1;
			Продолжить;
		КонецЕсли;
		
		ПараметрыВыполнения.Вставить("ИмяФайлаСПутем",
			РаботаСФайламиВызовСервера.ПолучитьИмяФайлаСПутемИзРегистра(
				ПараметрыВыполнения.Ссылка, ПараметрыВыполнения.ИмяКаталога, Ложь, Ложь));
		
		РаботаСФайламиКлиент.УдалитьФайлИзРабочегоКаталога(
			ПараметрыВыполнения, ПараметрыВыполнения.Ссылка);
		
		Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Истина Тогда
			Возврат;
		КонецЕсли;
		
		Если ПараметрыВыполнения.ИмяФайлаСПутем <> "" Тогда
			ФайлНаДиске = Новый Файл(ПараметрыВыполнения.ИмяФайлаСПутем);
			Если НЕ ФайлНаДиске.Существует() Тогда
				УдалитьПоСсылке(ПараметрыВыполнения.Ссылка);
			КонецЕсли;
		Иначе
			УдалитьПоСсылке(ПараметрыВыполнения.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыВыполнения.ЕстьЗанятыеФайлы Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Нельзя удалять из основного рабочего каталога файлы,
			           |занятые для редактирования.'"));
	КонецЕсли;
	
	Элементы.СписокФайлов.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайловВЦиклеПродолжить(Результат, ПараметрыВыполнения) Экспорт
	
	// Завершение операций с файлом.
	Если ПараметрыВыполнения.ИмяФайлаСПутем <> "" Тогда
		ФайлНаДиске = Новый Файл(ПараметрыВыполнения.ИмяФайлаСПутем);
		Если НЕ ФайлНаДиске.Существует() Тогда
			УдалитьПоСсылке(ПараметрыВыполнения.Ссылка);
		КонецЕсли;
	Иначе
		УдалитьПоСсылке(ПараметрыВыполнения.Ссылка);
	КонецЕсли;
	
	// Продолжение цикла.
	ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	ПараметрыВыполнения.Индекс = ПараметрыВыполнения.Индекс + 1;
	УдалитьИзЛокальногоКэшаФайловВЦикле(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайлов(Команда)
	УдалитьИзЛокальногоКэшаФайловВыполнить();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФайлЗанят(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.Ссылка = &Ссылка
	|	И ВерсииФайлов.Владелец.Редактирует <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.СписокФайлов.ТекущиеДанные <> Неопределено Тогда
		
		Ссылка = Элементы.СписокФайлов.ТекущиеДанные.Версия;
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Неопределено, Ссылка);
		
		Обработчик = Новый ОписаниеОповещения("ОбновитьСписокФайлов", ЭтотОбъект);
		
		ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, 
			ДанныеФайла.Ссылка, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
			
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокФайлов(Результат, ПараметрыВыполнения) Экспорт
	
	ЗаполнитьСписокФайлов();
	ЗаполнитьСписокФайловВФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УдалитьИзЛокальногоКэшаФайловВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	ОткрытьКарточкуВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуВыполнить()
	
	Если Элементы.СписокФайлов.ТекущиеДанные <> Неопределено Тогда
		Ссылка = Элементы.СписокФайлов.ТекущиеДанные.Версия;
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Неопределено, Ссылка);
		ПоказатьЗначение(,ДанныеФайла.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьКарточкуВыполнить();
КонецПроцедуры
