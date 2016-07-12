



nrOfEnemySquadsForTransport		= paramsArray select 0;
nrOfEnemySquadsForAssist	 	= paramsArray select 1;
nrOfEnemySquadsForTowing 		= paramsArray select 2;
nrOfEnemySquadsAtAO				= paramsArray select 3;
nrOfEnemySquadsAtIED			= paramsArray select 4;


// Variable for keeping track of completed tasks
tasksDone						= 0;
currentAssignedTask 			= 0;

// Variable to keep track of action ID for strategic map
actionID	= 0;

// [] spawn {call compile preprocessFileLineNumbers "EPD\Ied_Init.sqf";};



execVM "R3F_LOG\init.sqf";
// onPlayerConnected {call  "AiAnimations\setAIAnimations.sqf"};
playAnimationsScript = compileFinal "AiAnimations\setAIAnimations.sqf";
onPlayerConnected {[playAnimationsScript, BIS_fnc_call , true, true] call BIS_fnc_MP;};
