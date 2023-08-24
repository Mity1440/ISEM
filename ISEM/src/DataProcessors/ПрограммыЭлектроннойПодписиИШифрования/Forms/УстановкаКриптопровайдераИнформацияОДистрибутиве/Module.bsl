///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КонтрольнаяСумма", КонтрольнаяСумма);
	Параметры.Свойство("Дистрибутив", Дистрибутив);
	Параметры.Свойство("Версия", Версия);
	Параметры.Свойство("ИмяПрограммы", ИмяПрограммы);
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Установка %1';
																			|en = 'Install %1'"), ИмяПрограммы);
	Элементы.ДекорацияДистрибутивЗагружен.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дистрибутив %1 успешно загружен и готов к установке.';
																													|en = 'The %1 distribution package is imported and ready for installation.'"), ИмяПрограммы);
	Элементы.Дистрибутив.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Версия: %1';
																									|en = 'Version: %1'"), Версия);
	
	Если ИмяПрограммы = ЭлектроннаяПодписьКлиентСерверЛокализация.ИмяПрограммыVipNet() Тогда
		Элементы.КонтрольнаяСуммаРасширеннаяПодсказка.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Контрольную сумму можно проверить с помощью программы ViPNet HashCalc.
		|Программу можно скачать с сайта <a href = www.infotecs.ru>www.infotecs.ru</a>.';
		|en = 'You can check the checksum using ViPNet HashCalc.
		|You can download the application from <a href = www.infotecs.ru>www.infotecs.ru</a>.'"));
	Иначе
		Элементы.КонтрольнаяСуммаРасширеннаяПодсказка.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Контрольную сумму можно проверить с помощью программы cpverify.exe
		|Программу можно скачать с сайта <a href = www.cryptopro.ru>www.cryptopro.ru</a>.';
		|en = 'You can check the checksum using cpverify.exe
		|You can download the application from <a href = www.cryptopro.ru>www.cryptopro.ru</a>.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Установить(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти