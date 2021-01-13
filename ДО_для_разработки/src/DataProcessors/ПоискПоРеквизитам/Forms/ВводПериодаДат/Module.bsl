
&НаКлиенте
Процедура НеЗаполненоПриИзменении(Элемент)
	
	Элементы.ЗначениеРеквизита.Доступность = НЕ НеЗаполнено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ НеЗаполнено Тогда
		Закрыть(ЗначениеРеквизита);
	Иначе
		Закрыть(НеЗаполнено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.Заголовок = Параметры.ПредставлениеРеквизита;
	ЗначениеРеквизита = Параметры.ЗначениеРеквизита;
	НеЗаполнено = Параметры.НеЗаполнено;
	Элементы.ЗначениеРеквизита.Доступность = НЕ НеЗаполнено;	
	
КонецПроцедуры
