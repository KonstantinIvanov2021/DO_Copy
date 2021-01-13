#Область ПрограммныйИнтерфейс

// Возвращает подразделение для переданного пользователя.
//
Функция ПолучитьПодразделение(Пользователь) Экспорт 

	Если Не ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат Справочники.СтруктураПредприятия.ПустаяСсылка();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователяхДокументооборот.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.СтруктураПредприятия.ПустаяСсылка();
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Подразделение;

КонецФункции

// Возвращает должность для переданного пользователя.
//
Функция ПолучитьДолжность(Пользователь) Экспорт 

	Если Не ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат Справочники.Должности.ПустаяСсылка();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователяхДокументооборот.Должность КАК Должность
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Должности.ПустаяСсылка();
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Должность;

КонецФункции

// Возвращает руководителя для переданного пользователя.
//
Функция ПолучитьРуководителя(Пользователь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователяхДокументооборот.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Подразделение = Выборка.Подразделение;
	Если Подразделение.Руководитель <> Пользователь Тогда 
		Возврат Подразделение.Руководитель;
	КонецЕсли;		
	
	Пока ЗначениеЗаполнено(Подразделение.Родитель)  Цикл
		Подразделение = Подразделение.Родитель;
		Если Подразделение.Руководитель <> Пользователь Тогда 
			Возврат Подразделение.Руководитель;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат Подразделение.Руководитель;
	
КонецФункции	

// Возвращает список пользователей и, если указано, их контейнеров и автоподстановок для целей автоподбора.
//
// Параметры:
//   Текст - Строка - символы, введенные пользователем.
//   ДополнениеТипа - ОписаниеТипов - необязательный, дополнение типа выбираемых объектов (по умолчанию - только
//     пользователи. Для автоподстановок указывается тип "Строка".
//   ИменаПредметовДляФункций - Массив - необязательный, имена предметов для функций автоподстановки.
//
// Возвращаемое значение:
//   СписокЗначений - подходящие пользователи (контейнеры, автоподстановки) и их представления с уточнением.
//
Функция СформироватьДанныеВыбора(Текст,
	Знач ДополнениеТипа = Неопределено, ИменаПредметовДляФункций = Неопределено) Экспорт
	
	Если ДополнениеТипа = Неопределено Тогда
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
	КонецЕсли;
	
	// Пользователей выбираем всегда.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 20
		|	Пользователи.Ссылка КАК Ссылка,
		|	СведенияОПользователяхДокументооборот.Подразделение КАК Пояснение1,
		|	СведенияОПользователяхДокументооборот.Должность КАК Пояснение2
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
		|		ПО Пользователи.Ссылка = СведенияОПользователяхДокументооборот.Пользователь
		|ГДЕ
		|	Пользователи.Наименование ПОДОБНО &Текст
		|	И Не Пользователи.Недействителен
		|	И Не Пользователи.ПометкаУдаления
		|");
		
	// Роли.
	Если ДополнениеТипа.СодержитТип(Тип("СправочникСсылка.ПолныеРоли")) Тогда
		Запрос.Текст = Запрос.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	ПолныеРоли.Ссылка,
		|	&Роль,
		|	""""
		|ИЗ
		|	Справочник.ПолныеРоли КАК ПолныеРоли
		|ГДЕ
		|	ПолныеРоли.Владелец.Наименование ПОДОБНО &Текст
		|	И Не ПолныеРоли.ПометкаУдаления
		|";
		Запрос.УстановитьПараметр("Роль", НСтр("ru = 'роль'"));
	КонецЕсли;
	
	// Группы.
	Если ДополнениеТипа.СодержитТип(Тип("СправочникСсылка.РабочиеГруппы")) Тогда
		Запрос.Текст = Запрос.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	РабочиеГруппы.Ссылка,
		|	&Группа,
		|	""""
		|ИЗ
		|	Справочник.РабочиеГруппы КАК РабочиеГруппы
		|ГДЕ
		|	РабочиеГруппы.Наименование ПОДОБНО &Текст
		|	И Не РабочиеГруппы.ПометкаУдаления
		|	И Не РабочиеГруппы.Недействительна
		|";
		Запрос.УстановитьПараметр("Группа", НСтр("ru = 'группа'"));
	КонецЕсли;
	
	// Подразделения.
	Если ДополнениеТипа.СодержитТип(Тип("СправочникСсылка.СтруктураПредприятия")) Тогда
		Запрос.Текст = Запрос.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	СтруктураПредприятия.Ссылка,
		|	&Подразделение,
		|	""""
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Наименование ПОДОБНО &Текст
		|	И Не СтруктураПредприятия.ПометкаУдаления
		|";
		Запрос.УстановитьПараметр("Подразделение", НСтр("ru = 'подразделение'"));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Пояснение1)
			И ЗначениеЗаполнено(Выборка.Пояснение2) Тогда 
			ТекстПояснения = СтрШаблон(" (%1, %2)",
				Выборка.Пояснение1,
				Выборка.Пояснение2);
		ИначеЕсли ЗначениеЗаполнено(Выборка.Пояснение1) Тогда
			ТекстПояснения = СтрШаблон(" (%1)",
				Выборка.Пояснение1);
		ИначеЕсли ЗначениеЗаполнено(Выборка.Пояснение2) Тогда
			ТекстПояснения = СтрШаблон(" (%1)",
				Выборка.Пояснение2);
		Иначе
			ДанныеВыбора.Добавить(Выборка.Ссылка);
			Продолжить;
		КонецЕсли;
		ПредставлениеФорматированнаяСтрока = Новый ФорматированнаяСтрока(
			Строка(Выборка.Ссылка), 
			Новый ФорматированнаяСтрока(ТекстПояснения,, WebЦвета.Серый));
		ДанныеВыбора.Добавить(Выборка.Ссылка, ПредставлениеФорматированнаяСтрока);
	КонецЦикла;
	
	// Автоподстановки.
	Если ДополнениеТипа.СодержитТип(Тип("Строка")) Тогда
		ДоступныеФункции = ШаблоныБизнесПроцессов.ПолучитьСписокДоступныхФункций(ИменаПредметовДляФункций, Ложь);
		Для Каждого ЭлементСписка Из ДоступныеФункции Цикл
			Если НРег(Лев(ЭлементСписка.Представление, СтрДлина(Текст))) = НРег(Текст) Тогда 
				ДанныеВыбора.Добавить(ЭлементСписка.Представление);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДанныеВыбора;
	
КонецФункции

// Возвращает пользователей переданного подразделения.
//
// Параметры:
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение, пользователи которого возвращаются.
//  СУчетомИерархии - Булево - если Истина, то возвращаются пользователи переданного и подчиненных подразделений,
//                             если Ложь, то только пользователи переданного подразделения, по умолчанию - Ложь.
//  ТолькоДействительныхПользователей - Булево - если Истина, тогда возвращается массив только с действительными пользователями
//                                               не помеченными на удаление, иначе все пользователи подразделения(й).
//
// Возвращаемое значение:
//  Массив - массив пользователей подразделения.
//
Функция ПолучитьПользователейПодразделения(
	Подразделение, СУчетомИерархии = Ложь, ТолькоДействительныхПользователей = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СправочникПользователи.Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК СправочникПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
		|		ПО СправочникПользователи.Ссылка = СведенияОПользователяхДокументооборот.Пользователь";
		
	Условие = "";
	Разделитель = "	";
	
	Если ТолькоДействительныхПользователей Тогда
		Условие = Условие +
			"	НЕ СправочникПользователи.ПометкаУдаления
			|	И НЕ СправочникПользователи.Недействителен";
		Разделитель = "	И ";
	КонецЕсли;
	
	Если СУчетомИерархии Тогда
		Условие = Условие
			+ Разделитель 
			+ "СведенияОПользователяхДокументооборот.Подразделение В ИЕРАРХИИ (&Подразделение)";
	Иначе
		Условие = Условие
			+ Разделитель
			+ "СведенияОПользователяхДокументооборот.Подразделение = &Подразделение";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Условие) Тогда
		Запрос.Текст = Запрос.Текст
			+ Символы.ПС + "ГДЕ" + Символы.ПС
			+ Условие;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Получает список пользователей, входящих в рабочую группу.
//
Функция ПолучитьПользователейРабочейГруппы(РабочаяГруппа, СУчетомИерархии = Истина) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РабочиеГруппы.Ссылка
		|ИЗ
		|	Справочник.РабочиеГруппы КАК РабочиеГруппы
		|ГДЕ";
		
	Если СУчетомИерархии Тогда
		Запрос.Текст = Запрос.Текст + " РабочиеГруппы.Ссылка В ИЕРАРХИИ (&Ссылка)";	
	Иначе
		Запрос.Текст = Запрос.Текст + " РабочиеГруппы.Ссылка = &Ссылка";
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", РабочаяГруппа);
    МассивГрупп = Запрос.Выполнить().Выгрузить();	
	Для Каждого Группа из МассивГрупп Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СоставыГруппПользователей.Пользователь
			|ИЗ
			|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
			|ГДЕ
			|	СоставыГруппПользователей.ГруппаПользователей = &РабочаяГруппа";

		Запрос.УстановитьПараметр("РабочаяГруппа", Группа.Ссылка);

		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		
		Для Каждого ЭлементСостава Из РезультатЗапроса Цикл
			Если Результат.Найти(ЭлементСостава.Пользователь) = Неопределено Тогда
				Результат.Добавить(ЭлементСостава.Пользователь);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Возврат Результат;
	
КонецФункции

// Возвращает массив пользователей
//
// Возвращаемое значение:
//   Массив
//     СправочникСсылка.Пользователи
//
Функция ПолучитьВсехПользователей() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.ПометкаУдаления = ЛОЖЬ
		|	И Пользователи.Недействителен = ЛОЖЬ
		|	И Пользователи.Служебный = ЛОЖЬ";
		
	ВсеПользователи = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат ВсеПользователи;
	
КонецФункции

// Проверяет, является ли указанный пользователь руководителем.
Функция ЭтоРуководитель(Пользователь) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИСТИНА
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|ГДЕ
	|	НЕ СтруктураПредприятия.ПометкаУдаления
	|	И СтруктураПредприятия.Руководитель = &Пользователь";
		
	Запрос.Параметры.Вставить("Пользователь", Пользователь);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции	

#КонецОбласти