// �������, ������������ ��������������� ����� �� ��������� ���������
replica: function(lexicon)
{
	local ind, len;
	len := length(lexicon.phrases);
	if(lexicon.any)
	{
		ind := rand(len);
		// ������������ ������ ����� ����� ������ ������
		if(ind = lexicon.last)
		{
			if(ind = 1)
				ind := ind + 1;
			else
				ind := ind - 1;
		}
	}
	else
	{
		// ���� �������� order ������� ��������� �������� ������ �������, �� ��������� ��� �������� ���� � ��������������� �������
		if(lexicon.order = [])
		{
			local i, numbers := [], number;
			// ������ ������ ����������� �����
			for(i := 1; i <= len; i++)
			{
				numbers := numbers + [i];
			}
			// "�������������" ����������� ����� � �������� order � ��������������� �������
			for(i := 1; i <= len; i++)
			{
				number := numbers[rand(length(numbers))];
				numbers := numbers - [number];
				lexicon.order := lexicon.order + [number];
			}
			// ������������ ������ ����� ����� ������ ������
			if(lexicon.order[1] = lexicon.last)
			{
				number := lexicon.order[1];
				lexicon.order := lexicon.order - [number];
				lexicon.order := lexicon.order + [number];
			}
		}
		ind := lexicon.order[1];
		lexicon.order := lexicon.order - [ind];
	}
	lexicon.last := ind;
	return lexicon.phrases[ind];
}

// ����� ��������� ����
class lexicon: object
	/*
	* �������� any ���������� ����� ��������� ���������.
	* ���� any = true, �� ������� replica() ����� ���������� ����� ����� (�� ����������� ��������� ������������).
	* ���� any = nil, �� ������� replica() ������� ��������������� ����� � ��������������� �������, ���������� � order, ��� ����� �� phrases, � ��� ����� ���� �� ������.
	* any = true ����� ���� ����������� � actorDesc, ��� ������ ������ �� ����� ��������.
	* �� � any = nil ������� ������������, ��������, � �������� ����������, ����� �������������� �� �������������.
	* ������, ��� any = nil, ��������������� ������� ���� ������������ ������ ��� ��-������.
	*/
	any = nil // �� ������������� �������������� � �������� �������
	phrases = [] // ������ ���� ���������
	// �������� last � order � �������� ������� ���� ������������� �� ���������
	last = 0 // ����� ��������� ������������ �� ��������� �����
	order = [] // ������� ������� ���� ���������
;

// �������� ���� ��� �������� �������
//lexiconStartroomLdesc: lexicon
//	phrases = [
//		'������ �������� �������.'
//		'������ �������� �������.'
//		'������ �������� �������.'
//		'�������� �������� �������.'
//		'����� �������� �������.'
//	]
//;