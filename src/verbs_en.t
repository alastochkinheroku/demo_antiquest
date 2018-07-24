// VERBS.T
// Библиотека системных глаголов игры Чёрный странник
#pragma C++

replace attackVerb: deepverb
;

replace pokeVerb: deepverb
;

replace askVerb: deepverb
;

replace tellVerb: deepverb
;

replace switchVerb: deepverb
;

justGoVerb: deepverb
   verb = 'go'
   action(actor) = "Please, choose direction, like: go north."
;

replace turnOnVerb: deepverb, darkVerb
    verb = 'activate' 'turn on' 'switch on' 'switch'
    sdesc = "turn on"
    doAction = 'Turnon'
;

replace breakVerb: deepverb
	verb = 'break' 'ruin' 'destroy' 'fire' 'hit' 'kill' 'poke' 'jab' 'attack' 'kick'
	sdesc = "break"
	doAction = 'Break'
;

replace waitVerb: darkVerb
    verb = 'wait' 'z'
    sdesc = "wait"
	action(actor) =
	{
	    if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.wait;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.wait;
		else "Pass some time...\n";
	}
;

replace sleepVerb: darkVerb
	action(actor) =
	{
		if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.wait;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.wait;
		else "I fall asleep.\n";
	}
	verb = 'sleep'
    sdesc = "sleep"
;

replace jumpVerb: deepverb
    verb = 'jump' 'jump over' 'jump off'
    sdesc = "jump"
	action(actor) = { 
		if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.jump;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.jump;
		else "Wheeee!";
	}
;

replace digVerb: deepverb
    verb = 'dig' 'dig in'
    sdesc = "dig in"
	action(actor) = { 
		if (isclass(actor.location,room) && !isclass(actor.location,nestedroom)) actor.location.dig;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.dig;
		else "Digging!";
	}
;

replace yellVerb: deepverb
    verb = 'yell' 'shout' 'yell at' 'shout at'
    sdesc = "yell"
	action(actor) =
	{
		if (isclass(actor.location,room) && !isclass(actor.location,nestedroom)) actor.location.yell;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.yell;
		else "Yelling!";
	}
;

finishVerb: deepverb
	verb = 'finish' 'win' 'loose' 'die'
	sdesc = "finish"
	action(actor) =
	{
	  "It's not so easy! You must be strong.";
	}
;

talkVerb: deepverb
	verb = 'talk' 'chat' 'speak' 'talk to' 'speak to' 'chat to' 'talk with' 'speak with' 'chat with' 'ask' 'tell'
    sdesc = "talk"
	doAction = 'Talk'
;

listenVerb:darkVerb
	verb='listen' 'listen to'
	sdesc="listen"
	action(actor)=
		{  
		 if ((actor.location.location!=nil)) actor.location.location.listendesc;
		 else actor.location.listendesc;
		}
	doAction='ListenTo'
;

replace restartVerb: sysverb
	verb = 'restart'
	sdesc = "restart"
	restartGame(actor) =
	{
		local yesno;
		while (true)
		{
			"Are you sure you want to start over? (YES or NO) > ";
			yesno = input();
			yesno = lower(yesno);
			"\b";
			if ((yesno == 'yes') || (yesno == 'y'))
				{
					"\n";
					scoreStatus(0, 0);			
					restart(initRestartEndings, global.endings);
					break;
				}
				else
				{
					"\nOkay.\n";
					break;
				}
			}
	}
	action(actor) =
	{
		self.restartGame(actor);
		abort;
	}
;


replace helpVerb: deepverb
	verb = 'help' 'hint'
	sdesc = "help"
	action(actor) = {
		"\tAn adventure game lies somewhere between a story and a puzzle.
		 You play the main character, and the story unfolds around you
		 as you perform actions. You do this by giving yourself commands
		 at the <q>&gt;</q> prompt, commands such as";

		"\b<BLOCKQUOTE><tt>SIT\n
		 WALK EAST\n
		 HIT THE TABLE</TT></BLOCKQUOTE>";

		"\bIn response, the game will tell you what happens next. ";

		"\b\tBasic commands consist of either a verb by itself (such as
		 <TT>LOOK</TT> to see where you are) or a verb followed by nouns
		 (such as <TT>OPEN THE BOX</TT>). Think of the sentences you
		 type as things you are telling yourself to do.";

		"\b\tIf you would like more information about playing parser games, enter <b>instructions</b> (a lot of text!). ";
		abort;
	}
;

CreditsVerb: sysverb
	verb = 'credits'
	sdesc = "credits"
	action(actor) = {
		printf(IDS_CREDITS_TEXT);
		abort;
	}
;

Magic1Verb: sysverb
	verb = 'magic1'
	sdesc = "magic1"
	action(actor) = {
		startbattle();
	}
;

Magic2Verb: sysverb
	verb = 'magic2'
	sdesc = "magic2"
	action(actor) = {
		global.forceWin = true;
		basicNumObj.value = 0;
		basicNumObj.doBreak(Me);
	}
;

thinkVerb: sysverb
	verb = 'think' 'pray'
	sdesc = "think"
	action(actor) = {
		"Thinking isn\'t my strong side.";
	}
;

danceVerb: sysverb
	verb = 'dance'
	sdesc = "dance"
	action(actor) = {
		"I'm the best solo-latina dancer in all bathrooms!";
	}
;

kissVerb: sysverb
	verb = 'kiss'
	sdesc = "kiss"
	action(actor) = {
		"Where is my lover?";
	}
;

smellVerb: darkVerb
	verb='smell'
	sdesc="smell"
	doAction='Smell'
;

replace eatVerb: deepverb
    verb = 'eat' 'consume' 'taste'
    sdesc = "eat"
    doAction = 'Eat'
;


//Во время космического боя можно ввести цифру и поразить зону
replace additionalPreparsing: function( str )
{
	if ( (Me.location == spaceroom) && (cvtnum(str)>0) ) {
		   return ('break '+str);
	}
	//если возвращать true, то деЁфикация пропадает
	return nil;
}

#pragma C-