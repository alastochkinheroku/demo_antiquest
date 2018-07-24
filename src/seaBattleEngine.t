//Реализация движка морского боя 1D
#pragma C++

//enum STATE_
#define STATE_OK  1 //ЖИВ
#define STATE_HIT 2 //Подбит
#define STATE_DIE 3 //умер

//Класс юнита на поле
modify Unit
//private:
   mapState = STATE_OK
   life = 0
   allow_move = true
//public:
   selfInit = { //инициализация юнита
      self.mapState = STATE_OK;
	  self.life = self.mapLen;
	  self.allow_move = true;
   }
   decLife = { //уменьшить здоровье, на 1
     if (self.life > 0)
	 {
	   self.life -= 1;
	   if (self.life == 0) self.mapState = STATE_DIE;
	   else self.mapState = STATE_HIT;
	 }
   }  
;

//Класс карты
modify seaMap
//private:   
   len = 0 			//Размер карты
   units = [] 		//список юнитов на карте, для отслеживания
   history = []     //история попаданий
//public:
   selfInit(sz, isPl) = { //начальная инициализация карты
     local i=0;
	 self.len = sz;
	 self.units = [];
	 self.history = [];
	 for (i=0;i<self.len;i++) {
		self.units += [nil];
		self.history += [nil];
	 }		
	 self.isPlayer = isPl;
   }
   randSetup(unitList)={ //случайная расстановка списка юнитов
       local i, step, pos;
	   local free_pos, res_move;	   
	   //Вычисление свободного места = длина уровня минус охотники и по одной клетка между ними
	   free_pos = self.len;
	   for (i=1;i<=length(unitList);i++)
	   {
	      free_pos -= unitList[i].mapLen;
		  if (i>1) free_pos -= 1;
	   }
	   
	   pos = 1;
	   //"\nРасстановка для <<self.len>> (free=<<free_pos>>)\n";
	   for (i=1;i<=length(unitList);i++)
	   {
	      if (free_pos > 0) {
			 step = _rand(free_pos+1)-1;
			 if (step<0) step = 0;
			 free_pos -= step;
			 pos += step;
		  }
		  if (i>1) pos += 1;
	      res_move = self.move(unitList[i], pos);
		  //"шаг <<i>>:pos=<<pos>>, ok=<<res_move>> (free=<<free_pos>> step=<<step>>)\n";
		  pos += unitList[i].mapLen;
	   }
   }
   toString={
      local i=0;
	  local res = '';
      for (i=1;i<=self.len;i++) {
	  	if (self.units[i] != nil) {
		    if (self.history[i] == true) res += self.hitCellSymb;
			else {
#ifdef UNITTEST
				res += self.units[i].mapId;
#else
			    if (self.isPlayer) res += self.units[i].mapId;
				else res += self.unkCellSymb;
#endif
			}
		}
	  	else 
		{
		    if (self.history[i] == true) res += self.emptyCellSymb;
			else res += self.unkCellSymb;
		}
	  }
	  return res;
   }
   move(unit, pos)={//передвинуть юнита на новую позицию
      local i, used, low_neib, hi_heib;
	  if (unit.allow_move == nil) return MAP_MOVE_DISALLOW;
	  if (pos<1) return MAP_MOVE_LOW_EDGE;
	  if (pos>(self.len-unit.mapLen + 1)) return MAP_MOVE_HIGH_EDGE;
	  else 
	  {
	    used = nil;
	    for (i=0;i<unit.mapLen;i++)
	    {
	       if ((self.units[pos+i] != nil) && (self.units[pos+i] != unit))
	  	   {
	  	      used = true;
	  	   }
	    }
	    if (used == nil)
	    {
		   //определяем, есть ли соседи
		   low_neib = pos - 1;
		   hi_heib = pos + unit.mapLen;
		   if ( (low_neib >= 1) && (self.units[low_neib] != nil) && (self.units[low_neib] != unit) ) return MAP_MOVE_TOO_CLOSE_LOW;
		   if ( (hi_heib <= self.len) && (self.units[hi_heib] != nil) && (self.units[hi_heib] != unit) ) return MAP_MOVE_TOO_CLOSE_HI;
	       //освобождаем предыдущее положение
	       for (i=1;i<=self.len;i++) 
		      if (self.units[i] == unit) self.units[i] = nil;
			//Устанавливаем новое положение
		   for (i=0;i<unit.mapLen;i++) self.units[pos+i] = unit;
	       return MAP_MOVE_OK;
	    }
	    else
	    {
	       return MAP_MOVE_NOT_FREE;
	    }
	  }
   }
   
   hit(pos)={//попасть по позиции
      local lf;
	  if (pos<1) return HIT_RES_LOW_EDGE;
	  if (pos>self.len) return HIT_RES_HIGH_EDGE;
	  if (self.history[pos] != nil) return HIT_RES_ALREADY;
	  self.history[pos] = true;
	  if (self.units[pos] != nil)
	  {
	     self.units[pos].decLife;
		 if (self.units[pos].mapState == STATE_HIT) return HIT_RES_GOT;
		 return HIT_RES_KILL;
	  }
	  return HIT_RES_MISS;
   }
