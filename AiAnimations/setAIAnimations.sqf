
/*	AVAILABLE ANIMATIONS
----------------------------------------------------------
	> "STAND"		- standing still, slightly turning to the sides, with rifle weapon
	> "STAND_IA"		- standing still, slightly turning to the sides, with rifle weapon
	> "STAND_U1-3"	- standing still, slightly turning to the sides, no weapon
	> "WATCH1-2"		- standing and turning around, with rifle weapon
	> "GUARD"		- standing still, like on guard with hands behing the body
	> "LISTEN_BRIEFING"  - standing still, hands behind back, recieving briefing / commands, no rifle.
	> "LEAN_ON_TABLE"	- standing while leaning on the table
	> "LEAN"		- standing while leaning (on wall)
	> "BRIEFING"		- standing, playing ambient briefing loop with occasional random moves
	> "BRIEFING_POINT_LEFT"	- contains 1 extra pointing animation, pointing left & high
	> "BRIEFING_POINT_RIGHT"	- contains 1 extra pointing animation, pointing right & high
	> "BRIEFING_POINT_TABLE"	- contains 1 extra pointing animation, pointing front & low, like at table
	> "SIT1-3"		- sitting on chair or bench, with rifle weapon
	> "SIT_U1-3"		- sitting on chair or bench, without weapon
	> "SIT_AT_TABLE"	- sitting @ table, hands on table
	> "SIT_HIGH1-2" 	- sitting on taller objects like a table or wall, legs not touching the ground. Needs a rifle!
	> "SIT_LOW"		- sitting on the ground, with weapon.
	> "SIT_LOW_U"	- sitting on the ground, without weapon.
	> "SIT_SAD1-2"	- sitting on a chair, looking very sad.
	> "KNEEL"		- kneeling, with weapon.
	> "PRONE_INJURED_U1-2" - laying wounded, back on the ground, wothout weapon
	> "PRONE_INJURED"	- laying wounded & still, back on the ground, with or without weapon
	> "KNEEL_TREAT"	- kneeling while treating the wounded
	> "REPAIR_VEH_PRONE"	- repairing vehicle while laying on the ground (under the vehicle)
	> "REPAIR_VEH_KNEEL"	- repairing vehicle while kneeling (like changing a wheel)
	> "REPAIR_VEH_STAND"	- repairing/cleaning a vehicle while standing
----------------------------------------------------------
*/
// MAIN BASE
	// Briefing room
	[man_briefer_1, "BRIEFING"] call BIS_fnc_ambientAnim;
	[man_listener_1, "SIT_U2"] call BIS_fnc_ambientAnim;

	// At gates
	[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
	[man_at_gate_2, "STAND"] call BIS_fnc_ambientAnim;

	// Guards 
	[man_at_helicopters_1, "STAND_U2"] call BIS_fnc_ambientAnim;

	// Engineers
	[engineer_repair_heli_1, "REPAIR_VEH_STAND"] call BIS_fnc_ambientAnim;

	// Ambient guys
	[man_ambient_1, "STAND"] call BIS_fnc_ambientAnim;
	[man_ambient_2, "LEAN"] call BIS_fnc_ambientAnim;

	// Entrance to Airfield SOUTH
	[man_watch_1, "WATCH2"] call BIS_fnc_ambientAnim;
	[man_watch_2, "WATCH1"] call BIS_fnc_ambientAnim;
	[man_watch_3, "WATCH2"] call BIS_fnc_ambientAnim;

	// Entrance to Airfield NORTH
	[man_north_gate_1, "WATCH2"] call BIS_fnc_ambientAnim;
	[man_north_gate_2, "WATCH1"] call BIS_fnc_ambientAnim;
	[man_north_gate_3, "WATCH2"] call BIS_fnc_ambientAnim;
	
	// Guys at the gym
	[gym_guy_1, "STAND_U3"] call BIS_fnc_ambientAnim;
	[gym_guy_2, "SIT_U1"] call BIS_fnc_ambientAnim;

	// At the shoothouse
	[shoot_house_guy_1,"STAND_U2"] call BIS_fnc_ambientAnim;
	
	
// OP SPRINGFIELD


// OP EAGLE


// FB LYNX

// ANP CHECKPOINT NORTH

// ANP CHECKPOINT SOUTH-EAST
	
	
/* FOR COPY-PASTING
[man_watch_1, "WATCH2"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
[man_at_gate_1, "WATCH1"] call BIS_fnc_ambientAnim;
*/


/* OLD CODE! Just for reference for later on

// [mand_2,"BRIEFING", BIS_fnc_ambientAnim, true, true] call BIS_fnc_MP; // Old call
// [this,"SIT_U2", BIS_fnc_ambientAnim, true, true] call BIS_fnc_MP;
// [mand_1,"WATCH1", BIS_fnc_ambientAnim, true, true] call BIS_fnc_MP;




onPlayerConnected "[man_briefer_1, ""BRIEFING""] call BIS_fnc_ambientAnim"; // Briefter next to stratMap
onPlayerConnected "[man_listener_1, ""SIT_U2""] call BIS_fnc_ambientAnim"; // Briefter next to stratMap
onPlayerConnected "[man_at_gate_1, ""WATCH1""] call BIS_fnc_ambientAnim"; // Briefter next to stratMap

*/