//Include
#include <a_samp>
#include <a_objects>
#include <core>
#include <float>
#include <Pawn.CMD>
#include <streamer>
#include <compat> 
#include <sscanf2>
#include <dini>

#pragma tabsize 0

//Server Define
#define SERVER_NAME "Deathmatch Test"
#define SERVER_URL "sa-mp.co.id"
#define SERVER_MODE "NCDM 0.0.4"


/*==============================================================================
         					     Colors
===============================================================================*/
#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_WHITEP 		0xFFE4C4FF
#define COLOR_ORANGE   		0xDB881AFF
#define COLOR_ORANGE2		0xFF5000FF
#define COLOR_IVORY 		0xFFFF82FF
#define COLOR_LIME 			0xD2D2ABFF
#define COLOR_BLUE			0x004BFFFF
#define COLOR_SBLUE			0x56A4E4FF
#define COLOR_LBLUE 		0x33CCFFFF
#define COLOR_RCONBLUE      0x0080FF99
#define COLOR_PURPLE2 		0x5A00FFFF
#define COLOR_PURPLE      	0xD0AEEBFF
#define COLOR_RED 			0xFF0000FF
#define COLOR_LRED 			0xE65555FF
#define COLOR_LIGHTGREEN 	0x00FF00FF
#define COLOR_YELLOW 		0xFFFF00FF
#define COLOR_YELLOW2 		0xF5DEB3FF
#define COLOR_LB 			0x15D4EDFF
#define COLOR_PINK			0xEE82EEFF
#define COLOR_PINK2		 	0xFF828200
#define COLOR_GOLD			0xFFD700FF
#define COLOR_FIREBRICK 	0xB22222FF
#define COLOR_GREEN 		0x3BBD44FF
#define COLOR_GREY			0xBABABAFF
#define COLOR_GREY2 		0x778899FF
#define COLOR_GREY3			0xC8C8C8FF
#define COLOR_DARK 			0x7A7A7AFF
#define COLOR_BROWN 		0x8B4513FF
#define COLOR_SYSTEM 		0xEFEFF7FF
#define COLOR_RADIO       	0x8D8DFFFF
#define COLOR_RIKO			0xADD8E6FF
#define COLOR_FAMILY		0x00F77AFF
#define DIKA				0xC6E2FFFF

#define FAMILY_E	"{F77AFF}"
#define PURPLE_E2	"{7348EB}"
#define RED_E 		"{FF0000}"
#define BLUE_E 		"{004BFF}"
#define SBLUE_E 	"{56A4E4}"
#define PINK_E 		"{FFB6C1}"
#define YELLOW_E 	"{FFFF00}"
#define LG_E 		"{00FF00}"
#define LB_E 		"{15D4ED}"
#define LB2_E 		"{87CEFA}"
#define GREY_E 		"{BABABA}"
#define GREY2_E 	"{778899}"
#define GREY3_E 	"{C8C8C8}"
#define DARK_E 		"{7A7A7A}"
#define WHITE_E 	"{FFFFFF}"
#define WHITEP_E 	"{FFE4C4}"
#define IVORY_E 	"{FFFF82}"
#define ORANGE_E 	"{DB881A}"
#define ORANGE_E2	"{FF5000}"
#define GREEN_E 	"{3BBD44}"
#define PURPLE_E 	"{5A00FF}"
#define LIME_E 		"{D2D2AB}"
#define LRED_E		"{E65555}"
#define DOOM_		"{F4A460}"
#define MATHS       "{3571FC}"
#define REACTIONS   "{FD4141}"

#define dot "{F2F853}> {F0F0F0}"
#define COLOR_RGB(%1,%2,%3,%4) (((((%1) & 0xff) << 24) | (((%2) & 0xff) << 16) | (((%3) & 0xff) << 8) | ((%4) & 0xff)))
#define StripAlpha(%0) ((%0) >>> 8)

//Mappings
new tmpobjid;

//Dini Files
#define UserFile "\\Users\\%s.ini"
new file[256];

//Dialog Enum
enum
{
	DIALOG_REGISTER, //Gw ndak iso buat register
	DIALOG_LOGIN, //Gw ndak iso buat login
	DIALOG_UNUSED,
	DIALOG_WEAPON,
    DIALOG_PISTOL,
    DIALOG_AR,
    DIALOG_HEAVY,
    DIALOG_ETC,
    DIALOG_SSPAWN,
	DIALOG_TEAM //Pake logika lu ndiri nap gw ndak iso mikir anj (klo gaperlu apus aja)
}

