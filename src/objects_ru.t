#pragma C++

//////////////////////////////////////////////
////////////������� ����
//�����

modify Me
  lico=1
  desc ='�'
  isHim = true
  sdesc="�"
  rdesc="����"
  ddesc="���"
  vdesc="����"
  tdesc="����"
  pdesc="����"
;

theHalat : decoration
  desc = '�����/1�'
;

theRoom: fixeditem, floatingItem
   desc='�������/1�'	 
   noun = '�������/1�' '�����/1�'
   isHer = true
;

theWall: fixeditem, floatingItem
   desc='�����/1�'	 
   noun = '�����/1�' '�����/2'
   isHer = true
;

theCeiling: fixeditem, floatingItem
   desc='�������/1�'	 
   isHim = true
;

replace theFloor: beditem, floatingItem
	noun = '���' '����' '����' '�����' '����' '�����#t' 
	desc='���/1�'	 
	isHim = true
	statusPrep = "��"
	outOfPrep = "�"
	ioThrowAt(actor, dobj) =
	{
		"������� - �������. ";
		dobj.moveInto(actor.location);
	}
	noexit =
	{
		"<<ZAG(parserGetMe(),&sdesc)>> ������ �� <<glok(parserGetMe(),1,2,'����')>> ����
		�� <<glok(parserGetMe(),1,1,'�����')>> <<outOfPrep>> <<rdesc>>. ";
		return nil;
	}
;

//�������+ �� ������� 
class anyroom : room
;

class anyfixed : fixeditem
;

//

startroom: anyroom
 sdesc="� ����� �����"
;

startbed : anyfixed, beditem
  desc = '�����/1�'
  noun = '�����/1�' '�������/1�'
  adjective = '�������/1��'
  isHer=true
;

//
coridorroom: anyroom
  sdesc="�������"
;

//
techsection : anyroom
  sdesc = "����������� ������"
;

kabel : anyfixed, beditem
  desc = '������/1�'
  noun = '������/1�' '������/1�'
  adjective = '�������/1��'
  isHim=true
;
//
medroom : anyroom
  sdesc = "����������� �����"
;

robotmed : anyfixed, chairitem
  desc = '�����/1��'
  noun = '�����/1��' '�����/1��' '����/1��' '�������/1�' '������/1�'
  adjective = '����������������/1��' '������/1��'
  isHim=true
;

//
coridorrun: anyroom
  sdesc="������� � ��������"
;

///////////////////////////////////////////////////////////////
//SPACE
class SpaceShip : fixeditem, Unit
;

plMain: SpaceShip
 desc = '�������/1�'
 noun ='�������/1�' '��/1�'
 isHim = true
 mapId = '�'
;

plFighter: SpaceShip
 desc='�����������/1�'
 noun = '�����������/1�' '��/1�'
 isHim = true
 mapId = '�'
;

plBomber: SpaceShip
 desc = '��������������/1�'
 noun = '��������������/1�' '��/1�'
 isHim = true
 mapId = '�'
;

EnemyMain: SpaceShip
 desc='���������/1��� �������/1��'
 isHim = true
 mapId = '�'
;

EnemyFighter: SpaceShip
 desc='���������/1��� �����������/1��'
 isHim = true
 mapId = '�'
;

EnemyBomber: SpaceShip
 desc='���������/1��� �������/1��'
 isHim = true
 mapId = '�'
;

spaceroom: room
  sdesc="�� ������"
;

map : fixeditem
  desc = '�����/1�'
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
    case 1: return '��� ��� �� ���������� �����: "%c"??? ���������.'; break;
    case 2: return '� �������, ����� ����� ��� "%s" ��� ����������.'; break;
    case 3: return '����� "%s" ��������� � ������� �������� ����� ��������.'; break;
    case 4: return '� �����, �� ���������� �������� ����� ���������������� �����������.';  break;
    case 5: return '� �����, �� ���������� �������� ����������� ����� "���".'; break;
    case 6: return '� ������ ��������������� ����� ��������, ��������� ��������� ��������.'; break;
    case 7: return '������ �����7. ��� ��� ������, �������� ��� ��� ��������!';break;
    case 9: return '�� ��� ��� ������ "%s"? � ����� ��� �� ����!'; break;
    case 10: return '�� ���������� �� ������� ������� ���������� �������� ������ "%s".';break;
    case 11: return '�� ���������� �� ������� ������� ���������� ��������.'; break;
    case 12: return '�� ������ �������� ������ � ����� �������� ������������.';break;
    case 13: return '�� ��� ��� �� ���������� ������ "%s". ������ ��������...';  break;
    case 14: return '�� ��� ����������, ������ ���������.';  break;
    case 15: return '� ��� ��� �� �����, �� ��� �� ����������.'; break;
    case 16: return '� �� ���� ����� �����.'; break;
    case 17: return '� ��� �� ������ � �����������? ������?';   break;
    case 18: return '� �� ������� ��� �����������.';  break;
    case 19: return //'����� ����� ������� �� ������� �����.'; break;
    '� ����� ����� ������� ���� �����, ������� � �� ���� ������������.'; break;
    case 20: return '�� ���� ��� ������������ ����� "%s" ����� �������.'; break;
    case 21: return '����� ����� ������� ���� ������ �����.';  break;
    case 22: return '������, ����� ����� ������� ���� ������ �����.';  break;
    case 24: return '� �� ������� ��� �����������.';  break;
    case 25: return '������ ������������ ����� ��������� ��������.';  break;
    case 26: return '��� ������� ��� ����������.';  break;
    case 27: return '��� ������� ������ ���������.'; break;
    case 28: return '��� ������� ������ ��������� � ��������� ��������.';break;
    case 29: return '� �����, �� ���������� �������� ����������� ����� "�����".'; break;
    case 30: return '� ���� ������ %d �� ���.';   break;
    case 31: return '� ���� ������ �������������.';   break;
    case 38: return '����� ������ ����� �� �����.'; break;
    case 39: return '����� ����� �� �����.';   break;
    case 160: return '��� �������� ��������� ������� ����� "%s" �� ������ � ����.';   break;
    default:  return nil;
    }
}
  
#pragma C-