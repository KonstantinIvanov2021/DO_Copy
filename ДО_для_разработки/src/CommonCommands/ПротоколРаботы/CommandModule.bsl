
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("ОбъектДанных", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.ПротоколРаботыПользователей.Форма.ПротоколРаботы", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
