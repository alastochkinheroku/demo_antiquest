//Ñòðîêè
#pragma C++

//Àíàëîã Ñ# ôóíêöèè ïå÷àòè
//printf('òåêñò') -> "òåêñò"
//printf('text %1 %2', 3, 4) -> "text 3 4"
printf : function(fmt, ...)
{
  local i, ret, pattern, pos, len, newstr;
  local str=fmt;
  for (i=1;i<argcount;i++)
  {
    pattern = '%%' + cvtstr(i);
	ret = reSearch(pattern, str);
	while (ret != nil)
	{
		 pos = ret[1];
	     len = ret[2];
	     newstr = substr(str,1,pos-1) + cvtstr(getarg(i+1));
		 str = substr(str,pos+len,length(str));
		 //"pos=<<pos>>, len=<<len>>, newstr=<<newstr>>, str=<<str>>\n";
		 ret = reSearch(pattern, str);
	}
	str = newstr + str;
  }
#ifndef NO_SAY_PRINTF
  str += '<br>';
  say(str);
#else
  return str;
#endif
}

#ifdef UNITTEST
///////////////////
TestStrings: Test
  name = 'Ïðîâåðêà ñòðîê'
  exec={
     //CHECK_EQU(printf('ïðèâåò'),'ïðèâåò');
	 CHECK_EQU(printf('ïðèâåò %1 ', 2),'ïðèâåò 2 ');
	 CHECK_EQU(printf('%1 + %2 = %3', 5, 6, 11),'5 + 6 = 11');
  }
;
#endif

//find: \s*\(\s*actor\s*\)\s*\=\s*"
//      \s*\(\s*actor\s*\)\s*\=\s*{\s*"
//      \s*\=\s*\{\s*"
//      \s*\=\s*\s*"
//replace: \t\t' èëè '

#define IDS_VERSION_FMT '<b> Antiquest demo</b> <br> <br> Author: Lastochkin Anton <br> Version %1 <br>Type <b>help</b> if you’re playing for the first time. Enter <b>credits</b> to read some eulogies. Attention! This is cutted version, only as example of using translation. '
#define IDS_HELP_TEXT ''
#define IDS_CREDITS_TEXT '\t\b<b>Credits</b>\b The author expresses his deepest gratitude to all who helped creating this game. First of all, I want to thank Brian Rushton, who was the first one to test it. \n Beta testers: Brian Rushton, Ivan Roth, Nikita Tseykovets and Alik Gadzhimuradov. \n Translators: Peter Lastochkin, Valentin Kopteltsev (uux). \n Also thank you, dear \“game-reader\”, for trying this odd piece.\n\n The following songs are used with the permissions of it’s creators:\n*SaReGaMa - Fractal Universe (https://www.jamendo.com/track/856979/saregama-fractal-universe)\n*Capashen - Departure Electro (https://www.jamendo.com/track/1075892/departure-electro).\n'
#define IDS_ENDINGS 'Endings:'
#define IDS_FOUND_ENDINGS 'Endings being found: %1 of %2. \n'
#define IDS_INTRO 'I think I know every inch of this room by heart. More than a week passed, and they still didn’t put me in stasis. All the others were frozen, some even successfully. Could it be they just forgot about me? <br>'
#define IDS_ME_LDESC 'I’m wearing a white patient gown.'

#define IDS_WAIT_DEFAULT     'I waited a bit in this room.'
#define IDS_JUMP_DEFAULT     'I jumped up and down in this room.'
#define IDS_DIG_DEFAULT      'I’m digging in this room.'
#define IDS_YELL_DEFAULT     'I screamed a bit in this room.'
#define IDS_WALL_DEFAULT     'Just ordinary walls, if I notice something special, I\’ll tell you.'
#define IDS_FLOOR_DEFAULT    'A metal floor, quite usual for space stations. '
#define IDS_FLOOR_SIT        'OK, now I’m sitting on the cold floor.'
#define IDS_CEILING_DEFAULT  'Yep, it’s a ceiling. If I notice something special about it, I’ll tell you. '
#define IDS_LISTEN_DEFAULT   'If I hear something unusual, I’ll certainly tell you.'
     
#define IDS_HALAT_DESC       'A simple hospital gown. Something tells me I won’t be able to use it directly in this game.'
     
