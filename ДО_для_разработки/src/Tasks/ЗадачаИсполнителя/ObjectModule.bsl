#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает Истина, если в задаче указан исполнитель или роль исполнителя.
//
Функция РеквизитыАдресацииЗаполнены() Экспорт
	
	Возврат НЕ Исполнитель.Пустая() ИЛИ НЕ РольИсполнителя.Пустая();

КонецФункции

// Создает при необходимости в Дополнительных свойствах
// объекта свойство с именем, указанным в параметре Раздел, тип Структура.
// Устанавливает в структуре свойство Свойство в значение Значение
//
Процедура УстановитьДополнительноеСвойство(Раздел, Свойство, Значение) Экспорт
	Если Не ДополнительныеСвойства.Свойство(Раздел) Тогда
		ДополнительныеСвойства.Вставить(Раздел, Новый Структура);
	КонецЕсли;
	ДополнительныеСвойства[Раздел].Вставить(Свойство, Значение);
КонецПроцедуры

// Получает значение поля структуры дополнительного свойства объекта:
// ТекущийОбъект.ДополнительныеСвойства[Раздел][Свойство]
// если не задано, возвращает Неопределено.
//
Функция ПолучитьДополнительноеСвойство(Раздел, Свойство) Экспорт
	Перем Результат;
	Если Не ДополнительныеСвойства.Свойство(Раздел) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если ДополнительныеСвойства[Раздел].Свойство(Свойство, Результат) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Проверяет, задано ли поле дополнительного свойства