;

modify seaAiAbstract
   selfInit(map_size) = {
      local i;
      self.hit_hist = [];
      for (i=0;i<map_size;i++) self.hit_hist += [HIT_HIST_NONE];
	  self.prev_state = STRAT_NONE;
   }
   setResult(pos, hit_res) = {
	   if (hit_res == HIT_RES_GOT || hit_res == HIT_RES_KILL){
	       self.hit_hist[pos] = HIT_HIST_ENEMY;
	       if (hit_res == HIT_RES_KILL) self.prev_state = STRAT_DIE;
		   else self.prev_state = STRAT_HIT;
	   }
	   else if (hit_res == HIT_RES_MISS)
	   {
	       self.hit_hist[pos] = HIT_HIST_MISS;
		   self.prev_state = STRAT_MISS;
	   }
	   else
	   {
	      //неправильная стратегия (с точки зрегия разработки)
		  return nil;
	   }
	   return true;
   }
;

//Глобальный объект игры
modify seaGame
//private:
firstHit = true
levelLen = 0
//public:
    isAllowMove = {
	   return firstHit;
	}
	getMapLen={
	  return levelLen;
	}
	//начало нового боя
	startBattle(lvl_len) = {
	    local i;
	   	self.plMap.selfInit(lvl_len, true);
		self.aiMap.selfInit(lvl_len, nil);
		for (i=1;i<=length(plUnits);i++) self.plUnits[i].selfInit;
		for (i=1;i<=length(aiUnits);i++) self.aiUnits[i].selfInit;
		self.plMap.randSetup(self.plUnits);
		self.aiMap.randSetup(self.aiUnits);
		self.firstHit = true;
		self.aiStrategy.selfInit(lvl_len);
		levelLen = lvl_len;
	}
	//Проверка конца битвы
	checkEnd={
	   local all_die = true;
	   local i;
	   for (i=1;i<=length(self.plUnits);i++) {
		 if (self.plUnits[i].mapState != STATE_DIE) all_die = nil;
	   }
	   if (all_die==true) return GAME_AI_WIN;
	   
	   all_die = true;
	   for (i=1;i<=length(self.aiUnits);i++) {
		 if (self.aiUnits[i].mapState != STATE_DIE) all_die = nil;
	   }
	   if (all_die==true) return GAME_PL_WIN;
	   
	   return GAME_NOT_END;
	}
	
	//Цикл битвы - выстрел по противнику, затем он
	hitMove(pos) = {
	   local res_pl, res_ai, game_res, pos_ai, i;
	   local res_list = [];
	   if (self.firstHit) {
		 for (i=1;i<=length(plUnits);i++) self.plUnits[i].allow_move = nil;
		 for (i=1;i<=length(aiUnits);i++) self.aiUnits[i].allow_move = nil;
		 self.firstHit = nil;
	   }
		
	   res_pl = self.aiMap.hit(pos);
	   //ошибка - игрок сделал неправильное действие
	   if (res_pl <= HIT_RES_ALREADY){
	      res_list += [GAME_HIT_OK_NEXT];
		  res_list += [res_pl];
		  res_list += [nil];
		  return res_list;
	   }
	   game_res = self.checkEnd;
	   if (game_res == GAME_PL_WIN) {
	     res_list += [GAME_HIT_END];
		 res_list += [GAME_PL_WIN];
		 return res_list;
	   }
	   pos_ai = self.aiStrategy.makeHit;
	   res_ai = self.plMap.hit(pos_ai);
	   if (self.aiStrategy.setResult(pos_ai,res_ai) != true) {
			"\n!!!Неверная стратегия ai: <<res_ai>>!\n";
	   }
	   game_res = self.checkEnd;
	   if (game_res == GAME_AI_WIN) {
	     res_list += [GAME_HIT_END];
		 res_list += [GAME_AI_WIN];
		 return res_list;
	   }
	   
	   res_list += [GAME_HIT_OK_NEXT];
	   res_list += [res_pl];
	   res_list += [res_ai];
	   return res_list;
	}
;

/////////////////////////////////////////////////////////////////////////
modify seaAiRandom
   makeHit = {
      local i,free_cells, tar_pos;
	  free_cells = 0;
	  //считаем количество свободных клеток
      for (i=1;i<=length(self.hit_hist);i++){
	     if (self.hit_hist[i]==HIT_HIST_NONE) free_cells += 1;
	  }
	  //целимся
	  tar_pos = _rand(free_cells);
	  for (i=1;i<=length(self.hit_hist);i++){
	     if (self.hit_hist[i]==HIT_HIST_NONE) {
		    tar_pos -= 1;
			if (tar_pos==0) return i;
		 }
	  }
	  return 0;
   }
;

#define AI_ST_RAND 0  //случайный обстрел
#define AI_ST_LEFT 1  //идём влево, пока не убьём
#define AI_ST_RIGHT 2 //идём вправо, пока не убьём