//Player Enum
enum E_PLAYERS
{
    pName,
    pPassword,
    pScore,
    pLogin,
    pAdmin
}

new pData[MAX_PLAYERS][E_PLAYERS];

main()
{
	print("\n----------------------------------");
	print("  Deathmatch Gamemode\n");
	print("----------------------------------\n");
}

//Stock
stock GetName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
    pData[playerid][pName] == GetName
	return name;
}

public OnPlayerConnect(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));

	new tstr[128];
	format(tstr, sizeof(tstr), "%s(%d) Has entered the server", name, playerid);
	SendClientMessageToAll(COLOR_GOLD, tstr);

    format(file, sizeof(file), "\\Users\\%s.ini", name);
    if(!dini_Exists(file))
    {
         ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Register", "Hey! Welcome new player, before playing you need to register. Please create your password below", "Register", "Batal");
    }
    else
    {
         ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "This account has registered, Please input your password", "Login", "Batal");
    }
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	new cmd[256];
	
	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd, "/help", true) == 0) {
		SendClientMessage(playerid, COLOR_GOLD, "CMD: /help /weapons");
    	return 1;
	}

	return 0;
}

public OnPlayerSpawn(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_SSPAWN, DIALOG_STYLE_LIST, "Select Spawn", "Spawn 1\nSpawn 2\nSpawn 3\nSpawn 4\nSpawn 5\nSpawn 6", "Spawn", "Close");
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    new string[144];
    new money = random(500);
    GivePlayerMoney(playerid, - money);

    format(string, sizeof(string), "You lost -$%i!", money);
    SendClientMessage(playerid, COLOR_RED, string);
    new strings[120];
    new duit = random(800);
    GivePlayerMoney(playerid, duit);

    format(strings, sizeof(strings), "You got $%i!", duit);
    SendClientMessage(killerid, COLOR_RED, strings);
	return 1;
}

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit()
{	
	//Lobby
    tmpobjid = CreateDynamicObject(19377, -5.923298, 2688.018310, -45.156970, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -0.760800, 2688.010009, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -0.762009, 2688.011230, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -4.618090, 2687.871582, -41.497100, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "beigehotel_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -0.432960, 2685.579589, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -5.610700, 2692.721679, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -5.652560, 2692.721435, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -8.920538, 2687.879882, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -8.921038, 2687.928222, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
    tmpobjid = CreateDynamicObject(19929, -2.636830, 2688.960693, -45.071689, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19929, -2.636300, 2687.479248, -45.073699, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19925, -2.635080, 2685.616699, -45.071441, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19925, -2.633150, 2690.825439, -45.071399, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19929, -0.769200, 2690.829101, -41.508430, 180.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19929, -0.773060, 2685.612792, -45.071701, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19929, -0.769218, 2690.829101, -45.071701, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19925, -2.633198, 2690.825439, -41.508399, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19929, -2.636800, 2688.960693, -41.508399, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19929, -0.773100, 2685.612792, -41.508399, 180.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19929, -2.636300, 2687.479248, -41.506401, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19387, -0.436428, 2679.995605, -43.327499, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -0.427020, 2673.579345, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -0.426679, 2686.416748, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19925, -2.635098, 2685.616699, -41.508399, 180.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13003, "ce_racestart", "sa_wood07_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -12.853710, 2683.130615, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -14.767358, 2678.352539, -45.156970, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -9.766168, 2684.741943, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19387, -9.760478, 2679.156494, -43.327499, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -13.690898, 2683.128173, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -9.754240, 2673.609619, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -9.761288, 2685.578369, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -9.760270, 2672.736328, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -25.349060, 2678.252441, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -25.349830, 2678.493408, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -14.634010, 2673.590576, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -11.592728, 2673.513427, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -22.480129, 2683.129150, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -23.322580, 2683.128173, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -24.264789, 2673.592041, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -24.241840, 2673.590576, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -25.268920, 2678.255615, -45.156970, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -9.762228, 2673.609619, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -9.760210, 2684.742675, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 6.176390, 2678.157714, -45.156970, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
    tmpobjid = CreateDynamicObject(19387, -0.426429, 2679.995605, -47.587490, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18234, "cuntwbtxcs_t", "offwhitebrix", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -0.430440, 2674.447509, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -0.437669, 2685.581787, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -0.438670, 2674.446533, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -0.437020, 2673.579345, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -0.436679, 2686.416748, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, 4.439080, 2676.322265, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, 4.419168, 2682.958740, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 4.464398, 2682.957763, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 4.457368, 2676.322509, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, 5.862180, 2679.655761, -46.216800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 5.864068, 2679.142333, -42.715301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(1502, -0.427760, 2679.245117, -45.083400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, 0.377400, 2673.507080, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19387, -5.171978, 2673.506591, -43.327499, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, 0.373479, 2673.503662, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -10.757280, 2673.501464, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -3.707520, 2668.661132, -45.157001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -14.610870, 2673.591308, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 1.249040, 2673.511474, -42.715301, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -6.717710, 2668.645507, -45.157001, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -2.902828, 2660.032226, -46.696899, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "beigehotel_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 1.020990, 2663.930175, -48.530101, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -11.447058, 2663.915039, -48.530101, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
    tmpobjid = CreateDynamicObject(1502, -5.961578, 2673.510498, -45.083400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2879, "cj_ds_door", "CJ_DS_DOOR_256_", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 0.671140, 2659.097167, -48.530101, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -7.966138, 2659.092041, -48.530101, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, -4.034948, 2656.309326, -48.530101, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, 0.653029, 2655.432373, -49.795749, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14794, "ab_vegasgymmain", "bbar_wall3", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, 1.515869, 2655.173583, -49.797698, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14794, "ab_vegasgymmain", "bbar_wall3", 0x00000000);
    tmpobjid = CreateDynamicObject(631, -8.388488, 2686.114257, -44.164600, 0.000000, 0.000000, 27.937099, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFCCFF33);
    tmpobjid = CreateDynamicObject(631, -8.399318, 2689.856933, -44.164600, 0.000000, 0.000000, 27.937099, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFCCFF00);
    tmpobjid = CreateDynamicObject(631, -1.196588, 2684.114990, -44.164600, 0.000000, 0.000000, 27.937099, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "foliage256", 0xFF99FF00);
    tmpobjid = CreateDynamicObject(631, -1.306910, 2691.934326, -44.164600, 0.000000, 0.000000, 27.937099, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "foliage256", 0xFF99FF00);
    tmpobjid = CreateDynamicObject(19452, -18.276109, 2678.294433, -45.152801, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_border1", 0x00000000);
    tmpobjid = CreateDynamicObject(19174, -19.924049, 2683.038085, -42.527858, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 7009, "vgndwntwn1", "newpolice_sa", 0x00000000);
    tmpobjid = CreateDynamicObject(19373, -5.537498, 2688.263427, -45.150501, 0.000000, 90.000000, 45.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "mp_gs_border1", 0x00000000);
    tmpobjid = CreateDynamicObject(19373, -5.030498, 2678.696533, -45.276496, 0.000000, 90.000000, 45.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "CJ_CUSHION2", 0x00000000);
    tmpobjid = CreateDynamicObject(631, -10.331100, 2682.531738, -44.169898, 0.000000, 0.000000, 53.734798, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFF99FF00);
    tmpobjid = CreateDynamicObject(631, -22.626739, 2674.029296, -44.163890, 0.000000, 0.000000, 53.734798, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFF99FF00);
    tmpobjid = CreateDynamicObject(631, -9.188988, 2682.572021, -44.169898, 0.000000, 0.000000, 53.734798, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFF99FF33);
    tmpobjid = CreateDynamicObject(631, -1.069069, 2682.482421, -44.169898, 0.000000, 0.000000, 53.734798, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "kbplanter_plants1", 0xFFCCFF00);
    tmpobjid = CreateDynamicObject(19377, -4.319230, 2678.391845, -45.156970, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -4.492740, 2678.240234, -41.497100, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "beigehotel_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 5.994790, 2678.556640, -41.497100, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "beigehotel_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -15.001150, 2678.503417, -41.497100, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "beigehotel_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -25.498710, 2678.508300, -41.497100, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "beigehotel_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -3.895498, 2668.795410, -44.016601, 34.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "beigehotel_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -3.753489, 2668.607910, -41.497100, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "beigehotel_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19387, -5.171850, 2673.512451, -43.327499, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, -10.756790, 2673.515380, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(19452, 0.371369, 2673.512939, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5142, "lashops1b_las2", "lasplaza3", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -4.056300, 2689.904052, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -7.427659, 2689.911132, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -7.460588, 2685.028564, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -4.017889, 2685.060546, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -5.508830, 2687.289794, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -7.725708, 2681.264648, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -7.678400, 2675.198242, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -2.066230, 2675.020996, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -4.708758, 2680.230712, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -4.711588, 2677.265136, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -1.970489, 2681.408447, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -13.870920, 2678.228515, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -17.553489, 2678.189208, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -21.513889, 2678.211914, -39.114601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.675209, 2673.223144, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -2.642030, 2683.042236, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -0.852738, 2691.099853, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, 4.718800, 2683.040283, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -2.443130, 2673.603759, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, 4.831630, 2673.604736, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -0.522248, 2675.698730, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -0.522759, 2668.355957, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -1.530830, 2683.219726, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, 5.792418, 2683.218750, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.674670, 2680.571044, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -8.820818, 2690.450927, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -1.473109, 2692.628417, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, 5.891338, 2692.631835, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -8.821848, 2683.101074, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -0.852568, 2683.185302, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -10.004320, 2683.040283, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -17.325769, 2683.038330, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -24.661100, 2683.035644, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.846798, 2673.673828, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -17.173070, 2673.671875, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -24.476879, 2673.672851, -41.598098, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -25.255880, 2675.666259, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -25.255189, 2668.314697, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.843910, 2675.654785, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.845660, 2668.340087, -41.598098, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.666098, 2673.602050, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -0.525430, 2673.610107, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -0.526619, 2683.036132, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.671528, 2683.032470, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -8.823808, 2683.218261, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -8.819250, 2692.623779, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -0.852518, 2692.620361, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -0.851750, 2683.226318, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -25.246440, 2683.033935, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.850118, 2673.680664, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -9.859550, 2683.039062, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, -25.253128, 2673.686523, -40.562908, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19387, -0.436428, 2679.995605, -43.327499, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "scratchedmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, -6.880249, 2692.602539, -42.198944, -0.400000, 0.000000, -89.900070, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, -6.066161, 2692.623046, -43.044654, -0.400000, 0.000000, -89.900070, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
    tmpobjid = CreateDynamicObject(19089, 1.376773, 2676.406738, -42.441024, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.504770, 2675.927246, -43.351074, 0.000000, 0.000000, -90.699996, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.504770, 2675.927246, -44.281051, 0.000000, 0.000000, -90.699996, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.504770, 2675.927246, -42.781044, 0.000000, 0.000000, -90.699996, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -43.811031, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -44.771018, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -44.141025, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -43.991035, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -43.671016, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -43.521026, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -43.201042, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -42.991054, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -44.461067, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    tmpobjid = CreateDynamicObject(1744, 1.602867, 2675.899658, -44.611053, 0.000000, 0.000000, -94.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4992, "airportdetail", "prolaps01", 0x00000000);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(19420, -5.175164, 2673.649658, -42.441097, 90.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19172, -0.518492, 2675.232910, -41.990680, 2.100049, 0.000000, -89.899986, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19172, -5.994885, 2656.389892, -47.617031, 0.599999, 0.000000, -179.900024, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1569, -8.829958, 2686.513183, -45.078201, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19377, 5.200338, 2687.784179, -45.156970, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19929, -2.636300, 2687.479248, -41.506401, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2172, -20.544910, 2682.588623, -45.074138, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2193, -24.768100, 2681.562988, -45.072879, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2198, -15.120280, 2674.170898, -45.073699, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2183, -22.639919, 2677.768798, -45.073299, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1502, -9.724788, 2678.403320, -45.083400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2193, -23.769540, 2674.142822, -45.072898, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2183, -16.891929, 2677.723632, -45.073299, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2172, -13.909488, 2682.545166, -45.074138, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2193, -10.326140, 2675.151611, -45.072898, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2198, -19.726919, 2674.209228, -45.073699, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1811, 2.755490, 2676.857177, -44.459300, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1811, 2.116014, 2679.887207, -44.459300, 0.000000, 0.000000, 100.675720, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1811, 3.558166, 2679.891357, -44.459300, 0.000000, 0.000000, 79.741439, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2180, 2.378679, 2678.395263, -45.070270, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1622, 5.655610, 2682.470458, -41.878791, 10.000000, -15.000000, 21.363250, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1566, -0.494818, 2674.449462, -43.738750, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19452, -10.757088, 2673.509521, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(14411, -5.173200, 2670.599609, -48.272300, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11729, -3.315608, 2663.590332, -50.280559, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11730, -0.596948, 2663.582031, -50.276950, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2197, 0.063380, 2662.913085, -50.275878, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2400, -7.792368, 2656.842041, -50.441139, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2400, -7.790890, 2660.572265, -52.185848, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11729, -2.635360, 2663.586181, -50.280559, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11729, -1.957640, 2663.585937, -50.280559, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11729, -1.278970, 2663.585693, -50.280559, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2399, -7.641590, 2658.820312, -49.158988, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2399, -7.692668, 2662.519775, -49.158988, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2390, -7.818418, 2658.199951, -49.114498, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2390, -7.637468, 2660.803466, -49.114498, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2819, -1.415840, 2662.279296, -50.277900, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2386, -7.584270, 2663.568359, -48.382789, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2384, -7.576539, 2663.023681, -48.378059, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2383, -7.611908, 2661.378906, -49.101200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2401, -7.555688, 2657.015625, -49.147098, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2391, -7.568998, 2663.197753, -49.216201, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2704, -7.342598, 2659.704833, -49.108699, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2374, -7.657440, 2661.971435, -49.124599, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2400, -7.792890, 2660.572265, -50.441139, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2400, -7.789140, 2656.840087, -52.185848, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.759990, 2656.650634, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.204020, 2656.627197, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.206210, 2656.425781, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.205248, 2656.486816, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.204010, 2656.566162, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.759140, 2656.706542, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.765250, 2656.492919, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.766088, 2656.437011, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.761929, 2656.608886, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18637, -6.762780, 2656.552978, -49.670700, 80.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19141, -7.665180, 2656.523437, -48.438201, -20.000000, 270.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19141, -7.654388, 2657.464355, -48.438201, -20.000000, 270.000000, 274.025787, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19141, -7.465778, 2657.189697, -48.438201, -20.000000, 270.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19141, -7.407790, 2656.611816, -48.438201, -20.000000, 270.000000, 286.252777, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19141, -7.477068, 2656.910156, -48.438201, -20.000000, 270.000000, 262.885864, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19141, -7.684430, 2657.143066, -48.438201, -20.000000, 270.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19141, -7.694478, 2656.822753, -48.438201, -20.000000, 270.000000, 278.532165, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2612, 0.511690, 2659.229003, -48.300739, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19099, -7.683488, 2657.737304, -48.415901, 0.000000, 270.000000, 270.723144, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19099, -7.718100, 2658.257324, -48.415901, 0.000000, 270.000000, 278.532196, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19099, -7.490880, 2658.003173, -48.415901, 0.000000, 270.000000, 264.765899, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19141, -7.437849, 2657.590576, -48.438201, -20.000000, 270.000000, 274.025787, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2386, -7.556200, 2659.633789, -48.382801, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19162, -7.502398, 2658.487548, -48.479801, 0.000000, 270.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19162, -7.677060, 2658.657958, -48.479801, 0.000000, 270.000000, 283.298004, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19142, -7.575798, 2656.806640, -49.973400, 0.000000, 270.000000, 277.809051, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19142, -7.609610, 2660.194091, -48.245899, 0.000000, 270.000000, 272.004394, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19142, -7.582950, 2658.343750, -49.973400, 0.000000, 270.000000, 277.809051, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19142, -7.607950, 2657.786865, -49.973400, 0.000000, 270.000000, 267.741363, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19142, -7.651948, 2657.287353, -49.973400, 0.000000, 270.000000, 273.643005, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19515, -7.653738, 2659.306152, -50.025199, 0.000000, 270.000000, 264.351867, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19515, -7.586238, 2659.804199, -50.025199, 0.000000, 270.000000, 267.965179, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19142, -7.570549, 2658.812011, -49.973400, 0.000000, 270.000000, 272.004425, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19142, -7.546860, 2660.692626, -48.245899, 0.000000, 270.000000, 272.004394, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19514, -7.555300, 2660.157714, -50.176898, -20.000000, 270.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19514, -7.734818, 2660.583984, -50.176898, -20.000000, 270.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19514, -7.416018, 2660.391601, -50.176898, -20.000000, 270.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19514, -7.716588, 2660.385009, -50.176898, -20.000000, 270.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2358, 0.301930, 2662.704833, -50.157600, 0.000000, 0.000000, 273.886932, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2358, 0.147450, 2660.517822, -50.157600, 0.000000, 0.000000, 309.553619, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2358, 0.292140, 2661.242187, -50.157600, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2358, 0.246950, 2662.347167, -49.920600, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2358, 0.297509, 2661.964111, -50.157600, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19832, -0.014848, 2663.136962, -50.277000, 0.000000, 0.000000, 6.283480, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19832, -0.113889, 2662.407470, -50.277000, 0.000000, 0.000000, 80.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19832, -0.074840, 2661.145996, -50.277000, 0.000000, 0.000000, 119.001029, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19832, 0.245330, 2659.991210, -50.277000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2359, -0.391420, 2661.793945, -50.076408, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1566, -5.934360, 2656.370605, -48.887020, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19377, -2.784898, 2660.699951, -50.364368, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2612, 1.751270, 2682.808105, -43.283081, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2164, 3.159368, 2682.822265, -45.071670, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2002, -1.031091, 2678.010498, -45.071899, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2002, -18.682979, 2682.456542, -45.074581, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2310, -5.243490, 2692.271484, -44.576400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2310, -5.902568, 2692.258300, -44.576400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2310, -6.566830, 2692.266845, -44.576400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2310, -7.219008, 2692.282470, -44.576400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2310, -7.881110, 2692.298583, -44.576400, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1569, -8.837030, 2689.513671, -45.078201, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1714, -1.355679, 2686.975830, -45.069198, 0.000000, 0.000000, 266.654937, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1714, -1.493749, 2689.273437, -45.069198, 0.000000, 0.000000, 270.541870, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2190, -2.858710, 2689.768798, -44.285198, 0.000000, 0.000000, 70.667503, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2190, -2.745500, 2686.974853, -44.272201, 0.000000, 0.000000, 70.667503, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2002, -11.601308, 2682.546386, -45.074581, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2612, -16.693540, 2682.933837, -43.036460, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2737, -25.192880, 2677.703857, -43.314498, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2737, -25.194440, 2679.599121, -43.314498, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2611, -21.290479, 2673.725585, -43.011100, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2616, -18.008659, 2673.759521, -43.256290, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2615, -15.125108, 2673.761718, -43.330600, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1715, -11.026040, 2674.947265, -45.072399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -14.659218, 2677.240722, -45.069141, 0.000000, 0.000000, 18.146400, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -16.231790, 2677.057373, -45.069141, 0.000000, 0.000000, 351.095336, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -21.991760, 2677.239501, -45.069141, 0.000000, 0.000000, 351.095336, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -24.144340, 2682.024169, -45.069141, 0.000000, 0.000000, 351.095336, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -13.357410, 2681.896972, -45.069141, 0.000000, 0.000000, 351.095336, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1714, -24.081470, 2675.193115, -45.069641, 0.000000, 0.000000, 347.161071, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1714, -20.441350, 2675.013671, -45.069641, 0.000000, 0.000000, 15.477628, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1715, -15.936860, 2674.975341, -45.072399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -16.323129, 2679.684082, -45.069099, 0.000000, 0.000000, 183.613296, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -14.542658, 2679.617431, -45.069099, 0.000000, 0.000000, 171.832992, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -22.100700, 2679.737304, -45.069099, 0.000000, 0.000000, 183.613296, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -20.273929, 2679.541503, -45.069099, 0.000000, 0.000000, 165.056060, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2356, -20.390880, 2677.211914, -45.069141, 0.000000, 0.000000, 2.610599, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2615, -22.414560, 2682.974853, -43.173770, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2161, -9.870220, 2676.927734, -45.071601, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2161, -15.293120, 2682.995117, -45.071601, 0.000000, 0.000000, 1.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2197, -24.205059, 2676.074218, -45.072601, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2197, -21.405178, 2682.197753, -45.072601, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2191, -13.170350, 2674.241943, -45.072498, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2059, -20.311199, 2678.038330, -44.246700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2059, -16.913330, 2678.875976, -44.246700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2855, -19.529430, 2678.084472, -44.266849, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2855, -17.017660, 2678.046630, -44.266849, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2190, -15.952798, 2678.135742, -44.318599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2190, -14.592700, 2678.148437, -44.318599, 0.000000, 0.000000, 350.131011, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2190, -21.900470, 2678.233398, -44.318599, 0.000000, 0.000000, 350.131011, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19807, -21.608549, 2677.831054, -44.218799, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19807, -15.687330, 2677.686523, -44.218799, 0.000000, 0.000000, 346.932678, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19807, -14.263730, 2677.875732, -44.218799, 0.000000, 0.000000, 346.932678, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19172, -12.375498, 2673.681884, -42.533298, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2276, -13.566618, 2682.495605, -42.961280, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2261, -12.426198, 2682.532226, -42.443408, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2190, -16.166290, 2678.631103, -44.318599, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2190, -20.062950, 2678.626220, -44.318599, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19807, -20.519500, 2678.990234, -44.218799, 0.000000, 0.000000, 191.233505, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2855, -20.887710, 2678.732666, -44.266849, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2164, -3.079849, 2692.572998, -45.070899, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2202, -17.642190, 2682.475585, -45.071590, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2222, -13.822999, 2677.927001, -44.181400, 0.000000, 0.000000, 8.532118, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2222, -22.808689, 2677.940185, -44.181400, 0.000000, 0.000000, 8.532118, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2311, -7.546810, 2674.901123, -45.071498, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1726, -9.120738, 2674.668945, -45.071300, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2282, -7.106709, 2674.085449, -43.330699, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2263, -8.113380, 2674.100585, -43.723999, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19172, -9.658293, 2675.643066, -42.926700, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2221, -7.692308, 2676.013183, -44.478500, 0.000000, 0.000000, 2.493240, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19567, -7.777288, 2675.240722, -44.567199, 0.000000, 0.000000, 261.572052, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -23.826900, 2675.890380, -41.188598, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -19.371500, 2679.821044, -41.188598, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -23.859899, 2680.031738, -41.188598, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -12.366470, 2679.618408, -41.388591, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -12.325778, 2675.870849, -41.188591, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -15.493100, 2675.554199, -41.188598, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -19.423999, 2675.589355, -41.188598, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -15.406800, 2679.654052, -41.188598, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, 1.987360, 2678.141601, -41.388599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, 1.920719, 2680.961914, -41.388599, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(16780, -4.804368, 2678.654785, -41.420101, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2051, -3.708899, 2656.440673, -48.841701, 0.000000, 4.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2050, -1.133610, 2656.479248, -48.066379, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2056, -1.310700, 2663.297119, -49.339611, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2386, -7.601190, 2662.501708, -48.382801, 0.000000, 0.000000, 272.323944, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19142, -7.642048, 2661.146972, -48.245899, 0.000000, 270.000000, 266.966857, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2671, -6.507800, 2659.243896, -50.275901, 0.000000, 0.000000, 100.675720, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2671, -1.282119, 2657.071044, -50.275901, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2845, -3.197560, 2656.045898, -49.709159, 0.000000, 0.000000, 56.409980, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19452, -10.756540, 2673.507568, -46.216800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3014, -7.704288, 2663.546875, -50.227298, 0.000000, 0.000000, 355.404724, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3014, -7.681190, 2662.899414, -50.227298, 0.000000, 0.000000, 1.990949, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, -7.717998, 2662.372558, -50.126670, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, -7.471980, 2662.419677, -50.126670, 0.000000, 0.000000, 349.528930, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -5.742259, 2659.893066, -46.488899, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, -1.762869, 2659.718750, -46.488899, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2161, -0.853600, 2688.352050, -45.087200, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2609, -0.790508, 2686.303955, -44.485599, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2609, -0.847590, 2690.112304, -44.485599, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19623, 2.951565, 2682.586914, -43.161041, 0.000000, 0.000000, -7.299999, -1, -1, -1, 300.00, 300.00); 

	SetGameModeText(""SERVER_MODE"");
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_WEAPON)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
                    ShowPlayerDialog(playerid, DIALOG_PISTOL, DIALOG_STYLE_LIST, "Buy Pistol", "Silenced Pistol "GREEN_E"$400\nColt45 "GREEN_E"$600\nDeagle "GREEN_E"$800", "Select", "Close");
				}
				case 1:
				{
                    ShowPlayerDialog(playerid, DIALOG_AR, DIALOG_STYLE_LIST, "Buy Assault Rifle", "AK-47 "GREEN_E"$1200\nM4 "GREEN_E"$2200", "Select", "Close");
				}
				case 2:
				{
                    ShowPlayerDialog(playerid, DIALOG_HEAVY, DIALOG_STYLE_LIST, "Buy Rifle and Heavy Weapon", "Shotgun "GREEN_E"$1600\nCombat Shotgun "GREEN_E"$2000\nSniper Rifle "GREEN_E"$3200\nRifle "GREEN_E"$3000\nRPG-7 "GREEN_E"$5000", "Select", "Close");
				}
				case 3:
				{
					GivePlayerWeapon(playerid, 25, 100);
					SendClientMessage(playerid, COLOR_GREEN, "You has gived a Shotgun");
				}
			}
		}
	}
    if(dialogid == DIALOG_PISTOL)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {   
                    SendClientMessage(playerid, COLOR_BLUE,"Succesfuly buy a Silenced Pistol with 80 ammo");
                    GivePlayerWeapon(playerid, 22, 80);
                    GivePlayerMoney(playerid, -400);
                }
                case 1:
                {   
                    SendClientMessage(playerid, COLOR_BLUE,"Succesfuly buy a Colt 45 with 120 ammo");
                    GivePlayerWeapon(playerid, 23, 120);
                    GivePlayerMoney(playerid, -600);
                }
                case 2:
                {   
                    SendClientMessage(playerid, COLOR_BLUE,"Succesfuly buy a Desert Eagle with 50 ammo");
                    GivePlayerWeapon(playerid, 24, 50);
                    GivePlayerMoney(playerid, -800);
                }
            }
        }
    }
    if(dialogid == DIALOG_AR)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {   
                    SendClientMessage(playerid, COLOR_BLUE,"Succesfuly buy a AK-47 with 220 ammo");
                    GivePlayerWeapon(playerid, 30, 220);
                    GivePlayerMoney(playerid, -1200);
                }
                case 1:
                {   
                    SendClientMessage(playerid, COLOR_BLUE,"Succesfuly buy a M-4 with 220 ammo");
                    GivePlayerWeapon(playerid, 31, 220);
                    GivePlayerMoney(playerid, -2200);
                }
            }
        }
    }
    if(dialogid == DIALOG_REGISTER)
     {
      if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registrasi", "Selamat datang player baru, silahkan buat password mu yaa", "Register", "Batal");
      if(!response) return Kick(playerid); //Jika player klik batal
      new name[MAX_PLAYER_NAME];
      new int[222], score[223];
      GetPlayerName(playerid, name, sizeof(name));
      format(file, sizeof(file), "\\Users\\%s.ini", name);
      format(int, sizeof(int), "%s", GetPlayerInterior(playerid));
      format(score, sizeof(score), "%s", GetPlayerScore(playerid));
      dini_Create(file);
      dini_Set(file, "Nama", name);
      dini_Set(file, "Password", inputtext);
      dini_Set(file, "Interior", "0");
      dini_Set(file, "Score", "0");
      dini_Set(file, "Admin", "0");
      ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Akun ini sudah terdaftar, silahkan masukkan password mu yaa", "Login", "Batal");
     }

     if(dialogid == DIALOG_LOGIN)
     {
      if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Akun ini sudah terdaftar, silahkan masukkan password mu yaa", "Login", "Batal");
      if(!response) return Kick(playerid);
      new name[MAX_PLAYER_NAME], password[256];
      GetPlayerName(playerid, name, sizeof(name));
      format(file, sizeof(file), "\\Users\\%s.ini", name);
      format(password, sizeof(password), "%s", dini_Get(file, "Password"));
      if(!strcmp(password, inputtext))
      {
       pData[playerid][pLogin] = 1;
       SendClientMessage(playerid, COLOR_RED, "SERVER: "WHITE_E"Password anda benar, silahkan pencet spawn untuk spawn");
      }
      else
      {
       ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Your password isn't correct, coba masukkan ulang", "Login", "Batal");
      }
     }
    if(dialogid == DIALOG_SSPAWN)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SetPlayerPos(playerid, 1949.5585,1273.6281,10.8365);
                }
                case 1:
                {
                    SetPlayerPos(playerid, 2046.5460,1274.7776,10.6719);
                }
                case 2:
                {
                    SetPlayerPos(playerid, 2046.1478,1390.9000,10.6719);
                }
                case 3:
                {
                    SetPlayerPos(playerid, 1955.4836,1392.5227,9.1094);
                }
                case 4:
                {
                    SetPlayerPos(playerid, 1965.7312,1342.6174,9.2501);
                }
                case 5:
                {
                    SetPlayerPos(playerid, 1953.6908,1342.9768,15.3746);
                }
            }
        }
    }
	return 1;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