// Возвращает Булево
//
Функция ЗаданоДополнительноеСвойство(Раздел, Свойство, Значение) Экспорт
	Значение = Неопределено;
	Если Не ДополнительныеСвойства.Свойство(Раздел) Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат ДополнительныеСвойства[Раздел].Свойство(Свойство, Значение);
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗадачаБылаВыполнена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Выполнена");
	Если НЕ ЗадачаБылаВыполнена И Выполнена Тогда
		
		Если НЕ РеквизитыАдресацииЗаполнены() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Необходимо указать исполнителя задачи.'"),,,
				"Объект.Исполнитель", Отказ);
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ЗадачаБылаВыполнена И Выполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Эта задача уже была выполнена ранее.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Если СрокИсполнения <> '00010101' И ДатаНачала > СрокИсполнения Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дата начала исполнения не должна превышать крайний срок.'"),,,
			"Объект.ДатаНачала", Отказ);
		Возврат;
	КонецЕсли;
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Если (ИспользоватьДатуИВремяВСрокахЗадач И ДатаИсполнения < Дата) 
	 Или (Не ИспользоватьДатуИВремяВСрокахЗадач И ДатаИсполнения < НачалоДня(Дата)) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дата исполнения меньше даты назначения задачи.'"),, "Объект.ДатаИсполнения",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбычнаяЗапись = Истина;
	ОбработатьТолькоПередачуПредметов = Ложь;
	Если ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		
		ОбычнаяЗапись = Ложь;
		
		ОбработатьТолькоПередачуПредметов = 
			(ДополнительныеСвойства.ВидЗаписи = 
			"ЗаписьСОбновлением_МоихДокументов_КешаИнформацииОбОбъектах_ВизСогласования_ПредметовПодчиненныхПроцессов_ДопРеквизитовПоПредметам_СобытийИзмененияПредметов");
		
		Если Не ОбработатьТолькоПередачуПредметов Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбычнаяЗапись Тогда
	
		Если ДополнительныеСвойства.Свойство("ФактическийИсполнительЗадачи") Тогда
			ДополнительныеСвойства.Вставить("ПредыдущийИсполнитель", Исполнитель);
			Исполнитель = ДополнительныеСвойства.ФактическийИсполнительЗадачи;
		КонецЕсли;
		
		ЗаписатьСобытияЗадачи();
		
		ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
		
		ЗадачаБылаВыполнена = Ложь;
		Если НЕ Ссылка.Пустая() Тогда
			ЗадачаБылаВыполнена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Выполнена");
		КонецЕсли;
		
		Если ЗадачаБылаВыполнена И НЕ Выполнена Тогда
			ДополнительныеСвойства.Вставить("ВыполнениеЗадачиБылоОтменено", Истина);
		КонецЕсли;
		
		Если НЕ ЗадачаБылаВыполнена И Выполнена Тогда
			
			Если СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Остановлен Тогда
				ВызватьИсключение НСтр("ru = 'Нельзя выполнять задачи остановленных процессов.'");
			КонецЕсли;	
			
			Если СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Прерван Тогда
				ВызватьИсключение НСтр("ru = 'Нельзя выполнять задачи прерванных процессов.'");
			КонецЕсли;	
			
			// Если задача выполнена, то запишем в реквизит Исполнитель того
			// пользователя, который фактически выполнил задачу. Это нам потом
			// потребуется для отчетов. Такую запись делаем только в том
			// случае, если в базе было не выполнено, а в объекте стало выполнено
			// Исполнитель устанавливается, только если текущая задача не является ведущей.
			Если НЕ ЗначениеЗаполнено(Исполнитель)
				И ТочкаМаршрута.Вид <> ВидТочкиМаршрутаБизнесПроцесса.ВложенныйБизнесПроцесс Тогда
				Исполнитель = Пользователи.ТекущийПользователь();
			КонецЕсли;
			Если ДатаИсполнения = Дата(1, 1, 1) Тогда
				ДатаИсполнения = ТекущаяДатаСеанса();
			КонецЕсли;
			
			Если НЕ (ДополнительныеСвойства.Свойство("ОтключитьЗаполнениеДополнительныхДанныхПоЗадаче")
				И ДополнительныеСвойства.ОтключитьЗаполнениеДополнительныхДанныхПоЗадаче = Истина) Тогда
				
				ДополнительныеДанныеПоЗадаче = Неопределено;
				ЕстьМетодДополнительныеДанныеПоЗадаче = Ложь;
				
				ИмяПроцесса = БизнесПроцесс.Метаданные().Имя;
				МенеджерПроцесса = БизнесПроцессы[ИмяПроцесса];
				
				Попытка
					ЕстьМетодДополнительныеДанныеПоЗадаче = МенеджерПроцесса.ЕстьМетодДополнительныеДанныеПоЗадаче();
				Исключение
					// В модуле менеджера процесса может не быть метода ЕстьМетодДополнительныеДанныеПоЗадаче
				КонецПопытки;
				
				Если ЕстьМетодДополнительныеДанныеПоЗадаче Тогда
					ДополнительныеДанныеПоЗадаче = МенеджерПроцесса.ДополнительныеДанныеПоЗадаче(ЭтотОбъект);
				КонецЕсли;
				
				Если ТипЗнч(ДополнительныеДанныеПоЗадаче) = Тип("Структура") Тогда
					
					РезультатВыполненияЗадачи = Неопределено;
					ОписаниеСобытияДляИстории = Неопределено;
					ДополнительныеДанныеПоЗадаче.Свойство("РезультатВыполнения", РезультатВыполненияЗадачи);
					ДополнительныеДанныеПоЗадаче.Свойство("ОписаниеСобытияДляИстории", ОписаниеСобытияДляИстории);
					
					// Добавление записи в результаты выполнения
					Если ЗначениеЗаполнено(РезультатВыполненияЗадачи) Тогда
						РегистрыСведений.РезультатыВыполненияПроцессовИЗадач.ЗаписатьРезультатПоОбъекту(Ссылка, РезультатВыполненияЗадачи);
					КонецЕсли;
					
					// Добавление записи в историю выполнения
					Если ЗначениеЗаполнено(ОписаниеСобытияДляИстории) Тогда
						РегистрыСведений.ИсторияВыполненияЗадач.ЗаписатьСобытиеПоПроцессу(БизнесПроцесс, ОписаниеСобытияДляИстории);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			ДополнительныеСвойства.Вставить("ЗадачаВыполнена", Истина);
			
		КонецЕсли;
			
		Если Важность.Пустая() Тогда
			Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СостояниеБизнесПроцесса) Тогда
			СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Активен;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбычнаяЗапись Или ОбработатьТолькоПередачуПредметов Тогда
		
		// Обработка предметов задачи
		ПредметСтрокой = МультипредметностьКлиентСервер.ПредметыСтрокой(Предметы);
		
		ИзмененыПредметыЗадачи = Ложь;
		Если Не Ссылка.Пустая() Тогда
			ИзмененыПредметыЗадачи = Мультипредметность.ИзмененыПредметыЗадачи(ЭтотОбъект);
		КонецЕсли;
		
		// Обновление КешаИнформацииОбОбъектах
		Если ИзмененыПредметыЗадачи Тогда
			ПредыдущиеПредметы = Мультипредметность.ПолучитьПредметыЗадачи(ЭтотОбъект.Ссылка);
			БизнесПроцессыИЗадачиСервер.ПриЗаписиЗадачиСервер(ЭтотОбъект, ПредыдущиеПредметы);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбычнаяЗапись Тогда
		
		ПредыдущаяПометкаУдаления = Ложь;
		Если НЕ Ссылка.Пустая() Тогда
			
			ПредыдущаяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
			
			// Проверка не изменились ли реквизиты адресации
			Адресация = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, 
				"Исполнитель, РольИсполнителя");
			
			// Проверка изменения исполнителя
			Если Адресация.Исполнитель <> Исполнитель Тогда
				
				// Если была ролевая маршрутизация, то реквизиты адресации 
				// считаются измененными только если задача адресована не 
				// исполнителю роли
				Если ЗначениеЗаполнено(Адресация.РольИсполнителя) Тогда
					
					ИсполнителиРоли = РегистрыСведений.ИсполнителиЗадач.ИсполнителиРоли(Адресация.РольИсполнителя);
						
					НайденВИсполнителяхРоли = Ложь;
					Для каждого Эл из ИсполнителиРоли Цикл
						Если Эл = Исполнитель Тогда
							НайденВИсполнителяхРоли = Истина;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					
					Если Не НайденВИсполнителяхРоли Тогда
						ДополнительныеСвойства.Вставить("ИзменилисьРеквизитыАдресации", Истина);
						ДополнительныеСвойства.Вставить("СтарыеРеквизитыАдресации", Адресация);
						УстановитьДополнительныеСвойстваИзмененияИсполнителя();
					КонецЕсли;
						
				Иначе
						
					ДополнительныеСвойства.Вставить("ИзменилисьРеквизитыАдресации", Истина);
					ДополнительныеСвойства.Вставить("СтарыеРеквизитыАдресации", Адресация);
					УстановитьДополнительныеСвойстваИзмененияИсполнителя();
					
				КонецЕсли;
				
			КонецЕсли;
			
			// Проверка изменения ролевой маршрутизации
			Если Адресация.РольИсполнителя <> РольИсполнителя Тогда
				
				ДополнительныеСвойства.Вставить("ИзменилисьРеквизитыАдресации", Истина);
				ДополнительныеСвойства.Вставить("СтарыеРеквизитыАдресации", Адресация);
				УстановитьДополнительныеСвойстваИзмененияИсполнителя();
				
			КонецЕсли;
			
		КонецЕсли;
		ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
		
		Если ПредыдущаяПометкаУдаления <> ПометкаУдаления Тогда
			БизнесПроцессыИЗадачиВызовСервера.ПриПометкеУдаленияЗадачи(Ссылка, ПометкаУдаления);
		КонецЕсли;
		
		Если НЕ Ссылка.Пустая() Тогда
			ПредыдущееСостояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СостояниеБизнесПроцесса");
			ДополнительныеСвойства.Вставить("ПредыдущееСостояние", ПредыдущееСостояние);
			
			Если ПредыдущееСостояние <> СостояниеБизнесПроцесса Тогда
				УстановитьСостояниеПодчиненныхБизнесПроцессов(СостояниеБизнесПроцесса);
			КонецЕсли;	
		КонецЕсли;
		
		Если Выполнена И Не ПринятаКИсполнению Тогда
			ПринятаКИсполнению = Истина;
			ДатаПринятияКИсполнению = ТекущаяДатаСеанса();
		КонецЕсли;	
		
		Если Автор <> Неопределено И Не Автор.Пустая() Тогда
			АвторСтрокой = Строка(Автор);
		КонецЕсли;
		
	КонецЕсли;
	
	Если (ОбычнаяЗапись Или ОбработатьТолькоПередачуПредметов)
		И ИзмененыПредметыЗадачи Тогда
		
		// Обновление ПредметовПодчиненныхПроцессов
		ПередатьСтатусы = МультипредметностьКлиентСервер.ЭтоПроцессОбработкиДокументов(ЭтотОбъект.БизнесПроцесс);
		Мультипредметность.ПередатьПредметыЗадачиПодчиненнымПроцессам(ЭтотОбъект, ПередатьСтатусы);
		
		// Обновление СобытийИзмененияПредметов
		Мультипредметность.ЗаписатьСобытиеИзменениеПредметовЗадачи(ЭтотОбъект);
		
		// Обновление ДопРеквизитовПоПредметам
		Мультипредметность.СкопироватьЗначенияДопРеквизитовПредметов(ЭтотОбъект);
		
	КонецЕсли;
	
	Если ОбычнаяЗапись Тогда
		
		// Заполнение текущего исполнителя
		Если ЗначениеЗаполнено(Исполнитель) Тогда
			ТекущийИсполнитель = Исполнитель;
		Иначе
			ТекущийИсполнитель = РольИсполнителя;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбычнаяЗапись = Истина;
	ОбновитьТолькоКешИнформацииОбОбъектах = Ложь;
	Если ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		
		ОбычнаяЗапись = Ложь;
		
		ОбновитьТолькоКешИнформацииОбОбъектах = 
			(ДополнительныеСвойства.ВидЗаписи = 
			"ЗаписьСОбновлением_МоихДокументов_КешаИнформацииОбОбъектах_ВизСогласования_ПредметовПодчиненныхПроцессов_ДопРеквизитовПоПредметам_СобытийИзмененияПредметов");
		
		Если Не ОбновитьТолькоКешИнформацииОбОбъектах Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Обработка предметов задачи
	ЕстьЗаполненныеПредметы = Мультипредметность.ЕстьЗаполненныеПредметыОбъекта(ЭтотОбъект);
	
	Если ОбычнаяЗапись Тогда
		
		НужноОбновитьРабочуюГруппуПредмета = Ложь;
		НужноОбновитьРабочуюГруппуПроцесса = Ложь;
		
		ИзменилисьРеквизитыАдресации = Ложь;
		ЗадачаВыполнена = Ложь;
		
		Если ДополнительныеСвойства.Свойство("ИзменилисьРеквизитыАдресации") Тогда
			ИзменилисьРеквизитыАдресации = ДополнительныеСвойства.ИзменилисьРеквизитыАдресации;
		КонецЕсли;
				
		Если ДополнительныеСвойства.Свойство("ЗадачаВыполнена") Тогда
			ЗадачаВыполнена = ДополнительныеСвойства.ЗадачаВыполнена;
			Если ДополнительныеСвойства.ЗадачаВыполнена Тогда
				ПользовательИсполнитель = Неопределено;
				ДополнительныеСвойства.Свойство("ПользовательИсполнитель", ПользовательИсполнитель);
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
					Ссылка, Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи, , ПользовательИсполнитель);
			КонецЕсли;
		КонецЕсли;
		
		// Проверка на перенаправление задачи
		Если ИзменилисьРеквизитыАдресации И Не ЗадачаВыполнена Тогда 
			НужноОбновитьРабочуюГруппуПредмета = Истина;
			НужноОбновитьРабочуюГруппуПроцесса = Истина;
			ЗарегистрироватьПеренаправлениеЗадачи();
		КонецЕсли;
		
		// Новые задачи всегда должны пополнять рабочую группу предмета
		Если ДополнительныеСвойства.ЭтоНовый И ЕстьЗаполненныеПредметы Тогда
			НужноОбновитьРабочуюГруппуПредмета = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если (ОбычнаяЗапись Или ОбновитьТолькоКешИнформацииОбОбъектах)
		И ЕстьЗаполненныеПредметы Тогда
		
		// Обновление КешаИнформацииОбОбъектах
		РегистрыСведений.КешИнформацииОбОбъектах.УстановитьПризнак(ЭтотОбъект.Ссылка, "ЕстьФайлы", Истина);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбычнаяЗапись Тогда
		
		Если НужноОбновитьРабочуюГруппуПредмета Или НужноОбновитьРабочуюГруппуПроцесса Тогда
			
			ТаблицаУчастников = РаботаСРабочимиГруппами.ПолучитьПустуюТаблицуУчастников();
			
			Если ЗначениеЗаполнено(Исполнитель) Тогда
				РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаУчастников, Исполнитель);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(РольИсполнителя) Тогда
				РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаУчастников, РольИсполнителя);
			КонецЕсли;
			
			// Обновление рабочих групп предметов
			Если НужноОбновитьРабочуюГруппуПредмета Тогда
				
				Для каждого СтрокаПредмета из Предметы Цикл
					Если ЗначениеЗаполнено(СтрокаПредмета.Предмет) Тогда
						Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(СтрокаПредмета.Предмет) Тогда
							Попытка
								РаботаСРабочимиГруппами.ДобавитьУчастниковВРабочуюГруппуОбъекта(
									СтрокаПредмета.Предмет,
									ТаблицаУчастников,
									Истина,  // ОбновитьПраваДоступа
									Истина); // ЗаполнятьКолонкуИзменение
							Исключение
								
								РаботаСРабочимиГруппами.ОбработатьИсключениеПерезаписиРабочейГруппыПредметаПроцесса(
									СтрокаПредмета.Предмет);
								
							КонецПопытки;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
			// Обновление рабочей группы процесса
			Если НужноОбновитьРабочуюГруппуПроцесса Тогда
				
				СтарыеРеквизитыАдресации = Неопределено;
				ДополнительныеСвойства.Свойство("СтарыеРеквизитыАдресации", СтарыеРеквизитыАдресации);
				
				Если ЗначениеЗаполнено(СтарыеРеквизитыАдресации) Тогда
					
					СтарыеРеквизитыАдресации = ДополнительныеСвойства.СтарыеРеквизитыАдресации;
					Если ЗначениеЗаполнено(СтарыеРеквизитыАдресации.Исполнитель) Тогда
						
						РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
							ТаблицаУчастников, 
							СтарыеРеквизитыАдресации.Исполнитель);
							
					КонецЕсли;
						
					Если ЗначениеЗаполнено(СтарыеРеквизитыАдресации.РольИсполнителя) Тогда
							
						РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
							ТаблицаУчастников, 
							СтарыеРеквизитыАдресации.РольИсполнителя);
							
					КонецЕсли;
						
				КонецЕсли;
				
				РаботаСРабочимиГруппами.ДобавитьУчастниковВРабочуюГруппуОбъекта(
					БизнесПроцесс, 
					ТаблицаУчастников, 
					Ложь); // ОбновитьПраваДоступа
					
				// Обновление рабочих групп всех ведущих и главных процессов
				РаботаСРабочимиГруппами.ОбновитьРабочиеГруппыРодительскихПроцессов(БизнесПроцесс, ТаблицаУчастников);
				
			КонецЕсли;	
			
		КонецЕсли;	
		
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеЗадачи);
			
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("ВыполнениеЗадачиБылоОтменено")
			И ДополнительныеСвойства.ВыполнениеЗадачиБылоОтменено Тогда
			
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ОтменаВыполненияЗадачи);
			
		КонецЕсли;
		
		ПредыдущаяПометкаУдаления = Ложь;
		Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
			ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
		КонецЕсли;
		
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
			ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("ПредыдущееСостояние")
			И ДополнительныеСвойства.ПредыдущееСостояние <> СостояниеБизнесПроцесса
			И СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Прерван Тогда
			
			РегистрыСведений.ЗадачиДляВыполнения.УдалитьЗадачуИзОчереди(Ссылка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаОбъект.ЗадачаИсполнителя") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, 
			"БизнесПроцесс,ТочкаМаршрута,Наименование,Исполнитель,РольИсполнителя," + 
			"Важность,ДатаИсполнения,Автор,Описание,СрокИсполнения," + 
			"ДатаНачала,РезультатВыполнения,Предмет");
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Важность) Тогда
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СостояниеБизнесПроцесса) Тогда
		СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Активен;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередВыполнением(Отказ)
	
	ЭтотУзел = РаботаСБизнесПроцессами.ЭтотУзелОбменаДляОбработкиПроцессов();
	
	УзелОбменаПроцесса = ОбщегоНазначенияДокументооборот.
		ЗначениеРеквизитаОбъектаВПривилегированномРежиме(БизнесПроцесс, "УзелОбмена");
		
	Если УзелОбменаПроцесса <> ЭтотУзел Тогда
		ТекстИсключения = НСтр("ru = 'Задача может быть выполнена только в узле РИБ: ""%1""'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, УзелОбменаПроцесса);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	РегистрыСведений.ЗадачиДляВыполнения.УдалитьЗадачуИзОчереди(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьСостояниеПодчиненныхБизнесПроцессов(НовоеСостояние)
	
	НачатьТранзакцию();
	ПодчиненныеБизнесПроцессы = БизнесПроцессыИЗадачиВызовСервера.ПолучитьБизнесПроцессыГлавнойЗадачи(Ссылка);
	Если ПодчиненныеБизнесПроцессы <> Неопределено Тогда
		Для Каждого ПодчиненныйБизнесПроцесс Из ПодчиненныеБизнесПроцессы Цикл
			БизнесПроцессОбъект = ПодчиненныйБизнесПроцесс.ПолучитьОбъект();
			БизнесПроцессОбъект.Заблокировать();
			Если БизнесПроцессОбъект.Завершен Тогда
				Продолжить;
			КонецЕсли;
			БизнесПроцессОбъект.Состояние = НовоеСостояние;
			БизнесПроцессОбъект.Записать();
		КонецЦикла;	
	КонецЕсли;	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ЗаписатьСобытияЗадачи()
	
	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущееЗначениеВыполнена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Выполнена");
	
	Если ПредыдущееЗначениеВыполнена <> Выполнена И Выполнена = Истина Тогда
		Если ИсключенаИзПроцесса Тогда
			Комментарий = НСтр("ru = 'Исключена из процесса'");
			ИсторияСобытийЗадач.ЗаписатьСобытие(
				Ссылка, 
				Перечисления.ВидыСобытийЗадач.ИсключенаИзПроцесса, 
				Комментарий);
		Иначе
			Комментарий = НСтр("ru = 'Исполнитель: %Исполнитель%'");
			Комментарий = СтрЗаменить(Комментарий, "%Исполнитель%", Строка(Исполнитель));
			
			ПользовательИсполнитель = Неопределено;
			ДополнительныеСвойства.Свойство("ПользовательИсполнитель", ПользовательИсполнитель);
			
			ИсторияСобытийЗадач.ЗаписатьСобытие(
				Ссылка, 
				Перечисления.ВидыСобытийЗадач.Выполнена, 
				Комментарий,
				ПользовательИсполнитель);
		КонецЕсли;
	КонецЕсли;
	
	Если ПредыдущееЗначениеВыполнена <> Выполнена И Выполнена = Ложь Тогда
		
		Комментарий = НСтр("ru = 'Исполнитель: %2'");
			
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Комментарий,
			,
			Строка(Исполнитель));
			
		ИсторияСобытийЗадач.ЗаписатьСобытие(
			Ссылка, 
			Перечисления.ВидыСобытийЗадач.ВыполнениеОтменено, 
			Комментарий);
		
	КонецЕсли;
	
	Если Выполнена <> Истина Тогда
		
		ЗаписатьСобытиеПринятияЗадачи = Истина;
		ЗаписатьСобытиеПеренаправленияЗадачи = Истина;
		
		Если ЗначениеЗаполнено(РольИсполнителя)
			И Ссылка.РольИсполнителя = РольИсполнителя
			И Ссылка.Исполнитель <> Исполнитель Тогда // Если произошло принятие ролей задачи
			
			ЗаписатьСобытиеПринятияЗадачи = Истина;
			ЗаписатьСобытиеПеренаправленияЗадачи = Ложь;
			
		ИначеЕсли Ссылка.Исполнитель <> Исполнитель
				ИЛИ Ссылка.РольИсполнителя <> РольИсполнителя Тогда // Если произошло перенаправление задачи
				
			ЗаписатьСобытиеПринятияЗадачи = Ложь;
			ЗаписатьСобытиеПеренаправленияЗадачи = Истина;
			
		КонецЕсли;
		
		Если ЗаписатьСобытиеПринятияЗадачи
			И Ссылка.ПринятаКИсполнению <> ПринятаКИсполнению Тогда
			
			Комментарий = НСтр("ru = 'Исполнитель: %Исполнитель%'");
			Комментарий = СтрЗаменить(
				Комментарий,
				"%Исполнитель%",
				Строка(?(ЗначениеЗаполнено(Ссылка.Исполнитель), Ссылка.Исполнитель, Исполнитель)));
			
			Если ПринятаКИсполнению Тогда
				СобытиеДляЗадачи = Перечисления.ВидыСобытийЗадач.ПринятаКИсполнению;
			Иначе
				СобытиеДляЗадачи = Перечисления.ВидыСобытийЗадач.ПринятиеКИсполнениюОтменено;
			КонецЕсли;
			
			ИсторияСобытийЗадач.ЗаписатьСобытие(Ссылка, СобытиеДляЗадачи, Комментарий);
			
		КонецЕсли;
		
		Если ЗаписатьСобытиеПеренаправленияЗадачи
			И (Ссылка.Исполнитель <> Исполнитель
				ИЛИ Ссылка.РольИсполнителя <> РольИсполнителя) Тогда
			
			БылИсполнитель = Ссылка.Исполнитель;
			Если БылИсполнитель.Пустая() Тогда
				БылИсполнитель = Ссылка.РольИсполнителя;
			КонецЕсли;	
			
			СталИсполнитель = Исполнитель;
			Если СталИсполнитель.Пустая() Тогда
				СталИсполнитель = РольИсполнителя;
			КонецЕсли;	
			
			Комментарий = НСтр("ru = 'От исполнителя: %Был% к исполнителю: %Стал%'");
			Комментарий = СтрЗаменить(Комментарий, "%Был%", БылИсполнитель);
			Комментарий = СтрЗаменить(Комментарий, "%Стал%", СталИсполнитель);
			
			Если ДополнительныеСвойства.Свойство("КомментарийПеренаправления") Тогда
				Комментарий = Комментарий + "." + Символы.ПС
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Комментарий: %1'"), 
					ДополнительныеСвойства.КомментарийПеренаправления);
			КонецЕсли;
			
			ИсторияСобытийЗадач.ЗаписатьСобытие(
				Ссылка, 
				Перечисления.ВидыСобытийЗадач.Перенаправлена,
				Комментарий);
				
			СообщениеДляИсторииВыполнения = Формат(ТекущаяДата(), "ДЛФ=D") + ", " 
				+ Строка(Пользователи.ТекущийПользователь()) 
				+ НСтр("ru = '. Задача перенаправлена.'") + Символы.ПС
				+ СтрЗаменить(СтрЗаменить(Комментарий, НСтр("ru = 'От исполнителя:'"), НСтр("ru = 'От кого:'")),
				НСтр("ru = ' к исполнителю:'"), НСтр("ru = ', кому:'"));
			
			РегистрыСведений.ИсторияВыполненияЗадач.ЗаписатьСобытиеПоПроцессу(БизнесПроцесс, СообщениеДляИсторииВыполнения);
			
		КонецЕсли;
		
		Если Ссылка.СрокИсполнения <> СрокИсполнения Тогда
			
			Комментарий = НСтр("ru = 'Был: %Был%, стал: %Стал%'");
			Комментарий = СтрЗаменить(Комментарий, "%Был%", 
				?(ЗначениеЗаполнено(Ссылка.СрокИсполнения), Строка(Ссылка.СрокИсполнения), НСтр("ru = 'не указан'")));
			Комментарий = СтрЗаменить(Комментарий, "%Стал%", 
				?(ЗначениеЗаполнено(СрокИсполнения), Строка(СрокИсполнения), НСтр("ru = 'не указан'")));
			
			ИсторияСобытийЗадач.ЗаписатьСобытие(
				Ссылка, 
				Перечисления.ВидыСобытийЗадач.ИзмененСрок,
				Комментарий);
				
		КонецЕсли;
		
		Если Ссылка.Важность <> Важность Тогда
			
			Комментарий = НСтр("ru = 'Была: %Была%, стала: %Стала%'");
			Комментарий = СтрЗаменить(Комментарий, "%Была%", Строка(Ссылка.Важность));
			Комментарий = СтрЗаменить(Комментарий, "%Стала%", Строка(Важность));
			
			ИсторияСобытийЗадач.ЗаписатьСобытие(
				Ссылка, 
				Перечисления.ВидыСобытийЗадач.ИзмененаВажность,
				Комментарий);
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура УстановитьДополнительныеСвойстваИзмененияИсполнителя()
	
	Если Ссылка.Исполнитель <> Исполнитель ИЛИ Ссылка.РольИсполнителя <> РольИсполнителя Тогда
		
		БылИсполнитель = Ссылка.Исполнитель;
		Если БылИсполнитель.Пустая() Тогда
			БылИсполнитель = Ссылка.РольИсполнителя;
		КонецЕсли;
		
		СталИсполнитель = Исполнитель;
		Если СталИсполнитель.Пустая() Тогда
			СталИсполнитель = РольИсполнителя;
		КонецЕсли;
		
		ДополнительныеСвойства.Вставить("БылИсполнитель", БылИсполнитель);
		ДополнительныеСвойства.Вставить("СталИсполнитель", СталИсполнитель);
		
	КонецЕсли;
	
