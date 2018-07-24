/* Copyright (c) 2000 by Kevin Forchione.  All Rights Reserved. */
/*
 *  TADS LIBRARY EXTENSION
 *  TMORPH.T				
 *  version 3.0
 *
 *      tmorph.t provides a simple randomised "text morphing" 
 *      mechanism for TADS users. (Text morphing is the production 
 *      of randomised print strings).
 *  
 *
 *  Random Setting
 *  --------------
 *
 *  To use this function embed the text morphing syntax within the text
 *  string you wish to display. For example:
 *
 *      "[|A ball/Balls] of searing flame burst[s/] 
 *      out of your magic ring, rebound[s/] off of the ground, and 
 *      vaporize[s/] the kni[fe/ves] before [it/they] 
 *      can reach you.";
 *
 *  Place the elements to be morphed within [] brackets. No string 
 *  notation should be used inside of the brackets, as everything is 
 *  assumed to be text.
 *
 *  Each separate element of the morphing text should be separated by
 *  the '/' delimeter. If you do not wish to display any text simply 
 *  leave the element blank, for example: [silver/gold/] watch." 
 *  consists of 3 morphing elements, which would display:
 *
 *      gold watch
 *      silver watch
 *      watch
 *
 *  You can and should initialise the random generation at the beginning
 *  of a display sequence by putting the '|' initialiser at the beginning
 *  of the morphing sequence, e.g. [|apple/pear/peach]. The value used
 *  by subsequent text morphing syntax will use the value set by the
 *  initialiser.
 *
 *  Note that the sequence generated is random unless you specify a 
 *  sequencer_name and style in the initialisation section. For example, 
 *
 *  MorphSequencer
 *  --------------
 *
 *      [ringseq seq|A ball/Balls/A mighty fireball]
 *
 *  will dynamically create a sequencer object with the noun property of
 *  'ringseq'. This object will be initialized with a value of 1, which 
 *  means that your text morphing string will begin with #1 in its 
 *  morphing element list and sequentially progress each time the
 *  text switch with the initialiser is called. When the end of the list
 *  is reached the last value in the list is displayed from that point
 *  on. In our example the 1st time, 'A ball' is displayed; the 2nd,
 *  'Balls' displays, and all subsequent displays are 'A mighty
 *  fireball'.
 *
 *  MorphRandomizer
 *  ---------------
 *  
 *      [ringrnd rnd|A ball/Balls/A mighty fireball]
 *
 *  will dynamically create a sequencer object with the noun property of
 *  'ringrnd'. Display is produced in a completely random fashion.
 *
 *  MorphModulus
 *  ------------
 *
 *      [ringmod mod|A ball/Balls/A mighty fireball]
 *
 *  will dynamically create a sequencer object with the noun property of 
 *  'ringmod'. This object will be initialized with a value of 1, which
 *  means that your text morphing string will begin with #1 in its
 *  morphing element list and sequentially progress each time the text
 *  switch with the initialiser is called. When the end of the list
 *  is reached display starts over from the beginning.
 *
 *  MorphRedRndSeq
 *  --------------
 *
 *      [ringrrs rrs|A ball/Balls/A mighty fireball]
 *
 *  will dynamically create a sequencer object with the noun property of 
 *  'ringrrs'. This object works with a self-reducing random selection
 *  list that then returns the last displayed element when the list has
 *  been exhausted. 
 *
 *  MorphRedRndMod
 *  --------------
 *
 *      [ringmod mod|A ball/Balls/A mighty fireball]
 *
 *  will dynamically create a sequencer object with the noun property of 
 *  'ringmod'. This object works with a self-reducing random selection
 *  list that then resets the list when the list has been exhausted. 
 *
 *  Dynamic Control
 *  ---------------
 *
 *  For more dynamic control, based on game-state, you should first set
 *  the value of global.randomHold and remove any initialiser from the 
 *  text morph. For example:
 *
 *      global.randomHold = object.knifeCount;
 *      [A ball/Balls/A mighty fireball]
 *
 *----------------------------------------------------------------------
 *  REQUIREMENTS
 *
 *      + HTML TADS 2.2.6 or later
 *      + Should be #included after ADV.T and STD.T or WorldClass.t or 
 *        pianosa.t
 *
 *----------------------------------------------------------------------
 *  IMPORTANT LIBRARY INTERFACE AND MODIFICATION
 *
 *      None.
 *
 *----------------------------------------------------------------------
 *  COPYRIGHT NOTICE
 *
 *  	You may modify and use this file in any way you want, provided that
 *		if you redistribute modified copies of this file in source form, the
 *   	copies must include the original copyright notice (including this
 *   	paragraph), and must be clearly marked as modified from the original
 *   	version.
 *
 *------------------------------------------------------------------------------
 *  REVISION HISTORY
 *
 *		20-Feb-00:	Creation.
 *      21-Feb-00:  Modified to include init in the function call.
 */
 
