//Интерфейс движка морского боя 1D

//Краткие правила:
//На основе морского боя. Дана одномерная карта, на ней можно расположить войска разного размера. Между войсками минимум одна клетка. В начале боя расстановки случайные, до первого удара можно двигать юниты. После каждого удара есть результат - мимо, попал, убит. Кто первый уничтожит все войска протиника, тот победил.

//ОПИСАНИЕ ДВИЖКА
//1. Подмешать класс Unit к классу, наследнику Item
//2. Настроить mapId, mapLen, isPlayer
//3. Повторить для остальных юнитов (своих и компа)
//4. Создать две карты (seaMap) - одну для игрока, другую для компа, установить isPlayer
//5. Наследоваться от seaGame и установить юниты, карты и стратегию
//6. Перед началом игры вызвать startBattle
//7. После для каждого хода выполнять hitMove, проверять результат
//8. Связать глаголы движения и удара с действиями юнитов и игры


//Класс юнита на поле
class Unit : object
//protected:
   /*setup*/ mapId = '0' //идентификатор на карте, 1 символ
   /*setup*/ mapLen = 0 //занимаемая длина
   /*setup*/ isPlayer = nil //юнит принадлежит игроку
;

//Результаты передвижений
//enum MAP_MOVE
#define MAP_MOVE_OK        1 //передвинулся
#define MAP_MOVE_LOW_EDGE  2 //Карта начинается с 1!
#define MAP_MOVE_HIGH_EDGE 3 //Карта заканчивается в X!
#define MAP_MOVE_NOT_FREE  4 //Я не могу переместить на занятое поле!
#define MAP_MOVE_TOO_CLOSE_LOW 5 //Очень близко к соседнему юниту (слева)
#define MAP_MOVE_TOO_CLOSE_HI 6 //Очень близко к соседнему юниту (справа)
#define MAP_MOVE_DISALLOW      7 //запрещено двигаться

//Результаты попаданий
//enum HIT_RES
#define HIT_RES_LOW_EDGE  1 //Карта начинается с 1!
#define HIT_RES_HIGH_EDGE 2 //Карта заканчивается в X!
#define HIT_RES_ALREADY   3 //Вы уже стреляли туда!
#define HIT_RES_MISS      4 //промах
#define HIT_RES_GOT       5 //подбит
#define HIT_RES_KILL      6 //убит

//Класс карты
class seaMap : object
//protected:   
   /*setup*/ isPlayer = nil 	//карта принадлежит игроку
   unkCellSymb = '_'
   emptyCellSymb = '.'
   hitCellSymb = 'X'
   
//public:
   toString={} //печать карты в удобном формате
   move(unit, pos)={}//передвинуть юнита на новую позицию, возвращает MAP_MOVE
;

//Концовки для игры
#define GAME_NOT_END 1
#define GAME_PL_WIN  2
#define GAME_AI_WIN  3

//Результаты действия
#define GAME_HIT_OK_NEXT 1 //выполнен выстрел, двигаемся дальше
#define GAME_HIT_END     2 //выполнен выстрел, конец игры

//Глобальный объект игры
class seaGame : object
//protected:
    /*setup*/ plUnits = []
	/*setup*/ plMap = nil
	/*setup*/ aiUnits = []
	/*setup*/ aiMap = nil
	/*setup*/ aiStrategy = nil
//public:
	//начало нового боя
	//lvl_len - длина уровня
	//return void
	startBattle(lvl_len) = {}
	
	//Цикл битвы - выстрел по противнику, затем он
	//возвращает [GAME_HIT_OK_NEXT pl_res : HIT_RES ai_res : HIT_RES]
	//или [GAME_HIT_END GAME_PL_WIN/GAME_AI_WIN nil]
	hitMove(pos) = {}
	
	//Проверка разрешения перемещения
	isAllowMove = {}
	
	//получить длину карты
	getMapLen={} 
;

////////////////////////////////////////////
//Стратегии
//enum HIT_HIST
#define HIT_HIST_NONE 0   //не стреляли в эту область
#define HIT_HIST_MISS 1   //был зафиксирован промах
#define HIT_HIST_ENEMY 2  //был подбит враг
#define HIT_HIST_SPACE 3  //это место не надо простреливать (нет врага, одна клетка)

//enum STRAT_
#define STRAT_NONE 0
#define STRAT_MISS 1
#define STRAT_HIT 2
#define STRAT_DIE 3

//Класс стратегии для ai
class seaAiAbstract : object
//public:
	/*virtual*/ selfInit(map_size) = {} //инициализация для карты
	/*virtual*/ setResult(pos, hit_res) = {} //установить результат для выстрела (pos - позиция), hit_res-HIT_RES
	/*virtual*/ makeHit = {}      //выполнить выстрел, возвращает pos для выстрела
//protected:
	hit_hist = [] //история выстрелов по противнику (HIT_HIST)
	prev_state = STRAT_NONE //предыдущее состояние выстрела
;

//Случайная стратегия
seaAiRandom : seaAiAbstract
   makeHit = {}
;

//Случайная стратегия с обстрелом
seaAiRandomSmart : seaAiRandom
;

//Деление пополам
//seaAiHalf : seaAiAbstract
//   makeHit = {}
//;