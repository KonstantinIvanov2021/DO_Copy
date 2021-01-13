
// Возвращает список файлов в указанной папке
// Параметры
// ПапкаXDTO - папка, список файлов в которой надо получить
// 		тип значения - Folder (http://www.1c.ru/docmng)
// Возвращаемое значение
// Список файлов
// 		тип значения - FileList (http://www.1c.ru/docmng)
//
Функция ПолучитьСписокФайлов(ПапкаXDTO) Экспорт
	
	СписокФайловТип = ФабрикаXDTO.Тип("http://www.1c.ru/docmng", "FileList");
	СписокФайлов = ФабрикаXDTO.Создать(СписокФайловТип);
	
	Папка = Справочники.ПапкиФайлов.ПустаяСсылка();
	Если ПапкаXDTO.Code <> Неопределено И Не ПустаяСтрока(ПапкаXDTO.Code) Тогда
		Папка = Справочники.ПапкиФайлов.НайтиПоКоду(ПапкаXDTO.Code);
	ИначеЕсли ПапкаXDTO.Name <> Неопределено И Не ПустаяСтрока(ПапкаXDTO.Name) Тогда
		Папка = Справочники.ПапкиФайлов.НайтиПоНаименованию(ПапкаXDTO.Name);
	КонецЕсли;
	
	Если Папка.Пустая() Тогда
		ВызватьИсключение "Folder not found.";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.Наименование,
		|	Файлы.ТекущаяВерсияРасширение,
		|	Файлы.ТекущаяВерсияРазмер,
		|	Файлы.Описание,
		|	Файлы.Код
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.ВладелецФайла = &ВладелецФайла
		|	И Файлы.ПометкаУдаления = Ложь";

	Запрос.УстановитьПараметр("ВладелецФайла", Папка);
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СведенияОФайле = ФабрикаXDTO.Создать(
			ФабрикаXDTO.Тип("http://www.1c.ru/docmng", "ShortFileInfo"));
			
		СведенияОФайле.Code = ВыборкаДетальныеЗаписи.Код;	
		СведенияОФайле.Name = ВыборкаДетальныеЗаписи.Наименование;	
		СведенияОФайле.Extension = ВыборкаДетальныеЗаписи.ТекущаяВерсияРасширение;
		СведенияОФайле.Description = ВыборкаДетальныеЗаписи.Описание;
		СведенияОФайле.Size = ВыборкаДетальныеЗаписи.ТекущаяВерсияРазмер;
		СписокФайлов.Files.Добавить(СведенияОФайле);
	КонецЦикла;

	Возврат СписокФайлов;
	
КонецФункции

// Создает новую подпапку в указанной папке
// Параметры
// РодительскаяПапкаXDTO - родительская папка
// 		тип значения - Folder (http://www.1c.ru/docmng)
// НаименованиеНовойПапки - наименование новой папки
// 		тип значения - string (http://www.w3.org/2001/XMLSchema)
// ОписаниеНовойПапки - описание новой папки
// 		тип значения - string (http://www.w3.org/2001/XMLSchema)
// Возвращаемое значение
// Папка - описание созданной папки
// 		тип значения - Folder (http://www.1c.ru/docmng)
//
Функция ДобавитьПапку(РодительскаяПапкаXDTO, НаименованиеНовойПапки, ОписаниеНовойПапки) Экспорт
	
	ПапкаТип = ФабрикаXDTO.Тип("http://www.1c.ru/docmng", "Folder");
	Папка = ФабрикаXDTO.Создать(ПапкаТип);	
	
	Если ПустаяСтрока(НаименованиеНовойПапки) Тогда
		ВызватьИсключение "Invalid folder name.";
	КонецЕсли;
	
	РодительскаяПапка = Справочники.ПапкиФайлов.ПустаяСсылка();
	Если РодительскаяПапкаXDTO.Code <> Неопределено И Не ПустаяСтрока(РодительскаяПапкаXDTO.Code) Тогда
		РодительскаяПапка = Справочники.ПапкиФайлов.НайтиПоКоду(РодительскаяПапкаXDTO.Code);
	ИначеЕсли РодительскаяПапкаXDTO.Name <> Неопределено И Не ПустаяСтрока(РодительскаяПапкаXDTO.Name) Тогда
		РодительскаяПапка = Справочники.ПапкиФайлов.НайтиПоНаименованию(РодительскаяПапкаXDTO.Name);
	КонецЕсли;
	
	Если РодительскаяПапка.Пустая() Тогда
		ВызватьИсключение "Parent folder not found.";
	КонецЕсли;
	
	НоваяПапка = Справочники.ПапкиФайлов.СоздатьЭлемент();
	НоваяПапка.Наименование = НаименованиеНовойПапки;
	НоваяПапка.Описание = ОписаниеНовойПапки;
	НоваяПапка.Родитель = РодительскаяПапка;
	НоваяПапка.Записать();
	
	Папка.Code = НоваяПапка.Код;
	Папка.Name = НоваяПапка.Наименование;
	Папка.Description = НоваяПапка.Описание;
		
	Возврат Папка;
	
