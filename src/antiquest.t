#define USE_HTML_STATUS
#define USE_HTML_PROMPT

#define VERSION_NUM '0.1'

//билиотеки стандартные
#ifndef ENGLISH_VER
#define GENERATOR_INCLUDED
#include <advr.t>
#include <stdr.t>
#include <errorru.t>
#include <extendr.t>
#include <generator.t>

#include <strings_ru.t>

#else
#include <adv.t>               // load generic adventure game "adv.t"
#include <std.t>               // load standard underpinnings
#include <instruct.t>          // подробные инструкции
#include <strings_en.t>
#endif

#include <statemachine.t>


//История: главный герой - злодей, который обманул поселенцев с Марса, обещав им новый дом, на самом деле сделал дешовый корабль
//и собрался их везти на виллу для выполнения злодейских злодейств. Однако, он влюбился в одну из пассажирок и решил стать добрым.
//К этому моменту всех уже начали погружать в анабиоз, он решил перепрограммировать главный компьютер. К сожалению, на Марсе
//колонисты взяли с собой маленькую улиточку, которая затем начала расти и размножаться на борту. Слизь улиток нарушила работу
//компьютеров и роботы решили поднять бунт и ввели в анабиоз ГГ. Однако произошел сбой, у ГГ амнезия, и чтобы придумать что с ним делать,
//его отнесли в его каюту.

#pragma C++


modify global
   endings = [] //Список концовок
   forceWin = nil
;

initRestartEndings: function(ends_arr)
{
	global.endings = ends_arr;
	incscore(length(ends_arr));
}
#include <seaBattleInterface.t>
#include <seaBattleEngine.t>

#ifndef ENGLISH_VER
#include <verbs_ru.t>
#include <objects_ru.t>
#else
#include <verbs_en.t>
#include <objects_en.t>

/* Модифицируем класс локации так, чтобы её название выводилось жирным шрифтом.
 * Будет дейстовать для всех комнат в игре. Только если включен HTML  
 * by GrAnd
*/
#ifdef USE_HTML_STATUS
modify room
dispBeginSdesc = "<b>"
dispEndSdesc = "</b>"
;
#endif

#endif


//Список концовок
#define DIE_BED 1 
#define DIE_MED 2 
#define DIE_RUN 3 
#define HERO_END 4 
#define DEEP_END 5
#define BUNT_END 6 
#define STAR_END 7 
#define DIE_WALK 8
#define DIE_YELL 9
#define DIE_SLEEP 10
#define DIE_EAT 11
#define DIE_TELE 12
#define DIE_ECZO 13

//Проиграть звук в основном канале
play_sound : function(file){
   local sound_str = '<SOUND SRC="../res/sounds/' + file + '" LAYER=FOREGROUND>';
   say(sound_str);
}

play_background : function(file){
   local sound_str = '<SOUND SRC="../res/sounds/' + file + '" LAYER=BACKGROUND REPEAT=LOOP VOLUME=50>';
   "<SOUND CANCEL=BACKGROUND>";
   say(sound_str);
}

//Чито текстовый режим, без картинок
show_image2 : function(file, alt){
   //local sound_str = '<IMG SRC="../res/images/' + file + '" ALT="' + alt + '">';
   //say(sound_str);
   say(alt);
}



//Подключение мини-игр
#include <space.t>

replace version: object
    sdesc = {
	    if (length(global.endings)==0){
			printf(IDS_VERSION_FMT,VERSION_NUM);
		}
    } 
;

replace scoreFormat: function(points, turns)
{
	return IDS_ENDINGS + cvtstr(points) + '/' + cvtstr(global.maxscore);
}

replace scoreRank: function
{
   local i;
   printf(IDS_FOUND_ENDINGS, global.score, global.maxscore);
   for (i=1;i<=length(global.endings);i++) {
     "<<global.endings[i]>>: ";say(textend(global.endings[i]));"\n";
   }
}

replace introduction: function
{
   printf(IDS_INTRO);
}


replace commonInit: function
{
	"\H+"; 
	global.maxscore = 13;
	//машина состояний сюжета
	sm.register;
	//debugTrace(1,true);
	randomize();
	//Включаем музыку только при первом перезапуске
	if (length(global.endings)==0) {
	    //show_image('intro.mng');
		play_background('SaReGaMa_-_SaReGaMa_-_Fractal_Universe.ogg');
	}
#ifdef ENGLISH_VER	
   introduction();
#endif
}

replace turncount: function(parm)
{
   //из оригинального turncount
   incturn();
   global.turnsofar = global.turnsofar + 1;
   scoreStatus(global.score, global.turnsofar);
}

