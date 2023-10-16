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

#Область ОбработчикиСобытий 

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСхемуПриНеобходимостиПередЗаписью();
	
КонецПроцедуры  

#КонецОбласти  

#Область СлужебныеПроцедурыИФункции 

Процедура ОчиститьСхемуПриНеобходимостиПередЗаписью()
	
	МассивТиповСоСхемами = Новый Массив;
	МассивТиповСоСхемами.Добавить(Перечисления.ТипыФорматаИнтеграцийСистем.ED);
	МассивТиповСоСхемами.Добавить(Перечисления.ТипыФорматаИнтеграцийСистем.XDTO);

	Если МассивТиповСоСхемами.Найти(ТипФормата) = Неопределено Тогда
		Схема = Неопределено;		
	КонецЕсли;
	
КонецПроцедуры  

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru='Недопустимый вызов объекта на клиенте'");
#КонецЕсли 