КонецФункции

// Возвращает данные файла 
// Параметры
// КодФайла - код файла
// 		тип значения - string (http://www.w3.org/2001/XMLSchema)
// Возвращаемое значение
// Данные файла
// 		File (http://www.1c.ru/docmng)
//
Функция ПолучитьФайл(КодФайла) Экспорт
	
	ДанныеФайла = ФабрикаXDTO.Создать(
		ФабрикаXDTO.Тип("http://www.1c.ru/docmng", "File"));
		
	ФайлСсылка = Справочники.Файлы.НайтиПоКоду(КодФайла);
	Если ФайлСсылка.Пустая() Тогда
		ВызватьИсключение "File not found.";
	КонецЕсли;
	
	ДанныеФайла.Name = ФайлСсылка.Наименование;
	ДанныеФайла.Code = ФайлСсылка.Код;
	ДанныеФайла.Extension = ФайлСсылка.ТекущаяВерсияРасширение;
	ДанныеФайла.BinaryData = РаботаСФайламиВызовСервера.ПолучитьДвоичныеДанныеФайла(ФайлСсылка);
	
	Возврат ДанныеФайла;
	
КонецФункции

// Добавляет файл в указанную папку
// Параметры
// ПапкаXDTO - папка
// 		тип значения - Folder (http://www.1c.ru/docmng)
// ФайлXDTO - данные файла
// 		тип значения - File (http://www.1c.ru/docmng)
// Возвращаемое значение
// Сведения о добавленном файле
// 		ShortFileInfo (http://www.1c.ru/docmng)
//
Функция ДобавитьФайл(ПапкаXDTO, ФайлXDTO) Экспорт
	
	СведенияОФайле = ФабрикаXDTO.Создать(
		ФабрикаXDTO.Тип("http://www.1c.ru/docmng", "ShortFileInfo"));
		
	СведенияОФайле.Code = "";	
	СведенияОФайле.Name = "";	
	СведенияОФайле.Extension = "";
	СведенияОФайле.Description = "";
	СведенияОФайле.Size = 0;
	
	ВремяИзменения = ТекущаяДатаСеанса();
	ВремяИзмененияУниверсальное = РаботаСФайламиКлиентСервер.ПолучитьУниверсальноеВремя(ТекущаяДата());
	ДвоичныеДанные = ФайлXDTO.BinaryData;
	Если ДвоичныеДанные.Размер() = 0 Тогда
		ВызватьИсключение "Invalid binary data.";
	КонецЕсли;	
	
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	Папка = Справочники.ПапкиФайлов.ПустаяСсылка();
	Если ПапкаXDTO.Code <> Неопределено И Не ПустаяСтрока(ПапкаXDTO.Code) Тогда
		Папка = Справочники.ПапкиФайлов.НайтиПоКоду(ПапкаXDTO.Code);
	ИначеЕсли ПапкаXDTO.Name <> Неопределено И Не ПустаяСтрока(ПапкаXDTO.Name) Тогда
		Папка = Справочники.ПапкиФайлов.НайтиПоНаименованию(ПапкаXDTO.Name);
	КонецЕсли;
	
	Если Папка.Пустая() Тогда
		ВызватьИсключение "Invalid folder."
	КонецЕсли;
	
	// Создадим карточку Файла в БД
	ОписаниеФайла = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
	ОписаниеФайла.АдресВременногоХранилищаФайла = АдресВременногоХранилищаФайла;
	ОписаниеФайла.ИмяБезРасширения = ФайлXDTO.Name;
	ОписаниеФайла.РасширениеБезТочки = ФайловыеФункцииКлиентСервер.РасширениеБезТочки(ФайлXDTO.Extension);
	ОписаниеФайла.Размер = ДвоичныеДанные.Размер();
	ОписаниеФайла.ВремяИзменения = ВремяИзменения;
	ОписаниеФайла.ВремяИзмененияУниверсальное = ВремяИзмененияУниверсальное;
	
	НовыйФайл = РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(Папка, ОписаниеФайла);
		
	Если НовыйФайл <> Неопределено И Не НовыйФайл.Пустая() Тогда	
		СведенияОФайле.Code = НовыйФайл.Код;	
		СведенияОФайле.Name = НовыйФайл.Наименование;	
		СведенияОФайле.Extension = НовыйФайл.ТекущаяВерсияРасширение;
		СведенияОФайле.Description = НовыйФайл.Описание;
		СведенияОФайле.Size = НовыйФайл.ТекущаяВерсияРазмер;
	КонецЕсли;
	
	Возврат СведенияОФайле;
	