КонецПроцедуры

// Делает запись бизнес-события перенаправления задачи
Процедура ЗарегистрироватьПеренаправлениеЗадачи()
	
	ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи;
	
	Если ДополнительныеСвойства.Свойство("БылИсполнитель") Тогда
		БылИсполнитель = ДополнительныеСвойства.БылИсполнитель;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("СталИсполнитель") Тогда
		СталИсполнитель = ДополнительныеСвойства.СталИсполнитель;
	КонецЕсли;
	
	Автоперенаправление = Ложь;
	Если ДополнительныеСвойства.Свойство("Автоперенаправление") Тогда
		Автоперенаправление = ДополнительныеСвойства.Автоперенаправление;
	КонецЕсли;
	
	ПараметрыСобытия = Новый Структура;
	ПараметрыСобытия.Вставить("БылИсполнитель", БылИсполнитель);
	ПараметрыСобытия.Вставить("СталИсполнитель", СталИсполнитель);
	ПараметрыСобытия.Вставить("Автоперенаправление", Автоперенаправление);
	
	// тут формируем КонтекстСобытия (XML)
	ИнформацияДляЗаписиXML = Новый ЗаписьXML;
	ИнформацияДляЗаписиXML.УстановитьСтроку();
	
	НовыйСериализаторXDTO = Новый СериализаторXDTO(ФабрикаXDTO);
	НовыйСериализаторXDTO.ЗаписатьXML(ИнформацияДляЗаписиXML, ПараметрыСобытия, НазначениеТипаXML.Явное);
	
	СтрокаXML = ИнформацияДляЗаписиXML.Закрыть(); 
	КонтекстСобытия = Новый ХранилищеЗначения(СтрокаXML);
	
	БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, ВидСобытия, КонтекстСобытия);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли