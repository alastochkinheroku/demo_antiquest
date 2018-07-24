/* Copyright (c) 1993 Michael J. Roberts */
/*Modifyed 2017 Lastochkin
    Instruct.t  - general instructions verb implementation.

    Permission is granted to any registered user of TADS to
    use the information in this file, or any part of it, or any
    modified version of it, in any game written with TADS.

    This file provides an implementation for an INSTRUCTIONS
    command, which displays a full set of instructions for using
    a generic TADS game.  The information displayed by the
    INSTRUCTIONS command is essentially the same as in the
    DITCH.DOC or DEEP.DOC on-line documentation files, except
    that this version has been cleaned up to remove any references
    to specific games.

    You should go through the instructions and make any adjustments
    and additions appropriate to your game.  The information is
    very generic, and your game may have specific features and
    commands that should be mentioned.

    Note that the "Special commands" section lists a couple of
    commands that aren't in the standard ADV.T set, but could
    easily be provided by any game (such as CREDITS and NOTIFY --
    for this latter one, see SCORE.T, which shows my implementation
    of this feature).  When customizing this file, pay special
    attention to the "special commands" section to make sure you've
    adjusted the descriptions here and added any of your own.

    Another important thing you should do is look at the list of
    sample sentences, and make sure that any unusual commands
    (especially unusual ways of phrasing sentences) are included
    in the list.  If you resist listing a command there because
    you're afraid of giving away a puzzle, I claim that you don't
    have a very good puzzle, because "guess the verb" isn't a
    very fun game.  The parser should *never* be an obstacle; one
    very good way to ensure it isn't is to list a sample of every
    type of phrase the player will ever need to type.
*/

helpVerb: deepverb
    verb = 'help' 'hint'
    action(actor) =
    {
	"Sorry, but no hints are available.  If you'd like basic
	instructions for playing this game, type INSTRUCTIONS.";
    }
;

