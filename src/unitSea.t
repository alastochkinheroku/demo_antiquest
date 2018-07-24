//Юнит-тесты для морсого боя
#include <unittest.t>
#define UNITTEST
//Интерфейс и движок
#include <seaBattleInterface.t>
#include <seaBattleEngine.t>
#define NO_SAY_PRINTF
#include <strings.t>

#pragma C++

//Юнит-тесты
tstunit : Unit
   mapId = '1'
   mapLen = 1
   isPlayer = nil
;

Test1: Test
    name = 'Установка юнита'
	exec={
	   tstunit.selfInit;
	   CHECK_EQU(tstunit.mapState, STATE_OK);
	   CHECK_EQU(tstunit.life, 1);
	   CHECK_EQU(tstunit.allow_move, true);
	}
;

tstunit_health : Unit
   mapLen = 3
;

Test1_h: Test
    name = 'Уменьшение здоровья юнита'
	exec={
	   tstunit_health.selfInit;
	   CHECK_EQU(tstunit_health.mapState, STATE_OK);
	   CHECK_EQU(tstunit_health.life, 3);
	   tstunit_health.decLife;
	   CHECK_EQU(tstunit_health.mapState, STATE_HIT);
	   CHECK_EQU(tstunit_health.life, 2);
	   tstunit_health.decLife;
	   CHECK_EQU(tstunit_health.mapState, STATE_HIT);
	   CHECK_EQU(tstunit_health.life, 1);
	   tstunit_health.decLife;
	   CHECK_EQU(tstunit_health.mapState, STATE_DIE);
	   CHECK_EQU(tstunit_health.life, 0);
	   tstunit_health.decLife;
	   CHECK_EQU(tstunit_health.mapState, STATE_DIE);
	   CHECK_EQU(tstunit_health.life, 0);
	}
;

/////////////////////
tstmap : seaMap
   isPlayer = true
;

Test2: Test
    name = 'Установка карты'
	exec={
	   tstmap.selfInit(7,true);
	   CHECK_EQU(tstmap.len, 7);
	   CHECK_EQU(length(tstmap.units), 7);
	   CHECK_EQU(length(tstmap.history), 7);
	}
;

Test3: Test
    name = 'Печать пустой карты'
	exec={
	   tstmap.selfInit(5,true);
	   CHECK_EQU(tstmap.toString, '_____');
	}
;

Test4: Test
    name = 'Перемещение юнита успешное'
	exec={
	   tstmap.selfInit(3,nil);
	   tstunit.selfInit;
	   CHECK_EQU(tstmap.move(tstunit, 1), MAP_MOVE_OK);
	   CHECK_EQU(tstmap.toString, '1__');
	   CHECK_EQU(tstmap.move(tstunit, 2), MAP_MOVE_OK);
	   CHECK_EQU(tstmap.toString, '_1_');
	   CHECK_EQU(tstmap.move(tstunit, 3), MAP_MOVE_OK);
	   CHECK_EQU(tstmap.toString, '__1');
	}
;

tstunit2 : Unit
   mapId = '2'
   mapLen = 1
   isPlayer = nil
;

Test5: Test
    name = 'Перемещение юнита неуспешное'
	exec={
	   tstmap.selfInit(2,nil);
	   tstunit.selfInit;
	   CHECK_EQU(tstmap.move(tstunit, 0), MAP_MOVE_LOW_EDGE);
	   CHECK_EQU(tstmap.toString, '__');
	   CHECK_EQU(tstmap.move(tstunit, 3), MAP_MOVE_HIGH_EDGE);
	   CHECK_EQU(tstmap.toString, '__');
	   tstunit2.selfInit;
	   tstmap.move(tstunit2, 1);
	   CHECK_EQU(tstmap.move(tstunit, 1), MAP_MOVE_NOT_FREE);
	   CHECK_EQU(tstmap.toString, '2_');
	   CHECK_EQU(tstmap.move(tstunit, 2), MAP_MOVE_TOO_CLOSE_LOW);
	   CHECK_EQU(tstmap.toString, '2_');
	   tstmap.move(tstunit2, 2);
	   CHECK_EQU(tstmap.move(tstunit, 1), MAP_MOVE_TOO_CLOSE_HI);
	   CHECK_EQU(tstmap.toString, '_2');
	   tstunit.allow_move = nil;
	   CHECK_EQU(tstmap.move(tstunit, 2), MAP_MOVE_DISALLOW);
	   CHECK_EQU(tstmap.toString, '_2');
	}
