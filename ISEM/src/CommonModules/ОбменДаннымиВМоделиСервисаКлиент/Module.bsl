///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик запуска клиентского сеанса приложения.
// Если запущен сеанс для автономного рабочего места, то выводит пользователю оповещение
// о необходимости выполнить синхронизацию данных с приложением в Интернете
// (если установлен соответствующий признак).
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Если ОбщегоНазначенияКлиент.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.ЭтоАвтономноеРабочееМесто Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса";
		Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
			ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
		КонецЕсли;
		
		ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса"] =
			ПараметрыРаботыКлиента.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботы;
		
		Если ПараметрыРаботыКлиента.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботы Тогда
			
			ПоказатьОповещениеПользователя(НСтр("ru = 'Автономная работа';
												|en = 'Standalone mode'"), "e1cib/app/Обработка.ВыполнениеОбменаДанными",
				НСтр("ru = 'Рекомендуется синхронизировать данные с приложением в Интернете.';
					|en = 'It is recommended that you synchronize the workstation data with the web application.'"), БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Доопределяет список предупреждений пользователю перед завершением работы системы.
//
// Параметры:
//  Отказ - Булево - признак отказа от выхода из программы. Если в теле процедуры-обработчика установить
//                   данному параметру значение Истина, то работа с программой не будет завершена.
//  Предупреждения - Массив - в массив можно добавить элементы типа Структура,
//                            свойства которой см. в СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	ПараметрыАвтономнойРаботы = СтандартныеПодсистемыКлиент.ПараметрКлиента("ПараметрыАвтономнойРаботы");
	
	Если ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса"] = Истина
		И ПараметрыАвтономнойРаботы.СинхронизацияССервисомДавноНеВыполнялась Тогда
		
		ПараметрыПредупреждения = СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы();
		ПараметрыПредупреждения.РасширеннаяПодсказка = НСтр("ru = 'В некоторых случаях синхронизация данных может занять длительное время:
	        | - медленный канал связи;
	        | - большой объем данных;
	        | - доступно обновление приложения в Интернете.';
	        |en = 'Data synchronization may take a while if:
	        | • The connection is slow
	        | • The amount of data to sync is big
	        | • An application update is available online'");

		ПараметрыПредупреждения.ТекстПредупреждения = НСтр("ru = 'Не выполнена синхронизация данных с приложением в Интернете.';
															|en = 'Data is not synchronized with the web application.'");
		ПараметрыПредупреждения.ТекстФлажка = НСтр("ru = 'Синхронизировать данные с приложением в Интернете';
													|en = 'Synchronize data with web application'");
		ПараметрыПредупреждения.Приоритет = 80;
		
		ДействиеПриУстановленномФлажке = ПараметрыПредупреждения.ДействиеПриУстановленномФлажке;
		ДействиеПриУстановленномФлажке.Форма = "Обработка.ВыполнениеОбменаДанными.Форма.Форма";
		
		ПараметрыФормы = ПараметрыАвтономнойРаботы.ПараметрыФормыВыполненияОбменаДанными;
		ПараметрыФормы = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыФормы, Ложь);
		ПараметрыФормы.Вставить("ЗавершениеРаботыСистемы", Истина);
		ДействиеПриУстановленномФлажке.ПараметрыФормы = ПараметрыФормы;
		
		Предупреждения.Добавить(ПараметрыПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