// STARTROOM
#define IDS_STARTROOM_LDESC  'There’s just a long bed in the middle of this empty white room. The exit is to the west.'
#define IDS_STARTROOM_WAIT   'For a while, I’m lost in deep thought about the meaning of life. Finally, curiosity gets the best of me, and I step out into the corridor.'
#define IDS_STARTROOM_NOEXIT 'I throw myself against the wall, and it breaks! Boy, am I strong! After that, I slowly walk through the breach I made.'
#define IDS_STARTROOM_JUMP   'I jump, bump my head, and collapse. On regaining consciousness, I find myself in an entirely different place.'
#define IDS_STARTROOM_DIG    'I decided to dig a tunnel. I’m not sure whether this is a common practice aboard space stations; maybe I’m the first one to do that. Suddenly, someone grabbed and dragged me.'
#define IDS_STARTROOM_HIT    'When I hit the wall, I screamed.'
#define IDS_STARTROOM_TALK   'It’s time to talk to this room. Maybe the ultrasmart system tells me how to go into stasis. After all, my only interlocutor last week was an imaginary friend. As soon as I start talking, a robot round as a pancake rolls in, makes me lie down on its back, and wheels me away to an unknown destination.'
#define IDS_STARTROOM_CLEAN  'When doing the clean-up, I move the bed and see a huge hole occupying almost the whole wall. So, that’s where these constant cold droughts hitting my legs and nasty grinding noises came from! I decide to enter it immediately. '
#define IDS_STARTROOM_SEARCH 'When doing the search, I move the bed and see a huge hole occupying almost the whole wall. So, that’s where these constant cold droughts hitting my legs and nasty grinding noises came from! I decide to enter it immediately. '
     
// STARTBED
#define IDS_STARTBED_LDESC    'This bed is about four yards long. I wonder what people it’s been made for. '
#define IDS_STARTBED_TALK     'I decided to talk to the bed. I see nothing embarrassing about it. After all, my only interlocutor last week was an imaginary friend. As soon as I start talking, a robot round as a pancake rolls in, makes me lie down on its back, and wheels me away to an unknown destination. '
#define IDS_STARTBED_MOVE     'I move the bed aside and see a huge hole occupying almost the whole wall. So, that’s where these constant cold droughts hitting my legs and nasty grinding noises came from! I decide to enter it immediately.'
#define IDS_STARTBED_TAKE     'My, it’s a great thing! And so useful! I crawl under the bed and try to push it up at the middle – unsuccessfully. Then, I lift it at the edge. While I’m holding it up, a round robot rolls in and starts searching the cabin. An electronic voice unfamiliar to me says, \”We shouldn’t have taken him from the stasis room, it’d be better to leave him there\”. As I groan, the robot quickly climbs the bed and jumps. My arms weren’t made for such a weight...'
#define IDS_STARTBED_DROP      'I decided to throw the useless bed away. As I was dragging it towards the exit, a strange flickering light in the corridor attracted me.  '
#define IDS_STARTBED_WEAR      'Interesting idea! As far as can tell, the bed suits me fine. If not, I’ll just alter it. As I try to put the bed on, a round robot rolls in, blinks its LEDs at me, then fastens me to its flat back, and wheels me away.'
#define IDS_STARTBED_READ      'Maybe my bed is exactly the stasis apparatus I’m looking for? I started trying to find and decipher any. After an hour, I managed to make out a few symbols. As I was examining the bed, a robot sneaked up behind me, seized me by the gown and wheeled me away... '
#define IDS_STARTBED_TURN      'I’m sick and tired of sleeping with my head towards the exit! It’s time to turn the bed around! As I try to do that, I notice a huge hole in the wall. Getting curious, I creep inside.  '
#define IDS_STARTBED_TURNON    'Those beds must have a switch indeed. After all, I’m aboard a spaceship, so it can’t be just a plain bed! While I was looking for the button, a flat robot rolled in, tied me to its back and wheeled me away. '
#define IDS_STARTBED_TURNOFF   'It’s time to turn this bed off. Maybe this starts the stasis process. While I was looking for a button on my bed, a flat robot rolled in, tied me to its back and wheeled me away. '
#define IDS_STARTBED_SCREW     'I think my bed is not stable enough, so that I risk falling down from it. It’s time to fasten it to the floor, albeit I don’t have an appropriate tool. A pity I can’t tighten screws with my tongue! I start looking for the bed part most suitable for screwing and suddenly see a hole in the back wall! I decide to enter it immediately. '
#define IDS_STARTBED_UNSCREW   'It’s time to unscrew and disassemble this bed for good and demand a new one, with a double mattress. I start looking for the most appropriate part to unscrew and suddenly see a hole in the back wall! I decide to enter it immediately. '
#define IDS_STARTBED_EAT       'I lick the side of the bed, then, bite into the bed sheet. I think the bed in the neighbor cabin is tastier. While I was nibbling at the bed, a robot with a circular platform on its back sneaked up behind me, seized me, put me on its platform, and wheeled me away. '
#define IDS_STARTBED_CLEAN     'As I begin making the bed, a sound from the corridor attracts my attention, and I go towards it. '
#define IDS_STARTBED_BREAK     'I kick the bed as hard as I can. It goes through the wall and tumbles down noisily. I couldn’t’t imagine I’m that strong! I pass through the newly created breach.'
#define IDS_STARTBED_SEARCH    'I look behind the bed and see a hole! A huge one – it occupies practically the whole wall. So, that’s where these constant cold droughts hitting my legs and nasty grinding noises came from! I decide to enter it immediately. '
#define IDS_STARTBED_LISTENTO  'I listen to the bed closely for a while. Maybe it’s speaking not loud enough. '
#define IDS_STARTBED_SMELL     'It has a strange odor. I sniffed at it one more time, and it seemed even weirder to me.  '
#define IDS_STARTBED_TOUCH     'While I was touching the bed, a robot with a circular platform on its back sneaked up behind me, seized me, put me on its platform, and wheeled me away.  '
     