;


///////////////////
tstunit3 : Unit
   mapId = '3'
   mapLen = 2
   isPlayer = nil
;


Test6: Test
    name = 'Попадание в юнита успешное'
	exec={
	   tstmap.selfInit(5,nil);
	   tstunit.selfInit;
	   tstmap.move(tstunit, 1);
	   tstunit3.selfInit;
	   tstmap.move(tstunit3, 3);
	   CHECK_EQU(tstmap.toString, '1_33_');
	   //убиваем первого
	   CHECK_EQU(tstmap.hit(1), HIT_RES_KILL);
	   CHECK_EQU(tstmap.toString, 'X_33_');
	   CHECK_EQU(tstunit.life, 0);
	   CHECK_EQU(tstunit.mapState, STATE_DIE);
	   //убиваем второго
	   CHECK_EQU(tstmap.hit(3), HIT_RES_GOT);
	   CHECK_EQU(tstmap.toString, 'X_X3_');
	   CHECK_EQU(tstunit3.life, 1);
	   CHECK_EQU(tstunit3.mapState, STATE_HIT);
	   
	   CHECK_EQU(tstmap.hit(4), HIT_RES_KILL);
	   CHECK_EQU(tstmap.toString, 'X_XX_');
	   CHECK_EQU(tstunit3.life, 0);
	   CHECK_EQU(tstunit3.mapState, STATE_DIE);
	}
;


Test7: Test
    name = 'Попадание в юнита неуспешное'
	exec={
	   tstmap.selfInit(3,nil);
	   tstunit.selfInit;
	   tstmap.move(tstunit, 2);
	   CHECK_EQU(tstmap.toString, '_1_');
	   
	   CHECK_EQU(tstmap.hit(0), HIT_RES_LOW_EDGE);
	   CHECK_EQU(tstmap.toString, '_1_');
	   CHECK_EQU(tstunit.life, 1);
	   CHECK_EQU(tstunit.mapState, STATE_OK);
	   
	   CHECK_EQU(tstmap.hit(4), HIT_RES_HIGH_EDGE);
	   CHECK_EQU(tstmap.toString, '_1_');
	   CHECK_EQU(tstunit.life, 1);
	   CHECK_EQU(tstunit.mapState, STATE_OK);
	   
	   CHECK_EQU(tstmap.hit(1), HIT_RES_MISS);
	   CHECK_EQU(tstmap.toString, '.1_');
	   CHECK_EQU(tstunit.life, 1);
	   CHECK_EQU(tstunit.mapState, STATE_OK);
	   
	   CHECK_EQU(tstmap.hit(3), HIT_RES_MISS);
	   CHECK_EQU(tstmap.toString, '.1.');
	   CHECK_EQU(tstunit.life, 1);
	   CHECK_EQU(tstunit.mapState, STATE_OK);
	   
	   CHECK_EQU(tstmap.hit(3), HIT_RES_ALREADY);
	   CHECK_EQU(tstmap.toString, '.1.');
	   CHECK_EQU(tstunit.life, 1);
	   CHECK_EQU(tstunit.mapState, STATE_OK);
	}
;

////////////////////////////////////////
#define RAND_MIN 1
#define RAND_MAX 2
#define RAND_MID 3

modify global
   rand_mode = RAND_MIN
;

//тест расстановки - замена на минимальное число
replace _rand : function(x)
{
   if (global.rand_mode == RAND_MIN) return 1;
   else if (global.rand_mode == RAND_MAX) return x;
   else if (global.rand_mode == RAND_MID) return x/2;
   
   return 1;
}

Test8: Test
    name = 'Проверка случайной расстановки (мин/макс)'
	exec={
	   local unit_list = [tstunit, tstunit2, tstunit3];
	   tstunit.selfInit;
	   tstunit2.selfInit;
	   tstunit3.selfInit;
	   
	   tstmap.selfInit(8,nil);
	   global.rand_mode = RAND_MIN;
	   tstmap.randSetup(unit_list);
	   CHECK_EQU(tstmap.toString, '1_2_33__');
	   
	   tstmap.selfInit(8,nil);
	   global.rand_mode = RAND_MAX;
	   tstmap.randSetup(unit_list);
	   CHECK_EQU(tstmap.toString, '__1_2_33');
	}