#define __TMORPH_MODULE_

#pragma C+

morphFilter: function;
formatMorphText: function;
tm: function;
morphTracker: function;

/*
 *  morphFilter: function(str)
 *  
 *  Set this filter in commonInit(). It will continue to pass str to the
 *  formatMorphText() function until the function returns nil.
 *
 *      setOutputFilter(morphFilter);
 */
morphFilter: function(str)
{
    local ret;
    
    ret = formatMorphText(str);
    while(ret) 
    {
        str = ret;
        ret = formatMorphText(str);
    }
    return str;      
}

/*
 *  formatMorphText: function(str)
 *
 *  This function locates the first occurrence of a "text switch" and
 *  replaces it with the generated switch value from tm().
 */
formatMorphText: function(str)
{
    local i, f1, f2, bit, len, val, ret, grp, newstr = '';
    
    //  Find the "text switch"
    ret = reSearch('%[([^%[]*/+[^%[]*)%]', str);
    if (ret == nil) return nil;
    f1 = ret[1];
    f2 = ret[2];
    
    //  Get the information within the brackets  
    grp = reGetGroup(1);
    bit = grp[3];
    
    //  Search for '|' initialiser symbol and set init val
    ret = reSearch('(.*)%|', bit);
    if (ret != nil)
    {
        grp = reGetGroup(1);
        if (grp != nil)
        {
            if (grp[2] > 0)
                val = grp[3];
            else val = 0;
        }
        else val = nil;
        //  strip initialiser symbol and any val from bit
        bit = substr(bit, ret[2]+1, length(bit));
    }
    
    //  Translate switches into a single value
    bit = tm(bit, val);
    
    //  Build new string
    if (f1 != 1)
        newstr += substr(str, 1, f1-1);
    newstr += bit;
    if (f1+f2 != length(str))
        newstr += substr(str, f1+f2, length(str));
        
    return newstr;
}

/*
 *  tm: function(str, val)
 *
 *  This function creates a list of single-quote strings from the str
 *  parameter, using '/' as delimiters. It also sets the
 *  global.randomHold used to maintain morphing consistency. 
 */
tm: function(str, val)
{
    local i, s, w = '', list = [];
    
    for (i = 1; i <= length(str); ++i)
    {
        s = substr(str, i, 1);
        if (s == '/')
        {
            list += w;
            w = '';
        }
        else w += s;
    }
    list += w;
    
    
    if (val == 0) 
        global.randomHold = val;
    else if (val != nil)
        global.randomHold = morphTracker(val, length(list));
    
    if (proptype(global, &randomHold) != DTY_NUMBER 
    || global.randomHold < 1)
        global.randomHold = _rand(length(list));
    
    return list[global.randomHold];
}

/*
 *  morphTracker: function(str, len)
 *
 *  Function creates a dynamic object using the sequence_name provided
 *  by the initialisation area of the text morph. This object is
 *  initialised with val and given the noun vocabulary of the
 *  sequence_name. 
 *  
 *  If no val was provided then the object is initialised for position
 *  1 in the list of morphing elements.
 */
