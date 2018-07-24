// VERBS.T
// ���������� ��������� �������� ���� ׸���� ��������
#pragma C++

replace attackVerb: deepverb
	verb = '�����������'
	vopr = "�� ���� "
	pred = onPrep
	sdesc = "�����������"
	prepDefault = withPrep
	ioAction(withPrep) = 'AttackWith'
	dispprep=['�','��']
;

replace breakVerb: deepverb
	verb = '�������' '�������' '����������' '�������' '������' '������' '������' '��������' '�����' '���������' '�������' '�����' '�����' '����' '�������' '�����' '�������' '�����' '����' '���' '���������' '������' '������� ��' '������ ��' '����������� ��' '��������� ��' '������� ��' '����� ��' '������� �' '����� �' '������� �' '����� �' '������� ��' '����� ��' '���� ��' '��� ��' '���� �' '��� �' '���� ��' '��� ��' '���� �' '��� �' '�������� �' '������� �' '���������� �' '�������� �'
	sdesc = "�������"
	doAction = 'Break'
;

replace waitVerb: darkVerb
	verb = '�' '�����' '���������' '���' '�������'
	sdesc = "�����"
	action(actor) =
	{
	    if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.wait;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.wait;
		else "������ ��������� �����...\n";
	}
;

replace sleepVerb: darkVerb
	action(actor) =
	{
		if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.wait;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.wait;
		else "� �����.\n";
	}
	verb = '�����' '���' '������' '����' '�������' '�����' '���������' '�������' '�����' '���������' '�������' '��������' '�������'
	sdesc = "�����"
;

replace jumpVerb: deepverb 
	verb =	'��������' '������������' '����������' '���������' '�������' '�������' 
			'�����������' '���������' '������' '������'
	sdesc = "��������"
	action(actor) = { 
		if (isclass(actor.location,room)&& !isclass(actor.location,nestedroom)) actor.location.jump;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.jump;
		else "���!";
	}
;

replace digVerb: deepverb
	verb =	'������' '�����' '����' '���' '������' '�����' '��������' '�������'
			'���������' '��������' '�������' '������' 
			'��������' '�������' '����������' '���������' '���������' '��������'
	sdesc = "������"
	action(actor) = { 
		if (isclass(actor.location,room) && !isclass(actor.location,nestedroom)) actor.location.dig;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.dig;
		else "������!";
	}
;

replace yellVerb: deepverb
	verb = '�����' '�������' '�������' '�������' '������' '�������'
'���' '�����' '�����' '�����' '����' '�����' '��������' '������'
	sdesc = "�����"
	action(actor) =
	{
		if (isclass(actor.location,room) && !isclass(actor.location,nestedroom)) actor.location.yell;
		else if (actor.location.location != nil && (isclass(actor.location.location,room))) actor.location.location.yell;
		else "������!";
	}
;

replace eatVerb: deepverb
	verb = '����' '�����' '������' '������' '��������' '������' '�������' '�������' '������' 
			'����������' '�����������' '���������' '���' '���' '�����' '�����' '������' '�����' 
			'�����' '������' '���' '��������' '��������' '������' '�����' '�������' '�����' '�������'
	sdesc = "������"
	doAction = 'Eat'
;

finishVerb: deepverb
	verb = '�������' '��������' '��������' '���������' '����' '�������' '������' '��������' '�����' 
	sdesc = "�����"
	action(actor) =
	{
	  "���� �� �� ���� ��� ������! ���� ������� ����������...";
	}
;

replace restartVerb: sysverb
	verb = 'restart' '������'
	sdesc = "restart"
	restartGame(actor) =
	{
		local yesno;
		while (true)
		{
			"����� ������ ������ �������? (YES/NO ��� ��/���) > ";
			yesno = input();
			yesno = loweru(yesno);
			"\b";
			if ((yesno == '�') || (yesno == 'yes') || (yesno == 'y') || (yesno == '��'))

				{
					"\n";
					scoreStatus(0, 0);			
					restart(initRestartEndings, global.endings);
					break;
				}
				else
				{
					"\n��� ������.\n";
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
	verb = 'help' '������'
	sdesc = "������"
	action(actor) = {
		printf(IDS_HELP_TEXT);
		abort;
	}
;

CreditsVerb: sysverb
	verb = '�������������' '�������������'
	sdesc = "�������������"
	action(actor) = {
		printf(IDS_CREDITS_TEXT);
		abort;
	}
;

Magic1Verb: sysverb
	verb = '�����1'
	sdesc = "�����1"
	action(actor) = {
		startbattle();
	}
;

Magic2Verb: sysverb
	verb = '�����2'
	sdesc = "�����2"
	action(actor) = {
		global.forceWin = true;
		basicNumObj.value = 0;
		basicNumObj.doBreak(Me);
	}
;


//�� ����� ������������ ��� ����� ������ ����� � �������� ����
replace additionalPreparsing: function( str )
{
	if ( (Me.location == spaceroom) && (cvtnum(str)>0) ) {
		   return ('���� � '+str);
	}
	//���� ���������� true, �� ��������� ���������
	return nil;
}

#pragma C-