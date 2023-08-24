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
	
	Если НЕ Пользователи.ЭтоСеансВнешнегоПользователя() Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Варианты ответов анкет используются только внешними пользователями.';
				|en = 'Questionnaire response options are used only by external users.'"),,,,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
