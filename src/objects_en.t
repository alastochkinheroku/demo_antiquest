//////////////////////////////////////////////
////////////Объекты игры
//Общие

#pragma C++

theHalat : decoration
  sdesc = "bathrobe"
  noun = 'bathrobe' 'gown' 'robe'
;

theRoom: fixeditem, floatingItem
   sdesc="room"
   noun = 'room' 'cabin' 'hall' 'platform' 'section'
   
;

theWall: fixeditem, floatingItem
   sdesc="wall"	 
   noun = 'wall'
   
;

theCeiling: fixeditem, floatingItem
   sdesc="ceiling"	 
   noun = 'ceiling'
;

replace theFloor: beditem, floatingItem
	noun = 'floor' 'ground'
    sdesc = "ground"
    ldesc = "It lies beneath %youm%. "
    adesc = "the ground"
    statusPrep = "on"
    outOfPrep = "off of"
	ioThrowAt(actor, dobj) =
	{
		"Thrown. ";
		dobj.moveInto(actor.location);
	}
;

//Комнаты+ их Объекты 
class anyroom : room
;

class anyfixed : fixeditem
;

//

startroom: anyroom
 sdesc="In my cabin"
;

startbed : anyfixed, beditem
  sdesc = "bed"
  noun = 'bed' 'bunk'
  adjective = 'long'
  
;

//
coridorroom: anyroom
  sdesc="Corridor"
;

///////////////////////////////////////////////////////////////
//SPACE
class SpaceShip : fixeditem, Unit
;

plMain: SpaceShip
 sdesc = "flagship"
 noun ='flagship' 'fl'
 
 mapId = 'M'
;

plFighter: SpaceShip
 sdesc="fighter"
 noun = 'fighter' 'fi'
 
 mapId = 'F'
;

plBomber: SpaceShip
 sdesc = "bomber"
 noun = 'bomber' 'bo'
 
 mapId = 'B'
;

EnemyMain: SpaceShip
 sdesc="enemy flagship"
 
 mapId = 'M'
;

EnemyFighter: SpaceShip
 sdesc="enemy fighter"
 
 mapId = 'F'
;

EnemyBomber: SpaceShip
 sdesc="enemy bomber"
 
 mapId = 'B'
;

spaceroom: room
  sdesc="In orbit"
;

map : fixeditem
  sdesc = "map"
;
  
#pragma C-