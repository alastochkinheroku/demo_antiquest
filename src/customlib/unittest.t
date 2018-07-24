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
    "\bВыберите: ЗАНОВО, ВЫХОД.\n \n";
    while (true)
    {
        local resp;

        "\nПожалуйста, введите ЗАНОВО, ВЫХОД: >";
        resp := upper(input());
        resp := loweru(resp);
        if ((resp = 'restart') or (resp='заново'))
        {
            scoreStatus(0, 0);
            restart();
        }
        else if ((resp = 'exit') or (resp='выход'))
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
		"\n<<testEnv.curTest>>:проверка <<testEnv.nCheck>> (реальное: <<expr1>>, эталонное: <<etal>>) \n";
		testEnv.nFault += 1;
   }
}

//юнит-тест для выполнения
class Test: object
    name = 'Тест 1'
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
	//выполняем все найденные тесты
	tst = firstobj(Test);
    while(tst != nil)
    {
	  testEnv.curTest = tst.name;
	  testEnv.nCheck = 0;
      tst.exec;
	  tst = nextobj(tst);
	  ".";
    }
	if (testEnv.nFault == 0) "\nНЕТ ОШИБОК\n";
	else "\nОШИБОК: <<testEnv.nFault>>\n";
	"\n\n\n\n------\n\n\n\n";
	//die();
	terminate();
    quit();
}

startroom: room
 sdesc=""
 ldesc=""
;

