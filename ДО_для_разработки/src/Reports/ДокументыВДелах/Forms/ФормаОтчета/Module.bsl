
&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
 	ПараметрГод = Новый ПараметрКомпоновкиДанных("Год"); 
	Для Каждого ЭлементНастроек Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если (ТипЗнч(ЭлементНастроек) =  Тип("ЗначениеПараметраНастроекКомпоновкиДанных"))
		   И (ЭлементНастроек.Параметр = ПараметрГод) 
		   И (ЭлементНастроек.Значение = 0) Тогда
 			ЭлементНастроек.Значение = Год(ТекущаяДата());
			ЭлементНастроек.Использование = Истина;
 		КонецЕсли;	
 	КонецЦикла;	
	
КонецПроцедуры