;
////////////////////////////////////

plunit1 : Unit
  mapId = '1'
  mapLen = 2
  isPlayer = true
;

plunit2 : Unit
  mapId = '2'
  mapLen = 2
  isPlayer = true
;

plunit3 : Unit
  mapId = '3'
  mapLen = 3
  isPlayer = true
;

plmap1 : seaMap
   isPlayer = true
;
//
aiunit1 : Unit
  mapId = '1'
  mapLen = 2
  isPlayer = nil
;

aiunit2 : Unit
  mapId = '2'
  mapLen = 2
  isPlayer = nil
;

aiunit3 : Unit
  mapId = '3'
  mapLen = 3
  isPlayer = nil
;

aimap1 : seaMap
   isPlayer = nil
;


testGame : seaGame
   plUnits = [plunit1, plunit2, plunit3]
   plMap = plmap1
   aiUnits = [aiunit1, aiunit2, aiunit3]
   aiMap = aimap1
   aiStrategy = seaAiRandom
;

Test9: Test
    name = 'Проверка объекта-игры'
	exec={
	   global.rand_mode = RAND_MIN;
	   testGame.startBattle(10);
	   CHECK_EQU(plmap1.toString, '11_22_333_');
	   CHECK_EQU(aimap1.toString, '11_22_333_');
	}
;

Test10: Test
    name = 'Проверка победы/поражения'
	exec={
	   global.rand_mode = RAND_MIN;
	   testGame.startBattle(10);
	   CHECK_EQU(testGame.checkEnd, GAME_NOT_END);
	   
	   plmap1.hit(1);
	   plmap1.hit(2);
	   plmap1.hit(4);
	   plmap1.hit(5);
	   plmap1.hit(7);
	   plmap1.hit(8);
	   plmap1.hit(9);
	   CHECK_EQU(testGame.checkEnd, GAME_AI_WIN);
	   
	   testGame.startBattle(10);
	   CHECK_EQU(testGame.checkEnd, GAME_NOT_END);
	   aimap1.hit(1);
	   aimap1.hit(2);
	   aimap1.hit(4);
	   aimap1.hit(5);
	   aimap1.hit(7);
	   aimap1.hit(8);
	   aimap1.hit(9);
	   CHECK_EQU(testGame.checkEnd, GAME_PL_WIN);
	}
;

testAiRandom : seaAiRandom
;


Test11: Test
    name = 'Проверка случайной стратегии(мин/макс)'
	exec={
	   global.rand_mode = RAND_MIN;
	   testAiRandom.selfInit(3);
	   CHECK_EQU(testAiRandom.makeHit, 1);
	   testAiRandom.setResult(1, HIT_RES_MISS);
	   CHECK_EQU(testAiRandom.makeHit, 2);
	   testAiRandom.setResult(2, HIT_RES_GOT);
	   CHECK_EQU(testAiRandom.makeHit, 3);
	   testAiRandom.setResult(3, HIT_RES_MISS);
	   
	   
	   global.rand_mode = RAND_MAX;
	   testAiRandom.selfInit(3);
	   CHECK_EQU(testAiRandom.makeHit, 3);
	   testAiRandom.setResult(3, HIT_RES_MISS);
	   CHECK_EQU(testAiRandom.makeHit, 2);
	   testAiRandom.setResult(2, HIT_RES_GOT);
	   CHECK_EQU(testAiRandom.makeHit, 1);
	   testAiRandom.setResult(1, HIT_RES_MISS);
	}
;

testAiSmart : seaAiRandomSmart
;

TestSmart11: Test
    name = 'Проверка умной случайной стратегии(середина)'
	exec={
	   global.rand_mode = RAND_MID;
	   testAiSmart.selfInit(6);
	   CHECK_EQU(testAiSmart.makeHit, 3);
	   testAiSmart.setResult(3, HIT_RES_GOT);
	   
	   CHECK_EQU(testAiSmart.makeHit, 2);
	   testAiSmart.setResult(2, HIT_RES_GOT);
	   
	   CHECK_EQU(testAiSmart.makeHit, 1);
	   testAiSmart.setResult(1, HIT_RES_KILL);
	   
	   CHECK_EQU(testAiSmart.makeHit, 5);
	   testAiSmart.setResult(5, HIT_RES_MISS);
	   
	   //CHECK_EQU(testAiSmart.makeHit, 6);
	   //testAiSmart.setResult(6, HIT_RES_MISS);
	}