// coridorroom
#define IDS_CORID_LDESC    'A narrow grey corridor leading from north to south.'
#define IDS_CORID_WAIT     'After waiting a while in the corridor, I got bored and started pacing up and down. My memory began returning to me, and I remembered how they tried to put me into stasis but failed, and the doctor mentioned certain undesirable side effects such as amnesia and partial dementia. I kept pacing and talking to myself until wearing my legs off entirely. '
#define IDS_CORID_NOEXIT   'I start tapping along the corridor wall, find a hollow place and make a hole with my elbow. Then, I enter the newly created breach. '
#define IDS_CORID_JUMP     'I jump, bounce off the ceiling and fly into one of the walls. It collapses noisily, and I find myself in a different place. '
#define IDS_CORID_DIG      'With great presence of mind, I ram my head into the floor. Cracks start running from the dimple, and the nearby wall collapses. I pass through the breach. '
#define IDS_CORID_HIT      'Getting a running start, I kick the wall and breach it! Then, I slowly enter the newly created passage. '
#define IDS_CORID_TALKDESC 'As soon as I start to talk to the corridor I understand that my interlocutor doesn’t know anything about stasis capsules, and stop grilling him.  '
#define IDS_CORID_CLEAN    'I started a clean-up in the corridor. It made me remember my youth...  '
#define IDS_CORID_SEARCH   'I searched all cracks and winkles Ð no track of any stasis grains or hibernation grass.  '
      
//state move
#define AUTO_MOVE_STARTROOM      'I can’t stay here for so long. I’d rather leave for the corridor. '
#define AUTO_MOVE_CORIDOR      'Enough loafing around! I flip an imaginary coin, and decide to visit the northern part of the corridor. '
#define AUTO_MOVE_RUN      'Enough loafing around! I flip an imaginary coin, and decide to visit the northern part of the corridor.'
#define AUTO_MOVE_MED      'Getting tired of examining the robot, I vigorously walk towards the exit. As I see the medic is after me with a huge syringe I quicken my pace to a jog. Behind my back, a siren starts wailing. '
#define AUTO_MOVE_CROOM      'I look at my cabin through the translucent floor, then, kneel down and hit it with both my hands. While  flying down, I hear dozens of tiny manipulators patching the breach. '
#define AUTO_MOVE_ANABIA      'After rambling about the room for a while, I wisely move towards the exit. '
#define AUTO_MOVE_NEST      'How boring! Let’s get out of here.'
#define AUTO_MOVE_TELE      'Enough watching TV, time to get back to work!'
#define AUTO_MOVE_CARGO     'What an interesting place, I’d like to walk around some more.'

