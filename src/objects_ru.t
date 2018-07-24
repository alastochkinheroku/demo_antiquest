#pragma C++

//////////////////////////////////////////////
////////////Объекты игры
//Общие

modify Me
  lico=1
  desc ='я'
  isHim = true
  sdesc="я"
  rdesc="меня"
  ddesc="мне"
  vdesc="меня"
  tdesc="мною"
  pdesc="меня"
;

theHalat : decoration
  desc = 'халат/1м'
;

theRoom: fixeditem, floatingItem
   desc='комната/1ж'	 
   noun = 'комната/1ж' 'каюта/1ж'
   isHer = true
;

theWall: fixeditem, floatingItem
   desc='стена/1ж'	 
   noun = 'стена/1ж' 'стены/2'
   isHer = true
;

theCeiling: fixeditem, floatingItem
   desc='потолок/1м'	 
   isHim = true
;

replace theFloor: beditem, floatingItem
	noun = 'пол' 'пола' 'полу' 'полом' 'поле' 'полом#t' 
	desc='пол/1м'	 
	isHim = true
	statusPrep = "на"
	outOfPrep = "с"
	ioThrowAt(actor, dobj) =
	{
		"Сказано - брошено. ";
		dobj.moveInto(actor.location);
	}
	noexit =
	{
		"<<ZAG(parserGetMe(),&sdesc)>> никуда не <<glok(parserGetMe(),1,2,'пойд')>> пока
		не <<glok(parserGetMe(),1,1,'встан')>> <<outOfPrep>> <<rdesc>>. ";
		return nil;
	}
;

//Комнаты+ их Объекты 
class anyroom : room
;

class anyfixed : fixeditem
;

//

startroom: anyroom
 sdesc="В своей каюте"
;

startbed : anyfixed, beditem
  desc = 'койка/1ж'
  noun = 'койка/1ж' 'кровать/1ж'
  adjective = 'длинная/1пж'
  isHer=true
;

//
coridorroom: anyroom
  sdesc="Коридор"
;

//
techsection : anyroom
  sdesc = "Техническая секция"
;

kabel : anyfixed, beditem
  desc = 'кабель/1м'
  noun = 'кабель/1м' 'провод/1м'
  adjective = 'толстый/1пм'
  isHim=true
;
//
medroom : anyroom
  sdesc = "Медицинский отсек"
;

robotmed : anyfixed, chairitem
  desc = 'робот/1мо'
  noun = 'робот/1мо' 'медик/1мо' 'врач/1мо' 'сиденье/1с' 'голова/1ж'
  adjective = 'человекоподобный/1пм' 'мягкое/1пс'
  isHim=true
;

//
coridorrun: anyroom
  sdesc="Бегство в коридоре"
;

///////////////////////////////////////////////////////////////
//SPACE
class SpaceShip : fixeditem, Unit
;

plMain: SpaceShip
 desc = 'флагман/1м'
 noun ='флагман/1м' 'фл/1м'
 isHim = true
 mapId = 'Ф'
;

plFighter: SpaceShip
 desc='истребитель/1м'
 noun = 'истребитель/1м' 'ис/1м'
 isHim = true
 mapId = 'И'
;

plBomber: SpaceShip
 desc = 'бомбардировщик/1м'
 noun = 'бомбардировщик/1м' 'бо/1м'
 isHim = true
 mapId = 'Б'
;

EnemyMain: SpaceShip
 desc='вражеский/1пмо флагман/1мо'
 isHim = true
 mapId = 'Ф'
;

EnemyFighter: SpaceShip
 desc='вражеский/1пмо истребитель/1мо'
 isHim = true
 mapId = 'И'
;

EnemyBomber: SpaceShip
 desc='невысокий/1пмо охотник/1мо'
 isHim = true
 mapId = 'Б'
;

spaceroom: room
  sdesc="На орбите"
;

map : fixeditem
  desc = 'карта/1ж'
  isHer = true
;


//////////////////////////////////////////////////////
replace parseError: function(errnum, str)
{
    // if there's an allMessage waiting, use it instead of the default
    if (global.allMessage != nil)
        {
        local r;
        r = global.allMessage;
        global.allMessage = nil;
        return r;
        }
    else
    switch (errnum)
    {
    case 1: return 'Что это за пунктуация такая: "%c"??? Непонятно.'; break;
    case 2: return 'К счастью, такое слово как "%s" мне неизвестно.'; break;
    case 3: return 'Слово "%s" относится к слишком большому числу объектов.'; break;
    case 4: return 'Я думаю, Вы собирались написать после существительного определение.';  break;
    case 5: return 'Я думаю, Вы собирались написать определение после "оба".'; break;
    case 6: return 'Я ожидал существительное после предлога, задающего категорию предмета.'; break;
    case 7: return 'Ошибка номер7. Кто это увидел, сообщите как она возникла!';break;
    case 9: return 'Да где тут объект "%s"? Я нигде его не вижу!'; break;
    case 10: return 'Вы ссылаетесь на слишком большое количество объектов словом "%s".';break;
    case 11: return 'Вы ссылаетесь на слишком большое количество объектов.'; break;
    case 12: return 'Вы можете говорить только с одной персоной одновременно.';break;
    case 13: return 'На что это вы ссылаетесь словом "%s". Пишите понятнее...';  break;
    case 14: return 'На что ссылаетесь, вообще непонятно.';  break;
    case 15: return 'А вот мне не видно, на что вы ссылаетесь.'; break;
    case 16: return 'Я не вижу здесь этого.'; break;
    case 17: return 'А где же глагол в предложении? Забыли?';   break;
    case 18: return 'Я не понимаю это предложение.';  break;
    case 19: return //'После вашей команды не хватает слова.'; break;
    'В конце Вашей команды есть слова, которые я не могу использовать.'; break;
    case 20: return 'Не знаю как использовать слово "%s" таким образом.'; break;
    case 21: return 'После вашей команды есть лишние слова.';  break;
    case 22: return 'Похоже, после вашей команды есть лишние слова.';  break;
    case 24: return 'Я не понимаю это предложение.';  break;
    case 25: return 'Нельзя использовать много косвенных объектов.';  break;
    case 26: return 'Нет команды для повторения.';  break;
    case 27: return 'Эту команду нельзя повторить.'; break;
    case 28: return 'Эту команду нельзя применять к множеству объектов.';break;
    case 29: return 'Я думаю, Вы собирались написать определение после "любой".'; break;
    case 30: return 'Я вижу только %d из них.';   break;
    case 31: return 'С этим нельзя разговаривать.';   break;
    case 38: return 'Здесь больше этого не видно.'; break;
    case 39: return 'Здесь этого не видно.';   break;
    case 160: return 'Вам придется подробнее описать какой "%s" Вы имеете в виду.';   break;
    default:  return nil;
    }
}
  
#pragma C-