morphTracker: function(str, len)
{
    local tokenList, typeList, objList, mt, tk, ty, o;
    
    tokenList   = parserTokenize(str);
    typeList    = parserGetTokTypes(tokenList);
    
    tk          = tokenList[1];
    ty          = typeList[1];
    
    if (length(tokenList) == 2)
        mt = tokenList[2];
    else mt = 'rnd';
    
    objList = parserDictLookup([tk], [ty]);
    if (objList && length(objList))
        o = objList[1];
    else
    {
        switch(mt)
        {
            case 'seq':
                o = MorphSequencer.instantiate(tk, len);
                break;
                
            case 'mod':
                o = MorphModulus.instantiate(tk, len);
                break;
                
            case 'rrm':
                o = MorphRedRandMod.instantiate(tk, len);
                break;
                
            case 'rrs':
                o = MorphRedRandSeq.instantiate(tk, len);
                break;
                
            default:
                o = MorphRandomizer.instantiate(tk, len);
                break;
        }
    }

    return o.getVal;
}

class MorphSequencer: object
    noun    = ''
    len     = 0
    val     = 0
    
    getVal = {
        self.val++;
        
        if (self.val > self.len)
            self.val = len;
            
        return self.val;
    }
    
    instantiate(tk, l) = {
        local x = new MorphSequencer;
        
        x.len   = l;
        addword(x, &noun, tk);
        
        return x;
    }
;

class MorphRandomizer: MorphSequencer
    getVal = {
        self.val = _rand(self.len);
            
        return self.val;
    }
    
    instantiate(tk, l, ) = {
        local x = new MorphRandomizer;
        
        x.len   = l;
        addword(x, &noun, tk);
        
        return x;
    }
;

class MorphModulus: MorphSequencer
    getVal = {
        self.val++;
        
        if (self.val > self.len)
            self.val = 1;
            
        return self.val;
    }
    
    instantiate(tk, l) = {
        local x = new MorphModulus;
        
        x.len   = l;
        addword(x, &noun, tk);
        
        return x;
    }
;

class MorphRedRandMod: MorphSequencer
    rndList = []
    
    getVal = {
        local i, ln, n, newList = [];
        
        ln = length(self.rndList);
        
        if (ln == 0)
        {
            // rebuild the rndList
            ln = self.len;
            self.rndList = [];
            for (i = 1; i <= ln; ++i)
                self.rndList += i;
        }

        n = _rand(ln);
        self.val = self.rndList[n];
        
        for (i = 1; i <= ln; ++i)
            if (self.rndList[i] != self.val)
                newList += self.rndList[i];
                
        self.rndList = newList;
                    
        return self.val;
    }
    
    instantiate(tk, l) = {
        local x = new MorphRedRandMod;
        local i;
        
        x.len   = l;
        x.rndList = [];
        for (i = 1; i <= l; ++i)
            x.rndList += i;
        
        addword(x, &noun, tk);
        
        return x;
    }
;

class MorphRedRandSeq: MorphSequencer
    rndList = []
    
    getVal = {
        local i, ln, n, newList = [];
        
        ln = length(self.rndList);
        
        if (ln == 0)
        {
            return self.val;
        }

        n = _rand(ln);
        self.val = self.rndList[n];
        
        for (i = 1; i <= ln; ++i)
            if (self.rndList[i] != self.val)
                newList += self.rndList[i];
                        
        self.rndList = newList;
                    
        return self.val;
    }
    
    instantiate(tk, l) = {
        local x = new MorphRedRandSeq;
        local i;
        
        x.len   = l;
        x.rndList = [];
        for (i = 1; i <= l; ++i)
            x.rndList += i;
        
        addword(x, &noun, tk);
        
        return x;
    }
;

#pragma C-
