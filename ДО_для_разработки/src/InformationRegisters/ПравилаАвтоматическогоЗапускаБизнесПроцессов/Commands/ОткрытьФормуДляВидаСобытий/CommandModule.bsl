
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ВидСобытия, Заголовок", ПараметрКоманды, НСтр("ru='Правила автозапуска процесса'"));
	ОткрытьФорму("РегистрСведений.ПравилаАвтоматическогоЗапускаБизнесПроцессов.Форма.ФормаСпискаДляВидаСобытия",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
