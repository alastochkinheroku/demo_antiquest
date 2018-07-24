// CYOAR.T
// Библиотека поддержки меню
// Добавляется после advr.t

// Anton Lastochkin 2016
// Garth Dighton, 2001

// This library allows you to build a regular text adventure with
// choose-your-own-adventure elements - essentially, menus that you can
// attach to a room which give the player additional options beyond GET
// X, TAKE Y, etc. These options may take any form.

// Items of class Menu contain a particular set of choices, with their
// executable code. You need to override the choices property, and add a
// property for each possible choice to be executed when that choice is
// made. The choices property is a list of lists, each choice (inner
// list) consisting of a string, a property pointer (to the code), and
// and optional expression that determines whether that choice is
// currently valid.

// After creating a Menu object, attach it to a room by setting the
// "menu" property of the room. You can do this at any time - many of
// your menu choices will change the menu of a particular room, for
// instance. You may also want to change the menu when certain normal
// commands are executed.

// See the example provided for details.

// Credits: some of the code below - notably preparse(),
// commandPrompt(), and the choiceVerbs, is taken (with modifications)
// from Mark J. Musante's CYOA_lib, which is designed for a more
// standard choose-your-own adventure. 

modify room
	menu = nil
;

replace commandPrompt: function(code)
{
    "<font face='TADS-Input'>";
    if ((code = 0 || code = 1) && Me.location.menu) {
		Me.location.menu.constructChoices;
		if (Me.location.menu.chstr != '') {
			Me.location.menu.sayChoices;
		}
	}
    "\b&gt;";
}


class Menu: object
	chstr = ''
	sayChoices = {say(self.chstr);}
	choices = []
	gotoList = []

	constructChoices = {
		local i, n;
		self.chstr := '';
		self.gotoList := [];
		n := 1;
		if (self.choices && length(self.choices) > 0) {
			// Construct the choice list, testing to see if each choice
			// is valid
			for (i := 1; i<=length(self.choices); i++) {
				if (length(self.choices[i]) < 3
					|| self.choices[i][3] = true) {
					self.gotoList += self.choices[i][2];
					self.chstr := self.chstr + '\n\t(' + cvtstr(n) + ') ' +
						self.choices[i][1];
					n++;
				}
			}
		}
	}

	Execute(num) = {
		if (num > length(self.gotoList)) {
			"Пожалуйста, выберите пункт из меню, или введите обычную команду. ";
			abort;
		} else {
			self.(self.gotoList[num]);
		}
	}
;

replace additionalPreparsing: function( str )
{
	local foo;

	if ( str = '' ) {
		"Простите? ";
		return nil;
	}

	foo := cvtnum( str );
	switch( foo ) {
	case 1: return 'one';
	case 2: return 'two';
	case 3: return 'three';
	case 4: return 'four';
	case 5: return 'five';
	case 6: return 'six';
	case 7: return 'seven';
	case 8: return 'eight';
	case 9: return 'nine';
	default:
		if ( foo < 0 || foo > 9 || str = '0' ) {
			"Пожалуйста, выберите один из пунктов меню. ";
			return nil;
		}
		return true;
	}
}

//
// Basic choices.  Numbered 1 through 9.
//
choiceVerb: object
	num = 0
	action( actor ) = {
		if ( self.num = 0 ) {
			"Ошибка парсинга: номер не установлен в глаголе.\n";
			abort;
		}

		if ( self.num < 1 || self.num > 9 ) {
			"Ошибка парсинга: выбор вне зоны.\b";
			abort;
		}
		Me.location.menu.Execute(self.num);
	}

;

oneVerb: choiceVerb
	verb = 'one'
	num = 1
;

twoVerb: choiceVerb
	verb = 'two'
	num = 2
;

threeVerb: choiceVerb
	verb = 'three'
	num = 3
;

fourVerb: choiceVerb
	verb = 'four'
	num = 4
;

fiveVerb: choiceVerb
	verb = 'five'
	num = 5
;

sixVerb: choiceVerb
	verb = 'six'
	num = 6
;

sevenVerb: choiceVerb
	verb = 'seven'
	num = 7
;

eightVerb: choiceVerb
	verb = 'eight'
	num = 8
;

nineVerb: choiceVerb
	verb = 'nine'
	num = 9
;