//endings
#define IDS_DIE_BED    'Crushed down in an improper place'
#define IDS_DIE_MED    'Put to eternal rest by an attentive robot'
#define IDS_DIE_RUN    'Got a thorough ironing during a friendly chat '
#define IDS_HERO_END    'Went to carry out previously forgotten vile plans'
#define IDS_DEEP_END    'Lost in deep space with the spaceships because of my own greed '
#define IDS_BUNT_END    'Blatantly betrayed by my own crew during meditations '
#define IDS_STAR_END    'The way to space is paved using brute force '
#define IDS_DIE_WALK    'Worn off completely due to a nervous breakdown'
#define IDS_DIE_YELL    'Swatted as a persistent troublemaker  '
#define IDS_DIE_SLEEP   'Made my dream come true'
#define IDS_DIE_EAT     'Became a gastropod because of indigestion'
#define IDS_DIE_TELE    'Underestimated the harm of watching TV'
#define IDS_DIE_ECZO    'Died of an anticipated failure after an epic win'
    
#define IDS_DIE_BED_HINT    'I feel the urge to lift the bed...'
#define IDS_DIE_MED_HINT    'For some reason, I want to show off in front of the medical robot; maybe do a somersault?'
#define IDS_DIE_RUN_HINT    'When I run down the corridor, I just can’t help wiping something clean...'
#define IDS_HERO_END_HINT    'Hm, the control panel had a voice interface it seems.'
#define IDS_DEEP_END_HINT    'This panel in the control room is always out of place. I should reposition it...'
#define IDS_BUNT_END_HINT    'What’s been written on the control panel? Can’t remember it...'
#define IDS_STAR_END_HINT    'The control room bores me to death, time to tear it apart.'
#define IDS_DIE_WALK_HINT    'The corridor is so dull compared to my cabin, I don’t want to do anything there.'
#define IDS_DIE_YELL_HINT    'They say silent cables have their own secret lives and are very sensitive to loud noise.'
#define IDS_DIE_SLEEP_HINT    'After all, I should try to go to sleep inside the stasis chamber. '
#define IDS_DIE_EAT_HINT    'I’d like to eat some gourmet food. Do they serve mollusks anywhere here?'
#define IDS_DIE_TELE_HINT    'I always have the feeling all screens are turned the wrong way.'
#define IDS_DIE_ECZO_HINT    'I need to overcome my fears and put on some really cool clothing. '
    
#define IDS_FMT_NEW_ENDING    '\b<b>*** NEW ENDING %1!***</b>\b'
#define IDS_FMT_OLD_ENDING    '\b<b>*** THIS IS THE END %1! ***</b>\b'
#define IDS_START_NEW_GAME    '\b*** BEGINNING OF A NEW GAME***\b'
    
//sea battle
#define IDS_SPACE_INTRO    'I think I’m in a different dimension, where my command spaceship accompanied by a fighter and a bomber has to defeat the enemy having a similar fleet. This bastard hides on the other side of the ice planet, his defending systems are in perfect working order, he’s no easy prey. Fortunately, we managed to locate a weak signal and can hit targets in %1 areas with our ballistic missiles. Before the engagement, I can change the orbital positions of our ships within the same range. Our sensors can detect when an enemy ships is hit or destroyed. Full steam ahead!'
#define IDS_SPACE_LDESC    'The battle map covering %1 areas is projected onto my retina.'
#define IDS_SPACE_CANMOVE    'I still can move my ships; e.g., by typing \"move flagship to 1\" I place the stem of my command spaceship to the first area, and its stern to the third area. To shoot, you need to specify the area: \"hit 5\". The battle map displays up-to-date information about the fleet.'
#define IDS_SPACE_START_WARNING    'I can’t move my ships after the combat has begun!'
#define IDS_SPACE_MY_FLEET    '<br> My fleet: <br>'
#define IDS_SPACE_EN_FLEET    '<br>Enemy: <br>'
#define IDS_SPACE_FL_LDESC    'Big ship, occupies 3 areas.'
#define IDS_SPACE_FI_LDESC    'Middle-sized ship, occupies 2 areas.'
#define IDS_SPACE_BO_LDESC    'Middle-sized ship, occupies 2 areas.'
#define IDS_SPACE_INV_NUM    'Not used in adventure mode.'
    