КонецФункции

// Удаляет файл
// Параметры
// КодФайла - код файла
// 		тип значения - string (http://www.w3.org/2001/XMLSchema)
// Возвращаемое значение
// Истина
// 		тип значения - boolean (http://www.w3.org/2001/XMLSchema)
//
Функция УдалитьФайл(КодФайла)
	
	ФайлСсылка = Справочники.Файлы.НайтиПоКоду(КодФайла);
	Если ФайлСсылка.Пустая() Тогда
		ВызватьИсключение "File not found.";
	КонецЕсли;
	
	ФайлОбъект = ФайлСсылка.ПолучитьОбъект();
	ФайлОбъект.УстановитьПометкуУдаления(Истина);
	
	Возврат Истина;
	
КонецФункции

// Находит по имени подпапку в указанной папке
// Параметры
// РодительскаяПапкаXDTO - папка, в которой надо найти подпапку 
// 		тип значения - Folder (http://www.1c.ru/docmng)
// Наименование - имя папки для поиска
// 		тип значения - string (http://www.w3.org/2001/XMLSchema)
// Возвращаемое значение
// Папка
// 		Folder (http://www.1c.ru/docmng)
//
Функция НайтиПапку(РодительскаяПапкаXDTO, Наименование)
	
	ПапкаТип = ФабрикаXDTO.Тип("http://www.1c.ru/docmng", "Folder");
	ПапкаXDTO = ФабрикаXDTO.Создать(ПапкаТип);
	ПапкаXDTO.Code = "";
	ПапкаXDTO.Name = "";
	ПапкаXDTO.Description = "";
	
	РодительскаяПапка = Справочники.ПапкиФайлов.ПустаяСсылка();
	Если РодительскаяПапкаXDTO.Code <> Неопределено И Не ПустаяСтрока(РодительскаяПапкаXDTO.Code) Тогда
		РодительскаяПапка = Справочники.ПапкиФайлов.НайтиПоКоду(РодительскаяПапкаXDTO.Code);
	ИначеЕсли РодительскаяПапкаXDTO.Name <> Неопределено И Не ПустаяСтрока(РодительскаяПапкаXDTO.Name) Тогда
		РодительскаяПапка = Справочники.ПапкиФайлов.НайтиПоНаименованию(РодительскаяПапкаXDTO.Name);
	КонецЕсли;
	
	Если РодительскаяПапка.Пустая() Тогда
		ВызватьИсключение "Parent folder not found.";
	КонецЕсли;
	
	Папка = Справочники.ПапкиФайлов.ПустаяСсылка();
	Если ПустаяСтрока(Наименование) Тогда
		ВызватьИсключение "Invalid folder name.";
	КонецЕсли;
	
	Папка = Справочники.ПапкиФайлов.НайтиПоНаименованию(Наименование, , РодительскаяПапка);
	
	Если Папка <> Неопределено И Не Папка.Пустая() Тогда
		ПапкаXDTO.Code = Папка.Код;
		ПапкаXDTO.Name = Папка.Наименование;
		ПапкаXDTO.Description = Папка.Описание;
	КонецЕсли;
	
	Возврат ПапкаXDTO;
	
КонецФункции