instructionsVerb: deepverb
    verb = 'instructions'
    action(actor) =
    {
"\bHOW TO PLAY
\b\b
In an adventure game, you play by typing commands that describe what you want
to do.  Unfortunately, the game isn't as smart as you are, so it can't
understand nearly as many sentences as a person could.  In this section,
we'll describe most of the types of commands that you will need to use while
playing the game.
\b
Note that we've tried to design this game so that you won't need to
think of any unusual words or phrases that aren't directly mentioned by the
game.  We've especially tried to avoid making you guess a strange verb
or an unusal way of phrasing a commands.
\b
Each time you see the prompt, >, you type a command.  Your command should
be a simple imperative sentence, or a series of imperatives separated by
periods.  Press the RETURN (or ENTER) key when you are done typing your
command; the game doesn't start interpreting the command until you press
RETURN.
\b
You can use capital or small letters in any mixture.  You can use words such
as THE and AN when they're appropriate, but you can omit them if you prefer.
You can abbreviate any word to six or more letters, but the game will pay
attention to all of the letters you type.  For example, you could refer to
a FLASHLIGHT with the words FLASHL, FLASHLIG, and so forth, but not with
FLASHSDF.
\b";

"\b\b
TRAVEL
\b
At any time during the game, you are in a location.  The game desribes your
location when you first enter, and again any time you type LOOK.  In a given
location, you can reach anything described, so you don't need to type commands
to move about within a location.
\b
You move from place to place in the game by typing the direction you want to
go.  The game will always tell you the directions that you can go from a
location,
although it usually doesn't tell you what you will find when you go there.  You
will probably find it helpful to make a map as you explore the game.  The
directions the game recognizes are NORTH, SOUTH, EAST, WEST, NORTHEAST,
SOUTHEAST, UP, and DOWN.  You can abbreviate these to N, S, E, W, NE, SE, NW,
SW, U, and D.  In some locations you can also use IN and OUT.
\b
Generally, backtracking will take you back to where you started.  For example,
if you start off in the kitchen, go north into the living room, then go south,
you will be back in the kitchen.
\b
Most of the time, when the game describes a door or doorway, you don't need to
open the door to go through the passage; the game will do this for you.  Only
when the game explicitly describes a closed door (or other impediment to
travel) will you need to type a command to open the door.
";

"\b\b
OBJECTS
\b
In the game, you will find many objects that you can carry or otherwise
manipulate.  When you want to do something with an object, type a simple
command that tells the game what you want to do; be explicit.  For example,
you could type READ THE BOOK or OPEN THE DRAWER.  Most of the objects in the
game have fairly obvious uses; you shouldn't have to think of any obscure or
unrelated words to manipulate the objects.
\b
You generally don't have to specify exactly where you want to put an object
that you wish to carry; you can just type TAKE (followed by the object's
name) to carry an object.  We didn't think it was particularly interesting
to force you to specify which object you wish to put in your left pocket,
which you wish to carry in your right hand, and so forth.  However, there
is a limit to how many objects you can carry at once, and to how much weight
you can handle.  You can carry more objects (but not more weight, of course)
by putting some items inside containers (for example, you may be able to put
several objects into a box, and carry the box), since this reduces the number
of objects you actually have to juggle at once.
\b
Some basic verbs that you will use frequently are TAKE (to pick up an object),
DROP (to drop an object), OPEN and CLOSE, and EXAMINE (which you can abbreviate
to X).  You can PUT an object IN or ON another object when appropriate.  The
game recognizes many other verbs as well.  We tried to make all of the verbs
obvious; if you find a knob, you will be able to TURN it, and if you find a
button, you will be able to PUSH it.  By the same token, you probably won't
need to turn the button or push the knob.
\b
Some examples of commands that the game recognizes are shown below.  These
aren't necessarily commands that you'll ever type while playing, but
they illustrate some of the verbs and sentence formats that you may use.
\b
\n\t    GO NORTH
\n\t    NORTH
\n\t    N
\n\t    UP
\n\t    TAKE THE BOX
\n\t    PUT THE FLOPPY DISK INTO THE BOX
\n\t    CLOSE BOX
\n\t    LOOK AT DISK
\n\t    TAKE DISK OUT OF BOX
\n\t    LOOK IN BOX
\n\t    WEAR THE CONICAL HAT
\n\t    TAKE OFF HAT
\n\t    CLOSE BOX
\n\t    TURN ON THE LANTERN
\n\t    LIGHT MATCH
\n\t    LIGHT CANDLE WITH MATCH
\n\t    RING BELL
\n\t    POUR WATER INTO BUCKET
\n\t    PUSH BUTTON
\n\t    TURN KNOB
\n\t    EAT COOKIE
\n\t    DRINK MILK
\n\t    THROW KNIFE AT THIEF
\n\t    KILL TROLL WITH SWORD
\n\t    READ NEWSPAPER
\n\t    LOOK THROUGH WINDOW
\n\t    UNLOCK DOOR WITH KEY
\n\t    TIE THE ROPE TO THE HOOK
\n\t    CLIMB UP THE LADDER
\n\t    TURN THE KNOB
\n\t    JUMP
\n\t    TYPE \"HELLO\" ON THE KEYBOARD
\n\t    TYPE 1234 ON THE KEYPAD
\n\t    GET IN THE CAR
\n\t    GET OUT OF THE CAR
\n\t    GET ON THE HORSE
\n\t    GIVE WAND TO WIZARD
\n\t    ASK WIZARD ABOUT WAND
";

"\b\b
OTHER CHARACTERS
\b
You may encounter other characters in the game.  You can interact in certain
ways with these characters.  For example, you can GIVE things to them, and you
could try to attack them (although this is a non-violent game, so you
shouldn't expect to solve any of your problems this way).  In addition, you
can ask characters about things:
\b
\t    ASK WIZARD ABOUT WAND
\b
You can also tell characters to do something.  To do this, type the character's
name, then a comma, then a command that you want the character to perform.  You
can type several commands for the character all on the same line by separating
the commands with periods.  For example:
\b
\t    ROBOT, GO NORTH. PUSH BUTTON. GO SOUTH.
\b
Of course, you shouldn't expect that characters will always follow your
instructions; most characters have minds of their own, and won't automatically
do what you ask.
";

"\b\b
TIME
\b
Time passes only in response to commands you type.  Nothing happens
while the game is waiting for you to type something.  Each turn takes about
the same amount of time.  If you want to let some game time pass, because
you think something is about to happen, you can type WAIT (or just Z).
\b\b
SCORE
\b
The game assigns you a score while you play, indicating how close you are to
finishing the game.  At certain points in the game, you will be awarded points
when you solve some puzzle or obtain some item.  The score is intended to
provide you with a measure of your progress in the game, and increases as
you get further in the game; you never lose points once they are earned.
";

"\b\b
REFERRING TO MULTIPLE OBJECTS
\b
You can usually use multiple objects in your sentences.  You separate the
objects by the word AND or a comma.  For example:
\b
\n\t    TAKE THE BOX, THE FLOPPY DISK, AND THE ROPE
\n\t    PUT DISK AND ROPE IN BOX
\n\t    DROP BOX AND BALL
\b
You can use the word ALL to refer to everything that is applicable to your
command, and you can use EXCEPT (right after the word ALL) to exclude certain
objects.
\b
\n\t    TAKE ALL
\n\t    PUT ALL EXCEPT DISK AND ROPE INTO BOX
\n\t    TAKE EVERYTHING OUT OF THE BOX
\n\t    TAKE ALL OFF SHELF
\b
The word ALL refers to everything that makes sense for your command, excluding
things inside containers that are used in the command.  For example, if you
are carrying a box and a rope, and the box contains a floppy disk, typing
DROP ALL will drop only the box and the rope; the floppy disk will remain in
the box.
\b\b
\"IT\" AND \"THEM\"
\b
You an use IT and THEM to refer to the last object or objects that you used
in a command.  Some examples:
\b
\n\t    TAKE THE BOX
\n\t    OPEN IT
\n\t    TAKE THE DISK AND THE ROPE
\n\t    PUT THEM IN THE BOX
\b\b
MULTIPLE COMMANDS ON A LINE
\b
You can put multiple commands on a single input line by separating the
commands with periods or the word THEN, or with a comma or the word AND.
Each command still counts as a separate turn.  For example:
\b
\n\t    TAKE THE DISK AND PUT IT IN THE BOX
\n\t    TAKE BOX. OPEN IT.
\n\t    UNLOCK THE DOOR WITH THE KEY. OPEN IT, AND THEN GO NORTH
\b
If the game doesn't understand one of the commands on the input line, it will
tell you what it couldn't understand, and it will ignore the rest of the
commands on the line.
";

"\b\b
AMBIGUOUS COMMANDS
\b
If you type a command that leaves out some important information, the game will
try to figure out what you mean anyway.  When the game can be reasonably sure
about what you mean, because only one object would make sense with the command,
the game will make an assumption about the missing information and act as
though you had supplied it.  For example,
\b
\n\t    >TIE THE ROPE
\n\t    (to the hook)
\n\t    The rope is now tied to the hook.  The end of the
\n\t    rope nearly reaches the floor of the pit below.
\b
If your command is ambiguous enough that the game doesn't feel safe making
assumptions about what you meant, the game will ask you for more information.
You can answer these questions by typing the missing information.  If you
decide you didn't want to bother with the command after all, you can just type
a new command; the game will ignore the question it asked.  For example:
\b
\n\t    >UNLOCK THE DOOR
\n\t    What do you want to unlock the door with?
\b    
\n\t    >THE KEY
\n\t    Which key do you mean, the gold key, or the silver key?
\b    
\n\t    >GOLD
\n\t    The door is now unlocked.
\b\b
UNKNOWN WORDS
\b
The game will sometimes use words in its descriptions that it doesn't
understand
in your commands.  For example, you may see a description such as, \"The
planet's rings are visible as a thin arc high overhead, glimmering in the
sunlight.\"  If the game doesn't know words such as \"rings,\" you can assume
that they're not needed to play the game; they're in the descriptions simply
to make the story more interesting.  For those objects that are important,
the game recognizes many synonyms; if the game doesn't understand a word you
use, or any of its common synonyms, you are probably trying something that is
not necessary to continue the game.
";

"\b\b
SAVING AND RESTORING
\b
You can store a snapshot of the game's state in a disk file at any time.
Later, if you want to go back to a point you were at earlier in the game,
you can simply restore the position from the snapshot in the disk file.
You can save your position as many times as you like, using
different disk files for each position.  Saving the game also allows you to
play the game over the course of many days, without having to start over from
scratch each time you come back to the game.
\b
To save the game, type SAVE at any prompt.  The game will ask you for the
name of a disk file to use to store the game state.  (You will have to
specify a filename suitable for your computer system, and the disk must have
enough space to store the game state.  The game will tell you if the game
was not saved properly for some reason.)  You should give the file a name that
does not exist on your disk.  If you save the game into a file that already
exists, the data previously in that file will be destroyed.
\b
When you wish to restore a game, type RESTORE at the command prompt.  The
game will ask you for the name of a disk file that you specified with a
previous SAVE command.  After reading the disk file, the game state will
be restored to exactly the position when you saved it.
";

"\b\b
SPECIAL COMMANDS
\b
The game understands several special commands that you can use to control
the game.  You can use these commands at any prompt.
\b
AGAIN or G:  Repeats your last command.  If your last input line was composed
of several commands, only the last command on the line is repeated.
\b
CREDITS:  Show a list of the people that developed this game.
\b
INVENTORY or I:  Shows the list of items you are carrying.
\b
LOOK or L:  Shows the full description of your location.
\b
NOTIFY:  Tells the game whether you want to be notified of score
changes when they happen.  When the game starts, NOTIFY is turned on,
so you will see a message whenever you do something that changes
your score.  If you'd prefer not to see these messages, type NOTIFY.
(If you later change your mind, typing NOTIFY again will turn notification
back on.)
\b
OOPS:  Allows you to correct the spelling of a word in the last command.
You can use OOPS when the game displays this complaint:  \"I don't know the
word <word>.\"  Immediately after this message, you can type OOPS followed by
the corrected spelling of the misspelled word.  You can only type one word
after OOPS, so this command doesn't allow you to correct certain types of
errors, such as when you run two words together without a spce.
\b
QUIT:  Stops the game, and returns you to your operating system.
\b
RESTART:  Starts the game over from the beginning.
\b
RESTORE:  Restores a position previously saved with the SAVE command.
\b
SAVE:  Stores the current state of the game in a disk file, so that you can
come back to the same place later (with the RESTORE command).
\b
SCORE:  Shows you your current score, the maximum possible score, and the
number of turns you have taken so far.
\b
SCRIPT:  Starts writing everything you see on the screen (your commands and
the game's responses) to a disk file.  The game will ask you for a filename
to be used for the transcript; you should select a filename that does not yet
exist on your disk, because if you use an existing filename, data in the file
will be destroyed.  Use the UNSCRIPT command to stop making the transcript.
\b
TERSE:  Tells the game that you wish to see only short descriptions of
locations you have already seen when you enter them.  This is the default
mode.  See also the VERBOSE command.
\b
UNDO:  Take back the last command.  This can be used multiple times to
take back a series of commands in sequence.  The number of commands
that you can undo at any given time varies, but you can generally
undo over a hundred commands.
\b
UNSCRIPT:  Turns off the transcript being made with the SCRIPT command.
\b
VERBOSE:  Tells the game to show you the full description of every location
you enter, whether or not you have seen the description before.  By default,
the game will show you the full description of a location only when you first
enter it, and will show you the short description each time you enter the
location thereafter.  Of course, you can get a full description at any time
by typing LOOK.  See also the TERSE command.
\b
VERSION:  Shows you the current version of the game.
\b
WAIT or Z:  Causes game time to pass.  When the game is waiting for you to
type command, no game time passes; you can use this command to wait for
something to happen.
";

"\b\b
COMMAND EDITING AND RECALL
\b
On most computer systems, the game has a special feature that allows you to
use your keyboard's editing keys to modify an input line as you are typing
it, and to recall commands that you have previously typed for editing and
re-entry.  The specific keys you use vary depending on your system, and some
systems don't support this feature at all; see the system-specific
documentation for more information.
\b
While you are typing a command, the game allows you to go back and change
part of the line without backspacing over the rest of the line to get there.
Simply use your left and right cursor-arrow keys to move the cursor to any
point in the command line.  The BACKSPACE key deletes a character to the left
of the cursor, and the DELETE key deletes the character at which the cursor
is located.
\b
You can insert new text at the cursor simply by typing the text.  You can
press the RETURN (or ENTER) key with the cursor at any point in the line (the
cursor need not be at the end of the command line).
\b
You can recall the previous command that you  entered by pressing the up
cursor-arrow key; pressing the up-arrow key again recalls the command before
that, and so forth.  Using the down cursor-arrow key reverses this process,
until you get back to the original command that you were typing before you
started pressing the up-arrow key.
\b
Once you have recalled a prior command, you can re-enter it by pressing the
RETURN key.  In addition, you can edit the command, as described above, before
entering the command.
\b
The exact number of commands the game retains depends on the lengths of the
commands, but more than a hundred of the most recent commands are generally
retained at any given time.
";

"\b\b
REVIEW MODE
\b
Another special feature that the game supports on many computer systems is
called \"review mode.\"  The game remembers text as it \"scrolls\" off the
screen;
by invoking recall mode, you can go back and look at text that is no longer
visible on the screen.  On most systems, review mode is activated by pressing
the function key F1.
\b
Once in review mode, the status line that is normally at the top of the
screen will be replaced by the review mode help line.  This line shows the
keystrokes you use to view previous screenfuls of text, and also shows you the
key that exits review mode and resumes normal game play (this is generally the
game key that you used to activate review mode).
\b
While in review mode, your screen becomes a window onto the text that the
game has stored away.  When you first activate review mode, you are looking
at the very bottom of this text, which is the screenful of text that was
just displayed.  Use the up and down cursor-arrow keys to move the window up
and down.  Pressing the up cursor-arrow key moves the window up one line,
showing you one line of text that has scrolled off the screen.  Most systems
also provide keys to move up and down by a full screenful (also called a
\"page.\")
\b
To resume game play, press the same key that you used to activate review
mode.
\b
The number of screenfuls of text that the game stores away for review depends
on how much text is actually on each screen, since the game has a limit on the
number of characters it can store, not on the number of lines.  Normally, more
than twenty of the most recent screens of text are saved and available for
review at any given time.
";

    }
;


