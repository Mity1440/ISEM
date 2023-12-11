#Область ОписаниеПеременных

Перем ВыводитьИнтеграций; 
Перем ИмяВыводимогоВарианта;

#КонецОбласти              

#Область ПрограммныйИИнтерфейс

Процедура УстановитьКоличествоВыводимыхИнтеграций(ВыводитьИнтеграцийКоличество) Экспорт
	ВыводитьИнтеграций = ВыводитьИнтеграцийКоличество;
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
		
	Если ИтоговыеНастройки.Структура.Количество() = 1 
		И ИтоговыеНастройки.Структура[0].ПоляГруппировки.Элементы.Количество() = 0 Тогда 
		ИтоговыеНастройки.Структура[0].ПараметрыВывода.УстановитьЗначениеПараметра("КоличествоЗаписей", ВыводитьИнтеграций);  
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