#define IDS_SPACE_MAP_MOVE_OK    'The ship changed its position.'
#define IDS_SPACE_MAP_MOVE_LOW_EDGE    'I can’t move the ship beneath the bottom boundary of the battle zone!'
#define IDS_SPACE_MAP_MOVE_HIGH_EDGE    'I can’t move the ship over the top boundary of the battle zone!'
#define IDS_SPACE_MAP_MOVE_NOT_FREE    'The destination area is occupied by another spaceship.'
#define IDS_SPACE_MAP_MOVE_TOO_CLOSE    'I can’t put the spaceship so near to the neighbour ship.'
#define IDS_SPACE_MAP_MOVE_DISALLOW    'This manoeuvre is not allowed.'   
#define IDS_SPACE_MAP_ERR_MOVE    'Movement error: %1'   
    
#define IDS_SPACE_HIT_RES_LOW_EDGE    'I can’t shoot below the bottom boundary of the battle zone, there are no enemy ships there! '
#define IDS_SPACE_HIT_RES_HIGH_EDGE    'I can’t shoot over the top boundary of the battle zone, there are no enemy ships there!'
#define IDS_SPACE_HIT_RES_ALREADY    'This area has been shot at already.'
#define IDS_SPACE_HIT_RES_MISS    'A miss is recorded.'
#define IDS_SPACE_HIT_RES_GOT    'The sensors detect a series of explosions on the other side of the planet. The enemy ship is hit. '
#define IDS_SPACE_HIT_RES_KILL    'The systems of one of the enemy ships break down completely! It falls onto the planet. '
#define IDS_SPACE_EN_HIT_RES_MISS    'The enemy’s missile missed us.'
#define IDS_SPACE_EN_HIT_RES_GOT    'One of our ships is hit! Engaging reserve modules...'
#define IDS_SPACE_EN_HIT_RES_KILL    'Our spaceship is shot down. Preparing for a crash landing on the planet...'
    
#define IDS_SPACE_VICTORY    'We have won! Should I return to our main base or wake up? My mind turns to thoughts about things I haven’t tried yet. '
#define IDS_SPACE_DEFEAT    'All my ships are shot down; I have no other choice but to wake up.'
#define IDS_SPACE_FMT_UNKNOWN_STATE    'Unexpected case: %1'

