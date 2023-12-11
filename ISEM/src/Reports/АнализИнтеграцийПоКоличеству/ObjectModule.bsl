#Область ОписаниеПеременных

Перем ВыводитьКоличествоИС; 
Перем ОтборТехнологияИнтеграции;
Перем ИмяВыводимогоВарианта;

#КонецОбласти              

#Область ПрограммныйИИнтерфейс

Процедура УстановитьКоличествоИС(КоличествоИС) Экспорт
	ВыводитьКоличествоИС = КоличествоИС;
КонецПроцедуры

Процедура УстановитьТехнологиюИнтеграции(ТехнологияИнтеграции) Экспорт
	ОтборТехнологияИнтеграции = ТехнологияИнтеграции;
КонецПроцедуры           

Процедура УстановитьИмяВыводимогоВарианта(Имя) Экспорт
	ИмяВыводимогоВарианта = Имя;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;  
	
	Если ИмяВыводимогоВарианта = Неопределено Тогда
		ИтоговыеНастройки = КомпоновщикНастроек.ПолучитьНастройки();
	Иначе
		Вариант = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВыводимогоВарианта);
		ОбщегоНазначенияКлиентСервер.Проверить(НЕ Вариант = Неопределено, СтрШаблон("Варианта: %1 не существует", ИмяВыводимогоВарианта));
		ИтоговыеНастройки = Вариант.Настройки
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяВыводимогоВарианта) Тогда 
		ИтоговыеНастройки.Структура[0].Серии[0].ПараметрыВывода.УстановитьЗначениеПараметра("КоличествоЗаписей", ВыводитьКоличествоИС);
		Если ЗначениеЗаполнено(ОтборТехнологияИнтеграции) Тогда
			ЭлементОтборТехнологияИнтеграции = ИтоговыеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтборТехнологияИнтеграции.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТехнологияИнтеграции"); 
			ЭлементОтборТехнологияИнтеграции.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтборТехнологияИнтеграции.ПравоеЗначение = ОтборТехнологияИнтеграции;
		КонецЕсли;
	КонецЕсли;
		
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, ИтоговыеНастройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновкиДанных, , ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.НачатьВывод();

	Пока Истина Цикл

		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			Прервать;
		КонецЕсли;		

		ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);

	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();	

КонецПроцедуры

#КонецОбласти            

#Область Инициализация

ВыводитьИнтеграций = 10;

#КонецОбласти 