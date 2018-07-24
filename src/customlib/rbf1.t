/*
** S H U F F L E - function
** This will shuffle a list of any size, any objects.
** The algorithm is from Knuth.
*/
shuffle: function(list) {
	local i;
	local retlist;
	local tempitem;
	local ndx;
	retlist := list;
	for ( i := 1; i < length(list); i++) {
		ndx := rand(length(list));
		tempitem := retlist[i];
		retlist[i] := retlist[ndx];
		retlist[ndx] := tempitem;
		}
	return retlist;
	}

/*
** N D X V E C - function
** This will create a list (vector) of numeric data types
** Used internally by srtndx, it may have other uses, or
** at least nostalgic use by APL programmers
*/
ndxvec: function(entries) {
	local alist :=[];
	local i;
	for ( i := 1; i <= entries; i++) {
		alist := alist + i;
		}
	return(alist);
	}

/*
** V E C T O R - function
** This will arrange a list by the elements of the second argument.
** Second argument is an list of numeric data types, from 1 to
** the length(first list).
*/
vector: function(list,ilist) {

	local rlist := [];
	local elem;
	local listelem;

	while (car(ilist)) {
		elem := car(ilist);
		ilist := cdr(ilist);
		if (datatype(list[elem]) = 7) {
			listelem := list[elem];
			rlist := rlist + [listelem];
			}
		else {
			rlist := rlist + list[elem];
			}
		}

	return rlist;
	}

/*
** S R T N D X - function
** This will sort a list and return the sorted index vector
** that, if used with vector(), will yield the sorted list.
** The idea here is to get the sort order of the list and
** use it on another list.
** Simple bubble sort, no frills.
*/
srtndx: function(list,order) {
	local ilist := ndxvec(length(list));
	local lstlen := length(list);
	local check, check2;
	local temp, tempndx;

	while ( lstlen > 1 ) {
		for ( check := 1; check < lstlen; check++) {
			check2 := check + 1;
			if (morethan(list[check],list[check2])) {
				temp := list[check2];
				list[check2] := list[check];
				list[check] := temp;
				tempndx := ilist[check2];
				ilist[check2] := ilist[check];
				ilist[check] := tempndx;
				}
			}
		lstlen--;
		}

	if (order = 'A') {
		return ilist;
		}
	else {
		return(reverse(ilist));
		}
	}

/*
** R E V E R S E - function
** Reverses a list.  Used by SRTNDX
*/
reverse: function(list) {
	local ndx;
	local rlist := ndxvec(length(list));
	local i, j;
	for ( i := length(list); i > 0; i--) {
		j := length(list) - i + 1;
		rlist[i] := list[j];
		}
	return rlist;
	}
/*
** M O R E T H A N - function
** Returns 0 or 1, depending on the comparison of the
** two objects. True if obj1 > obj2.
** different objects compare according to value returned
** by datatype(), same objects compare as follows:
** number & string: natural order; object: compare sdesc
** if present, otherwise equal; nil is less than true;
** lists compare based on number of elements; function and
** property pointers are always equal.
*/
morethan: function(elem1, elem2) {
	local cmprval := nil;
	if (datatype(elem1) = datatype(elem2)){
		switch (datatype(elem1)){
			case 1:
			case 3:
				cmprval := elem1 > elem2;
				break;
			case 2:
				if (proptype(elem1,&sdesc) = proptype(elem2,&sdesc)){
					switch ( proptype(elem1,&sdesc) ) {
						case 1:
						case 3:
							cmprval := elem1.sdesc > elem2.sdesc;
							break;
						case 7:
							cmprval := length(elem1.sdesc) > length(elem2.sdesc);
							break;
						default:
						}
					}
				break;
			case 7:
				cmprval := length(elem1) > length(elem2);
				break;
			default:
				cmprval := nil;
			}
		}
	else {
		cmprval := datatype(elem1) > datatype(elem2);
		}
	return cmprval;
	}