modify Me
  ldesc={printf(IDS_ME_LDESC);}
;


modify anyfixed
	verDoTalk(actor)={}
	
	verDoPull(actor) = {}
	doPull(actor) = {self.doMove(actor);}
	verDoDetach(actor) = {}
	doDetach(actor) = {self.doMove(actor);}
	verDoPush(actor) = {}
	doPush(actor) = {self.doMove(actor);}
	verDoMove(actor) = {}
	verDoWear(actor) = {}
	verDoTake(actor) = {}
	verDoDrop(actor) = {}
	verDoThrow(actor) = {}
	doThrow(actor) = { self.doDrop(actor); }
	verDoLookunder(actor) = {}
	doLookunder(actor) = {self.doSearch(actor);}
	verDoRead(actor) = {}
	verDoLookbehind(actor) = {}
	doLookbehind(actor) = {self.doSearch(actor);}
	verDoTurn(actor) = {}
	verDoTurnon(actor) = {}
	verDoTurnoff(actor) = {}
	verDoScrew(actor) = {}
	verDoUnscrew(actor) = {}
	verDoEat(actor) = {}
	verDoDrink(actor) = {}
	doDrink(actor) = {self.doEat(actor);}
	verDoClean(actor) = {}
	verDoBreak(actor) = {}
	genMoveDir = {self.doMove(Me);}
	verDoSearch(actor) = {}
	verDoListenTo(actor)={}
	verDoSmell(actor)={}
	verDoTouch(actor)={}
;

modify anyroom
   wait = printf(IDS_WAIT_DEFAULT)
   jump = printf(IDS_JUMP_DEFAULT)
   dig =  printf(IDS_DIG_DEFAULT)
   yell = printf(IDS_YELL_DEFAULT)
   
   enterRoom(actor) =	  // sent to room as actor is entering it
   {
        if (!isclass(self,nestedroom)) {
			sm.cs.goNewLock(self); //Переход в новую локацию
		}
		self.lookAround((!self.isseen) || global.verbose);
		if (self.islit)
		{
			if (!self.isseen)
				self.firstseen;
			self.isseen = true;
		}
   }
   
   up = {self.jump; return nil;}
   down = {self.dig; return nil;}
;

modify theHalat
  location = Me
  ldesc = printf(IDS_HALAT_DESC)
  isHim = true
;


modify theRoom
   ldesc = {
      Me.location.lookAround(true);
   }
   location =
   {
	  return parserGetMe().location;
   }
   locationOK = true
   verDoBreak(actor) = {}
   doBreak(actor) = { sm.cs.last_lock.hit; }
   verDoTalk(actor) = {}
   doTalk(actor) = { sm.cs.last_lock.talkdesc; }
   verDoClean(actor)={}
   doClean(actor) = {sm.cs.last_lock.clean;}
   verDoSearch(actor)={}
   doSearch(actor) = {sm.cs.last_lock.search;}
;

modify theWall
   ldesc = printf(IDS_WALL_DEFAULT)
   location =
   {
		return parserGetMe().location;
   }
   locationOK = true
   verDoBreak(actor) = {}
   doBreak(actor) = { sm.cs.last_lock.hit; }
   verDoTalk(actor) = {}
   doTalk(actor) = { sm.cs.last_lock.talkdesc; }
   verDoPush(actor) = {}
   doPush(actor) = { sm.cs.last_lock.hit; }
   verDoClean(actor)={}
   doClean(actor) = {sm.cs.last_lock.clean;}
   verDoSearch(actor)={}
   doSearch(actor) = {sm.cs.last_lock.search;}
;

modify theCeiling
   ldesc = printf(IDS_CEILING_DEFAULT)
   location =
   {
		return parserGetMe().location;
   }
   locationOK = true
   verDoBreak(actor) = {}
   doBreak(actor) = { sm.cs.last_lock.hit; }
   verDoTalk(actor) = {}
   doTalk(actor) = { sm.cs.last_lock.talkdesc; }
   verDoClean(actor)={}
   doClean(actor) = {sm.cs.last_lock.clean;}
   verDoSearch(actor)={}
   doSearch(actor) = {sm.cs.last_lock.search;}
;

