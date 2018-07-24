//МИНИ-игра про космические корабли типа морского боя 1D

//основной класс игры
spaceGame : seaGame
;

//Карты для игры
plmap1 : seaMap
   isPlayer = true
;
aimap1 : seaMap
   isPlayer = nil
;

//Класс Космического корабля
modify SpaceShip
#ifndef ENGLISH_VER
  verDoMoveOn(actor, dobj) = {
#else
  verDoMoveTo(actor, dobj) = {
#endif
	if (spaceGame.isAllowMove == nil) printf(IDS_SPACE_START_WARNING);
  }
  
#ifndef ENGLISH_VER
  doMoveOn(actor, dobj) = 
#else
  doMoveTo(actor, dobj) = 
#endif
  {
     local res_move;
	 //только если это числовой объект
     if (isclass(dobj,basicNumObj)) {
		res_move = plmap1.move(self, dobj.value);
		switch (res_move)
		{
			case MAP_MOVE_OK: { printf(IDS_SPACE_MAP_MOVE_OK); map.ldesc;} break;
			case MAP_MOVE_LOW_EDGE: printf(IDS_SPACE_MAP_MOVE_LOW_EDGE);break;
			case MAP_MOVE_HIGH_EDGE:	printf(IDS_SPACE_MAP_MOVE_HIGH_EDGE);break;
			case MAP_MOVE_NOT_FREE: printf(IDS_SPACE_MAP_MOVE_NOT_FREE);break;
			case MAP_MOVE_TOO_CLOSE_LOW:
			case MAP_MOVE_TOO_CLOSE_HI: printf(IDS_SPACE_MAP_MOVE_TOO_CLOSE);break;
			case MAP_MOVE_DISALLOW: printf(IDS_SPACE_MAP_MOVE_DISALLOW);
			default: printf(IDS_SPACE_MAP_ERR_MOVE,res_move); break;
		}
	 }
  }
;

modify plMain
 location=spaceroom
 ldesc=printf(IDS_SPACE_FL_LDESC)
 isPlayer = true
 mapLen = 3
;

modify plFighter
 location=spaceroom
 ldesc=printf(IDS_SPACE_FI_LDESC)
 isPlayer = true
 mapLen = 2
;

modify plBomber
 location=spaceroom
 ldesc=printf(IDS_SPACE_BO_LDESC)
 isPlayer = true
 mapLen = 2
;

//Противники
modify EnemyMain
 mapLen = 3
;

modify EnemyFighter
 mapLen = 2
;

modify EnemyBomber
 mapLen = 2
;

//Описание игры
modify spaceGame
   plUnits = [plFighter, plMain, plBomber]
   plMap = plmap1
   aiUnits = [EnemyBomber, EnemyFighter, EnemyMain]
   aiMap = aimap1
   aiStrategy = seaAiRandomSmart
;

//////////////////////////////////////////////////////////
modify spaceroom
  ldesc = {
	printf(IDS_SPACE_LDESC,spaceGame.getMapLen);
	if (spaceGame.isAllowMove) printf(IDS_SPACE_CANMOVE);
	map.ldesc;
  }
  up = {
    sm.register;
	return startroom;
  }
;

modify map
  location = spaceroom
  ldesc = { 
	//printf(IDS_SPACE_FMT_FLEET,plmap1.toString,aimap1.toString);
	local i,sm;
	local mymap = plmap1.toString;
	local aimap = aimap1.toString;
	printf(IDS_SPACE_MY_FLEET);
	for (i=1;i<=length(mymap);i++){
		sm = substr(mymap,i,1);
		if (sm==plmap1.unkCellSymb) show_image2('cell_empty.png','*');
		else if (sm==plmap1.emptyCellSymb) show_image2('cell_miss.png','0');
		else if (sm==plmap1.hitCellSymb) show_image2('cell_hit.png','X');
		else if (sm==plMain.mapId) show_image2('flagman_ok.png',plMain.mapId);
		else if (sm==plFighter.mapId) show_image2('fighter_ok.png',plFighter.mapId);
		else if (sm==plBomber.mapId) show_image2('bomber_ok.png',plBomber.mapId);
	}
	
	printf(IDS_SPACE_EN_FLEET);
	for (i=1;i<=length(aimap);i++){
       sm = substr(aimap,i,1);
	   if (sm==aimap1.unkCellSymb) show_image2('cell_empty.png','*');
	   else if (sm==aimap1.emptyCellSymb) show_image2('cell_miss.png','0');
	   else if (sm==aimap1.hitCellSymb) show_image2('cell_hit.png','X');
	}
	"<br>";
  }
;

#ifndef ENGLISH_VER
modify moveVerb
	ioAction(onPrep) = 'MoveOn'
;
#endif

//parseErrorParam: function(errnum, str, ...)
//{
	// наберите здесь свой программный код
//	return nil;
//}

modify basicNumObj
#ifndef ENGLISH_VER
	verIoMoveOn(actor) = {}
	ioMoveOn(actor, dobj) = { dobj.doMoveOn(actor, self); }
#else
    verIoMoveTo(actor) = {}
	ioMoveTo(actor, dobj) = { dobj.doMoveTo(actor, self); }
#endif	
	verDoBreak(actor) = {if (Me.location != spaceroom) printf(IDS_SPACE_INV_NUM);}
	doBreak(actor) = {
	    local res_move, game_stat, hit_pl, hit_ai, game_res, need_ai;
		local rand_stop, i, rest_endings;
		res_move = spaceGame.hitMove(self.value);
	    game_stat = res_move[1];
		game_res = res_move[2];
		
		if (global.forceWin == true)
		{
		   game_stat = GAME_HIT_END;
		   game_res = GAME_PL_WIN;
		   global.forceWin = nil;
		}
		
		if (game_stat == GAME_HIT_OK_NEXT)
		{
		   hit_pl = res_move[2];
		   hit_ai = res_move[3];
		   switch(hit_pl)
		   {
		      case HIT_RES_LOW_EDGE: 
			     printf(IDS_SPACE_HIT_RES_LOW_EDGE);
				 need_ai = nil;
				 break;
			  case HIT_RES_HIGH_EDGE: 
			     printf(IDS_SPACE_HIT_RES_HIGH_EDGE);
				 need_ai = nil;
				 break;
		      case HIT_RES_ALREADY: 
			     printf(IDS_SPACE_HIT_RES_ALREADY);
				 need_ai = nil;
				 break;
			  case HIT_RES_MISS: 
			     printf(IDS_SPACE_HIT_RES_MISS);
				 need_ai = true;
				 break;
			  case HIT_RES_GOT: 
			     printf(IDS_SPACE_HIT_RES_GOT);
				 play_sound('hit_enemy.ogg');  
				 need_ai = true;
				 break;
			  case HIT_RES_KILL: 
			     printf(IDS_SPACE_HIT_RES_KILL);
				 play_sound('destroy_enemy.ogg');
				 need_ai = true;
				 break;
		   }
		   
		   if (need_ai)
		   {
		      switch(hit_ai)
			  {
				  case HIT_RES_MISS: 
					 printf(IDS_SPACE_EN_HIT_RES_MISS);
					 break;
				  case HIT_RES_GOT: 
					 printf(IDS_SPACE_EN_HIT_RES_GOT);
					 play_sound('hit_mine.ogg');
					 break;
				  case HIT_RES_KILL: 
					 printf(IDS_SPACE_EN_HIT_RES_KILL);
					 play_sound('hit_mine.ogg');
					 break;
			 }
			 
			 map.ldesc;
		   }
		}
		else if (game_stat == GAME_HIT_END)
		{
		   map.ldesc;
		   if (game_res == GAME_PL_WIN) {
		     printf(IDS_SPACE_VICTORY);
			 
			 //Обработка подсказок
			 rest_endings = [];
			 for (i=1;i<=global.maxscore;i++) rest_endings += [i];
			 for (i=1;i<=length(global.endings);i++) rest_endings -= global.endings(i);
			 //Выбираем случайную концовку
			 rand_stop = _rand(length(rest_endings));
			 switch (rest_endings[rand_stop])
			 {
			    case DIE_BED:  printf(IDS_DIE_BED_HINT); break;
				case DIE_MED:  printf(IDS_DIE_MED_HINT); break;
				case DIE_RUN:  printf(IDS_DIE_RUN_HINT); break;
				case HERO_END: printf(IDS_HERO_END_HINT); break;
				case DEEP_END: printf(IDS_DEEP_END_HINT); break;
				case BUNT_END: printf(IDS_BUNT_END_HINT); break;
				case STAR_END: printf(IDS_STAR_END_HINT); break;
				case DIE_WALK: printf(IDS_DIE_WALK_HINT); break;
				case DIE_YELL: printf(IDS_DIE_YELL_HINT); break;
				case DIE_SLEEP: printf(IDS_DIE_SLEEP_HINT); break;
				case DIE_EAT: printf(IDS_DIE_EAT_HINT); break;
				case DIE_TELE: printf(IDS_DIE_TELE_HINT); break;
				case DIE_ECZO: printf(IDS_DIE_ECZO_HINT); break;
			 }
			 sm.register;
			 play_background('SaReGaMa_-_SaReGaMa_-_Fractal_Universe.ogg');
			 Me.travelTo(startroom);
		   }
		   else if (game_res == GAME_AI_WIN) {
		     printf(IDS_SPACE_DEFEAT);
			 sm.register;
			 play_background('SaReGaMa_-_SaReGaMa_-_Fractal_Universe.ogg');
			 Me.travelTo(startroom);
		   }
		   else 
		   {
		      printf(IDS_SPACE_FMT_UNKNOWN_STATE,game_res);
		   }
		}
	}
;