modify seaAiRandomSmart
   ai_state = AI_ST_RAND
   hit_cell = 0
   
   selfInit(map_size) = {
      self.ai_state = AI_ST_RAND;
	  self.hit_cell = 0;
      inherited.selfInit(map_size);
   }
   
   //доступна позиция для прострела
   validHitCell(pos) = {
      if (pos<1) return nil;
	  if (pos>length(self.hit_hist)) return nil;
	  if (self.hit_hist[pos] != HIT_HIST_NONE) return nil;
	  return true;
   }
   
   //Установка зон для поражённого корабля
   makeSpaceZone(pos) = {
      local i;
      
	  //Устанавливаем слева признак границы корабля
	  for (i=pos;i>=2;i--){
		 if ((self.hit_hist[i] == HIT_HIST_ENEMY) && (self.hit_hist[i-1] != HIT_HIST_ENEMY))
		 {
		    if (self.validHitCell(i-1)) self.hit_hist[i-1] = HIT_HIST_SPACE;
		    break;
		 }
	  }
	  
	  //Устанавливаем справа признак границы корабля
	  for (i=pos;i<length(self.hit_hist);i++){
		 if ((self.hit_hist[i] == HIT_HIST_ENEMY) && (self.hit_hist[i+1] != HIT_HIST_ENEMY))
		 {
		    if (self.validHitCell(i+1)) self.hit_hist[i+1] = HIT_HIST_SPACE;
		    break;
		 }
	  }
   }
   
   setResult(pos, hit_res) = {
      //Когда попали, начинаем обстреливать корабль
      if ((self.ai_state == AI_ST_RAND) && (hit_res == HIT_RES_GOT) )
	  {
	     if (self.validHitCell(pos-1) && self.validHitCell(pos+1)) {
		    if (_rand(2)==1) {
				self.hit_cell = pos-1;
				self.ai_state = AI_ST_LEFT;
			}
			else {
			    self.hit_cell = pos+1;
				self.ai_state = AI_ST_RIGHT;
			}
		 }
		 else if (self.validHitCell(pos-1)) {
		    self.hit_cell = pos-1;
			self.ai_state = AI_ST_LEFT;
		 }
		 else if (self.validHitCell(pos+1)) {
			self.hit_cell = pos+1;
		    self.ai_state = AI_ST_RIGHT;
		 }
	  }
	  else //продолжаем обстрел в этом направлении
	  if ((self.ai_state == AI_ST_LEFT) && (hit_res == HIT_RES_GOT) )
	  {
	     if (self.validHitCell(pos-1)) { //идём дальше
			 self.hit_cell = pos-1;
		 }
		 else if (self.validHitCell(pos+2)) //просто дошли до края, пробуем в другую сторону
		 {
		     self.hit_cell = pos+2;
			 self.ai_state = AI_ST_RIGHT;
		 }
		 else {
		    self.ai_state = AI_ST_RAND;
		 }
	  }
	  else //продолжаем обстрел в этом направлении
	  if ((self.ai_state == AI_ST_RIGHT) && (hit_res == HIT_RES_GOT) )
	  {
		if (self.validHitCell(pos+1)) {
			  self.hit_cell = pos+1;
		}
		else if (self.validHitCell(pos-2)) //просто дошли до края, пробуем в другую сторону
		 {
		     self.hit_cell = pos-2;
			 self.ai_state = AI_ST_LEFT;
		 }
		 else {
		    self.ai_state = AI_ST_RAND;
		 }
	  }
	  else //не попали в этом направлении, пытаемся перейти направо
	  if ((self.ai_state == AI_ST_LEFT) && (hit_res == HIT_RES_MISS) )
	  {
	     if (self.validHitCell(pos+2)) {
		    self.hit_cell = pos+2;
		    self.ai_state = AI_ST_RIGHT;
		 }
		 else {
			self.ai_state = AI_ST_RAND;
		 }
	  }
	  else //не попали в этом направлении, пытаемся перейти направо
	  if ((self.ai_state == AI_ST_RIGHT) && (hit_res == HIT_RES_MISS) )
	  {
	     if (self.validHitCell(pos-2)) {
		    self.hit_cell = pos-2;
		    self.ai_state = AI_ST_LEFT;
		 }
		 else {
			self.ai_state = AI_ST_RAND;
		 }
	  }
	  else //не попали в этом направлении, пытаемся перейти направо
	  if ( ((self.ai_state == AI_ST_LEFT) || (self.ai_state == AI_ST_RIGHT)) && (hit_res == HIT_RES_KILL) )
	  {
	    //Подбили, устанавливаем зоны с обеих сторон корабля
		self.makeSpaceZone(pos);
		self.ai_state = AI_ST_RAND;
	  }
	  
	  return inherited.setResult(pos, hit_res);
   }
   
   makeHit = {
      if (self.ai_state == AI_ST_RAND) return inherited.makeHit;
	  else if ( (self.ai_state == AI_ST_LEFT) || (self.ai_state == AI_ST_RIGHT) )  return self.hit_cell;
	  
	  return 0;
   }
;

#pragma C--
