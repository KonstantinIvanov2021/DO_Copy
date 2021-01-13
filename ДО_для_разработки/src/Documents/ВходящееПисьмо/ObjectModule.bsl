#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовоеПисьмо", Ссылка.Пустая());
	
	Если ДополнительныеСвойства.ЭтоНовоеПисьмо Тогда
		НомерСпособаАдресации = ВстроеннаяПочтаСервер.ПолучитьСпособАдресацииОбъекта(ЭтотОбъект);
	КонецЕсли;		
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если Не Ссылка.Пустая() Тогда
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, Папка");
		ПредыдущаяПометкаУдаления = ЗначенияРеквизитов.ПометкаУдаления;
		ДополнительныеСвойства.Вставить("ПредыдущаяПапка", ЗначенияРеквизитов.Папка);
		ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ЗначенияРеквизитов.ПометкаУдаления);
		
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		КонецЕсли;
	КонецЕсли;
	ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
	
	ВстроеннаяПочтаСервер.ПрименитьПравила(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Папка) Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Не указана папка письма'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПапка = Неопределено;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПапка") Тогда
		ПредыдущаяПапка = ДополнительныеСвойства.ПредыдущаяПапка;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если Папка <> ПредыдущаяПапка Или ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		
		Если ЗначениеЗаполнено(ПредыдущаяПапка) Тогда
			РегистрыСведений.КоличествоПисемВПапках.ОчиститьЗаписиПоПапке(ПредыдущаяПапка);
		КонецЕсли;
		
		РегистрыСведений.КоличествоПисемВПапках.ОчиститьЗаписиПоПапке(Папка);
		
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;	
	
КонецПроцедуры

// Возвращает структуру "ТипТекста, Кодировка, Текст"
//
Функция ПолучитьСодержаниеПисьма() Экспорт
	
	Результат = Новый Структура("Текст, ТипТекста, Кодировка");
	
	Если ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML Тогда
		
		Результат.ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML;
		
		ТекстПисьма = ТекстПисьмаHTMLХранилище.Получить();
		
		Если ТекстПисьма = Неопределено Тогда
			ТекстПисьма = "";
		КонецЕсли;
		
		Результат.Текст = ТекстПисьма;
		
	ИначеЕсли ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст
		Или Не ЗначениеЗаполнено(ТипТекста) Тогда
		
		Результат.ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст;
		
		ТекстПисьма = ТекстПисьмаПростойТекстХранилище.Получить();
		
		Если ТекстПисьма = Неопределено Тогда
			ТекстПисьма = "";
		КонецЕсли;
		
		Результат.Текст = ТекстПисьма;
		
	КонецЕсли;
	
	Результат.Кодировка = Кодировка;
	
	Возврат Результат;
	
КонецФункции

// Устанавливает текст, тип текста и кодировку письма.
//
Процедура УстановитьСодержаниеПисьма(
	Знач ТекстПисьма,
	Знач ТипТекстаПисьма = Неопределено,
	Знач КодировкаПисьма = Неопределено) Экспорт
	
	Если Не ЭтоНовый() И ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст Тогда
		РегистрыСведений.HTMLПредставленияСодержанияПисем.Удалить(Ссылка);
	КонецЕсли;
	
	ТипТекста = ?(ЗначениеЗаполнено(ТипТекстаПисьма),
		ТипТекстаПисьма,
		Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст);
	
	Кодировка = ?(ЗначениеЗаполнено(КодировкаПисьма),
		КодировкаПисьма,
		"utf-8");
	
	Почта.ИсправитьПереводыСтрок(ТекстПисьма);
	
	Если ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML Тогда
		
		ТекстПисьмаHTMLХранилище = Новый ХранилищеЗначения(ТекстПисьма, Новый СжатиеДанных);
		
		ПростойТекст = РаботаС_HTML.ПолучитьТекстИзHTML(ТекстПисьма);
		ТекстПисьмаПростойТекстХранилище = Новый ХранилищеЗначения(ПростойТекст, Новый СжатиеДанных);
		
	Иначе
		ТекстПисьмаПростойТекстХранилище = Новый ХранилищеЗначения(ТекстПисьма, Новый СжатиеДанных);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст письма в виде простого текста.
Функция ПолучитьТекстовоеПредставлениеСодержанияПисьма() Экспорт
	
	Результат = "";
	
	Если ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML Тогда
		
		ТекстHTML = ТекстПисьмаHTMLХранилище.Получить();
		
		Если ТекстHTML = Неопределено Тогда
			
			Результат = "";
			
		Иначе
			
			Результат = РаботаС_HTML.ПолучитьТекстИзHTML(ТекстHTML, Кодировка);
			
		КонецЕсли;
		
	Иначе
		
		Результат = ТекстПисьмаПростойТекстХранилище.Получить();
		
		Если Результат = Неопределено Тогда
			
			Результат = "";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПередУдалением(Отказ)
	
	ВстроеннаяПочтаСервер.ПередУдалениемПисьма(ЭтотОбъект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли