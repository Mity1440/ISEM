#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
	
// ISEM: Менеджер интеграций между информационными системами
//
// Copyright 2017-2023 Dmitry Makarevich (Mity1440)
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//
// URL:    https://github.com/Mity1440/ISEM
// e-mail: mitia.mackarevich@yandex.ru

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

#Область Версия_2023_12_1_0

// Заполнить значения данных интеграции для списка
// 
Процедура ЗаполнитьДанныеИнтеграцийДляСписка_2023_12_1_0(Параметры) Экспорт
	
	ПаузаПриВыполненииОбработчика = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбновлениеИБ", "ПаузаПриВыполненииОбработчика", 0);
	Если ПаузаПриВыполненииОбработчика <> 0 Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбновлениеИБ", "ПаузаПриВыполненииОбработчика", 0);
	КонецЕсли;
	
	// Выборка данных для многопоточного обновления.
	ИнтеграцииСистем = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Для каждого Интеграция Из ИнтеграцииСистем Цикл
		
		Попытка
			
			ЗаписатьДанныеИнтеграцииСистемДляСписка(Интеграция.Ссылка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
				
			Если ПаузаПриВыполненииОбработчика <> 0 Тогда
				// АПК:277-выкл для целей тестирования.
				ОбновлениеИнформационнойБазыСлужебный.Пауза(ПаузаПриВыполненииОбработчика);
				// АПК:277-вкл
				ПаузаПриВыполненииОбработчика = 0;
			КонецЕсли;
			// Конец имитации ошибки.
			
		Исключение
			// Если не удалось обработать какой-либо заказ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать заказ покупателя %1 по причине:
					|%2'"), 
					Интеграция.Ссылка, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.ИнтеграцииСистем, Интеграция.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ИнтеграцииСистем");
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые интеграции систем (пропущены): %1'"), 
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ИнтеграцииСистем,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработана очередная порция интеграций систем: %1'"),
				ОбъектовОбработано));
	КонецЕсли;
	
	
КонецПроцедуры 

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватДанныеИнтеграцийДляСпискаКОбработкеДляПереходаНа_2023_12_1_0(Параметры) Экспорт
	
	// Параметры выборки данных для многопоточного обновления.
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.ИнтеграцииСистем";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнтеграцииСистем.Ссылка
	|ИЗ
	|	Справочник.ИнтеграцииСистем КАК ИнтеграцииСистем
	|ГДЕ
	|	НЕ ИнтеграцииСистем.ПометкаУдаления";
		
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);

КонецПроцедуры

Процедура ЗаписатьДанныеИнтеграцииСистемДляСписка(ИнтеграцияСсылка)
	
	НачатьТранзакцию();
	Попытка
	
		// Блокируем объект от изменения другими сеансами.
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ИнтеграцииСистем");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ИнтеграцияСсылка);
		Блокировка.Заблокировать();
		
		РегистрыСведений.ИнтеграцииСистемДанныеДляСписка.ЗаписатьДанные(ИнтеграцияСсылка, Ложь);
		
		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ИнтеграцияСсылка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли