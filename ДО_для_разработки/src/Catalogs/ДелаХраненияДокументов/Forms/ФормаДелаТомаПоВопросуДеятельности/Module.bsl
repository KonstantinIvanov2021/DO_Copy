
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВопросыДеятельности = Новый Массив;
			
	врВопросДеятельности = Параметры.ВопросДеятельности;
	Пока ЗначениеЗаполнено(врВопросДеятельности) Цикл
		ВопросыДеятельности.Добавить(врВопросДеятельности);
		врВопросДеятельности = врВопросДеятельности.Родитель;
	КонецЦикла;
	
	Список.Параметры.УстановитьЗначениеПараметра("ВопросыДеятельности", ВопросыДеятельности);
	
КонецПроцедуры