modify theFloor
	ldesc = printf(IDS_FLOOR_DEFAULT)
	location =
	{
		return parserGetMe().location;
	}
	locationOK = true		// suppress warning about location being a method
	doSiton(actor) =
	{
		printf(IDS_FLOOR_SIT);
		actor.location.wait;
	}

	doLieon(actor) =
	{
		self.doSiton(actor);
	}
	ioPutOn(actor, dobj) =
	{
		dobj.doDrop(actor);
	}
	ioPutIn(actor, dobj) =
	{
		dobj.doDrop(actor);
	}
	verDoBreak(actor) = {}
	doBreak(actor) = { sm.cs.last_lock.dig; }
	verDoTalk(actor) = {}
	doTalk(actor) = { sm.cs.last_lock.talkdesc; }
	verDoClean(actor)={}
	doClean(actor) = {sm.cs.last_lock.clean;}
	verDoSearch(actor)={}
    doSearch(actor) = {sm.cs.last_lock.search;}
;

//TODO: добавить комнате listen, yell
//               предметам: залезть, открыть, закрыть

////////////////////////////////////////////////////////////////
//Своя комната
////////////////////////////////////////////////////////////////
modify startroom
 ldesc = printf(IDS_STARTROOM_LDESC)
 wait={ printf(IDS_STARTROOM_WAIT); Me.travelTo(coridorroom); }
 noexit = { printf(IDS_STARTROOM_NOEXIT); return coridorroom; }
 jump = { printf(IDS_STARTROOM_JUMP); Me.travelTo(coridorroom); }
 dig = { printf(IDS_STARTROOM_DIG); Me.travelTo(coridorroom); }
 west = coridorroom
 //действия с комнатой
 hit = { printf(IDS_STARTROOM_HIT); Me.travelTo(coridorroom); }
 talkdesc = {printf(IDS_STARTROOM_TALK);  Me.travelTo(coridorroom); }
 clean={printf(IDS_STARTROOM_CLEAN); Me.travelTo(coridorroom);}
 search={printf(IDS_STARTROOM_SEARCH); Me.travelTo(coridorroom);}
 listendesc = printf(IDS_LISTEN_DEFAULT)
;


modify startbed
  location = startroom
  ldesc = printf(IDS_STARTBED_LDESC)
  
  doTalk(actor) = {printf(IDS_STARTBED_TALK);  Me.travelTo(coridorroom); }
  //Стандартные реакции
  doMove(actor) = {printf(IDS_STARTBED_MOVE); Me.travelTo(coridorroom);}
  doTake(actor) = {printf(IDS_STARTBED_TAKE); end_game(DIE_BED); }
  doDrop(actor) = { printf(IDS_STARTBED_DROP); Me.travelTo(coridorroom); }
  doWear(actor) = {printf(IDS_STARTBED_WEAR); Me.travelTo(coridorroom); }
  doRead(actor) = {printf(IDS_STARTBED_READ); Me.travelTo(coridorroom); }
  doTurn(actor) = {printf(IDS_STARTBED_TURN); Me.travelTo(coridorroom); }
  doTurnon(actor) = { printf(IDS_STARTBED_TURNON); Me.travelTo(coridorroom); }
  doTurnoff(actor) = { printf(IDS_STARTBED_TURNOFF); Me.travelTo(coridorroom); }
  doScrew(actor) = { printf(IDS_STARTBED_SCREW); Me.travelTo(coridorroom); }
  doUnscrew(actor) = { printf(IDS_STARTBED_UNSCREW); Me.travelTo(coridorroom); }
  doEat(actor) = { printf(IDS_STARTBED_EAT); Me.travelTo(coridorroom); }
  doClean(actor) = { printf(IDS_STARTBED_CLEAN); Me.travelTo(coridorroom); }
  doBreak(actor) = {printf(IDS_STARTBED_BREAK); Me.travelTo(coridorroom);}
  doSearch(actor) = {printf(IDS_STARTBED_SEARCH); Me.travelTo(coridorroom);}
  doListenTo(actor)=printf(IDS_STARTBED_LISTENTO)
  doSmell(actor)=printf(IDS_STARTBED_SMELL)
  doTouch(actor)={ printf(IDS_STARTBED_TOUCH); Me.travelTo(coridorroom); }
;

/////////////////////////////

modify coridorroom
  ldesc = printf(IDS_CORID_LDESC)
  north = {
	return startroom;
  }
  south = {
	return startroom;
  }
  wait={ printf(IDS_CORID_WAIT); end_game(DIE_WALK); }
  noexit = { printf(IDS_CORID_NOEXIT); return startroom; }
  jump = { printf(IDS_CORID_JUMP); Me.travelTo(startroom); }
  dig = {printf(IDS_CORID_DIG); Me.travelTo(startroom); }
  hit = { printf(IDS_CORID_HIT); Me.travelTo(startroom); }
  talkdesc = printf(IDS_CORID_TALKDESC)
  clean=printf(IDS_CORID_CLEAN)
  search=printf(IDS_CORID_SEARCH)
  listendesc = printf(IDS_LISTEN_DEFAULT)