;


////////////////////////////////////
plunit_x1 : Unit
  mapId = '1'
  mapLen = 2
  isPlayer = true
;

plunit_x2 : Unit
  mapId = '2'
  mapLen = 3
  isPlayer = true
;

plunit_x3 : Unit
  mapId = '3'
  mapLen = 2
  isPlayer = true
;

Test_mid: Test
    name = 'Проверка случайной расстановки (середина)'
	exec={
	   local unit_list = [plunit_x1, plunit_x2, plunit_x3];
	   plunit_x1.selfInit;
	   plunit_x2.selfInit;
	   plunit_x3.selfInit;
	   
	   tstmap.selfInit(10,nil);
	   global.rand_mode = RAND_MID;
	   //"---------------------------";
	   tstmap.randSetup(unit_list);
	   CHECK_EQU(tstmap.toString, '11_222_33_');
	   
	   tstmap.selfInit(20,nil);
	   global.rand_mode = RAND_MID;
	   //Фиксирующий тест
	   //"---------------------------";
	   tstmap.randSetup(unit_list);
	   CHECK_EQU(tstmap.toString, '_____11___222__33___');
	}
;

TestFullGame: Test
    name = 'Проверка объекта-игры (полная)'
	exec={
	   local res;
	   global.rand_mode = RAND_MIN;
	   testGame.startBattle(10);
	   CHECK_EQU(plmap1.toString, '11_22_333_');
	   CHECK_EQU(aimap1.toString, '11_22_333_');
	   //стреляем с конца, комп с начала (из-за RAND_MIN)
	   res = testGame.hitMove(9);
	   CHECK_EQU(res[1], GAME_HIT_OK_NEXT);
	   CHECK_EQU(res[2], HIT_RES_GOT);
	   CHECK_EQU(res[3], HIT_RES_GOT);
	   CHECK_EQU(plmap1.toString, 'X1_22_333_');
	   CHECK_EQU(aimap1.toString, '11_22_33X_');
	   
	   res = testGame.hitMove(8);
	   CHECK_EQU(res[1], GAME_HIT_OK_NEXT);
	   CHECK_EQU(res[2], HIT_RES_GOT);
	   CHECK_EQU(res[3], HIT_RES_KILL); //10
	   CHECK_EQU(plmap1.toString, 'XX_22_333_');
	   CHECK_EQU(aimap1.toString, '11_22_3XX_');
	   
	   res = testGame.hitMove(7);
	   CHECK_EQU(res[1], GAME_HIT_OK_NEXT);
	   CHECK_EQU(res[2], HIT_RES_KILL);
	   CHECK_EQU(res[3], HIT_RES_MISS);
	   CHECK_EQU(plmap1.toString, 'XX.22_333_');
	   CHECK_EQU(aimap1.toString, '11_22_XXX_');
	   
	   res = testGame.hitMove(5);
	   CHECK_EQU(res[1], GAME_HIT_OK_NEXT);
	   CHECK_EQU(res[2], HIT_RES_GOT);
	   CHECK_EQU(res[3], HIT_RES_GOT); //20
	   CHECK_EQU(plmap1.toString, 'XX.X2_333_');
	   CHECK_EQU(aimap1.toString, '11_2X_XXX_');
	   
	   res = testGame.hitMove(4);
	   CHECK_EQU(res[1], GAME_HIT_OK_NEXT);
	   CHECK_EQU(res[2], HIT_RES_KILL);
	   CHECK_EQU(res[3], HIT_RES_KILL);
	   CHECK_EQU(plmap1.toString, 'XX.XX_333_');
	   CHECK_EQU(aimap1.toString, '11_XX_XXX_');
	   
	   res = testGame.hitMove(2);
	   CHECK_EQU(res[1], GAME_HIT_OK_NEXT); //28
	   CHECK_EQU(res[2], HIT_RES_GOT);
	   CHECK_EQU(res[3], HIT_RES_MISS);
	   CHECK_EQU(plmap1.toString, 'XX.XX.333_');
	   CHECK_EQU(aimap1.toString, '1X_XX_XXX_');
	}
;