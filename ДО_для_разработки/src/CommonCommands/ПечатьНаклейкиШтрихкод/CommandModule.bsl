
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
#Если НЕ ВебКлиент Тогда
	ЗаголовокПриложения = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЗаголовокПриложения;
	ТабличныйДокумент = ПолучитьПечатнуюФорму(ПараметрКоманды, ЗаголовокПриложения);
	
	Если ТабличныйДокумент <> Неопределено Тогда
		ТабличныйДокумент.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
		Оповестить("НапечатанШтрихкод",ПараметрКоманды); 
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Для шаблонов файлов штрихкод не формируется.'"));
	КонецЕсли;
#Иначе
	ПоказатьПредупреждение(, НСтр("ru = 'В веб-клиенте выполнение данной операции невозможно.'"));
#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПечатнуюФорму(ПараметрКоманды, ЗаголовокПриложения)
	
	ДанныеОШтрихкоде = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(ПараметрКоманды, Ложь);
	Если ДанныеОШтрихкоде = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Для файлов, находящихся в папке ""Шаблоны файлов"", а также для файлов, прикрепленных к должности или контрагенту,
			|штрихкод не формируется.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если ДанныеОШтрихкоде.Свойство("СообщениеОбОшибке") Тогда
		ВызватьИсключение(ДанныеОШтрихкоде.СообщениеОбОшибке);
	КонецЕсли;
	
	НастройкиШтрихкода = ШтрихкодированиеСервер.ПолучитьПерсональныеНастройкиПоложенияШтрихкодаНаСтранице();
	
	ВысотаНаклейки = НастройкиШтрихкода.ВысотаНаклейки;
	ШиринаНаклейки = НастройкиШтрихкода.ШиринаНаклейки;
	Если ВысотаНаклейки = Неопределено
		ИЛИ ПустаяСтрока(ВысотаНаклейки) Тогда
		ВысотаНаклейки = 20;
		ШиринаНаклейки = 38;
		ХранилищеОбщихНастроек.Сохранить("НастройкиШтрихкода", "ШиринаНаклейки", ШиринаНаклейки);
		ХранилищеОбщихНастроек.Сохранить("НастройкиШтрихкода", "ВысотаНаклейки", ВысотаНаклейки);
	КонецЕсли;
	
	ТабДокумент = Новый ТабличныйДокумент();
	Макет = ПолучитьОбщийМакет("НаклейкаШтрихкод");
    ТабДокумент.ШиринаСтраницы = ШиринаНаклейки;
	ТабДокумент.ВысотаСтраницы = ВысотаНаклейки;
	ТабДокумент.ИмяПринтера = Макет.ИмяПринтера;
	ТабДокумент.ВерхнийКолонтитул.Выводить = Ложь;
	ТабДокумент.НижнийКолонтитул.Выводить = Ложь;
	ТабДокумент.ОбластьПечати = Макет.ОбластьПечати;
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу = 0;
	ТабДокумент.ПолеСверху = 0;
	ТабДокумент.ПолеСнизу = 0;
	ТабДокумент.ПолеСлева = 0;
	ТабДокумент.ПолеСправа = 0;
	Шапка = Макет.ПолучитьОбласть("Шапка");
	
	РисунокШтрихкод = Шапка.Область("Штрихкод");
    
	РисунокШтрихкод.Верх = 1;
	РисунокШтрихкод.Лево = 1;
	РисунокШтрихкод.Ширина = ШиринаНаклейки - 2;
	РисунокШтрихкод.Высота = ВысотаНаклейки - 2;
	
	ДанныеОШтрихкоде.ДвоичныеДанныеИзображения = ШтрихкодированиеСервер.ПолучитьКартинкуШтрихкода(ДанныеОШтрихкоде.Штрихкод, , РисунокШтрихкод.Высота, Истина).ПолучитьДвоичныеДанные();
	
	КартинкаШтрихкода = Новый Картинка(ДанныеОШтрихкоде.ДвоичныеДанныеИзображения);
	РисунокШтрихкод.Картинка = КартинкаШтрихкода;
	
	ТабДокумент.Вывести(Шапка);
	
	Возврат ТабДокумент; 
	
КонецФункции