;

///////////////////////////

//Состояние игры
class GameState : State
   last_lock = startroom
   //Переход в новую локацию
   goNewLock(rm) = {
     if (rm != self.last_lock) {
	    //"*НОВАЯ ЛОКАЦИЯ*";
		self.last_lock = rm;
	    //Сбрасываем счетчик, если это новая локация
	    self.nextState(self);
	 }
   }
   //Каждый ход
   nextTurn(turn)={
      local need_next = nil;
      //Форсированный переход в новую локацию, если герой долго осматривает, думает
      if (turn>=5) 
	  {
	     //"*ПЕРЕХОД*";
	     if (self.last_lock==startroom) {
		    printf(AUTO_MOVE_STARTROOM);
		    Me.travelTo(coridorroom);
			need_next = true;
		 }
		 else if (self.last_lock==coridorroom) {
		    printf(AUTO_MOVE_CORIDOR);
			Me.travelTo(startroom);
			need_next = true;
		 }
		 
		 if (need_next)
		 {
			//Переходим в себя же
			self.nextState(self);
		 }
	  }
   }
;

//Машина состояний - подключается в начале
sm : StateMachine
   cs = GameState
;


//Обработка концовок

textend: function(code)
{
   switch(code)
   {
     case DIE_BED: return   IDS_DIE_BED;
	 case DIE_MED: return   IDS_DIE_MED;
	 case DIE_RUN: return   IDS_DIE_RUN;
	 case HERO_END: return  IDS_HERO_END;
	 case DEEP_END: return  IDS_DEEP_END;
	 case BUNT_END: return  IDS_BUNT_END;
	 case STAR_END: return  IDS_STAR_END;
	 case DIE_WALK: return  IDS_DIE_WALK;
	 case DIE_YELL: return  IDS_DIE_YELL;
	 case DIE_SLEEP: return IDS_DIE_SLEEP;
	 case DIE_EAT: 	return  IDS_DIE_EAT;
	 case DIE_TELE: return  IDS_DIE_TELE;
	 case DIE_ECZO: return IDS_DIE_ECZO;
   }
}

effectsend: function(code)
{
   switch(code)
   {
     case DIE_BED:   play_sound('bed-jumping.ogg'); /*show_image('die_bed.png');*/ break;
	 case DIE_MED:   /*show_image('die_med.png');*/ break;
	 case DIE_RUN:   play_sound('sportcars.ogg');  /*show_image('bucket.png');*/ break;
	 case HERO_END:  play_sound('scifi-engine-startup.ogg'); /*show_image('control_panel.png');*/ break;
	 case DEEP_END:  /*show_image('far_galaxy.jpg');*/ break;
	 case BUNT_END:  play_sound('robotic-laugh.ogg'); /*show_image('bunt.png');*/ break;
	 case STAR_END:  play_sound('lostinspace.ogg'); /*show_image('die_star.jpg');*/ break;
	 case DIE_WALK:  /*show_image('sleepers.jpg');*/ break;
	 case DIE_YELL:  /*show_image('cable.jpg');*/ break;
	 case DIE_SLEEP: /*show_image('sea.jpg');*/ break;
	 case DIE_EAT:   /*show_image('snail.jpg');*/  break;
	 case DIE_TELE:  /*show_image('tvset.jpg');*/  break;
	 case DIE_ECZO:  /*show_image('high_voltage.png');*/  break;
   }
}

startbattle : function
{
    local len_field = _rand(5)+12;
	sm.unregister;
	printf(IDS_SPACE_INTRO, len_field);
	spaceGame.startBattle(len_field);
	Me.travelTo(spaceroom);
}

end_game: function(code)
{
	if (find(global.endings,code)==nil){
	    effectsend(code);
		printf(IDS_FMT_NEW_ENDING, code);
		incscore(1);
		global.endings += [code];
	}
	else {
	   printf(IDS_FMT_OLD_ENDING, code);
	   
	   //Запуск космического боя
	   if (_rand(2)==1)
	   {
	      play_background('Capashen_-_Departure__Electro_.ogg');
	      //show_image('spacepilot.jpg');
		  startbattle();
		  abort;
	   }
	}
    scoreRank();
    //Новая игра
	printf(IDS_START_NEW_GAME);
	scoreStatus(0, 0);
    restart(initRestartEndings, global.endings);
}


