//��������� ������ �������� ��� 1D

//������� �������:
//�� ������ �������� ���. ���� ���������� �����, �� ��� ����� ����������� ������ ������� �������. ����� �������� ������� ���� ������. � ������ ��� ����������� ���������, �� ������� ����� ����� ������� �����. ����� ������� ����� ���� ��������� - ����, �����, ����. ��� ������ ��������� ��� ������ ���������, ��� �������.

//�������� ������
//1. ��������� ����� Unit � ������, ���������� Item
//2. ��������� mapId, mapLen, isPlayer
//3. ��������� ��� ��������� ������ (����� � �����)
//4. ������� ��� ����� (seaMap) - ���� ��� ������, ������ ��� �����, ���������� isPlayer
//5. ������������� �� seaGame � ���������� �����, ����� � ���������
//6. ����� ������� ���� ������� startBattle
//7. ����� ��� ������� ���� ��������� hitMove, ��������� ���������
//8. ������� ������� �������� � ����� � ���������� ������ � ����


//����� ����� �� ����
class Unit : object
//protected:
   /*setup*/ mapId = '0' //������������� �� �����, 1 ������
   /*setup*/ mapLen = 0 //���������� �����
   /*setup*/ isPlayer = nil //���� ����������� ������
;

//���������� ������������
//enum MAP_MOVE
#define MAP_MOVE_OK        1 //������������
#define MAP_MOVE_LOW_EDGE  2 //����� ���������� � 1!
#define MAP_MOVE_HIGH_EDGE 3 //����� ������������� � X!
#define MAP_MOVE_NOT_FREE  4 //� �� ���� ����������� �� ������� ����!
#define MAP_MOVE_TOO_CLOSE_LOW 5 //����� ������ � ��������� ����� (�����)
#define MAP_MOVE_TOO_CLOSE_HI 6 //����� ������ � ��������� ����� (������)
#define MAP_MOVE_DISALLOW      7 //��������� ���������

//���������� ���������
//enum HIT_RES
#define HIT_RES_LOW_EDGE  1 //����� ���������� � 1!
#define HIT_RES_HIGH_EDGE 2 //����� ������������� � X!
#define HIT_RES_ALREADY   3 //�� ��� �������� ����!
#define HIT_RES_MISS      4 //������
#define HIT_RES_GOT       5 //������
#define HIT_RES_KILL      6 //����

//����� �����
class seaMap : object
//protected:   
   /*setup*/ isPlayer = nil 	//����� ����������� ������
   unkCellSymb = '_'
   emptyCellSymb = '.'
   hitCellSymb = 'X'
   
//public:
   toString={} //������ ����� � ������� �������
   move(unit, pos)={}//����������� ����� �� ����� �������, ���������� MAP_MOVE
;

//�������� ��� ����
#define GAME_NOT_END 1
#define GAME_PL_WIN  2
#define GAME_AI_WIN  3

//���������� ��������
#define GAME_HIT_OK_NEXT 1 //�������� �������, ��������� ������
#define GAME_HIT_END     2 //�������� �������, ����� ����

//���������� ������ ����
class seaGame : object
//protected:
    /*setup*/ plUnits = []
	/*setup*/ plMap = nil
	/*setup*/ aiUnits = []
	/*setup*/ aiMap = nil
	/*setup*/ aiStrategy = nil
//public:
	//������ ������ ���
	//lvl_len - ����� ������
	//return void
	startBattle(lvl_len) = {}
	
	//���� ����� - ������� �� ����������, ����� ��
	//���������� [GAME_HIT_OK_NEXT pl_res : HIT_RES ai_res : HIT_RES]
	//��� [GAME_HIT_END GAME_PL_WIN/GAME_AI_WIN nil]
	hitMove(pos) = {}
	
	//�������� ���������� �����������
	isAllowMove = {}
	
	//�������� ����� �����
	getMapLen={} 
;

////////////////////////////////////////////
//���������
//enum HIT_HIST
#define HIT_HIST_NONE 0   //�� �������� � ��� �������
#define HIT_HIST_MISS 1   //��� ������������ ������
#define HIT_HIST_ENEMY 2  //��� ������ ����
#define HIT_HIST_SPACE 3  //��� ����� �� ���� ������������� (��� �����, ���� ������)

//enum STRAT_
#define STRAT_NONE 0
#define STRAT_MISS 1
#define STRAT_HIT 2
#define STRAT_DIE 3

//����� ��������� ��� ai
class seaAiAbstract : object
//public:
	/*virtual*/ selfInit(map_size) = {} //������������� ��� �����
	/*virtual*/ setResult(pos, hit_res) = {} //���������� ��������� ��� �������� (pos - �������), hit_res-HIT_RES
	/*virtual*/ makeHit = {}      //��������� �������, ���������� pos ��� ��������
//protected:
	hit_hist = [] //������� ��������� �� ���������� (HIT_HIST)
	prev_state = STRAT_NONE //���������� ��������� ��������
;

//��������� ���������
seaAiRandom : seaAiAbstract
   makeHit = {}
;

//��������� ��������� � ���������
seaAiRandomSmart : seaAiRandom
;

//������� �������
//seaAiHalf : seaAiAbstract
//   makeHit = {}
//;