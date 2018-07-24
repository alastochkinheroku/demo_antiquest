#define USE_HTML_STATUS
#define USE_HTML_PROMPT
#define GENERATOR_INCLUDED

#include <advr.t>
#include <stdr.t>
#include <errorru.t>
#include <extendr.t>
#include <generator.t>

replace die: function
{
    "\b��������: ������, �����.\n \n";
    while (true)
    {
        local resp;

        "\n����������, ������� ������, �����: >";
        resp := upper(input());
        resp := loweru(resp);
        if ((resp = 'restart') or (resp='������'))
        {
            scoreStatus(0, 0);
            restart();
        }
        else if ((resp = 'exit') or (resp='�����'))
        {
            terminate();
            quit();
            abort;
        }
    }
}

#pragma C++

testEnv : object
   nFault = 0
   nCheck = 0
   curTest = ''
;

CHECK_EQU : function(expr1, etal)
{
   testEnv.nCheck += 1;
   if (expr1 != etal) {
		"\n<<testEnv.curTest>>:�������� <<testEnv.nCheck>> (��������: <<expr1>>, ���������: <<etal>>) \n";
		testEnv.nFault += 1;
   }
}

//����-���� ��� ����������
class Test: object
    name = '���� 1'
	exec={}
;

replace introduction: function
{
}

replace version: object
    sdesc = ""
;
replace commonInit: function
{
    local tst;
	"\H+"; 
	"\n\n\n------\n\n\n";
	//��������� ��� ��������� �����
	tst = firstobj(Test);
    while(tst != nil)
    {
	  testEnv.curTest = tst.name;
	  testEnv.nCheck = 0;
      tst.exec;
	  tst = nextobj(tst);
	  ".";
    }
	if (testEnv.nFault == 0) "\n��� ������\n";
	else "\n������: <<testEnv.nFault>>\n";
	"\n\n\n\n------\n\n\n\n";
	//die();
	terminate();
    quit();
}

startroom: room
 sdesc=""
 ldesc=""
;

