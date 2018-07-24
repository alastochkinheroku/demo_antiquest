// VERBS.T
// Библиотека системных глаголов игры Чёрный странник
#pragma C++

replace attackVerb: deepverb
	verb = 'убитьсильно'
	vopr = "На кого "
	pred = onPrep
	sdesc = "убитьсильно"
	prepDefault = withPrep
	ioAction(withPrep) = 'AttackWith'
	dispprep=['в','по']
;

replace breakVerb: deepverb
	verb = 'разбить' 'сломать' 'уничтожить' 'порвать' 'ломать' 'разбей' 'сломай' 'уничтожь' 'порви' 'разорвать' 'разорви' 'ломай' 'убить' 'убей' 'ударить' 'ударь' 'врезать' 'врежь' 'бить' 'бей' 'атаковать' 'атакуй' 'напасть на' 'напади на' 'наброситься на' 'набросься на' 'ударить по' 'ударь по' 'ударить в' 'ударь в' 'врезать в' 'врежь в' 'врезать по' 'врежь по' 'дать по' 'дай по' 'дать в' 'дай в' 'бить по' 'бей по' 'бить в' 'бей в' 'стрелять в' 'стреляй в' 'выстрелить в' 'выстрели в'
	sdesc = "сломать"
	doAction = 'Break'
;

replace waitVerb: darkVerb
	verb = 'ж' 'ждать' 'подождать' 'жди' 'подожди'
	sdesc = "ждать"
	action(actor) =
	{
	    if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.wait;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.wait;
		else "Прошло некоторое время...\n";
	}
;

replace sleepVerb: darkVerb
	action(actor) =
	{
		if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.wait;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.wait;
		else "Я уснул.\n";
	}
	verb = 'спать' 'спи' 'уснуть' 'усни' 'заснуть' 'засни' 'выспаться' 'поспать' 'поспи' 'отдохнуть' 'отдыхай' 'отдыхать' 'отдохни'
	sdesc = "спать"
;

replace jumpVerb: deepverb 
	verb =	'прыгнуть' 'перепрыгнуть' 'перепрыгни' 'спрыгнуть' 'спрыгни' 'прыгать' 
			'подпрыгнуть' 'подпрыгни' 'прыгни' 'прыгай'
	sdesc = "прыгнуть"
	action(actor) = { 
		if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.jump;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.jump;
		else "Гоп!";
	}
;

replace digVerb: deepverb
	verb =	'копать' 'копай' 'рыть' 'рой' 'вырыть' 'вырой' 'выкопать' 'выкопай'
			'раскопать' 'раскопай' 'разрыть' 'разрой' 
			'копаться' 'копайся' 'покопаться' 'покопайся' 'разгрести' 'разгреби'
	sdesc = "копать"
	action(actor) = { 
		if (isclass(actor.location,room) && !isclass(actor.location,nestedroom)) actor.location.dig;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.dig;
		else "Копаем!";
	}
;

replace yellVerb: deepverb
	verb = 'орать' 'кричать' 'визжать' 'заорать' 'вопить' 'оборать'
'ори' 'кричи' 'визжи' 'заори' 'вопи' 'обори' 'крикнуть' 'крикни'
	sdesc = "орать"
	action(actor) =
	{
		if (isclass(actor.location,room) && !isclass(actor.location,nestedroom)) actor.location.yell;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.yell;
		else "Визжим!";
	}
;

replace eatVerb: deepverb
	verb = 'есть' 'жрать' 'кушать' 'съесть' 'откусить' 'поесть' 'сожрать' 'слопать' 'жевать' 
			'проглотить' 'попробовать' 'пробовать' 'ешь' 'жри' 'кушай' 'съешь' 'откуси' 'поешь' 
			'сожри' 'слопай' 'жуй' 'проглоти' 'попробуй' 'пробуй' 'лизни' 'лизнуть' 'укуси' 'укусить'
	sdesc = "съесть"
	doAction = 'Eat'
;

finishVerb: deepverb
	verb = 'выиграй' 'выиграть' 'проиграй' 'проиграть' 'умри' 'умереть' 'сдохни' 'сдохнуть' 'конец' 
	sdesc = "конец"
	action(actor) =
	{
	  "Если вы всё было так просто! Надо немного помучиться...";
	}
;

replace restartVerb: sysverb
	verb = 'restart' 'заново'
	sdesc = "restart"
	restartGame(actor) =
	{
		local yesno;
		while (true)
		{
			"Точно хотите начать сначала? (YES/NO или ДА/НЕТ) > ";
			yesno = input();
			yesno = loweru(yesno);
			"\b";
			if ((yesno == 'д') || (yesno == 'yes') || (yesno == 'y') || (yesno == 'да'))

				{
					"\n";
					scoreStatus(0, 0);			
					restart(initRestartEndings, global.endings);
					break;
				}
				else
				{
					"\nКак угодно.\n";
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

replace HelpVerb: sysverb
	verb = 'help' 'помощь'
	sdesc = "помощь"
	action(actor) = {
		printf(IDS_HELP_TEXT);
		abort;
	}
;

CreditsVerb: sysverb
	verb = 'благодарности' 'благодарность'
	sdesc = "благодарности"
	action(actor) = {
		printf(IDS_CREDITS_TEXT);
		abort;
	}
;

Magic1Verb: sysverb
	verb = 'магия1'
	sdesc = "магия1"
	action(actor) = {
		startbattle();
	}
;

Magic2Verb: sysverb
	verb = 'магия2'
	sdesc = "магия2"
	action(actor) = {
		global.forceWin = true;
		basicNumObj.value = 0;
		basicNumObj.doBreak(Me);
	}
;


//Во время космического боя можно ввести цифру и поразить зону
replace additionalPreparsing: function( str )
{
	if ( (Me.location == spaceroom) && (cvtnum(str)>0) ) {
		   return ('бить в '+str);
	}
	//если возвращать true, то деЁфикация пропадает
	return nil;
}

#pragma C-