CMD:weapons(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_WEAPON, DIALOG_STYLE_LIST, "Weapon Buy", "Pistol\nAssault Rifle\nRifle and Heavy\nAnother", "Select", "Close");
	return 1;
}

CMD:gotoco(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return SendClientMessage(playerid, COLOR_RED, "SERVER:"WHITE_E" Anda bukan admin");
		
	new Float: pos[3], int;
	if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int)) return SendClientMessage(playerid, COLOR_LIME, "/gotoco [x coordinate] [y coordinate] [z coordinate] [interior]");

	SendClientMessage(playerid, COLOR_LIME, "Anda telah terteleportasi ke kordinat tersebut.");
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	SetPlayerInterior(playerid, int);
	return 1;
}

CMD:setskin(playerid, params[])
{
    new
        skinid,
        otherid;

    if(sscanf(params, "ud", playerid, skinid))
        return SendClientMessage(playerid, COLOR_GREEN, "/skin [playerid/PartOfName] [skin id]");

    if(!IsPlayerConnected(playerid))
        return SendClientMessage(playerid, COLOR_RED, "Player belum masuk!");

    if(skinid < 0 || skinid > 299)
        return SendClientMessage(playerid, COLOR_RED, "Invalid skin ID. Skins range from 0 to 299.");

    SetPlayerSkin(otherid, skinid);

    SendClientMessage(playerid, COLOR_BLUE, "You have set your skin.");
    return 1;
}