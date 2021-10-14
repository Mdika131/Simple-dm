// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <streamer>
#include <compat>

//Modules
#include "COLOR.pwn"

//Server Define
#define NAME "Deathmatch Testing Server"

main()
{
	print("\n----------------------------------");
	print(" Deathmatch Test Has Loaded");
	print("----------------------------------\n");
}

//Dialog
enum
{
	DIALOG_HELP
}
public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("Deathmatch Test");
	AddPlayerClass(294, -975.975708, 1060.983032, 1345.671875, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(295, -1113.9158, 1059.6702, 1342.8475, 277.6786, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid, COLOR_GREEN, "Welcome to "NAME"");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	GivePlayerWeapon(playerid, 31, 500);
	GivePlayerWeapon(playerid, 24, 125);
	SetPlayerInterior(playerid, 10);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SendClientMessage(playerid, COLOR_RED, "You die");
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/help", cmdtext, true, 10) == 0)
	{
		SendClientMessage(playerid, COLOR_BLUE, "Costumize this command");
		return 1;
	}
	if (strcmp("/credit", cmdtext, true, 10 == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "This gamemode created by Resi Mahardika");
		SendClientMessage(playerid, COLOR_BLUE, "If you have a problem at use this gamemode please contact:");
		SendClientMessage(playerid, COLOR_WHITE, "DISCORD: I'm Dika#1239");
		SendClientMessage(playerid, COLOR_RED, "YOUTUBE: Resi Mahardika");
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