//Âñòàâèòü ñðàçó ïîñëå #include <strings_en.t>
//Òåñòû îøèáîê ïðè óñòàíîâêå ñòðîê
/*
test_lang : function
{
printf(IDS_WAIT_DEFAULT);
printf(IDS_JUMP_DEFAULT);
printf(IDS_DIG_DEFAULT);
printf(IDS_YELL_DEFAULT);
printf(IDS_WALL_DEFAULT);
printf(IDS_FLOOR_DEFAULT);
printf(IDS_FLOOR_SIT);
printf(IDS_CEILING_DEFAULT);
printf(IDS_LISTEN_DEFAULT);
     
printf(IDS_HALAT_DESC);
     
// STARTROOM
printf(IDS_STARTROOM_LDESC);
printf(IDS_STARTROOM_WAIT);
printf(IDS_STARTROOM_NOEXIT);
printf(IDS_STARTROOM_JUMP);
printf(IDS_STARTROOM_DIG);
printf(IDS_STARTROOM_HIT);
printf(IDS_STARTROOM_TALK);
printf(IDS_STARTROOM_CLEAN);
printf(IDS_STARTROOM_SEARCH);
     
// STARTBED
printf(IDS_STARTBED_LDESC);
printf(IDS_STARTBED_TALK);
printf(IDS_STARTBED_MOVE);
printf(IDS_STARTBED_TAKE);
printf(IDS_STARTBED_DROP);
printf(IDS_STARTBED_WEAR);
printf(IDS_STARTBED_READ);
printf(IDS_STARTBED_TURN);
printf(IDS_STARTBED_TURNON);
printf(IDS_STARTBED_TURNOFF);
printf(IDS_STARTBED_SCREW);
printf(IDS_STARTBED_UNSCREW);
printf(IDS_STARTBED_EAT);
printf(IDS_STARTBED_CLEAN);
printf(IDS_STARTBED_BREAK);
printf(IDS_STARTBED_SEARCH);
printf(IDS_STARTBED_LISTENTO);
printf(IDS_STARTBED_SMELL);
printf(IDS_STARTBED_TOUCH);
     
// coridorroom     //coridorroom
printf(IDS_CORID_LDESC);
printf(IDS_CORID_WAIT);
printf(IDS_CORID_NOEXIT);
printf(IDS_CORID_JUMP);
printf(IDS_CORID_DIG);
printf(IDS_CORID_HIT);
printf(IDS_CORID_TALKDESC);
printf(IDS_CORID_CLEAN);
printf(IDS_CORID_SEARCH);
     
// techsection
printf(IDS_TECH_LDESC);
printf(IDS_TECH_WAIT);
printf(IDS_TECH_NOEXIT);
printf(IDS_TECH_JUMP);
printf(IDS_TECH_DIG);
printf(IDS_TECH_HIT);
printf(IDS_TECH_TALKDESC);
printf(IDS_TECH_CLEAN);
printf(IDS_TECH_SEARCH);
printf(IDS_TECH_YELL);
     
//cable
printf(IDS_KABEL_LDESC);
printf(IDS_KABEL_TALK);
printf(IDS_KABEL_MOVE);
printf(IDS_KABEL_TAKE);
printf(IDS_KABEL_DROP);
printf(IDS_KABEL_WEAR);
printf(IDS_KABEL_READ);
printf(IDS_KABEL_TURN);
printf(IDS_KABEL_TURNON);
printf(IDS_KABEL_TURNOFF);
printf(IDS_KABEL_SCREW);
printf(IDS_KABEL_UNSCREW);
printf(IDS_KABEL_EAT);
printf(IDS_KABEL_CLEAN);
printf(IDS_KABEL_BREAK);
printf(IDS_KABEL_SEARCH);
printf(IDS_KABEL_LISTENTO);
printf(IDS_KABEL_SMELL);
printf(IDS_KABEL_TOUCH);
     
// medroom     //medroom
printf(IDS_MEDROOM_LDESC);
printf(IDS_MEDROOM_WAIT);
printf(IDS_MEDROOM_NOEXIT);
printf(IDS_MEDROOM_JUMP);
printf(IDS_MEDROOM_DIG);
printf(IDS_MEDROOM_HIT);
printf(IDS_MEDROOM_TALKDESC);
printf(IDS_MEDROOM_CLEAN);
printf(IDS_MEDROOM_SEARCH);
printf(IDS_MEDROOM_END);
     
// robotmed  
printf(IDS_MEDROBOT_LDESC);
printf(IDS_MEDROBOT_TALKDESC);
printf(IDS_MEDROBOT_MOVE);
printf(IDS_MEDROBOT_TAKE);
printf(IDS_MEDROBOT_DROP);
printf(IDS_MEDROBOT_WEAR);
printf(IDS_MEDROBOT_READ);
printf(IDS_MEDROBOT_TURN);
printf(IDS_MEDROBOT_TURNON);
printf(IDS_MEDROBOT_TURNOFF);
printf(IDS_MEDROBOT_SCREW);
printf(IDS_MEDROBOT_UNSCREW);
printf(IDS_MEDROBOT_EAT);
printf(IDS_MEDROBOT_CLEAN);
printf(IDS_MEDROBOT_BREAK);
printf(IDS_MEDROBOT_SEARCH);
printf(IDS_MEDROBOT_LISTENTO);
printf(IDS_MEDROBOT_SMELL);
printf(IDS_MEDROBOT_TOUCH);
     
//coridor run 
printf(IDS_RUN_LDESC);
printf(IDS_RUN_WAIT);
printf(IDS_RUN_NOEXIT);
printf(IDS_RUN_JUMP);
printf(IDS_RUN_DIG);
printf(IDS_RUN_NORTH);
printf(IDS_RUN_SOUTH);
printf(IDS_RUN_HIT);
printf(IDS_RUN_TALKDESC);
printf(IDS_RUN_CLEAN);
printf(IDS_RUN_SEARCH);
       
// anabia
printf(IDS_ANABIA_LDESC);
printf(IDS_ANABIA_WAIT_OUT);
printf(IDS_ANABIA_WAIT_IN);
printf(IDS_ANABIA_NOEXIT);
printf(IDS_ANABIA_JUMP);
printf(IDS_ANABIA_DIG);
printf(IDS_ANABIA_HIT);
printf(IDS_ANABIA_TALKDESC);
printf(IDS_ANABIA_CLEAN);
printf(IDS_ANABIA_SEARCH);

// anabia bed 
printf(IDS_ANBED_LDESC);
printf(IDS_ANBED_LIE);
printf(IDS_ANBED_MOVE);
printf(IDS_ANBED_TAKE);
printf(IDS_ANBED_READ);
printf(IDS_ANBED_TURN);
printf(IDS_ANBED_TURNON);
printf(IDS_ANBED_TURNOFF);
printf(IDS_ANBED_SCREW);
printf(IDS_ANBED_UNSCREW);
printf(IDS_ANBED_EAT);
printf(IDS_ANBED_CLEAN);
printf(IDS_ANBED_BREAK);
printf(IDS_ANBED_SEARCH);
printf(IDS_ANBED_LISTENTO);
printf(IDS_ANBED_SMELL);
printf(IDS_ANBED_TOUCH);
     
//control room 
printf(IDS_CROOM_LDESC);
printf(IDS_CROOM_WAIT);
printf(IDS_CROOM_NOEXIT);
printf(IDS_CROOM_JUMP);
printf(IDS_CROOM_DIG);
printf(IDS_CROOM_HIT);
     
//control panel
printf(IDS_PANEL_LDESC);
printf(IDS_PANEL_TALKDESC);
printf(IDS_PANEL_MOVE);
printf(IDS_PANEL_READ);
printf(IDS_PANEL_TURNON);
printf(IDS_PANEL_EAT);
printf(IDS_PANEL_CLEAN);
printf(IDS_PANEL_BREAK);
printf(IDS_PANEL_LISTENTO);
printf(IDS_PANEL_SMELL);
printf(IDS_PANEL_TOUCH);
printf(IDS_PANEL_BEFORE_BREAK);
printf(IDS_PANEL_BEFORE_BUNT);
printf(IDS_PANEL_AFTER_OUT);
    
//nest
printf(IDS_NEST_LDESC);
printf(IDS_NEST_WAIT);
printf(IDS_NEST_NOEXIT);
printf(IDS_NEST_JUMP);
printf(IDS_NEST_DIG);
printf(IDS_NEST_HIT);
printf(IDS_NEST_TALKDESC);
printf(IDS_NEST_CLEAN);
printf(IDS_NEST_SEARCH);
printf(IDS_SLIZ_LDESC);

//snail
printf(IDS_SNAIL_LDESC);
printf(IDS_SNAIL_TALKDESC);
printf(IDS_SNAIL_MOVE);
printf(IDS_SNAIL_TAKE);
printf(IDS_SNAIL_DROP);
printf(IDS_SNAIL_WEAR);
printf(IDS_SNAIL_READ);
printf(IDS_SNAIL_TURNONOFF);
printf(IDS_SNAIL_SCREW);
printf(IDS_SNAIL_EAT);
printf(IDS_SNAIL_CLEAN);
printf(IDS_SNAIL_BREAK);
printf(IDS_SNAIL_LISTENTO);
printf(IDS_SNAIL_SMELL);
printf(IDS_SNAIL_TOUCH);
    
//emitter
printf(IDS_EMITTER_LDESC);
printf(IDS_EMITTER_WAIT);
printf(IDS_EMITTER_NOEXIT);
printf(IDS_EMITTER_JUMP);
printf(IDS_EMITTER_DIG);
printf(IDS_EMITTER_HIT);
printf(IDS_EMITTER_TALKDESC);
printf(IDS_EMITTER_CLEAN);
printf(IDS_EMITTER_SEARCH);
      
//tele
printf(IDS_TELE_LDESC);
printf(IDS_TELE_MOVE);
printf(IDS_TELE_TAKE);
printf(IDS_TELE_WEAR);
printf(IDS_TELE_READ);
printf(IDS_TELE_TURN);
printf(IDS_TELE_TURNONOFF);
printf(IDS_TELE_SCREW);
printf(IDS_TELE_EAT);
printf(IDS_TELE_LISTENTO);
printf(IDS_TELE_SMELL);
printf(IDS_TELE_TOUCH);

  
//cargo
printf(IDS_CARGO_LDESC);
printf(IDS_CARGO_WAIT);
printf(IDS_CARGO_NOEXIT);
printf(IDS_CARGO_JUMP);
printf(IDS_CARGO_DIG);
printf(IDS_CARGO_TALKDESC);
printf(IDS_CARGO_CLEAN);
printf(IDS_CARGO_SEARCH);
      
//eczo
printf(IDS_ECZO_LDESC);
printf(IDS_ECZO_MOVE);
printf(IDS_ECZO_TAKE);
printf(IDS_ECZO_WEAR);
printf(IDS_ECZO_READ);
printf(IDS_ECZO_TURN);
printf(IDS_ECZO_TURNONOFF);
printf(IDS_ECZO_SCREW);
printf(IDS_ECZO_EAT);
printf(IDS_ECZO_LISTENTO);
printf(IDS_ECZO_SMELL);
printf(IDS_ECZO_TOUCH);
      
//state move
printf(AUTO_MOVE_STARTROOM);
printf(AUTO_MOVE_CORIDOR);
printf(AUTO_MOVE_RUN);
printf(AUTO_MOVE_MED);
printf(AUTO_MOVE_CROOM);
printf(AUTO_MOVE_ANABIA);
printf(AUTO_MOVE_NEST);
printf(AUTO_MOVE_TELE);
printf(AUTO_MOVE_CARGO);
}

test_lang2 : function
{
//endings
printf(IDS_DIE_BED);
printf(IDS_DIE_MED);
printf(IDS_DIE_RUN);
printf(IDS_HERO_END);
printf(IDS_DEEP_END);
printf(IDS_BUNT_END);
printf(IDS_STAR_END);
printf(IDS_DIE_WALK);
printf(IDS_DIE_YELL);
printf(IDS_DIE_SLEEP);
printf(IDS_DIE_EAT);
printf(IDS_DIE_TELE);
printf(IDS_DIE_ECZO);
    
printf(IDS_DIE_BED_HINT);
printf(IDS_DIE_MED_HINT);
printf(IDS_DIE_RUN_HINT);
printf(IDS_HERO_END_HINT);
printf(IDS_DEEP_END_HINT);
printf(IDS_BUNT_END_HINT);
printf(IDS_STAR_END_HINT);
printf(IDS_DIE_WALK_HINT);
printf(IDS_DIE_YELL_HINT);
printf(IDS_DIE_SLEEP_HINT);
printf(IDS_DIE_EAT_HINT);
printf(IDS_DIE_TELE_HINT);
printf(IDS_DIE_ECZO_HINT);
    
printf(IDS_FMT_NEW_ENDING);
printf(IDS_FMT_OLD_ENDING);
printf(IDS_START_NEW_GAME);
  
//sea battle
printf(IDS_SPACE_INTRO);
printf(IDS_SPACE_LDESC);
printf(IDS_SPACE_CANMOVE);
printf(IDS_SPACE_START_WARNING);
printf(IDS_SPACE_MY_FLEET);
printf(IDS_SPACE_EN_FLEET);
printf(IDS_SPACE_FL_LDESC);
printf(IDS_SPACE_FI_LDESC);
printf(IDS_SPACE_BO_LDESC);
printf(IDS_SPACE_INV_NUM);
    
printf(IDS_SPACE_MAP_MOVE_OK);
printf(IDS_SPACE_MAP_MOVE_LOW_EDGE);
printf(IDS_SPACE_MAP_MOVE_HIGH_EDG);
printf(IDS_SPACE_MAP_MOVE_NOT_FREE);
printf(IDS_SPACE_MAP_MOVE_TOO_CLOS);
printf(IDS_SPACE_MAP_MOVE_DISALLOW);
printf(IDS_SPACE_MAP_ERR_MOVE);
  
printf(IDS_SPACE_HIT_RES_LOW_EDGE);
printf(IDS_SPACE_HIT_RES_HIGH_EDGE);
printf(IDS_SPACE_HIT_RES_ALREADY);
printf(IDS_SPACE_HIT_RES_MISS);
printf(IDS_SPACE_HIT_RES_GOT);
printf(IDS_SPACE_HIT_RES_KILL);
printf(IDS_SPACE_EN_HIT_RES_MISS);
printf(IDS_SPACE_EN_HIT_RES_GOT);
printf(IDS_SPACE_EN_HIT_RES_KILL);
    
printf(IDS_SPACE_VICTORY);
printf(IDS_SPACE_DEFEAT);
printf(IDS_SPACE_FMT_UNKNOWN_STATE); 
}

*/