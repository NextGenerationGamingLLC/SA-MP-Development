/*
	Furniture System
		by Jingles


	Integrated the Texture Studio by Pottus.
*/

#include <YSI\y_hooks>

#define 		MAX_CATALOG 					1000
#define 		MAX_TILES 						16


#define         PREVIEW_STATE_NONE				0
#define         PREVIEW_STATE_ALLTEXTURES		1
#define         PREVIEW_STATE_THEME				2
#define         PREVIEW_STATE_SEARCH			3
#define         PREVIEW_STATE_SELECT			4


#define         DEFAULT_TEXTURE                 1000
#define         MAX_THEME_TEXTURES              100
#define 		MAX_SEARCH_TEXTURES				1000

enum eFurnitureCatalog {
	fc_iModelID,
	fc_iTypeID,
	fc_szName[32],
	fc_iPrice,
	fc_iVIP
}
new arrFurnitureCatalog[MAX_CATALOG][eFurnitureCatalog];

new FurnitureSystem = 1,
	textm_Selected3DTextureMenu[MAX_PLAYERS] = { -1, ...},
	textm_SelectedTile[MAX_PLAYERS];

enum TextMenuParams {

	Float:textm_fRot,
	bool:textm_bExists,
	textm_iTiles,
	textm_iObjectID[MAX_TILES],
	Float:textm_OrigPosX[MAX_TILES],
	Float:textm_OrigPosY[MAX_TILES],
	Float:textm_OrigPosZ[MAX_TILES],
	Float:textm_AddX,
	Float:textm_AddY,
	textm_iSelectColor[MAX_TILES],
	textm_iUnselectColor[MAX_TILES],
	textm_iPlayerID
}
new TextureMenuInfo[MAX_PLAYERS][TextMenuParams];

enum TextMenuInfo {

    ptextm_TPreviewState,
	ptextm_CurrTextureIndex,
    ptextm_Menus3D,
    ptextm_CurrThemeIndex,
    PlayerText:Menu3D_Model_Info,
}
new PlayerTextureMenuInfo[MAX_PLAYERS][TextMenuInfo];

new PlayerTextureThemeIndex[MAX_PLAYERS][100]; // Max of 100 textures in a theme.
new ListItemTextureTrackId[MAX_PLAYERS][MAX_SEARCH_TEXTURES];

hook OnGameModeInit() {

	FurnitureTDInit();
}

hook OnPlayerConnect(playerid) {

	Furniture_ResetPVars(playerid);
	FurniturePlayerTDInit(playerid);
	Reset3DTextureMenuVars(playerid);
}

hook OnPlayerDisconnect(playerid, reason) {
	Furniture_ResetPVars(playerid);
	Unload3DTextureMenu(playerid);
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) {

	if(clickedid == Furniture_TD[21]) FurnitureMenu(playerid, 5); // Painting
	if(clickedid == Furniture_TD[22]) FurnitureMenu(playerid, 4); // Building
	if(clickedid == Furniture_TD[7]) BuildIcons(playerid, 1);
	if(clickedid == Furniture_TD[18] || clickedid == Furniture_TD[18]) FurnitureMenu(playerid, 2); // Build Mode.
	if(clickedid == Furniture_TD[8]) FurnitureMenu(playerid, 3); // Sell Mode.
	if(clickedid == Furniture_TD[9]) FurnitureMenu(playerid, 1); // Buy Mode.
	if(clickedid == Furniture_TD[13]) cmd_furniture(playerid, "");	
	if(clickedid == Furniture_TD[14]) cmd_furniturehelp(playerid, "");
	if(clickedid == Furniture_TD[16]) cmd_furnitureresetpos(playerid, "");
	if(clickedid == Furniture_TD[10]) FurniturePermit(playerid);
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(OnPlayerKeyStateChange3DMenu(playerid,newkeys,oldkeys)) return 1;

	if(newkeys & KEY_SPRINT && newkeys & KEY_CROUCH) {

		if(GetPVarType(playerid, PVAR_FURNITURE_EDITING)) {

			new Float:fPos[3],
				iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING);

			GetXYInFrontOfPlayer(playerid, fPos[0], fPos[1], 1.0);
			SetDynamicObjectPos(iObjectID, fPos[0], fPos[1], fPos[2]);
		}
	}
	if(newkeys & KEY_LOOK_BEHIND && GetPVarInt(playerid, PVAR_FURNITURE)) {

		if(!Bit_State(arrPlayerBits[playerid], f_bCursor)) {
 		
			Bit_On(arrPlayerBits[playerid], f_bCursor);
			SelectTextDraw(playerid, 0xF6FBFCFF);
		}
		else {
			CancelSelectTextDraw(playerid);
			Bit_Off(arrPlayerBits[playerid], f_bCursor);
		}
		return 1;
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {
		
		case DIALOG_FURNITURE: {
			if(!response) return 1;
			switch(listitem) {
				case 0: FurnitureMenu(playerid, 1);
				case 1: FurnitureMenu(playerid, 2);
				case 2: FurnitureMenu(playerid, 3);
			}
		}
		case DIALOG_FURNITURE_BUY: {
			
			if(!response) return FurnitureMenu(playerid, 0);
			szMiscArray[0] = 0;

			new x;
			for(new i; i < MAX_CATALOG; ++i) {
				if(arrFurnitureCatalog[i][fc_iTypeID] == listitem) {
					
					if(arrFurnitureCatalog[i][fc_iModelID] != 0) {

						if(arrFurnitureCatalog[i][fc_iVIP] == 1) format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}(VIP) %s ($%s){FFFFFF}\n", szMiscArray, arrFurnitureCatalog[i][fc_szName], number_format(arrFurnitureCatalog[i][fc_iPrice]));
						else format(szMiscArray, sizeof(szMiscArray), "%s\n%s ($%s)", szMiscArray, arrFurnitureCatalog[i][fc_szName], number_format(arrFurnitureCatalog[i][fc_iPrice]));

						ListItemTrackId[playerid][x] = i;
						++x;
					}
					else break;
				}
			}

			new szTitle[32];
			format(szTitle, sizeof(szTitle), "Furniture - %s", szFurnitureCategories[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_BUYSELECT, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Buy", "Cancel");
		}
		case DIALOG_FURNITURE_BUYSELECT: {

			if(response) {

				new i = ListItemTrackId[playerid][listitem];
				SetPVarInt(playerid, "frncat", i);
				if(PlayerInfo[playerid][pDonateRank] < arrFurnitureCatalog[i][fc_iVIP] && PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your VIP level is not high enough to buy this piece of furniture.");
				PreviewFurniture(playerid, arrFurnitureCatalog[i][fc_iModelID], true);
				SetPVarInt(playerid, PVAR_FURNITURE_BUYMODEL, arrFurnitureCatalog[i][fc_iModelID]);
				format(szMiscArray, sizeof(szMiscArray), "Would you like to buy this %s for $%s and %s materials?", GetFurnitureName(arrFurnitureCatalog[i][fc_iModelID]), number_format(GetFurniturePrice(arrFurnitureCatalog[i][fc_iModelID])), number_format(GetFurniturePrice(arrFurnitureCatalog[i][fc_iModelID]) / 10));
				ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_BUYCONFIRM, DIALOG_STYLE_MSGBOX, "Furniture Menu | Confirm Purchase", szMiscArray, "Buy", "Cancel");
			}
			else FurnitureMenu(playerid, 1);
		}
		case DIALOG_FURNITURE_BUYCONFIRM: {

			PreviewFurniture(playerid, -1, false);
			if(!response) {

				FurnitureMenu(playerid, 1);
				DeletePVar(playerid, PVAR_FURNITURE_BUYMODEL);
			}
			else {

				new iModelID = GetPVarInt(playerid, PVAR_FURNITURE_BUYMODEL),
					iHouseID = GetHouseID(playerid),
					iSlotID = -1;

				iSlotID = GetNextFurnitureSlotID(playerid, iHouseID);
				if(iSlotID > GetMaxFurnitureSlots(playerid) || iSlotID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any furniture slots left.");
				
				new iPrice = GetFurniturePrice(iModelID);
				if(GetPlayerMoney(playerid) < iPrice) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough money to buy this.");
				if(PlayerInfo[playerid][pMats] < floatround((iPrice / 10))) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough materials to make this.");

				new Float:fPos[3],
					iVW = GetPlayerVirtualWorld(playerid);

				GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
				defer FurnitureControl(playerid, fPos[0], fPos[1], fPos[2]);
				GetXYInFrontOfPlayer(playerid, fPos[0], fPos[1], 1.5);
				HouseInfo[iHouseID][hFurniture][iSlotID] = CreateDynamicObject(iModelID, fPos[0], fPos[1], fPos[2], 0.0, 0.0, 0.0, iVW);
				if(IsADoor(iModelID)) {

					new iLocalDoorArea = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 5.0, HouseInfo[iHouseID][hIntVW]),
						szData[3];

					szData[0] = iHouseID;
					szData[1] = HouseInfo[iHouseID][hFurniture][iSlotID];
					szData[2] = 0;
					Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
				}
				Streamer_SetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][iSlotID], E_STREAMER_EXTRA_ID, iHouseID);
				GivePlayerCash(playerid, -iPrice);
				PlayerInfo[playerid][pMats] -= (iPrice / 10);
				
				SetPVarInt(playerid, PVAR_FURNITURE_SLOT, iSlotID);
				SetPVarInt(playerid, PVAR_FURNITURE_EDITING, HouseInfo[iHouseID][hFurniture][iSlotID]);
				TogglePlayerControllable(playerid, false);
				CreateFurniture(playerid, iHouseID, iSlotID, iModelID, fPos[0], fPos[1], fPos[2], 0.0, 0.0, 0.0);
				EditDynamicObject(playerid, HouseInfo[iHouseID][hFurniture][iSlotID]);
				FurnitureEditObject(playerid);
			}
		}
		case DIALOG_FURNITURE_EDIT: {

			if(!response) return FurnitureMenu(playerid, 0), DeletePVar(playerid, PVAR_FURNITURE_SLOT), DeletePVar(playerid, PVAR_FURNITURE_EDITING);

			new iHouseID = GetHouseID(playerid);

			if(GetPVarType(playerid, PVAR_FURNITURE_SLOT)) {
								
				switch(listitem) {

					case 0: {
						FurnitureEditObject(playerid);
						return EditDynamicObject(playerid, GetPVarInt(playerid, PVAR_FURNITURE_EDITING));
					}
					case 2: SetPVarInt(playerid, "color", 1);
				}
				return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT, DIALOG_STYLE_LIST, "Furniture Menu | Slot", "Slot 1\nSlot 2\nSlot 3\nSlot 4\nSlot 5\n{EE0000}Remove All", "Select", "Cancel");
			}
			else {

				if(IsValidFurniture(iHouseID, listitem, 1)) {

					SetPVarInt(playerid, PVAR_FURNITURE_SLOT, listitem);
					SetPVarInt(playerid, PVAR_FURNITURE_EDITING, HouseInfo[iHouseID][hFurniture][listitem]);
					//return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_EDIT, DIALOG_STYLE_LIST, "Furniture Menu | Edit", "Move position\nChange texture\nChange color", "Select", "Back");
					return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_EDIT, DIALOG_STYLE_LIST, "Furniture Menu | Edit", "Move position\nChange texture", "Select", "Back");
				}
				else SendClientMessage(playerid, COLOR_GRAD1, "There's no furniture in that slot.");			
			}
		}
		case DIALOG_FURNITURE_SELL: {
			
			if(!response) return FurnitureMenu(playerid, 0), DeletePVar(playerid, "SellFurniture");

			new iHouseID = GetHouseID(playerid),
				iSlotID = GetPVarInt(playerid, PVAR_FURNITURE_SLOT),
				iModelID = Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][iSlotID], E_STREAMER_MODEL_ID);

			DeletePVar(playerid, "SellFurniture");
			SellFurniture(playerid, iHouseID, iSlotID, GetFurniturePrice(iModelID));
			DeletePVar(playerid, PVAR_FURNITURE_SLOT);
			return 1;
		}
		case DIALOG_FURNITURE_PAINT: {

			if(!response) return 1;

			//return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Slot", "Slot 1\nSlot 2\nSlot 3\nSlot 4\nSlot 5\n{EE0000}Remove All", "Select", "Cancel");
			SendClientMessageEx(playerid, COLOR_GRAD1, "** Use ~k~~GROUP_CONTROL_BWD~ and ~k~~CONVERSATION_NO~ to browse. Press ~k~~CONVERSATION_YES~ to choose.");
			SendClientMessageEx(playerid, COLOR_GRAD1, "** Press ~k~~PED_LOOKBEHIND~ to cancel. Press ~k~~PED_DUCK~ to remove all textures.");
			PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_SELECT;
			textm_SelectedTile[playerid] = 0;

			#define MAX_OBJECT_TEXTSLOTS 5
			new iTmpModel[MAX_OBJECT_TEXTSLOTS],
				szTXDName[MAX_OBJECT_TEXTSLOTS][32],
				szTextureName[MAX_OBJECT_TEXTSLOTS][32],
				iColor,
				iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING);

			GetDynamicObjectMaterial(iObjectID, 0, iTmpModel[0], szTXDName[0], szTextureName[0], iColor, 32, 32);
			SetDynamicObjectMaterial(iObjectID, 0, iTmpModel[0], szTXDName[0], szTextureName[0], 0xFFFFFFFF);
			for(new iIndex = 1; iIndex < MAX_OBJECT_TEXTSLOTS; ++iIndex) { // Skip 0, that one remains bright.

				GetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor, 32, 32);
				SetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], 0xFF999999);
				/*
				if(isnull(szTXDName[iIndex])) {
					SetPVarInt(playerid, "maxtextslots", iIndex);
					break;
				}
				*/
			}
			PlayerTextDrawSetString(playerid, Furniture_PTD[playerid][2], "Slot: 1");
			PlayerTextDrawShow(playerid, Furniture_PTD[playerid][2]);
			format(szMiscArray, sizeof(szMiscArray), "Name: %s", szTextureName[0]);
			PlayerTextDrawSetString(playerid, Furniture_PTD[playerid][3], szMiscArray);
			PlayerTextDrawShow(playerid, Furniture_PTD[playerid][3]);
			CancelSelectTextDraw(playerid);
			return 1;			

		}
		case DIALOG_FURNITURE_PAINT2: {

			if(!response) return DeletePVar(playerid, "color"), DeletePVar(playerid, "textslot"), DeletePVar(playerid, "studorfind"), DeletePVar(playerid, "textsearch"), DeletePVar(playerid, "studio"), DeletePVar(playerid, "processtext");

			if(GetPVarType(playerid, "studorfind")) {

				DeletePVar(playerid, "studorfind");
				switch(listitem) {

					case 0: SetPVarInt(playerid, "studio", 1);
					case 1: SetPVarInt(playerid, "textsearch", 1);
					case 2: {

						SetPVarInt(playerid, "color", 1);
						format(szMiscArray, sizeof(szMiscArray), "%s", MakeColorMenu());
						return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Select Color", szMiscArray, "Select", "Cancel"); 
					}
				}
				SetPVarInt(playerid, "processtext", 1);
				return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_INPUT, "Furniture Menu | Search Texture", "Please insert a keyword for your texture. Leave it empty if you want to browse all.", "Select", "Cancel");
				
			}
			if(GetPVarType(playerid, "processtext")) {

				new x;
				DeletePVar(playerid, "processtext");
				if(isnull(inputtext) && GetPVarType(playerid, "studio"))  {

					PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_ALLTEXTURES;
					SendClientMessageEx(playerid, COLOR_GRAD1, "[Furniture]: Displaying all textures.");
				}
				else {

					for(new i; i < sizeof(arrTextures); ++i) {

						if(strfind(arrTextures[i][text_TXDName], inputtext, true) != -1 || strfind(arrTextures[i][text_TextureName], inputtext, true) != -1) {

							if(x > MAX_SEARCH_TEXTURES) {

								format(szMiscArray, sizeof(szMiscArray), "** Your search contains more than %d results. Therefore the maximum will be displayed.", MAX_SEARCH_TEXTURES);
								SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
								break;
							}
							ListItemTextureTrackId[playerid][x] = i;
							format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, arrTextures[i][text_TextureName]);
							x++;
						}
					}
				}

				if(GetPVarType(playerid, "studio")) {
					
					DeletePVar(playerid, "studio");
					if(PlayerTextureMenuInfo[playerid][ptextm_Menus3D] != -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have an in-world texture menu.");

					if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] != PREVIEW_STATE_ALLTEXTURES) {
						PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_SEARCH;
					}
    
					new Float:fPos[4];
					GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
					GetPlayerFacingAngle(playerid, fPos[3]);

					fPos[0] = (fPos[0] + 1.75 * floatsin(-fPos[3] + -90, degrees));
					fPos[1] = (fPos[1] + 1.75 * floatcos(-fPos[3] + -90, degrees));
					fPos[0] = (fPos[0] + 2.0 * floatsin(-fPos[3], degrees));
					fPos[1] = (fPos[1] + 2.0 * floatcos(-fPos[3], degrees));

					SendClientMessageEx(playerid, COLOR_GRAD1, "** Next series: ~k~~GROUP_CONTROL_BWD~ and ~k~~SNEAK_ABOUT~ - Previous series:  ~k~~CONVERSATION_NO~ and ~k~~SNEAK_ABOUT~.");
					PlayerTextureMenuInfo[playerid][ptextm_Menus3D] = Create3DTextureMenu(playerid, fPos[0], fPos[1], fPos[2], fPos[3], 16);
					// Update textures
					switch(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState]) {

						case PREVIEW_STATE_SEARCH: {

							 for(new i = 0; i < 16; i++) {

								Set3DTextureMenuTile(PlayerTextureMenuInfo[playerid][ptextm_Menus3D], i, 0, arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TModel],
									arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TXDName], arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TextureName], 0, 0xFF999999);
							}
						}
						default: {

							for(new i = 0; i < 16; i++) {
						
							    Set3DTextureMenuTile(PlayerTextureMenuInfo[playerid][ptextm_Menus3D], i, 0, arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TModel],
							    	arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TXDName], arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TextureName], 0, 0xFF999999);
							}
						}
					}
					

					Select3DTextureMenu(playerid, PlayerTextureMenuInfo[playerid][ptextm_Menus3D]);
				    //PlayerTextDrawShow(playerid, PlayerTextureMenuInfo[playerid][Menu3D_Model_Info]);
				    return 1;
				}

				if(GetPVarType(playerid, "textsearch")) {

					if(!x) return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_INPUT, "Furniture Menu | Search Texture", "Your keyword didn't come up with any results. Please try again.", "Select", "Cancel");
					DeletePVar(playerid, "textsearch");
					return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Select Texture", szMiscArray, "Select", "Cancel");
				}
			}

			if(!GetPVarType(playerid, "textslot")) {

				if(strcmp(inputtext, "Remove All", true) == 0) return ReloadFurniture(playerid);

				szMiscArray[0] = 0;
				SetPVarInt(playerid, "textslot", listitem);
				switch(GetPVarType(playerid, "color")) {

					case 0: {

						//for(new i; i < sizeof(szFurnitureTextures); ++i) format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szFurnitureTextures[i][0]);
						//return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Texture Lab", szMiscArray, "Select", "Cancel");
						SetPVarInt(playerid, "studorfind", 1);
						return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Texturing", "Texture Studio\nSearch Texture", "Select", "Cancel");
					}
					case 1: return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_INPUT, "Furniture Menu | Color Lab", "Please enter a HEX color code.", "Select", "Cancel");
				}
			}
			else {

				new iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING),
					iSlotID = GetPVarInt(playerid, PVAR_FURNITURE_SLOT),
					iTextSlot = GetPVarInt(playerid, "textslot"),
					iHouseID = GetHouseID(playerid);

				switch(GetPVarType(playerid, "color")) {

					case 0: ProcessFurnitureTexture(iHouseID, iSlotID, iObjectID, iTextSlot, ListItemTextureTrackId[playerid][listitem], 0, 1);
					case 1: ProcessFurnitureTexture(iHouseID, iSlotID, iObjectID, iTextSlot, 0, GetFurnitureColorCode(listitem), 1);
				}

				DeletePVar(playerid, PVAR_FURNITURE_EDITING);
				DeletePVar(playerid, PVAR_FURNITURE_SLOT);
				DeletePVar(playerid, "textslot");
				DeletePVar(playerid, "color");
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture]: {CCCCCC}You successfully painted the furniture.");
				return 1;
			}
		}
		case DIALOG_PERMITBUILDER: {

			if(isnull(inputtext) || !response) return DeletePVar(playerid, "PRMBLD");

			if(!GetPVarType(playerid, "PRMBLD")) {

				new uPlayer;
				sscanf(inputtext, "u", uPlayer);
				if(!IsPlayerConnected(uPlayer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid player id.");

				SetPVarInt(playerid, "PRMBLD", uPlayer);
				format(szMiscArray, sizeof(szMiscArray), "[Furniture]: {DDDDDD}Which house would like like to permit {FFFF00}%s {DDDDDD}to build in?", GetPlayerNameEx(uPlayer));
				SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
				ShowPlayerDialogEx(playerid, DIALOG_PERMITBUILDER, DIALOG_STYLE_LIST, "Furniture | Permit Builder", "House 1\nHouse 2\nHouse3", "Select", "Cancel");
			}
			else {

				new iHouseID;

				switch(listitem) {
					case 0: {
						if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a house in this slot."), DeletePVar(playerid, "PRMBLD");
						iHouseID = PlayerInfo[playerid][pPhousekey];
					}
					case 1: {
						if(PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a house in this slot."), DeletePVar(playerid, "PRMBLD");
						iHouseID = PlayerInfo[playerid][pPhousekey2];
					}
					case 2: {
						if(PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a house in this slot."), DeletePVar(playerid, "PRMBLD");
						iHouseID = PlayerInfo[playerid][pPhousekey3];
					}
					default: return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid house ID."), DeletePVar(playerid, "PRMBLD");
				}

				new giveplayerid = GetPVarInt(playerid, "PRMBLD");
				PlayerInfo[giveplayerid][pHouseBuilder] = iHouseID;

				DeletePVar(playerid, "PRMBLD");
				format(szMiscArray, sizeof(szMiscArray), "%s granted you the permission to build in their house. Your previous home permissions have been replaced.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_YELLOW, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "You have granted %s the permission to build in your house.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			}
		}
		case DIALOG_FURNITURE_DESCONFIRM: {

			if(response) {
				
				new iHouseID = GetHouseID(playerid);
				if(iHouseID == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a house.");
				for(new i; i < MAX_FURNITURE_SLOTS; ++i) DestroyFurniture(iHouseID, i);
				SendClientMessageEx(playerid, COLOR_YELLOW, "You successfully destroyed all the house's furniture.");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD1, "You cancelled destroying all the house's furniture.");
		}
	}
	return 0;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z) {


	if(GetPVarType(playerid, "copdestroyfur")) {

		new iHouseID = GetHouseID(playerid),
			i,
			iData;

		iData = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID);
		if(iHouseID != iData) return SendClientMessageEx(playerid, COLOR_GRAD1, "This object is not a piece of furniture.");
		for(i = 0; i < MAX_FURNITURE_SLOTS; ++i) if(HouseInfo[iHouseID][hFurniture][i] == objectid) break;

		if(IsValidFurniture(iHouseID, i, 1)) {

			DestroyDynamicObject(HouseInfo[iHouseID][hFurniture][i]);
			DeletePVar(playerid, "copdestroyfur");
			format(szMiscArray, sizeof(szMiscArray), "** %s destroyed a piece of furniture.", GetPlayerNameEx(playerid));
			SendGroupMessage(GROUP_TYPE_LEA, COLOR_DBLUE, szMiscArray);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "You didn't specify a piece of furniture.");
	}
	if(GetPVarType(playerid, PVAR_FURNITURE)) {

		CancelEdit(playerid);

		new iHouseID = GetHouseID(playerid),
			i,
			iData;

		iData = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID);
		if(iHouseID != iData) return SendClientMessageEx(playerid, COLOR_GRAD1, "This object is not a piece of furniture.");
		for(i = 0; i < MAX_FURNITURE_SLOTS; ++i) if(HouseInfo[iHouseID][hFurniture][i] == objectid) break;

		if(GetPVarType(playerid, "SellFurniture")) { 

			SetPVarInt(playerid, PVAR_FURNITURE_SLOT, i);
			format(szMiscArray, sizeof(szMiscArray), "Are you sure you want to sell the %s for $%s?", 
				GetFurnitureName(GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][i])), number_format(GetFurniturePrice(GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][i]))));
			
			ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_SELL, DIALOG_STYLE_MSGBOX, "Furniture Menu | Confirm", szMiscArray, "Sell", "Cancel");
			return 1;
		}
		else if(GetPVarType(playerid, "paint")) {

			DeletePVar(playerid, "paint");

			PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][0], modelid);
			PlayerTextDrawSetPreviewRot(playerid, Furniture_PTD[playerid][0], 345.000000, 0.000000, 0.000000, 1.300000);
			PlayerTextDrawHide(playerid, Furniture_PTD[playerid][0]);
			PlayerTextDrawShow(playerid, Furniture_PTD[playerid][0]);
			TextDrawShowForPlayer(playerid, Furniture_TD[23]);
			TextDrawShowForPlayer(playerid, Furniture_TD[24]);

			BuildIcons(playerid, 0);
			SetPVarInt(playerid, PVAR_FURNITURE_SLOT, i);
			SetPVarInt(playerid, PVAR_FURNITURE_EDITING, objectid);
			//ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Texture Slot", "Slot 1\nSlot 2\nSlot 3\nSlot 4\nSlot 5\n{EE0000}Remove All", "Select", "Cancel");

			// New texture browser on the object:
			SendClientMessageEx(playerid, COLOR_GRAD1, "** Use ~k~~GROUP_CONTROL_BWD~ and ~k~~CONVERSATION_NO~ to browse. Press ~k~~CONVERSATION_YES~ to choose.");
			SendClientMessageEx(playerid, COLOR_GRAD1, "** Press ~k~~PED_LOOKBEHIND~ to cancel. Press ~k~~PED_DUCK~ to remove all textures.");
			PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_SELECT;
			textm_SelectedTile[playerid] = 0;

			#define MAX_OBJECT_TEXTSLOTS 5
			new iTmpModel[MAX_OBJECT_TEXTSLOTS],
				szTXDName[MAX_OBJECT_TEXTSLOTS][32],
				szTextureName[MAX_OBJECT_TEXTSLOTS][32],
				iColor,
				iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING);


			
			GetDynamicObjectMaterial(iObjectID, 0, iTmpModel[0], szTXDName[0], szTextureName[0], iColor, 32, 32);
			SetDynamicObjectMaterial(iObjectID, 0, iTmpModel[0], szTXDName[0], szTextureName[0], 0xFFFFFFFF);
			for(new iIndex = 1; iIndex < MAX_OBJECT_TEXTSLOTS; ++iIndex) { // Skip 0, that one remains bright.

				GetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor, 32, 32);
				SetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], 0xFF999999);
				/*
				if(isnull(szTXDName[iIndex])) {
					SetPVarInt(playerid, "maxtextslots", iIndex);
					format(szMiscArray, sizeof(szMiscArray), "Text slots: %d", iIndex);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					break;
				}
				*/
			}
			PlayerTextDrawSetString(playerid, Furniture_PTD[playerid][2], "Slot: 1");
			PlayerTextDrawShow(playerid, Furniture_PTD[playerid][2]);
			format(szMiscArray, sizeof(szMiscArray), "Name: %s", szTextureName[0]);
			PlayerTextDrawSetString(playerid, Furniture_PTD[playerid][3], szMiscArray);
			PlayerTextDrawShow(playerid, Furniture_PTD[playerid][3]);
			CancelSelectTextDraw(playerid);
		}
		else {

			EditFurniture(playerid, objectid, modelid);
			BuildIcons(playerid, 0);
		}
	}
	return 1;	
}


timer FurnitureControl[1000](playerid, Float:X, Float:Y, Float:Z) {
	TogglePlayerControllable(playerid, true);
	SetPlayerPos(playerid, X, Y, Z);
}


timer FurnitureEditObject[5000](playerid) {
	
	new Float:fPos[6];
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	if(!GetPVarType(playerid, "furnfirst")) {

		SetPVarInt(playerid, "furnfirst", 1);
		SetPVarFloat(playerid, "PX", fPos[0]);
		SetPVarFloat(playerid, "PY", fPos[1]);
		SetPVarFloat(playerid, "PZ", fPos[2]);
		defer FurnitureEditObject(playerid);
		return 1;
	}
	fPos[3] = GetPVarFloat(playerid, "PX");
	fPos[4] = GetPVarFloat(playerid, "PY");
	fPos[5] = GetPVarFloat(playerid, "PZ");
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, fPos[3], fPos[4], fPos[5])) {

		CancelEdit(playerid);
		DeletePVar(playerid, "furnfirst");
		new iHouseID = GetPVarInt(playerid, PVAR_INHOUSE);
		Player_StreamPrep(playerid, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ], FREEZE_TIME);
		SendClientMessageEx(playerid, COLOR_GRAD1, "You went too far away.");
		return 1;
	}
	if(fPos[5] > (fPos[2] + 2.0)) {

		CancelEdit(playerid);
		DeletePVar(playerid, "furnfirst");
		new iHouseID = GetPVarInt(playerid, PVAR_INHOUSE);
		Player_StreamPrep(playerid, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ], FREEZE_TIME);
		SendClientMessageEx(playerid, COLOR_GRAD1, "You went too far away.");
		return 1;
	}
	return 1;
}

timer Furniture_HousePosition[5000](playerid, iHouseID) {

	Player_StreamPrep(playerid, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ], FREEZE_TIME);
}


timer RehashHouseFurniture[10000](iHouseID) {

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `furniture` WHERE `houseid` = '%d'", iHouseID);
	mysql_tquery(MainPipeline, szMiscArray, "OnRehashHouseFurniture", "i", iHouseID);
}


BuildIcons(playerid, choice) {

	switch(choice) {

		case 0: {

			TextDrawHideForPlayer(playerid, Furniture_TD[19]);
			TextDrawHideForPlayer(playerid, Furniture_TD[20]);
			TextDrawHideForPlayer(playerid, Furniture_TD[21]);
			TextDrawHideForPlayer(playerid, Furniture_TD[22]);
		}
		case 1: {

			TextDrawShowForPlayer(playerid, Furniture_TD[19]);
			TextDrawShowForPlayer(playerid, Furniture_TD[20]);
			TextDrawShowForPlayer(playerid, Furniture_TD[21]);
			TextDrawShowForPlayer(playerid, Furniture_TD[22]);
		}
	}
}

GetMaxFurnitureSlots(playerid) {

	new iMaxSlots;

	switch(PlayerInfo[playerid][pDonateRank]) {
		case 1: iMaxSlots = 35; // Bronze VIPs
		case 2: iMaxSlots = 40; // Silver VIPs
		case 3: iMaxSlots = 50; // Gold VIPs
		case 4: iMaxSlots = 75; // Platinum VIPs
		default: iMaxSlots = 30; // Regular
	}
	iMaxSlots += PlayerInfo[playerid][pFurnitureSlots];
	if(iMaxSlots >= MAX_FURNITURE_SLOTS) iMaxSlots = MAX_FURNITURE_SLOTS-1;
	if(IsAdminLevel(playerid, ADMIN_SENIOR, 0)) iMaxSlots = MAX_FURNITURE_SLOTS-1;
	return iMaxSlots;
}

EditFurniture(playerid, objectid, modelid) {

	new iHouseID = GetHouseID(playerid);
	DeletePVar(playerid, "furnfirst");
	for(new i; i < MAX_FURNITURE_SLOTS; ++i) if(HouseInfo[iHouseID][hFurniture][i] == objectid) SetPVarInt(playerid, PVAR_FURNITURE_SLOT, i);
	SetPVarInt(playerid, PVAR_FURNITURE_EDITING, objectid);
	FurnitureEditObject(playerid);
	PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][0], modelid);
	PlayerTextDrawSetPreviewRot(playerid, Furniture_PTD[playerid][0], 345.000000, 0.000000, 0.000000, 1.300000);
	PlayerTextDrawHide(playerid, Furniture_PTD[playerid][0]);
	PlayerTextDrawShow(playerid, Furniture_PTD[playerid][0]);
	TextDrawShowForPlayer(playerid, Furniture_TD[23]);
	TextDrawShowForPlayer(playerid, Furniture_TD[24]);
	EditDynamicObject(playerid, objectid);
}

PreviewFurniture(playerid, iModelID, bool:show) {

	switch(show) {

		case 0: {
			DeletePVar(playerid, "FurnPreview");
			TextDrawHideForPlayer(playerid, Furniture_TD[25]);
			TextDrawHideForPlayer(playerid, Furniture_TD[26]);
			TextDrawHideForPlayer(playerid, Furniture_TD[27]);
			
			PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][0], GetPlayerSkin(playerid));
			PlayerTextDrawHide(playerid, Furniture_PTD[playerid][0]);
			PlayerTextDrawShow(playerid, Furniture_PTD[playerid][0]);
			PlayerTextDrawHide(playerid, Furniture_PTD[playerid][1]);
		}
		default: {

			TextDrawShowForPlayer(playerid, Furniture_TD[25]);
			TextDrawShowForPlayer(playerid, Furniture_TD[26]);
			TextDrawShowForPlayer(playerid, Furniture_TD[27]);

			PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][0], iModelID);
			PlayerTextDrawHide(playerid, Furniture_PTD[playerid][0]);
			PlayerTextDrawShow(playerid, Furniture_PTD[playerid][0]);
		
			PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][1], iModelID);
			PlayerTextDrawHide(playerid, Furniture_PTD[playerid][1]);
			PlayerTextDrawShow(playerid, Furniture_PTD[playerid][1]);
			SetPVarInt(playerid, "FurnPreview", 1);
			defer AnimateFurniturePreview(playerid, 0);
		}
	}
}

timer AnimateFurniturePreview[1000](playerid, rotation) {

	if(GetPVarType(playerid, "FurnPreview")) {
		PlayerTextDrawSetPreviewRot(playerid, Furniture_PTD[playerid][1], -16.000000, 0.000000, rotation, 1.000000);
		PlayerTextDrawHide(playerid, Furniture_PTD[playerid][1]);
		PlayerTextDrawShow(playerid, Furniture_PTD[playerid][1]);
		defer AnimateFurniturePreview(playerid, rotation+45);
	}
}

FurnitureListInit() {

	// Loading from MySQL database.
	mysql_tquery(MainPipeline, "SELECT * FROM `furniturecatalog`", "OnLoadFurnitureList", "");
}

forward OnLoadFurnitureList();
public OnLoadFurnitureList() {

	szMiscArray[0] = 0;

	new iRows,
		iCount;

	cache_get_row_count(iRows);
	if(!iRows || mysql_errno(MainPipeline)) print("[Furniture System]: No catalog found in the database.");

	while(iCount < iRows) {
		cache_get_value_name_int(iCount, "type", arrFurnitureCatalog[iCount][fc_iTypeID]);
		cache_get_value_name_int(iCount, "modelid", arrFurnitureCatalog[iCount][fc_iModelID]);
		cache_get_value_name(iCount, "name", arrFurnitureCatalog[iCount][fc_szName], 32);
		cache_get_value_name_int(iCount, "price", arrFurnitureCatalog[iCount][fc_iPrice]);
		cache_get_value_name_int(iCount, "vip", arrFurnitureCatalog[iCount][fc_iVIP]);
		++iCount;
	}
	printf("[Furniture System] Loaded %d pieces of furniture from the catalog.", iCount);
	return 1;
}

IsValidFurniture(iHouseID, iSlotID, check) {

	switch(check) {
		case 0: if(IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][iSlotID])) return 1;
		default: if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][iSlotID], E_STREAMER_EXTRA_ID) == iHouseID && IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][iSlotID])) return 1;	
	}
	return 0;
}

GetNextFurnitureSlotID(playerid, iHouseID) {

	new iSlotID = -1,
		iMaxSlots = GetMaxFurnitureSlots(playerid);

	for(new i; i < iMaxSlots; ++i) {

		if(!IsValidFurniture(iHouseID, i, 0)) {
			iSlotID = i;
			break;
		}
	}
	return iSlotID;
}

GetHouseID(playerid) {

	for(new i; i < MAX_HOUSES; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW]) return i;
	}
	return INVALID_HOUSE_ID;
}

HousePermissionCheck(playerid, iHouseID) {

	if(PlayerInfo[playerid][pPhousekey] == iHouseID) return 1;
	if(PlayerInfo[playerid][pPhousekey2] == iHouseID) return 1;
	if(PlayerInfo[playerid][pPhousekey3] == iHouseID) return 1;
	if(PlayerInfo[playerid][pHouseBuilder] == iHouseID) return 1;
	if(IsAdminLevel(playerid, ADMIN_SENIOR, 0)) return 1;
	return 0;
}

FurnitureMenu(playerid, menu = 0) {

	DeletePVar(playerid, "paint");
	new iHouseID = GetHouseID(playerid);
	if(iHouseID == INVALID_HOUSE_ID) {

		cmd_furniture(playerid, "");
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a house anymore.");
	}
	if(!HousePermissionCheck(playerid, iHouseID)) {
		cmd_furniture(playerid, "");
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not allowed to modify this house's furniture.");
	}
	switch(menu) {

		case 0: {
			
			if(!GetPVarInt(playerid, PVAR_FURNITURE)) {

				SetPVarInt(playerid, PVAR_FURNITURE, 1);
				SelectTextDraw(playerid, 0xF6FBFCFF);
				PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][0], PlayerInfo[playerid][pModel]);
				PlayerTextDrawSetPreviewRot(playerid, Furniture_PTD[playerid][0], 345.000000, 0.000000, 320.000000, 1.000000);
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][0]);
				PlayerTextDrawShow(playerid, Furniture_PTD[playerid][0]);
				TextDrawShowForPlayer(playerid, Furniture_TD[0]);
				TextDrawShowForPlayer(playerid, Furniture_TD[1]);
				TextDrawShowForPlayer(playerid, Furniture_TD[2]);
				TextDrawShowForPlayer(playerid, Furniture_TD[3]);
				TextDrawShowForPlayer(playerid, Furniture_TD[4]);
				TextDrawShowForPlayer(playerid, Furniture_TD[5]);
				TextDrawShowForPlayer(playerid, Furniture_TD[6]);
				TextDrawShowForPlayer(playerid, Furniture_TD[7]);
				TextDrawShowForPlayer(playerid, Furniture_TD[8]);
				TextDrawShowForPlayer(playerid, Furniture_TD[9]);
				TextDrawShowForPlayer(playerid, Furniture_TD[10]);
				TextDrawShowForPlayer(playerid, Furniture_TD[11]);
				TextDrawShowForPlayer(playerid, Furniture_TD[12]);
				TextDrawShowForPlayer(playerid, Furniture_TD[13]);
				TextDrawShowForPlayer(playerid, Furniture_TD[14]);
				TextDrawShowForPlayer(playerid, Furniture_TD[15]);
				TextDrawShowForPlayer(playerid, Furniture_TD[16]);
				TextDrawShowForPlayer(playerid, Furniture_TD[17]);
				TextDrawShowForPlayer(playerid, Furniture_TD[18]);
				TextDrawShowForPlayer(playerid, Furniture_TD[28]);

			}
			else {
				TextDrawHideForPlayer(playerid, Furniture_TD[23]);
				TextDrawHideForPlayer(playerid, Furniture_TD[24]);
				SelectTextDraw(playerid, 0xF6FBFCFF);
				DeletePVar(playerid, PVAR_FURNITURE_EDITING);
				DeletePVar(playerid, PVAR_FURNITURE_SLOT);
			}
			/*return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE, DIALOG_STYLE_LIST, "Furniture Menu", "\
				Buy furniture\n\
				Edit furniture\n\
				Sell furniture\n", "Select", "Cancel");
			*/
		}
		case 1: { // Buy furniture.

			return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_BUY, DIALOG_STYLE_LIST, "Furniture Menu | Categories", FurnitureCatalog(), "Select", "Back");
		}
		case 2: { // Edit your own furniture.

			szMiscArray[0] = 0;
			TextDrawShowForPlayer(playerid, Furniture_TD[23]);
			TextDrawShowForPlayer(playerid, Furniture_TD[24]);
			new iMaxSlots = GetMaxFurnitureSlots(playerid);
			for(new i; i < iMaxSlots; ++i) {

				if(IsValidFurniture(iHouseID, i, 1)) format(szMiscArray, sizeof(szMiscArray), "%s[%d] %s\n", szMiscArray, i, GetFurnitureName(Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][i], E_STREAMER_MODEL_ID)));
				else format(szMiscArray, sizeof(szMiscArray), "%s[%d] %s\n", szMiscArray, i, "None");
			}
			if(isnull(szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any furniture.");
			return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_EDIT, DIALOG_STYLE_LIST, "Furniture Menu | Edit", szMiscArray, "Select", "Cancel");
		}
		case 3: { // Sell furniture.

			SetPVarInt(playerid, "SellFurniture", 1);
			SelectObject(playerid);
			return 1;
			
			/*
			new iMaxSlots = GetMaxFurnitureSlots(playerid);
			for(new i; i < iMaxSlots; ++i) {

				if(IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][i])) format(szMiscArray, sizeof(szMiscArray), "%s[%d] %s\n", szMiscArray, i, GetFurnitureName(Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][i], E_STREAMER_MODEL_ID)));
				else format(szMiscArray, sizeof(szMiscArray), "%s[%d] %s\n", szMiscArray, i, "None");
			}
			return ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_SELL, DIALOG_STYLE_LIST, "Furniture Menu | Sell", szMiscArray, "Select", "Cancel");
			*/
		}
		case 4: { // New Build Mode.

			SelectObject(playerid);
			return 1;
		}
		case 5: { // Paint

			SetPVarInt(playerid, "paint", 1);
			SelectObject(playerid);
			return 1;
		}
	}
	return 1;
}


FurnitureCatalog() {

	szMiscArray[0] = 0;
	for(new i; i < sizeof(szFurnitureCategories); ++i) {
		format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szFurnitureCategories[i]);
	}
	return szMiscArray;
}


GetFurnitureName(iModelID) {
	
	new szName[32];
	for(new i; i < MAX_CATALOG; ++i) {

		if(iModelID == arrFurnitureCatalog[i][fc_iModelID]) {

			strins(szName, arrFurnitureCatalog[i][fc_szName], 0, sizeof(szName));
			return szName;

		}
	}
	szName = "None";
	return szName;
}

GetFurniturePrice(iModelID) {
	
	for(new i; i < MAX_CATALOG; ++i) {

		if(iModelID == arrFurnitureCatalog[i][fc_iModelID]) {

			return arrFurnitureCatalog[i][fc_iPrice];
		}
	}
	return 0;
}

SellFurniture(playerid, iHouseID, iSlotID, iPrice) {

	format(szMiscArray, sizeof(szMiscArray), "You have sold the %s for $%s", GetFurnitureName(GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][iSlotID])), number_format(iPrice));
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
	DestroyFurniture(iHouseID, iSlotID);
}

GetDynamicObjectModel(iObjectID) {

	return Streamer_GetIntData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_MODEL_ID);
}

forward OnRevokeBuildPerms();
public OnRevokeBuildPerms() {

	new iRows;
	cache_get_row_count(iRows);
	if(!iRows) return 1;

	for(new row; row < iRows; ++row) {
		new value;
		cache_get_value_name_int(row, "id", value);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `HouseBuilder` = '%d' WHERE `id` = '%d'", INVALID_HOUSE_ID, value);
		mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	return 1;
}

Furniture_ResetPVars(playerid) {

	DeletePVar(playerid, "SellFurniture");
	DeletePVar(playerid, "color");
	DeletePVar(playerid, "textslot");
	DeletePVar(playerid, "PRMBLD");
	DeletePVar(playerid, "paint");
	DeletePVar(playerid, "furnfirst");
	DeletePVar(playerid, "PX");
	DeletePVar(playerid, "PY");
	DeletePVar(playerid, "PZ");
}

FurniturePermit(playerid) {

	ShowPlayerDialogEx(playerid, DIALOG_PERMITBUILDER, DIALOG_STYLE_INPUT, "Furniture | Permit Builder", "Enter the ID or name of the person you would like to permit to build in your house.", "Select", "Cancel");

}

stock LoadFurniture() {

	mysql_tquery(MainPipeline, "SELECT * FROM `furniture`", "OnLoadFurniture", "");
}

forward OnLoadFurniture();
public OnLoadFurniture() {

	new iRows, iCount, value, Float:fValue;
	cache_get_row_count(iRows);

	for(iCount = 0; iCount < iRows; ++iCount) {

		ProcessFurniture(
			cache_get_value_name_int(iCount, "houseid", value),
			cache_get_value_name_int(iCount, "slotid", value), 
			cache_get_value_name_int(iCount, "modelid", value),
			cache_get_value_name_float(iCount, "x", fValue), 
			cache_get_value_name_float(iCount, "y", fValue),
			cache_get_value_name_float(iCount, "z", fValue),
			cache_get_value_name_float(iCount, "rx", fValue), 
			cache_get_value_name_float(iCount, "ry", fValue),
			cache_get_value_name_float(iCount, "rz", fValue),
			cache_get_value_name_int(iCount, "text0", value),
			cache_get_value_name_int(iCount, "text1", value),
			cache_get_value_name_int(iCount, "text2", value),
			cache_get_value_name_int(iCount, "text3", value),
			cache_get_value_name_int(iCount, "text4", value),
			cache_get_value_name_int(iCount, "col0", value),
			cache_get_value_name_int(iCount, "col1", value),
			cache_get_value_name_int(iCount, "col2", value),
			cache_get_value_name_int(iCount, "col3", value),
			cache_get_value_name_int(iCount, "col4", value));
	}
	//return printf("[Furniture] Loaded %d pieces of furniture from the database.", iCount);
	return 1;
}

forward OnRehashHouseFurniture(iHouseID);
public OnRehashHouseFurniture(iHouseID) {

	new iRows;
	cache_get_row_count(iRows);
	if(!iRows) return 1;

	new iCount, value, Float:fValue;
	for(iCount = 0; iCount < iRows; ++iCount) {

		ProcessFurniture(
			iHouseID,
			cache_get_value_name_int(iCount, "slotid", value), 
			cache_get_value_name_int(iCount, "modelid", value),
			cache_get_value_name_float(iCount, "x", fValue), 
			cache_get_value_name_float(iCount, "y", fValue),
			cache_get_value_name_float(iCount, "z", fValue),
			cache_get_value_name_float(iCount, "rx", fValue), 
			cache_get_value_name_float(iCount, "ry", fValue),
			cache_get_value_name_float(iCount, "rz", fValue),
			cache_get_value_name_int(iCount, "text0", value),
			cache_get_value_name_int(iCount, "text1", value),
			cache_get_value_name_int(iCount, "text2", value),
			cache_get_value_name_int(iCount, "text3", value),
			cache_get_value_name_int(iCount, "text4", value),
			cache_get_value_name_int(iCount, "col0", value),
			cache_get_value_name_int(iCount, "col1", value),
			cache_get_value_name_int(iCount, "col2", value),
			cache_get_value_name_int(iCount, "col3", value),
			cache_get_value_name_int(iCount, "col4", value));
	}
	return printf("[Furniture] Loaded %d pieces of furniture from the database.", iCount);
}

// Check first/last visitor
// House_VistorCheck(playerid, iHouseID, choice) {
House_VistorCheck(iHouseID) {

	if(!HouseInfo[iHouseID][hFurnitureLoaded]) {

		HouseInfo[iHouseID][hFurnitureLoaded] = 1;
		for(new o = 0; o < MAX_FURNITURE_SLOTS; o++) {
			HouseInfo[iHouseID][hFurniture][o] = -1;
		}
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `furniture` WHERE `houseid` = '%d'", iHouseID);
		mysql_tquery(MainPipeline, szMiscArray, "OnLoadFurniture", "");

		/*
		new iCount;
		foreach(new p : Player) {
			
			if(PlayerInfo[p][pVW] == HouseInfo[iHouseID][hIntVW] && IsPlayerInRangeOfPoint(p, 40, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ])) {
				if(p == playerid) continue;
				iCount++;
			}
		}
		if(!iCount) {

			switch(choice) {

				case 0: { // Enter House
					
					HouseInfo[iHouseID][hFurnitureLoaded] = 1;
					format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `furniture` WHERE `houseid` = '%d'", iHouseID);
					mysql_tquery(MainPipeline, szMiscArray, true, "OnLoadFurniture", ""); // load the furniture
				}

				
				case 1: {
					for(new i; i < MAX_FURNITURE_SLOTS; ++i) {
						if(IsValidFurniture(iHouseID, i, 1)) DestroyDynamicObject(HouseInfo[iHouseID][hFurniture][i]); // Exit House
					}
				}
			}
		}
		*/
	}
}

CreateFurniture(playerid, iHouseID, iSlotID, iModelID, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ) {

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `furniture` (`houseid`, `sqlid`, `modelid`, `slotid`, `x`,`y`,`z`, `rx`, `ry`, `rz`) \
		VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%f','%f')", iHouseID, PlayerInfo[playerid][pId], iModelID, iSlotID, X, Y, Z, RX, RY, RZ);
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
}

ProcessFurniture(iHouseID, iSlotID, iModelID, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ, text0 = -1, text1 = -1, text2 = -1, text3 = -1, text4 = -1, col0 = -1, col1 = -1, col2 = -1, col3 = -1, col4 = -1) {

	
	HouseInfo[iHouseID][hFurniture][iSlotID] = CreateDynamicObject(iModelID, X, Y, Z, RX, RY, RZ, HouseInfo[iHouseID][hIntVW]);
	ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 0, text0, col0, 0);
	ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 1, text1, col1, 0);
	ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 2, text2, col2, 0);
	ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 3, text3, col3, 0);
	ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 4, text4, col4, 0);
	if(IsADoor(iModelID)) {

		new iLocalDoorArea = CreateDynamicSphere(X, Y, Z, 5.0, HouseInfo[iHouseID][hIntVW]),
			szData[3];

		szData[0] = iHouseID;
		szData[1] = HouseInfo[iHouseID][hFurniture][iSlotID];
		szData[2] = 0;
		Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
	}
	Streamer_SetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][iSlotID], E_STREAMER_EXTRA_ID, iHouseID);
	return 1;
}

IsADoor(iModelID) {
	switch(iModelID) {
		case 1491, 1502, 1492, 1493, 1495, 1500, 1501, 1496, 1497, 1504, 1505, 1506, 1507, 1523, 1536, 1535, 1557, 19302, 19304, 18756, 11714, 3440, 3533, 19943, 1616, 1622: return 1;
	}
	return 0;
}

ProcessFurnitureTexture(iHouseID, iSlotID, iObjectID, materialindex, input, color = 0, sql = 0) {

	if(sql) {

		if(color == 0) {

			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `text%d` = '%d' \
				WHERE `houseid` = '%d' AND `slotid` = '%d'", materialindex, input, iHouseID, iSlotID);
		}
		else {
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `col%d` = '%d' \
				WHERE `houseid` = '%d' AND `slotid` = '%d'", materialindex, color, iHouseID, iSlotID);
		}
		mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	if(input > 0) SetDynamicObjectMaterial(iObjectID, materialindex, arrTextures[input][text_TModel], arrTextures[input][text_TXDName], arrTextures[input][text_TextureName], color);
	else if(input == 0) { // Coloring objects.
		
		new iTmpModel,
			szTXDName[32],
			szTextureName[32],
			iTmpColor;

		GetDynamicObjectMaterial(iObjectID, materialindex, iTmpModel, szTXDName, szTextureName, iTmpColor, 32, 32);
		SetDynamicObjectMaterial(iObjectID, materialindex, iTmpModel, szTXDName, szTextureName, color);
	}
	return 1;
}

ReloadFurniture(playerid) {

	new iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING),
		iModelID = Streamer_GetIntData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_MODEL_ID),
		iSlotID = GetPVarInt(playerid, PVAR_FURNITURE_SLOT),
		iHouseID = GetHouseID(playerid),
		iLocalDoorArea;

	new Float:fPos[6];
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_X, fPos[0]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_Y, fPos[1]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_Z, fPos[2]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_R_X, fPos[3]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_R_Y, fPos[4]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_R_Z, fPos[5]);

	iLocalDoorArea = Streamer_GetIntData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_EXTRA_ID);

	DestroyDynamicObject(iObjectID);
	HouseInfo[iHouseID][hFurniture][iSlotID] = CreateDynamicObject(iModelID, fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5], HouseInfo[iHouseID][hIntVW]);

	if(IsADoor(iModelID)) {

		new szData[3];
		if(IsValidDynamicArea(iLocalDoorArea)) DestroyDynamicArea(iLocalDoorArea);
		iLocalDoorArea = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 5.0, HouseInfo[iHouseID][hIntVW]),

		szData[1] = HouseInfo[iHouseID][hFurniture][iSlotID];
		szData[2] = 0;
		Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
	}
	Streamer_SetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][iSlotID], E_STREAMER_EXTRA_ID, iHouseID);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `text0` = '-1', `text1` = '-1', `text2` = '-1', `text3` = '-1', \
			`col0` = '0', `col1` = '0', `col2` = '0', `col3` = '0', `col4` = '0' WHERE `houseid` = '%d' AND `slotid` = '%d'", iHouseID, iSlotID);
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

DestroyFurniture(iHouseID, iSlotID) {

	if(IsValidFurniture(iHouseID, iSlotID, 1)) {
		DestroyDynamicObject(HouseInfo[iHouseID][hFurniture][iSlotID]);
		HouseInfo[iHouseID][hFurniture][iSlotID] = -1;
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `furniture` WHERE `houseid` = '%d' AND `slotid` = '%d'", iHouseID, iSlotID);
		mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
}

FurniturePlayerTDInit(playerid) {

	Furniture_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 551.000000, 354.000000, "Skin");
	PlayerTextDrawBackgroundColor(playerid, Furniture_PTD[playerid][0], 0);
	PlayerTextDrawFont(playerid, Furniture_PTD[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, Furniture_PTD[playerid][0], 0.169999, 1.200000);
	PlayerTextDrawColor(playerid, Furniture_PTD[playerid][0], -1);
	PlayerTextDrawSetOutline(playerid, Furniture_PTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, Furniture_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, Furniture_PTD[playerid][0], 2);
	PlayerTextDrawUseBox(playerid, Furniture_PTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, Furniture_PTD[playerid][0], 0x00000000);
	PlayerTextDrawTextSize(playerid, Furniture_PTD[playerid][0], 80.000000, 74.000000);
	PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][0], 93);
	PlayerTextDrawSetPreviewRot(playerid, Furniture_PTD[playerid][0], 345.000000, 0.000000, 320.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Furniture_PTD[playerid][0], 0);

	Furniture_PTD[playerid][1] = CreatePlayerTextDraw(playerid,495.000000, 173.000000, "Model");
	PlayerTextDrawBackgroundColor(playerid, Furniture_PTD[playerid][1], 0);
	PlayerTextDrawFont(playerid, Furniture_PTD[playerid][1], 5);
 	PlayerTextDrawColor(playerid, Furniture_PTD[playerid][1], -1);
	PlayerTextDrawSetOutline(playerid, Furniture_PTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, Furniture_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, Furniture_PTD[playerid][1], 0);
	PlayerTextDrawUseBox(playerid, Furniture_PTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, Furniture_PTD[playerid][1], 0x00000000);
	PlayerTextDrawTextSize(playerid, Furniture_PTD[playerid][1], 109.000000, 97.000000);
	PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][1], 0);
	PlayerTextDrawSetPreviewRot(playerid,  Furniture_PTD[playerid][1], -16.000000, 0.000000, -55.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Furniture_PTD[playerid][1], 0);

	Furniture_PTD[playerid][2] = CreatePlayerTextDraw(playerid,627.000000, 287.000000, "Slot: 1");
	PlayerTextDrawAlignment(playerid, Furniture_PTD[playerid][2], 3);
	PlayerTextDrawBackgroundColor(playerid, Furniture_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, Furniture_PTD[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, Furniture_PTD[playerid][2], 0.230000, 1.000000);
	PlayerTextDrawColor(playerid, Furniture_PTD[playerid][2], -1);
	PlayerTextDrawSetOutline(playerid, Furniture_PTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, Furniture_PTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, Furniture_PTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, Furniture_PTD[playerid][2], 0);

	Furniture_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 628.000000, 299.000000, "Name:");
	PlayerTextDrawAlignment(playerid, Furniture_PTD[playerid][3], 3);
	PlayerTextDrawBackgroundColor(playerid, Furniture_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, Furniture_PTD[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, Furniture_PTD[playerid][3], 0.230000, 1.000000);
	PlayerTextDrawColor(playerid, Furniture_PTD[playerid][3], -1);
	PlayerTextDrawSetOutline(playerid, Furniture_PTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, Furniture_PTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, Furniture_PTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, Furniture_PTD[playerid][3], 0);

}

FurnitureTDInit() {

	// Create the textdraws:
	Furniture_TD[0] = TextDrawCreate(555.000000, 356.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[0], 255);
	TextDrawFont(Furniture_TD[0], 4);
	TextDrawLetterSize(Furniture_TD[0], 0.209999, 1.200000);
	TextDrawColor(Furniture_TD[0], 9961471);
	TextDrawSetOutline(Furniture_TD[0], 0);
	TextDrawSetProportional(Furniture_TD[0], 1);
	TextDrawSetShadow(Furniture_TD[0], 1);
	TextDrawUseBox(Furniture_TD[0], 1);
	TextDrawBoxColor(Furniture_TD[0], 255);
	TextDrawTextSize(Furniture_TD[0], 74.000000, 73.000000);
	TextDrawSetSelectable(Furniture_TD[0], 0);

	Furniture_TD[1] = TextDrawCreate(572.000000, 322.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[1], 0);
	TextDrawFont(Furniture_TD[1], 4);
	TextDrawLetterSize(Furniture_TD[1], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[1], -926365636);
	TextDrawSetOutline(Furniture_TD[1], 0);
	TextDrawSetProportional(Furniture_TD[1], 1);
	TextDrawSetShadow(Furniture_TD[1], 2);
	TextDrawUseBox(Furniture_TD[1], 1);
	TextDrawBoxColor(Furniture_TD[1], 336860200);
	TextDrawTextSize(Furniture_TD[1], 32.000000, 36.000000);
	TextDrawSetSelectable(Furniture_TD[1], 0);

	Furniture_TD[2] = TextDrawCreate(559.000000, 359.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[2], 255);
	TextDrawFont(Furniture_TD[2], 4);
	TextDrawLetterSize(Furniture_TD[2], 0.209999, 1.200000);
	TextDrawColor(Furniture_TD[2], -1);
	TextDrawSetOutline(Furniture_TD[2], 0);
	TextDrawSetProportional(Furniture_TD[2], 1);
	TextDrawSetShadow(Furniture_TD[2], 1);
	TextDrawUseBox(Furniture_TD[2], 1);
	TextDrawBoxColor(Furniture_TD[2], 255);
	TextDrawTextSize(Furniture_TD[2], 67.000000, 66.000000);
	TextDrawSetSelectable(Furniture_TD[2], 0);

	Furniture_TD[3] = TextDrawCreate(571.000000, 421.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[3], 255);
	TextDrawFont(Furniture_TD[3], 4);
	TextDrawLetterSize(Furniture_TD[3], 0.209999, 1.200000);
	TextDrawColor(Furniture_TD[3], 1010580500);
	TextDrawSetOutline(Furniture_TD[3], 0);
	TextDrawSetProportional(Furniture_TD[3], 1);
	TextDrawSetShadow(Furniture_TD[3], 1);
	TextDrawUseBox(Furniture_TD[3], 1);
	TextDrawBoxColor(Furniture_TD[3], 255);
	TextDrawTextSize(Furniture_TD[3], 44.000000, -13.000000);
	TextDrawSetSelectable(Furniture_TD[3], 1);

	Furniture_TD[4] = TextDrawCreate(525.000000, 368.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[4], 0);
	TextDrawFont(Furniture_TD[4], 4);
	TextDrawLetterSize(Furniture_TD[4], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[4], -926365636);
	TextDrawSetOutline(Furniture_TD[4], 0);
	TextDrawSetProportional(Furniture_TD[4], 1);
	TextDrawSetShadow(Furniture_TD[4], 2);
	TextDrawUseBox(Furniture_TD[4], 1);
	TextDrawBoxColor(Furniture_TD[4], 336860200);
	TextDrawTextSize(Furniture_TD[4], 32.000000, 36.000000);
	TextDrawSetSelectable(Furniture_TD[4], 1);

	Furniture_TD[5] = TextDrawCreate(603.000000, 329.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[5], 0);
	TextDrawFont(Furniture_TD[5], 4);
	TextDrawLetterSize(Furniture_TD[5], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[5], -926365636);
	TextDrawSetOutline(Furniture_TD[5], 0);
	TextDrawSetProportional(Furniture_TD[5], 1);
	TextDrawSetShadow(Furniture_TD[5], 2);
	TextDrawUseBox(Furniture_TD[5], 1);
	TextDrawBoxColor(Furniture_TD[5], 336860200);
	TextDrawTextSize(Furniture_TD[5], 32.000000, 36.000000);
	TextDrawSetSelectable(Furniture_TD[5], 1);

	Furniture_TD[6] = TextDrawCreate(542.000000, 335.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[6], 0);
	TextDrawFont(Furniture_TD[6], 4);
	TextDrawLetterSize(Furniture_TD[6], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[6], -926365636);
	TextDrawSetOutline(Furniture_TD[6], 0);
	TextDrawSetProportional(Furniture_TD[6], 1);
	TextDrawSetShadow(Furniture_TD[6], 2);
	TextDrawUseBox(Furniture_TD[6], 1);
	TextDrawBoxColor(Furniture_TD[6], 336860200);
	TextDrawTextSize(Furniture_TD[6], 32.000000, 36.000000);
	TextDrawSetSelectable(Furniture_TD[6], 1);

	Furniture_TD[7] = TextDrawCreate(528.000000, 339.000000, "Building mode");
	TextDrawBackgroundColor(Furniture_TD[7], 0);
	TextDrawFont(Furniture_TD[7], 5);
	TextDrawLetterSize(Furniture_TD[7], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[7], -1);
	TextDrawSetOutline(Furniture_TD[7], 0);
	TextDrawSetProportional(Furniture_TD[7], 1);
	TextDrawSetShadow(Furniture_TD[7], 2);
	TextDrawUseBox(Furniture_TD[7], 1);
	TextDrawBoxColor(Furniture_TD[7], 0);
	TextDrawTextSize(Furniture_TD[7], 66.000000, 31.000000);
	TextDrawSetPreviewModel(Furniture_TD[7], 18635);
	TextDrawSetPreviewRot(Furniture_TD[7], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[7], 1);

	
	Furniture_TD[8] = TextDrawCreate(515.000000, 372.000000, "Sell Mode");
	TextDrawBackgroundColor(Furniture_TD[8], 0);
	TextDrawFont(Furniture_TD[8], 5);
	TextDrawLetterSize(Furniture_TD[8], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[8], -1);
	TextDrawSetOutline(Furniture_TD[8], 0);
	TextDrawSetProportional(Furniture_TD[8], 1);
	TextDrawSetShadow(Furniture_TD[8], 2);
	TextDrawUseBox(Furniture_TD[8], 1);
	TextDrawBoxColor(Furniture_TD[8], 0);
	TextDrawTextSize(Furniture_TD[8], 53.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[8], 1274);
	TextDrawSetPreviewRot(Furniture_TD[8], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[8], 1);

	Furniture_TD[9] = TextDrawCreate(570.000000, 324.000000, "Buy Mode");
	TextDrawBackgroundColor(Furniture_TD[9], 0);
	TextDrawFont(Furniture_TD[9], 5);
	TextDrawLetterSize(Furniture_TD[9], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[9], -1);
	TextDrawSetOutline(Furniture_TD[9], 0);
	TextDrawSetProportional(Furniture_TD[9], 1);
	TextDrawSetShadow(Furniture_TD[9], 2);
	TextDrawUseBox(Furniture_TD[9], 1);
	TextDrawBoxColor(Furniture_TD[9], 0);
	TextDrawTextSize(Furniture_TD[9], 37.000000, 33.000000);
	TextDrawSetPreviewModel(Furniture_TD[9], 1272);
	TextDrawSetPreviewRot(Furniture_TD[9], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[9], 1);

	Furniture_TD[10] = TextDrawCreate(602.000000, 332.000000, "Permit Builder");
	TextDrawBackgroundColor(Furniture_TD[10], 0);
	TextDrawFont(Furniture_TD[10], 5);
	TextDrawLetterSize(Furniture_TD[10], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[10], -1);
	TextDrawSetOutline(Furniture_TD[10], 0);
	TextDrawSetProportional(Furniture_TD[10], 1);
	TextDrawSetShadow(Furniture_TD[10], 2);
	TextDrawUseBox(Furniture_TD[10], 1);
	TextDrawBoxColor(Furniture_TD[10], 0);
	TextDrawTextSize(Furniture_TD[10], 32.000000, 30.000000);
	TextDrawSetPreviewModel(Furniture_TD[10], 1314);
	TextDrawSetPreviewRot(Furniture_TD[10], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[10], 1);

	Furniture_TD[11] = TextDrawCreate(603.000000, 424.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[11], 0);
	TextDrawFont(Furniture_TD[11], 4);
	TextDrawLetterSize(Furniture_TD[11], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[11], -926365636);
	TextDrawSetOutline(Furniture_TD[11], 0);
	TextDrawSetProportional(Furniture_TD[11], 1);
	TextDrawSetShadow(Furniture_TD[11], 2);
	TextDrawUseBox(Furniture_TD[11], 1);
	TextDrawBoxColor(Furniture_TD[11], 336860200);
	TextDrawTextSize(Furniture_TD[11], 13.000000, 14.000000);
	TextDrawSetSelectable(Furniture_TD[11], 1);

	Furniture_TD[12] = TextDrawCreate(617.000000, 413.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[12], 0);
	TextDrawFont(Furniture_TD[12], 4);
	TextDrawLetterSize(Furniture_TD[12], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[12], -926365636);
	TextDrawSetOutline(Furniture_TD[12], 0);
	TextDrawSetProportional(Furniture_TD[12], 1);
	TextDrawSetShadow(Furniture_TD[12], 2);
	TextDrawUseBox(Furniture_TD[12], 1);
	TextDrawBoxColor(Furniture_TD[12], 336860200);
	TextDrawTextSize(Furniture_TD[12], 13.000000, 14.000000);
	TextDrawSetSelectable(Furniture_TD[12], 1);

	Furniture_TD[13] = TextDrawCreate(618.000000, 414.000000, "LD_CHAT:thumbdn");
	TextDrawBackgroundColor(Furniture_TD[13], 0);
	TextDrawFont(Furniture_TD[13], 4);
	TextDrawLetterSize(Furniture_TD[13], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[13], -926365636);
	TextDrawSetOutline(Furniture_TD[13], 0);
	TextDrawSetProportional(Furniture_TD[13], 1);
	TextDrawSetShadow(Furniture_TD[13], 2);
	TextDrawUseBox(Furniture_TD[13], 1);
	TextDrawBoxColor(Furniture_TD[13], 336860200);
	TextDrawTextSize(Furniture_TD[13], 12.000000, 12.000000);
	TextDrawSetSelectable(Furniture_TD[13], 1);

	Furniture_TD[14] = TextDrawCreate(604.000000, 425.000000, "Info");
	TextDrawBackgroundColor(Furniture_TD[14], 0);
	TextDrawFont(Furniture_TD[14], 5);
	TextDrawLetterSize(Furniture_TD[14], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[14], -926365636);
	TextDrawSetOutline(Furniture_TD[14], 0);
	TextDrawSetProportional(Furniture_TD[14], 1);
	TextDrawSetShadow(Furniture_TD[14], 0);
	TextDrawUseBox(Furniture_TD[14], 1);
	TextDrawBoxColor(Furniture_TD[14], 336860200);
	TextDrawTextSize(Furniture_TD[14], 12.000000, 12.000000);
	TextDrawSetPreviewModel(Furniture_TD[14], 1239);
	TextDrawSetPreviewRot(Furniture_TD[14], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[14], 1);

	Furniture_TD[15] = TextDrawCreate(624.000000, 367.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[15], 0);
	TextDrawFont(Furniture_TD[15], 4);
	TextDrawLetterSize(Furniture_TD[15], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[15], -926365636);
	TextDrawSetOutline(Furniture_TD[15], 0);
	TextDrawSetProportional(Furniture_TD[15], 1);
	TextDrawSetShadow(Furniture_TD[15], 2);
	TextDrawUseBox(Furniture_TD[15], 1);
	TextDrawBoxColor(Furniture_TD[15], 336860200);
	TextDrawTextSize(Furniture_TD[15], 13.000000, 14.000000);
	TextDrawSetSelectable(Furniture_TD[15], 1);

	Furniture_TD[16] = TextDrawCreate(625.000000, 367.000000, "LD_CHAT:badchat");
	TextDrawBackgroundColor(Furniture_TD[16], 0);
	TextDrawFont(Furniture_TD[16], 4);
	TextDrawLetterSize(Furniture_TD[16], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[16], -926365636);
	TextDrawSetOutline(Furniture_TD[16], 0);
	TextDrawSetProportional(Furniture_TD[16], 1);
	TextDrawSetShadow(Furniture_TD[16], 2);
	TextDrawUseBox(Furniture_TD[16], 1);
	TextDrawBoxColor(Furniture_TD[16], 336860200);
	TextDrawTextSize(Furniture_TD[16], 12.000000, 12.000000);
	TextDrawSetSelectable(Furniture_TD[16], 1);

	Furniture_TD[17] = TextDrawCreate(543.000000, 404.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[17], 0);
	TextDrawFont(Furniture_TD[17], 4);
	TextDrawLetterSize(Furniture_TD[17], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[17], -926365636);
	TextDrawSetOutline(Furniture_TD[17], 0);
	TextDrawSetProportional(Furniture_TD[17], 1);
	TextDrawSetShadow(Furniture_TD[17], 2);
	TextDrawUseBox(Furniture_TD[17], 1);
	TextDrawBoxColor(Furniture_TD[17], 336860200);
	TextDrawTextSize(Furniture_TD[17], 20.000000, 21.000000);
	TextDrawSetPreviewModel(Furniture_TD[17], 18635);
	TextDrawSetPreviewRot(Furniture_TD[17], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[17], 1);

	Furniture_TD[18] = TextDrawCreate(542.000000, 404.000000, "House Icon 2");
	TextDrawBackgroundColor(Furniture_TD[18], 0);
	TextDrawFont(Furniture_TD[18], 5);
	TextDrawLetterSize(Furniture_TD[18], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[18], -1);
	TextDrawSetOutline(Furniture_TD[18], 1);
	TextDrawSetProportional(Furniture_TD[18], 1);
	TextDrawUseBox(Furniture_TD[18], 1);
	TextDrawBoxColor(Furniture_TD[18], 0);
	TextDrawTextSize(Furniture_TD[18], 22.000000, 21.000000);
	TextDrawSetPreviewModel(Furniture_TD[18], 1273);
	TextDrawSetPreviewRot(Furniture_TD[18], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[18], 1);


	Furniture_TD[19] = TextDrawCreate(542.000000, 310.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[19], 0);
	TextDrawFont(Furniture_TD[19], 4);
	TextDrawLetterSize(Furniture_TD[19], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[19], -926365636);
	TextDrawSetOutline(Furniture_TD[19], 0);
	TextDrawSetProportional(Furniture_TD[19], 1);
	TextDrawSetShadow(Furniture_TD[19], 2);
	TextDrawUseBox(Furniture_TD[19], 1);
	TextDrawBoxColor(Furniture_TD[19], 336860200);
	TextDrawTextSize(Furniture_TD[19], 25.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[19], 18635);
	TextDrawSetPreviewRot(Furniture_TD[19], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[19], 1);

	Furniture_TD[20] = TextDrawCreate(519.000000, 333.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[20], 0);
	TextDrawFont(Furniture_TD[20], 4);
	TextDrawLetterSize(Furniture_TD[20], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[20], -926365636);
	TextDrawSetOutline(Furniture_TD[20], 0);
	TextDrawSetProportional(Furniture_TD[20], 1);
	TextDrawSetShadow(Furniture_TD[20], 2);
	TextDrawUseBox(Furniture_TD[20], 1);
	TextDrawBoxColor(Furniture_TD[20], 336860200);
	TextDrawTextSize(Furniture_TD[20], 25.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[20], 18635);
	TextDrawSetPreviewRot(Furniture_TD[20], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[20], 1);

	Furniture_TD[21] = TextDrawCreate(540.000000, 310.000000, "Paint");
	TextDrawBackgroundColor(Furniture_TD[21], -256);
	TextDrawFont(Furniture_TD[21], 5);
	TextDrawLetterSize(Furniture_TD[21], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[21], -922753281);
	TextDrawSetOutline(Furniture_TD[21], 0);
	TextDrawSetProportional(Furniture_TD[21], 1);
	TextDrawSetShadow(Furniture_TD[21], 0);
	TextDrawUseBox(Furniture_TD[21], 1);
	TextDrawBoxColor(Furniture_TD[21], 0);
	TextDrawTextSize(Furniture_TD[21], 29.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[21], 19468);
	TextDrawSetPreviewRot(Furniture_TD[21], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[21], 1);

	Furniture_TD[22] = TextDrawCreate(517.000000, 333.000000, "Build");
	TextDrawBackgroundColor(Furniture_TD[22], -256);
	TextDrawFont(Furniture_TD[22], 5);
	TextDrawLetterSize(Furniture_TD[22], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[22], -1);
	TextDrawSetOutline(Furniture_TD[22], 0);
	TextDrawSetProportional(Furniture_TD[22], 1);
	TextDrawSetShadow(Furniture_TD[22], 0);
	TextDrawUseBox(Furniture_TD[22], 1);
	TextDrawBoxColor(Furniture_TD[22], 0);
	TextDrawTextSize(Furniture_TD[22], 29.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[22], 3096);
	TextDrawSetPreviewRot(Furniture_TD[22], 0.000000, 45.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[22], 1);

	Furniture_TD[23] = TextDrawCreate(523.000000, 426.000000, "Building Mode");
	TextDrawAlignment(Furniture_TD[23], 2);
	TextDrawBackgroundColor(Furniture_TD[23], 255);
	TextDrawFont(Furniture_TD[23], 2);
	TextDrawLetterSize(Furniture_TD[23], 0.250000, 1.000000);
	TextDrawColor(Furniture_TD[23], -1);
	TextDrawSetOutline(Furniture_TD[23], 0);
	TextDrawSetProportional(Furniture_TD[23], 1);
	TextDrawSetShadow(Furniture_TD[23], 1);
	TextDrawSetSelectable(Furniture_TD[23], 1);

	Furniture_TD[24] = TextDrawCreate(448.000000, 437.000000, "Use the CROUCH & SPRINT key to move the object to you.");
	TextDrawAlignment(Furniture_TD[24], 2);
	TextDrawBackgroundColor(Furniture_TD[24], 255);
	TextDrawFont(Furniture_TD[24], 2);
	TextDrawLetterSize(Furniture_TD[24], 0.150000, 1.000000);
	TextDrawColor(Furniture_TD[24], -926355201);
	TextDrawSetOutline(Furniture_TD[24], 0);
	TextDrawSetProportional(Furniture_TD[24], 1);
	TextDrawSetShadow(Furniture_TD[24], 0);
	TextDrawSetSelectable(Furniture_TD[24], 0);

	Furniture_TD[25] = TextDrawCreate(490.000000, 168.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[25], 255);
	TextDrawFont(Furniture_TD[25], 4);
	TextDrawLetterSize(Furniture_TD[25], 0.500000, 1.000000);
	TextDrawColor(Furniture_TD[25], 9961471);
	TextDrawSetOutline(Furniture_TD[25], 0);
	TextDrawSetProportional(Furniture_TD[25], 1);
	TextDrawSetShadow(Furniture_TD[25], 1);
	TextDrawUseBox(Furniture_TD[25], 1);
	TextDrawBoxColor(Furniture_TD[25], 255);
	TextDrawTextSize(Furniture_TD[25], 122.000000, 111.000000);
	TextDrawSetSelectable(Furniture_TD[25], 0);

	Furniture_TD[26] = TextDrawCreate(495.000000, 173.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[26], 255);
	TextDrawFont(Furniture_TD[26], 4);
	TextDrawLetterSize(Furniture_TD[26], 0.500000, 1.000000);
 	TextDrawSetOutline(Furniture_TD[26], 0);
	TextDrawSetProportional(Furniture_TD[26], 1);
	TextDrawSetShadow(Furniture_TD[26], 1);
	TextDrawUseBox(Furniture_TD[26], 1);
	TextDrawBoxColor(Furniture_TD[26], 255);
	TextDrawTextSize(Furniture_TD[26], 112.000000, 101.000000);
	TextDrawSetSelectable(Furniture_TD[26], 0);

	Furniture_TD[27] = TextDrawCreate(517.000000, 240.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[27], 255);
	TextDrawFont(Furniture_TD[27], 4);
	TextDrawLetterSize(Furniture_TD[27], 0.500000, 1.000000);
	TextDrawColor(Furniture_TD[27], 20);
	TextDrawSetOutline(Furniture_TD[27], 0);
	TextDrawSetProportional(Furniture_TD[27], 1);
	TextDrawSetShadow(Furniture_TD[27], 1);
	TextDrawUseBox(Furniture_TD[27], 1);
	TextDrawBoxColor(Furniture_TD[27], 255);
	TextDrawTextSize(Furniture_TD[27], 66.000000, 32.000000);
	TextDrawSetSelectable(Furniture_TD[27], 0);

	Furniture_TD[28] = TextDrawCreate(544.000000, 439.000000, "Furniture System - by Jingles");
	TextDrawBackgroundColor(Furniture_TD[28], 255);
	TextDrawFont(Furniture_TD[28], 2);
	TextDrawLetterSize(Furniture_TD[28], 0.139999, 0.899999);
	TextDrawColor(Furniture_TD[28], -156);
	TextDrawSetOutline(Furniture_TD[28], 0);
	TextDrawSetProportional(Furniture_TD[28], 1);
	TextDrawSetShadow(Furniture_TD[28], 0);
	TextDrawSetSelectable(Furniture_TD[28], 0);
}

MakeColorMenu() {

	szMiscArray[0] = 0;
	strcat(szMiscArray, "{F0F8FF}AliceBlue\n\
		{FAEBD7}AntiqueWhite\n\
		{00FFFF}Aqua\n\
		{7FFFD4}Aquamarine\n\
		{F0FFFF}Azure\n\
		{F5F5DC}Beige\n\
		{FFE4C4}Bisque\n\
		{000000}Black\n\
		{FFEBCD}BlanchedAlmond\n\
		{0000FF}Blue\n\
		{8A2BE2}BlueViolet\n\
		{A52A2A}Brown\n\
		{DEB887}BurlyWood\n\
		{5F9EA0}CadetBlue\n\
		{7FFF00}Chartreuse\n\
		{D2691E}Chocolate\n\
		{FF7F50}Coral\n\
		{6495ED}CornflowerBlue\n\
		{FFF8DC}Cornsilk\n\
		{DC143C}Crimson\n\
		{00FFFF}Cyan\n\
		{00008B}DarkBlue\n\
		{008B8B}DarkCyan\n");

	strcat(szMiscArray, "{B8860B}DarkGoldenRod\n\
		{A9A9A9}DarkGray\n\
		{A9A9A9}DarkGrey\n\
		{006400}DarkGreen\n\
		{BDB76B}DarkKhaki\n\
		{8B008B}DarkMagenta\n\
		{556B2F}DarkOliveGreen\n\
		{FF8C00}DarkOrange\n\
		{9932CC}DarkOrchid\n\
		{8B0000}DarkRed\n\
		{E9967A}DarkSalmon\n\
		{8FBC8F}DarkSeaGreen\n\
		{483D8B}DarkSlateBlue\n\
		{2F4F4F}DarkSlateGray\n\
		{2F4F4F}DarkSlateGrey\n\
		{00CED1}DarkTurquoise\n\
		{9400D3}DarkViolet\n\
		{FF1493}DeepPink\n\
		{00BFFF}DeepSkyBlue\n\
		{696969}DimGray\n");

	strcat(szMiscArray, "{696969}DimGrey\n\
		{1E90FF}DodgerBlue\n\
		{B22222}FireBrick\n\
		{FFFAF0}FloralWhite\n\
		{228B22}ForestGreen\n\
		{FF00FF}Fuchsia\n\
		{DCDCDC}Gainsboro\n\
		{F8F8FF}GhostWhite\n\
		{FFD700}Gold\n\
		{DAA520}GoldenRod\n\
		{808080}Gray\n\
		{808080}Grey\n\
		{008000}Green\n\
		{ADFF2F}GreenYellow\n\
		{F0FFF0}HoneyDew\n\
		{FF69B4}HotPink\n\
		{CD5C5C}IndianRed\n\
		{4B0082}Indigo\n");

	strcat(szMiscArray, "{FFFFF0}Ivory\n\
		{F0E68C}Khaki\n\
		{E6E6FA}Lavender\n\
		{FFF0F5}LavenderBlush\n\
		{7CFC00}LawnGreen\n\
		{FFFACD}LemonChiffon\n\
		{ADD8E6}LightBlue\n\
		{F08080}LightCoral\n\
		{E0FFFF}LightCyan\n\
		{FAFAD2}LightGoldenRodYellow\n\
		{D3D3D3}LightGray\n\
		{D3D3D3}LightGrey\n\
		{90EE90}LightGreen\n\
		{FFB6C1}LightPink\n\
		{FFA07A}LightSalmon\n\
		{20B2AA}LightSeaGreen\n");
		
	strcat(szMiscArray, "\
		{87CEFA}LightSkyBlue\n\
		{778899}LightSlateGray\n\
		{778899}LightSlateGrey\n\
		{B0C4DE}LightSteelBlue\n\
		{FFFFE0}LightYellow\n\
		{00FF00}Lime\n\
		{32CD32}LimeGreen\n\
		{FAF0E6}Linen\n\
		{7B68EE}MediumSlateBlue\n\
		{00FA9A}MediumSpringGreen\n\
		{48D1CC}MediumTurquoise\n\
		{C71585}MediumVioletRed\n\
		{191970}MidnightBlue\n\
		{F5FFFA}MintCream\n\
		{FFE4E1}MistyRose\n\
		{FFE4B5}Moccasin\n\
		{FFDEAD}NavajoWhite\n\
		{000080}Navy\n\
		{FDF5E6}OldLace\n", 0);

	strcat(szMiscArray, "{808000}Olive\n\
		{6B8E23}OliveDrab\n\
		{FFA500}Orange\n\
		{FF4500}OrangeRed\n\
		{DA70D6}Orchid\n\
		{EEE8AA}PaleGoldenRod\n\
		{98FB98}PaleGreen\n\
		{AFEEEE}PaleTurquoise\n\
		{DB7093}PaleVioletRed\n\
		{FFEFD5}PapayaWhip\n\
		{FFDAB9}PeachPuff\n\
		{CD853F}Peru\n\
		{FFC0CB}Pink\n\
		{DDA0DD}Plum\n\
		{B0E0E6}PowderBlue\n\
		{800080}Purple\n\
		{663399}RebeccaPurple\n\
		{FF0000}Red\n");

	strcat(szMiscArray, "{BC8F8F}RosyBrown\n\
		{4169E1}RoyalBlue\n\
		{8B4513}SaddleBrown\n\
		{FA8072}Salmon\n\
		{F4A460}SandyBrown\n\
		{2E8B57}SeaGreen\n\
		{FFF5EE}SeaShell\n\
		{A0522D}Sienna\n\
		{C0C0C0}Silver\n\
		{87CEEB}SkyBlue\n\
		{6A5ACD}SlateBlue\n\
		{708090}SlateGray\n\
		{708090}SlateGrey\n\
		{FFFAFA}Snow\n\
		{00FF7F}SpringGreen\n\
		{4682B4}SteelBlue\n\
		{D2B48C}Tan\n\
		{008080}Teal\n\
		{D8BFD8}Thistle\n");

	strcat(szMiscArray, "{FF6347}Tomato\n\
		{40E0D0}Turquoise\n\
		{EE82EE}Violet\n\
		{F5DEB3}Wheat\n\
		{FFFFFF}White\n\
		{F5F5F5}WhiteSmoke\n\
		{FFFF00}Yellow\n\
		{9ACD32}YellowGreen");
	return szMiscArray;
}

GetFurnitureColorCode(id) {

	new iColorCode;
	switch(id) {

		case 0: iColorCode = 0xFFF0F8FF;
		case 1: iColorCode = 0xFFFAEBD7;
		case 2: iColorCode = 0xFF00FFFF;
		case 3: iColorCode = 0xFF7FFFD4;
		case 4: iColorCode = 0xFFF0FFFF;
		case 5: iColorCode = 0xFFF5F5DC;
		case 6: iColorCode = 0xFFFFE4C4;
		case 7: iColorCode = 0xFF000000;
		case 8: iColorCode = 0xFFFFEBCD;
		case 9: iColorCode = 0xFF0000FF;
		case 10: iColorCode = 0xFF8A2BE2;
		case 11: iColorCode = 0xFFA52A2A;
		case 12: iColorCode = 0xFFDEB887;
		case 13: iColorCode = 0xFF5F9EA0;
		case 14: iColorCode = 0xFF7FFF00;
		case 15: iColorCode = 0xFFD2691E;
		case 16: iColorCode = 0xFFFF7F50;
		case 17: iColorCode = 0xFF6495ED;
		case 18: iColorCode = 0xFFFFF8DC;
		case 19: iColorCode = 0xFFDC143C;
		case 20: iColorCode = 0xFF00FFFF;
		case 21: iColorCode = 0xFF00008B;
		case 22: iColorCode = 0xFF008B8B;
		case 23: iColorCode = 0xFFB8860B;
		case 24: iColorCode = 0xFFA9A9A9;
		case 25: iColorCode = 0xFFA9A9A9;
		case 26: iColorCode = 0xFF006400;
		case 27: iColorCode = 0xFFBDB76B;
		case 28: iColorCode = 0xFF8B008B;
		case 29: iColorCode = 0xFF556B2F;
		case 30: iColorCode = 0xFFFF8C00;
		case 31: iColorCode = 0xFF9932CC;
		case 32: iColorCode = 0xFF8B0000;
		case 33: iColorCode = 0xFFE9967A;
		case 34: iColorCode = 0xFF8FBC8F;
		case 35: iColorCode = 0xFF483D8B;
		case 36: iColorCode = 0xFF2F4F4F;
		case 37: iColorCode = 0xFF2F4F4F;
		case 38: iColorCode = 0xFF00CED1;
		case 39: iColorCode = 0xFF9400D3;
		case 40: iColorCode = 0xFFFF1493;
		case 41: iColorCode = 0xFF00BFFF;
		case 42: iColorCode = 0xFF696969;
		case 43: iColorCode = 0xFF696969;
		case 44: iColorCode = 0xFF1E90FF;
		case 45: iColorCode = 0xFFB22222;
		case 46: iColorCode = 0xFFFFFAF0;
		case 47: iColorCode = 0xFF228B22;
		case 48: iColorCode = 0xFFFF00FF;
		case 49: iColorCode = 0xFFDCDCDC;
		case 50: iColorCode = 0xFFF8F8FF;
		case 51: iColorCode = 0xFFFFD700;
		case 52: iColorCode = 0xFFDAA520;
		case 53: iColorCode = 0xFF808080;
		case 54: iColorCode = 0xFF808080;
		case 55: iColorCode = 0xFF008000;
		case 56: iColorCode = 0xFFADFF2F;
		case 57: iColorCode = 0xFFF0FFF0;
		case 58: iColorCode = 0xFFFF69B4;
		case 59: iColorCode = 0xFFCD5C5C;
		case 60: iColorCode = 0xFF4B0082;
		case 61: iColorCode = 0xFFFFFFF0;
		case 62: iColorCode = 0xFFF0E68C;
		case 63: iColorCode = 0xFFE6E6FA;
		case 64: iColorCode = 0xFFFFF0F5;
		case 65: iColorCode = 0xFF7CFC00;
		case 66: iColorCode = 0xFFFFFACD;
		case 67: iColorCode = 0xFFADD8E6;
		case 68: iColorCode = 0xFFF08080;
		case 69: iColorCode = 0xFFE0FFFF;
		case 70: iColorCode = 0xFFFAFAD2;
		case 71: iColorCode = 0xFFD3D3D3;
		case 72: iColorCode = 0xFFD3D3D3;
		case 73: iColorCode = 0xFF90EE90;
		case 74: iColorCode = 0xFFFFB6C1;
		case 75: iColorCode = 0xFFFFA07A;
		case 76: iColorCode = 0xFF20B2AA;
		case 77: iColorCode = 0xFF87CEFA;
		case 78: iColorCode = 0xFF778899;
		case 79: iColorCode = 0xFF778899;
		case 80: iColorCode = 0xFFB0C4DE;
		case 81: iColorCode = 0xFFFFFFE0;
		case 82: iColorCode = 0xFF00FF00;
		case 83: iColorCode = 0xFF32CD32;
		case 84: iColorCode = 0xFFFAF0E6;
		case 85: iColorCode = 0xFFFF00FF;
		case 86: iColorCode = 0xFF800000;
		case 87: iColorCode = 0xFF66CDAA;	
		case 88: iColorCode = 0xFF0000CD;
		case 89: iColorCode = 0xFFBA55D3;
		case 90: iColorCode = 0xFF9370DB;
		case 91: iColorCode = 0xFF3CB371;
		case 92: iColorCode = 0xFF7B68EE;	
		case 93: iColorCode = 0xFF00FA9A;	
		case 94: iColorCode = 0xFF48D1CC;	
		case 95: iColorCode = 0xFFC71585;	
		case 96: iColorCode = 0xFF191970;
		case 97: iColorCode = 0xFFF5FFFA;
		case 98: iColorCode = 0xFFFFE4E1;
		case 99: iColorCode = 0xFFFFE4B5;
		case 100: iColorCode = 0xFFFFDEAD;
		case 101: iColorCode = 0xFF000080;
		case 102: iColorCode = 0xFFFDF5E6;
		case 103: iColorCode = 0xFF808000;
		case 104: iColorCode = 0xFF6B8E23;
		case 105: iColorCode = 0xFFFFA500;
		case 106: iColorCode = 0xFFFF4500;
		case 107: iColorCode = 0xFFDA70D6;
		case 108: iColorCode = 0xFFEEE8AA;
		case 109: iColorCode = 0xFF98FB98;
		case 110: iColorCode = 0xFFAFEEEE;
		case 111: iColorCode = 0xFFDB7093;
		case 112: iColorCode = 0xFFFFEFD5;
		case 113: iColorCode = 0xFFFFDAB9;
		case 114: iColorCode = 0xFFCD853F;
		case 115: iColorCode = 0xFFFFC0CB;
		case 116: iColorCode = 0xFFDDA0DD;
		case 117: iColorCode = 0xFFB0E0E6;
		case 118: iColorCode = 0xFF800080;
		case 119: iColorCode = 0xFF663399;
		case 120: iColorCode = 0xFFFF0000;
		case 121: iColorCode = 0xFFBC8F8F;
		case 122: iColorCode = 0xFF4169E1;
		case 123: iColorCode = 0xFF8B4513;
		case 124: iColorCode = 0xFFFA8072;
		case 125: iColorCode = 0xFFF4A460;
		case 126: iColorCode = 0xFF2E8B57;
		case 127: iColorCode = 0xFFFFF5EE;
		case 128: iColorCode = 0xFFA0522D;
		case 129: iColorCode = 0xFFC0C0C0;
		case 130: iColorCode = 0xFF87CEEB;
		case 131: iColorCode = 0xFF6A5ACD;
		case 132: iColorCode = 0xFF708090;
		case 133: iColorCode = 0xFF708090;
		case 134: iColorCode = 0xFFFFFAFA;
		case 135: iColorCode = 0xFF00FF7F;
		case 136: iColorCode = 0xFF4682B4;
		case 137: iColorCode = 0xFFD2B48C;
		case 138: iColorCode = 0xFF008080;
		case 139: iColorCode = 0xFFD8BFD8;
		case 140: iColorCode = 0xFFFF6347;
		case 141: iColorCode = 0xFF40E0D0;
		case 142: iColorCode = 0xFFEE82EE;
		case 143: iColorCode = 0xFFF5DEB3;
		case 144: iColorCode = 0xFFFFFFFF;
		case 145: iColorCode = 0xFFF5F5F5;
		case 146: iColorCode = 0xFFFFFF00;
		default: iColorCode = 0xFF9ACD32;
	}
	return iColorCode;
}

CMD:furniturehelp(playerid, params[]) {

	SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture] {CCCCCC}/furniture | /myslots | /furnitureresetpos | /permitbuilder | /revokebuilders | /destroyallfurniture | {FF2222}Press ~k~~PED_LOOKBEHIND~ (twice) to toggle the mouse cursor.");
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture] {CCCCCC}/unfurnishhouse (remove default GTA:SA furniture) | /furnishhouse (add default GTA:SA furniture)");
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture] {CCCCCC}Blue House = Buy Furniture | Hammer = Build Mode (wrench = position, bucket = painting). | !-icon = Panic Button.");
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture] {CCCCCC}Dollar Icon = Sell Furniture | Green House = List of your furniture. | Red Puppets = Assign Build Permissions to Player.");
	if(IsAdminLevel(playerid, ADMIN_GENERAL, 0)) SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture] {FFFF00}/destroyfuniture | /destroyallfurniture | /rehashcatalog");
	return 1;
}

CMD:furnituresystem(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;

	if(FurnitureSystem) {
		FurnitureSystem = 0;
		format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) disabled the Furniture System", GetPlayerNameEx(playerid), playerid);
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);
	}
	else {
		FurnitureSystem = 1;
		format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) enabled the Furniture System", GetPlayerNameEx(playerid), playerid);
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);
	}
	return 1;
}

CMD:myslots(playerid, params[]) {

	format(szMiscArray, sizeof(szMiscArray), "** You have %d furniture slots you can use.", GetMaxFurnitureSlots(playerid));
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}

CMD:furniture(playerid, params[]) {

	if(!FurnitureSystem) return 1;

	if(GetPVarType(playerid, PVAR_FURNITURE)) {
			
		TextDrawHideForPlayer(playerid, Furniture_TD[0]);
		TextDrawHideForPlayer(playerid, Furniture_TD[1]);
		TextDrawHideForPlayer(playerid, Furniture_TD[2]);
		TextDrawHideForPlayer(playerid, Furniture_TD[3]);
		TextDrawHideForPlayer(playerid, Furniture_TD[4]);
		TextDrawHideForPlayer(playerid, Furniture_TD[5]);
		TextDrawHideForPlayer(playerid, Furniture_TD[6]);
		TextDrawHideForPlayer(playerid, Furniture_TD[7]);
		TextDrawHideForPlayer(playerid, Furniture_TD[8]);
		TextDrawHideForPlayer(playerid, Furniture_TD[9]);
		TextDrawHideForPlayer(playerid, Furniture_TD[10]);
		TextDrawHideForPlayer(playerid, Furniture_TD[11]);
		TextDrawHideForPlayer(playerid, Furniture_TD[12]);
		TextDrawHideForPlayer(playerid, Furniture_TD[13]);
		TextDrawHideForPlayer(playerid, Furniture_TD[14]);
		TextDrawHideForPlayer(playerid, Furniture_TD[15]);
		TextDrawHideForPlayer(playerid, Furniture_TD[16]);
		TextDrawHideForPlayer(playerid, Furniture_TD[17]);
		TextDrawHideForPlayer(playerid, Furniture_TD[18]);
		TextDrawHideForPlayer(playerid, Furniture_TD[19]);
		TextDrawHideForPlayer(playerid, Furniture_TD[20]);
		TextDrawHideForPlayer(playerid, Furniture_TD[21]);
		TextDrawHideForPlayer(playerid, Furniture_TD[22]);
		TextDrawHideForPlayer(playerid, Furniture_TD[23]);
		TextDrawHideForPlayer(playerid, Furniture_TD[24]);
		TextDrawHideForPlayer(playerid, Furniture_TD[25]);
		TextDrawHideForPlayer(playerid, Furniture_TD[26]);
		TextDrawHideForPlayer(playerid, Furniture_TD[27]);
		TextDrawHideForPlayer(playerid, Furniture_TD[28]);
		PlayerTextDrawHide(playerid, Furniture_PTD[playerid][0]);
		PlayerTextDrawHide(playerid, Furniture_PTD[playerid][1]);
		PlayerTextDrawHide(playerid, Furniture_PTD[playerid][2]);
		PlayerTextDrawHide(playerid, Furniture_PTD[playerid][3]);
		CancelSelectTextDraw(playerid);
		DeletePVar(playerid, PVAR_FURNITURE);
		DeletePVar(playerid, PVAR_INHOUSE);
		DeletePVar(playerid, PVAR_FURNITURE_SLOT);
		DeletePVar(playerid, PVAR_FURNITURE_EDITING);
		DeletePVar(playerid, PVAR_FURNITURE_BUYMODEL);
		Furniture_ResetPVars(playerid);
		Exit3DTextureMenu(playerid);
	}			
	else {
		new i = GetHouseID(playerid);
		if(i == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be in a house.");
		if(!HousePermissionCheck(playerid, i)) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have the permission to edit this house's furniture.");
		FurnitureMenu(playerid, 0);
		SetPVarInt(playerid, PVAR_INHOUSE, i);
	}
	return 1;
}

CMD:setfurnitureslots(playerid, params[]) {

	if(!FurnitureSystem) return 1;

	if(IsAdminLevel(playerid, ADMIN_HEAD, 0)) {

		new uPlayer,
			iAmount;

		if(sscanf(params, "ud", uPlayer, iAmount)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /setfurnitureslots [playerid] [slots]");
		if(!IsPlayerConnected(uPlayer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player is not online.");
		if(!(0 < iAmount < MAX_FURNITURE_SLOTS)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount.");
		
		PlayerInfo[uPlayer][pFurnitureSlots] = iAmount;

		format(szMiscArray, sizeof(szMiscArray), "Administrator %s set your furniture slots to %d.", GetPlayerNameEx(playerid), iAmount);
		SendClientMessageEx(uPlayer, COLOR_YELLOW, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "You set %s's furniture slots to %d.", GetPlayerNameEx(uPlayer), iAmount);
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "Administrator %s set %s's furniture slots to %d.", GetPlayerNameEx(playerid), GetPlayerNameEx(uPlayer), iAmount);
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);

		format(szMiscArray, sizeof(szMiscArray), "%s set %s's (%d) furniture slots to %d.", GetPlayerNameExt(playerid), GetPlayerNameExt(uPlayer), PlayerInfo[uPlayer][pId], iAmount);
		Log("logs/furniture.log", szMiscArray);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command.");
	return 1;
}

CMD:destroyallfurniture(playerid, params[]) {

	if(!FurnitureSystem) return 1;
	
	new iHouseID = GetHouseID(playerid);
	if(iHouseID == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a house.");
	if(HouseInfo[iHouseID][hOwnerID] != GetPlayerSQLId(playerid) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "Only the house owner can do this.");
	ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_DESCONFIRM, DIALOG_STYLE_MSGBOX, "Destroy Furniture", "{FFFFFF}Are you sure you want to {FF0000}permantenly destroy {FFFFFF}this house's furniture?", "Yes", "No");
	return 1;
}

CMD:unfurnishhouse(playerid, params[]) {

	if(!FurnitureSystem) return 1;
	
	new iHouseID = GetHouseID(playerid),
		Float:fHouseZ,
		fDistance;

	// if(!HousePermissionCheck(playerid, iHouseID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this in this house.");
	if(HouseInfo[iHouseID][hOwnerID] != GetPlayerSQLId(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Only the house owner can do this.");
	for(new i; i < sizeof(InteriorsList); ++i) {
		fDistance = floatround(GetDistanceBetweenPoints(HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ],
			InteriorsList[i][0], InteriorsList[i][1], InteriorsList[i][2]), floatround_round);

		if(fDistance < 40 && HouseInfo[iHouseID][hIntIW] == floatround(InteriorsList[i][3])) {
			
			fHouseZ = InteriorsList[i][2];
			break;
		}
	}

	if(fHouseZ == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This task cannot be completed for your house interior type.");

	if(HouseInfo[iHouseID][hInteriorZ] > fHouseZ + 25.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your house is already unfurnished.");
	HouseInfo[iHouseID][hInteriorZ] = fHouseZ + 30;
	HouseInfo[iHouseID][hCustomInterior] = 1;
	SaveHouse(iHouseID);

	new Float:fPos[6];
	for(new i; i < MAX_FURNITURE_SLOTS; ++i) {

		if(IsValidFurniture(iHouseID, i, 1)) {

			new iModelID = GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][i]);
			GetDynamicObjectPos(HouseInfo[iHouseID][hFurniture][i], fPos[0], fPos[1], fPos[2]);
			GetDynamicObjectRot(HouseInfo[iHouseID][hFurniture][i], fPos[3], fPos[4], fPos[5]);
			//DestroyDynamicObject(HouseInfo[iHouseID][hFurniture][i]);

			fPos[2] = fPos[2] + 30.0;
			if(IsADoor(iModelID)) {

				new iLocalDoorArea = Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][i], E_STREAMER_EXTRA_ID),
					szData[3];
				if(IsValidDynamicArea(iLocalDoorArea)) DestroyDynamicArea(iLocalDoorArea);

				iLocalDoorArea = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 5.0, HouseInfo[iHouseID][hIntVW]);
				szData[0] = iHouseID;
				szData[1] = HouseInfo[iHouseID][hFurniture][i];
				szData[2] = 0;
				Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
			}

			SetDynamicObjectPos(HouseInfo[iHouseID][hFurniture][i], fPos[0], fPos[1], fPos[2]);
			SetDynamicObjectRot(HouseInfo[iHouseID][hFurniture][i], fPos[3], fPos[4], fPos[5]);
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `z` = '%f' WHERE `houseid` = '%d' AND `slotid` = '%d'", fPos[2], iHouseID, i);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	RehashHouse(iHouseID);
	// defer RehashHouseFurniture(iHouseID);
	foreach(new p : Player) {

		if(PlayerInfo[p][pVW] == PlayerInfo[playerid][pVW] && ProxDetectorS(50, playerid, p)) {

			SendClientMessageEx(p, COLOR_GRAD1, "You will be moved to the unfurnished version of the house.");
			defer Furniture_HousePosition(p, iHouseID);
		}
	}
	return 1;
}

CMD:furnishhouse(playerid, params[]) {

	if(!FurnitureSystem) return 1;

	new iHouseID = GetHouseID(playerid),
		Float:fHouseZ,
		fDistance;

	// if(!HousePermissionCheck(playerid, iHouseID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this in this house.");
	if(HouseInfo[iHouseID][hOwnerID] != GetPlayerSQLId(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Only the house owner can do this.");
	for(new i; i < sizeof(InteriorsList); ++i) {
		fDistance = floatround(GetDistanceBetweenPoints(HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ],
			InteriorsList[i][0], InteriorsList[i][1], InteriorsList[i][2]), floatround_round);

		if(fDistance < 40 && HouseInfo[iHouseID][hIntIW] == floatround(InteriorsList[i][3])) {
			
			fHouseZ = InteriorsList[i][2];
			break;
		}
	}

	if(fHouseZ == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This task cannot be completed for your house interior type.");
	if(HouseInfo[iHouseID][hInteriorZ] < fHouseZ + 25.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your house is already furnished.");
	HouseInfo[iHouseID][hInteriorZ] = fHouseZ;
	HouseInfo[iHouseID][hCustomInterior] = 0;
	SaveHouse(iHouseID);
	
	new Float:fPos[6];
	for(new i; i < MAX_FURNITURE_SLOTS; ++i) {

		if(IsValidFurniture(iHouseID, i, 1)) {

			new iModelID = GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][i]);

			GetDynamicObjectPos(HouseInfo[iHouseID][hFurniture][i], fPos[0], fPos[1], fPos[2]);
			GetDynamicObjectRot(HouseInfo[iHouseID][hFurniture][i], fPos[3], fPos[4], fPos[5]);

			fPos[2] = fPos[2] - 30.0;
			if(IsADoor(iModelID)) {

				new iLocalDoorArea = Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][i], E_STREAMER_EXTRA_ID),
					szData[3];

				if(IsValidDynamicArea(iLocalDoorArea)) DestroyDynamicArea(iLocalDoorArea);

				iLocalDoorArea = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 5.0, HouseInfo[iHouseID][hIntVW]);
				szData[0] = iHouseID;
				szData[1] = HouseInfo[iHouseID][hFurniture][i];
				szData[2] = 0;
				Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
			}
			//HouseInfo[iHouseID][hFurniture][i] = CreateDynamicObject(iModelID, fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5], HouseInfo[iHouseID][hIntVW]);
			SetDynamicObjectPos(HouseInfo[iHouseID][hFurniture][i], fPos[0], fPos[1], fPos[2]);
			SetDynamicObjectRot(HouseInfo[iHouseID][hFurniture][i], fPos[3], fPos[4], fPos[5]);
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `z` = '%f' WHERE `houseid` = '%d' AND `slotid` = '%d'", fPos[2], iHouseID, i);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	RehashHouse(iHouseID);
	foreach(new p : Player) {

		if(PlayerInfo[p][pVW] == PlayerInfo[playerid][pVW] && ProxDetectorS(50, playerid, p)) {

			SendClientMessageEx(p, COLOR_GRAD1, "You will be moved to the unfurnished version of the house.");
			defer Furniture_HousePosition(p, iHouseID);
		}
	}
	return 1;
}

forward OnEditFurniture();
public OnEditFurniture() {

	if(mysql_errno()) return SendClientMessageToAll(0, "[Furniture] Did not save.");
	return 1;
}

CMD:furnitureresetpos(playerid, params[]) {

	if(!FurnitureSystem) return 1;

	if(GetPVarType(playerid, PVAR_FURNITURE)) {

		new i = GetHouseID(playerid);
		if(i == INVALID_HOUSE_ID) {

			cmd_furniture(playerid, "");
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be in a house.");
		}

		new iHouseID = GetPVarInt(playerid, PVAR_INHOUSE);
		Player_StreamPrep(playerid, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ], FREEZE_TIME);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You can only use this when you are falling while positioning a piece of furniture.");
	return 1;
}

CMD:destroyfurniture(playerid, params[]) {

	if(!FurnitureSystem) return 1;

	new iHouseID = GetHouseID(playerid),
		iSlotID;

	if(!IsAdminLevel(playerid, ADMIN_GENERAL, 1)) return 1;
	if(iHouseID == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a house");
	if(sscanf(params, "d", iSlotID)) return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /destroyfurniture [slot].");
	if(!IsValidFurniture(iHouseID, iSlotID, 1)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid slot.");
	DestroyFurniture(iHouseID, iSlotID);
	return 1;
}

CMD:copdestroy(playerid, params[]) {

	if(!FurnitureSystem) return 1;

	new iHouseID = GetHouseID(playerid);
	if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a cop.");
	if(iHouseID == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a house");
	SetPVarInt(playerid, "copdestroyfur", 1);
	SelectObject(playerid);
	return 1;
}

CMD:revokebuilders(playerid, params[]) {

	if(!FurnitureSystem) return 1;

	new iHouseID;
	if(sscanf(params, "d", iHouseID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /revokebuilder [house (1, 2, 3)]");
	switch(iHouseID) {
		case 1: {
			if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "This house slot is not being used.");
			iHouseID = PlayerInfo[playerid][pPhousekey];
		}
		case 2: {
			if(PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "This house slot is not being used.");
			iHouseID = PlayerInfo[playerid][pPhousekey2];
		}
		case 3: {
			if(PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "This house slot is not being used.");
			iHouseID = PlayerInfo[playerid][pPhousekey3];
		}
		default: return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid house ID.");
	}

	foreach(new i : Player) if(PlayerInfo[playerid][pHouseBuilder] == iHouseID) PlayerInfo[playerid][pHouseBuilder] = INVALID_HOUSE_ID;
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `id` FROM `accounts` WHERE `HouseBuilder` = '%d'", iHouseID);
	mysql_tquery(MainPipeline, szMiscArray, "OnRevokeBuildPerms", "");
	SendClientMessageEx(playerid, COLOR_YELLOW, "All builder's permissions have been revoked.");
	return 1;
}

CMD:door(playerid, params[]) {
	
	if(GetHouseID(playerid) == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be in a house.");
	
	if(IsPlayerInAnyDynamicArea(playerid)) {

		new areaid[4],
			iObjectID,
			iState,
			Float:fPos[6],
			szData[3];

		GetPlayerDynamicAreas(playerid, areaid);
		for(new i; i < sizeof(areaid); ++i) {

			Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid[i], E_STREAMER_EXTRA_ID, szData, sizeof(szData));
			iObjectID = szData[1];
			iState = szData[2];

			if(IsValidDynamicObject(iObjectID)) {
				if(IsDynamicObjectMoving(iObjectID)) return 1;
				GetDynamicObjectPos(iObjectID, fPos[0], fPos[1], fPos[2]);
				GetDynamicObjectRot(iObjectID, fPos[3], fPos[4], fPos[5]);
				if(IsPlayerInRangeOfPoint(playerid, 5.0, fPos[0], fPos[1], fPos[2])) {
					switch(iState) {
						case 0: {
							szData[2] = 1;
							MoveDynamicObject(iObjectID, fPos[0] + 0.01, fPos[1], fPos[2], 0.03, fPos[3], fPos[4], fPos[5] + 90.0);
							Streamer_SetArrayData(STREAMER_TYPE_AREA, areaid[i], E_STREAMER_EXTRA_ID, szData, sizeof(szData));
						}
						case 1: {
							szData[2] = 0;
							MoveDynamicObject(iObjectID, fPos[0] - 0.01, fPos[1], fPos[2], 0.03, fPos[3], fPos[4], fPos[5] - 90.0);
							Streamer_SetArrayData(STREAMER_TYPE_AREA, areaid[i], E_STREAMER_EXTRA_ID, szData, sizeof(szData));
						}
					}
				}
			}
		}
	}
	return 1;
}
		
CMD:rehashcatalog(playerid, params[]) {

	if(IsAdminLevel(playerid, ADMIN_HEAD, 1)) {
		for(new i; i < MAX_CATALOG; ++i) {

			arrFurnitureCatalog[i][fc_iModelID] = 0;
			arrFurnitureCatalog[i][fc_iTypeID] = 0;
			arrFurnitureCatalog[i][fc_szName][0] = 0;
			arrFurnitureCatalog[i][fc_iPrice] = 0;
		}
		FurnitureListInit();
		SendClientMessageEx(playerid, COLOR_GRAD1, "Rehasing the furniture catalog...");
	}
	return 1;
}





// Texture Studio (by Pottus).
Create3DTextureMenu(playerid, Float:X, Float:Y, Float:Z, Float:R, tiles) {

	if(!(0 < tiles <= MAX_TILES)) return -1;
	foreach(new i : Player) {
		
	    if(TextureMenuInfo[i][textm_bExists]) continue;

     	new Float:NextX,
     		Float:NextY,
     		idx,
      		binc;

       	TextureMenuInfo[i][textm_fRot] = R;
		TextureMenuInfo[i][textm_iTiles] = tiles;
		TextureMenuInfo[i][textm_AddX] = 0.25*floatsin(R, degrees);
		TextureMenuInfo[i][textm_AddY] = -floatcos(R, degrees) * 0.25;

		NextX = floatcos(R, degrees)+0.05*floatcos(R, degrees);
		NextY = floatsin(R, degrees)+0.05*floatsin(R, degrees);

		for(new b = 0; b < tiles; b++) {

  			if(b%4 == 0 && b != 0) idx++,binc+=4;
   			TextureMenuInfo[i][textm_iObjectID][b] = CreateDynamicObject(2661, X + NextX * idx, Y + NextY * idx, Z + 1.65 - 0.55 * (b - binc), 0, 0, R, .playerid = playerid);
      		GetDynamicObjectPos(TextureMenuInfo[i][textm_iObjectID][b], TextureMenuInfo[i][textm_OrigPosX][b], TextureMenuInfo[i][textm_OrigPosY][b], TextureMenuInfo[i][textm_OrigPosZ][b]);
		}
		TextureMenuInfo[i][textm_bExists] = true;
		TextureMenuInfo[i][textm_iPlayerID] = playerid;
		Streamer_Update(playerid);
		return i;
	}
	return -1;
}

Set3DTextureMenuTile(i, tile, index, model, txd[], texture[], selectcolor, unselectcolor) {

	if(!TextureMenuInfo[i][textm_bExists]) return 0;
	if(!(0 < tile <= TextureMenuInfo[i][textm_iTiles])) return 0;
	if(!IsValidDynamicObject(TextureMenuInfo[i][textm_iObjectID][tile])) return 0;
	TextureMenuInfo[i][textm_iSelectColor][tile] = selectcolor;
	TextureMenuInfo[i][textm_iUnselectColor][tile] = unselectcolor;
	if(textm_SelectedTile[TextureMenuInfo[i][textm_iPlayerID]] == tile) SetDynamicObjectMaterial(TextureMenuInfo[i][textm_iObjectID][tile], index, model, txd, texture, selectcolor);
	else SetDynamicObjectMaterial(TextureMenuInfo[i][textm_iObjectID][tile], index, model, txd, texture, unselectcolor);
	return 1;
}

Select3DTextureMenu(playerid, i) {

	if(!TextureMenuInfo[i][textm_bExists]) return -1;
	if(TextureMenuInfo[i][textm_iPlayerID] != playerid) return -1;
	if(textm_Selected3DTextureMenu[playerid] != -1) CancelSelect3DTextureMenu(playerid);

	textm_SelectedTile[playerid] = 0;
	textm_Selected3DTextureMenu[playerid] = i;

	new model,
		txd[32],
		texture[32],
		color;

	GetDynamicObjectMaterial(TextureMenuInfo[i][textm_iObjectID][0], 0, model, txd, texture, color);
 	SetDynamicObjectMaterial(TextureMenuInfo[i][textm_iObjectID][0], 0, model, txd, texture, TextureMenuInfo[i][textm_iSelectColor][0]);
 	MoveDynamicObject(TextureMenuInfo[i][textm_iObjectID][0], TextureMenuInfo[i][textm_OrigPosX][0] + TextureMenuInfo[i][textm_AddX], TextureMenuInfo[i][textm_OrigPosY][0] + TextureMenuInfo[i][textm_AddY], TextureMenuInfo[i][textm_OrigPosZ][0], 1.0);
	return 1;
}

CancelSelect3DTextureMenu(playerid) {

	if(textm_Selected3DTextureMenu[playerid] == -1) return -1;
	new i = textm_Selected3DTextureMenu[playerid];

	new model,
		txd[32],
		texture[32],
		color;

	GetDynamicObjectMaterial(TextureMenuInfo[i][textm_iObjectID][textm_SelectedTile[playerid]], 0, model, txd, texture, color);
 	SetDynamicObjectMaterial(TextureMenuInfo[i][textm_iObjectID][textm_SelectedTile[playerid]], 0, model, txd, texture, TextureMenuInfo[i][textm_iUnselectColor][textm_SelectedTile[playerid]]);
	
	MoveDynamicObject(TextureMenuInfo[i][textm_iObjectID][textm_SelectedTile[playerid]], TextureMenuInfo[i][textm_OrigPosX][textm_SelectedTile[playerid]],
		TextureMenuInfo[i][textm_OrigPosY][textm_SelectedTile[playerid]], TextureMenuInfo[i][textm_OrigPosZ][textm_SelectedTile[playerid]], 1.0);

	textm_Selected3DTextureMenu[playerid] = -1;
	textm_SelectedTile[playerid] = -1;
	PlayerTextureMenuInfo[playerid][ptextm_Menus3D] = -1;
	return 1;
}

Destroy3DTextureMenu(i) {

    if(!TextureMenuInfo[i][textm_bExists]) return -1;
    if(textm_Selected3DTextureMenu[TextureMenuInfo[i][textm_iPlayerID]] == i) CancelSelect3DTextureMenu(TextureMenuInfo[i][textm_iPlayerID]);
    
    for(new idx = 0; idx < TextureMenuInfo[i][textm_iTiles]; idx++) {
		if(IsValidDynamicObject(TextureMenuInfo[i][textm_iObjectID][idx])) DestroyDynamicObject(TextureMenuInfo[i][textm_iObjectID][idx]);
		TextureMenuInfo[i][textm_iObjectID][idx] = INVALID_OBJECT_ID;
	}
	TextureMenuInfo[i][textm_bExists] = false;
 	TextureMenuInfo[i][textm_iTiles] = 0;
 	TextureMenuInfo[i][textm_AddX] = 0.0;
 	TextureMenuInfo[i][textm_AddY] = 0.0;
 	TextureMenuInfo[i][textm_iPlayerID] = INVALID_PLAYER_ID;
	return 1;
}

Exit3DTextureMenu(playerid) {

	PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_NONE;
	PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = 0;
	PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] = 0;
	if(PlayerTextureMenuInfo[playerid][ptextm_Menus3D] != -1) {

        Destroy3DTextureMenu(PlayerTextureMenuInfo[playerid][ptextm_Menus3D]);
        PlayerTextureMenuInfo[playerid][ptextm_Menus3D] = -1;
	}
	textm_SelectedTile[playerid] = false;
	textm_Selected3DTextureMenu[playerid] = -1;

}

Reset3DTextureMenuVars(playerid) {

	textm_Selected3DTextureMenu[playerid] = -1;
	textm_SelectedTile[playerid] = -1;

	PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_NONE;
	PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = 0;
	PlayerTextureMenuInfo[playerid][ptextm_Menus3D] = -1;
	PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] = 0;


	TextureMenuInfo[playerid][textm_fRot] = 0;
	TextureMenuInfo[playerid][textm_bExists] = false;
	TextureMenuInfo[playerid][textm_iPlayerID] = INVALID_PLAYER_ID;
}

Unload3DTextureMenu(playerid) {

	if(textm_Selected3DTextureMenu[playerid] != -1) CancelSelect3DTextureMenu(playerid);
}

OnPlayerKeyStateChange3DMenu(playerid, newkeys, oldkeys) {

	#pragma unused oldkeys
	if(textm_Selected3DTextureMenu[playerid] != -1 || PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_SELECT) {

		new MenuID = textm_Selected3DTextureMenu[playerid];

		if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_SELECT) {
			
			#define MAX_OBJECT_TEXTSLOTS 5
			new
				iTmpModel[MAX_OBJECT_TEXTSLOTS],
				szTXDName[MAX_OBJECT_TEXTSLOTS][32],
				szTextureName[MAX_OBJECT_TEXTSLOTS][32],
				iColor,
				iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING);
			
			if(newkeys == KEY_NO) { // Next

				if(textm_SelectedTile[playerid] == MAX_OBJECT_TEXTSLOTS) textm_SelectedTile[playerid] = -1; // So we start at 0.
				textm_SelectedTile[playerid]++;
				GetDynamicObjectMaterial(iObjectID, textm_SelectedTile[playerid], iTmpModel[textm_SelectedTile[playerid]], szTXDName[textm_SelectedTile[playerid]], szTextureName[textm_SelectedTile[playerid]], iColor, 32, 32);
				
				if(isnull(szTXDName[textm_SelectedTile[playerid]])) {
					SetDynamicObjectMaterial(iObjectID, textm_SelectedTile[playerid], -1, "none", "none", 0xFFFFFFFF);
				}
				else SetDynamicObjectMaterial(iObjectID, textm_SelectedTile[playerid], iTmpModel[textm_SelectedTile[playerid]], szTXDName[textm_SelectedTile[playerid]], szTextureName[textm_SelectedTile[playerid]], 0xFFFFFFFF);
				
				for(new iIndex = 0; iIndex < MAX_OBJECT_TEXTSLOTS; ++iIndex) {

					if(iIndex != textm_SelectedTile[playerid]) {

						GetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor, 32, 32);
						if(isnull(szTXDName[iIndex])) {
							SetDynamicObjectMaterial(iObjectID, iIndex, -1, "none", "none", 0xFF999999);
						}
						else SetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], 0xFF999999);						
					}
				}
				format(szMiscArray, sizeof(szMiscArray), "Slot: %d", textm_SelectedTile[playerid]+1);
				PlayerTextDrawSetString(playerid, Furniture_PTD[playerid][2], szMiscArray);
				PlayerTextDrawShow(playerid, Furniture_PTD[playerid][2]);
				format(szMiscArray, sizeof(szMiscArray), "Name: %s", szTextureName[textm_SelectedTile[playerid]]);
				PlayerTextDrawSetString(playerid, Furniture_PTD[playerid][3], szMiscArray);
				PlayerTextDrawShow(playerid, Furniture_PTD[playerid][3]);
				return 1;
			}
			if(newkeys == KEY_CTRL_BACK) { // Previous

				if(textm_SelectedTile[playerid] == 0) textm_SelectedTile[playerid] = MAX_OBJECT_TEXTSLOTS;
				textm_SelectedTile[playerid]--;

				GetDynamicObjectMaterial(iObjectID, textm_SelectedTile[playerid], iTmpModel[textm_SelectedTile[playerid]], szTXDName[textm_SelectedTile[playerid]], szTextureName[textm_SelectedTile[playerid]], iColor, 32, 32);
				if(isnull(szTXDName[textm_SelectedTile[playerid]])) {
					SetDynamicObjectMaterial(iObjectID, textm_SelectedTile[playerid], -1, "none", "none", 0xFFFFFFFF);
				}
				else SetDynamicObjectMaterial(iObjectID, textm_SelectedTile[playerid], iTmpModel[textm_SelectedTile[playerid]], szTXDName[textm_SelectedTile[playerid]], szTextureName[textm_SelectedTile[playerid]], 0xFFFFFFFF);

				for(new iIndex = 0; iIndex < MAX_OBJECT_TEXTSLOTS; ++iIndex) {

					if(iIndex != textm_SelectedTile[playerid]) {
						GetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor, 32, 32);
						if(isnull(szTXDName[iIndex])) {
							SetDynamicObjectMaterial(iObjectID, iIndex, -1, "none", "none", 0xFF999999);
						}
						else SetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], 0xFF999999);						
					}
				}
				format(szMiscArray, sizeof(szMiscArray), "Slot: %d", textm_SelectedTile[playerid]+1);
				PlayerTextDrawSetString(playerid, Furniture_PTD[playerid][2], szMiscArray);
				PlayerTextDrawShow(playerid, Furniture_PTD[playerid][2]);
				format(szMiscArray, sizeof(szMiscArray), "Name: %s", szTextureName[textm_SelectedTile[playerid]]);
				PlayerTextDrawSetString(playerid, Furniture_PTD[playerid][3], szMiscArray);
				PlayerTextDrawShow(playerid, Furniture_PTD[playerid][3]);
				return 1;
			}
			if(newkeys == KEY_YES) { // Accept

				SetPVarInt(playerid, "textslot", textm_SelectedTile[playerid]);
				textm_SelectedTile[playerid] = 0;
				PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_NONE;
				DeletePVar(playerid, "maxtextslots");
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][2]);
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][3]);
				for(new iIndex = 0; iIndex < MAX_OBJECT_TEXTSLOTS; ++iIndex) {

					GetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor, 32, 32);
					if(isnull(szTXDName[iIndex])) {
						SetDynamicObjectMaterial(iObjectID, iIndex, -1, "none", "none", iColor);
					}
					else SetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor);	
				}
	
				SetPVarInt(playerid, "studorfind", 1);
				ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Texturing", "Texture Studio\nSearch Texture\nColor Studio", "Select", "Cancel");
				return 1;
			}
			if(newkeys == KEY_LOOK_BEHIND) { // Cancel

				textm_SelectedTile[playerid] = 0;
				PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_NONE;
				DeletePVar(playerid, "maxtextslots");
				DeletePVar(playerid, PVAR_FURNITURE_SLOT);
				DeletePVar(playerid, PVAR_FURNITURE_EDITING);
				SendClientMessageEx(playerid, COLOR_GRAD1, "** You stopped texturizing the object.");
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][2]);
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][3]);

				for(new iIndex = 0; iIndex < MAX_OBJECT_TEXTSLOTS; ++iIndex) {

					GetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor, 32, 32);
					if(isnull(szTXDName[iIndex])) {
						SetDynamicObjectMaterial(iObjectID, iIndex, -1, "none", "none", iColor);
					}
					else SetDynamicObjectMaterial(iObjectID, iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor);
				}
				return 1;
			}
			if(newkeys == KEY_CROUCH) { // Delete textures.

				textm_SelectedTile[playerid] = 0;
				PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] = PREVIEW_STATE_NONE;
				ReloadFurniture(playerid);
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][2]);
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][3]);
				return 1;
			}
			return 1;
		}

		if(OnPlayerKeyStateChangeMenu(playerid,newkeys,oldkeys)) return 1;

	    if(newkeys == KEY_NO) {
			
			new model,
				txd[32],
				texture[32],
				color;

			GetDynamicObjectMaterial(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]],0, model, txd, texture, color);
		 	SetDynamicObjectMaterial(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]],0, model, txd, texture, TextureMenuInfo[MenuID][textm_iUnselectColor][textm_SelectedTile[playerid]]);

			MoveDynamicObject(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]], TextureMenuInfo[MenuID][textm_OrigPosX][textm_SelectedTile[playerid]],
				TextureMenuInfo[MenuID][textm_OrigPosY][textm_SelectedTile[playerid]], TextureMenuInfo[MenuID][textm_OrigPosZ][textm_SelectedTile[playerid]],1.0);
			
			textm_SelectedTile[playerid]++;
			if(textm_SelectedTile[playerid] == TextureMenuInfo[MenuID][textm_iTiles]) textm_SelectedTile[playerid] = 0;

			GetDynamicObjectMaterial(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]], 0, model, txd, texture, color);
		 	SetDynamicObjectMaterial(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]], 0, model, txd, texture, TextureMenuInfo[MenuID][textm_iSelectColor][textm_SelectedTile[playerid]]);

			MoveDynamicObject(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]], TextureMenuInfo[MenuID][textm_OrigPosX][textm_SelectedTile[playerid]] + TextureMenuInfo[MenuID][textm_AddX],
				TextureMenuInfo[MenuID][textm_OrigPosY][textm_SelectedTile[playerid]] + TextureMenuInfo[MenuID][textm_AddY], TextureMenuInfo[MenuID][textm_OrigPosZ][textm_SelectedTile[playerid]], 1.0);

			//if(funcidx("OnPlayerChange3DMenuBox") != -1) OnPlayerChange3DMenuBox(playerid, MenuID, textm_SelectedTile[playerid]); set td name

			return 1;
		}
		if(newkeys == KEY_CTRL_BACK) {
			
			new model,txd[32],
				texture[32],
				color;

			GetDynamicObjectMaterial(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]],0,model, txd, texture, color);
		 	SetDynamicObjectMaterial(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]],0, model, txd, texture,  TextureMenuInfo[MenuID][textm_iUnselectColor][textm_SelectedTile[playerid]]);

	        MoveDynamicObject(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]], TextureMenuInfo[MenuID][textm_OrigPosX][textm_SelectedTile[playerid]],
	        	TextureMenuInfo[MenuID][textm_OrigPosY][textm_SelectedTile[playerid]], TextureMenuInfo[MenuID][textm_OrigPosZ][textm_SelectedTile[playerid]], 1.0);
			
			textm_SelectedTile[playerid]--;
			if(textm_SelectedTile[playerid] < 0) textm_SelectedTile[playerid] = TextureMenuInfo[MenuID][textm_iTiles]-1;

			GetDynamicObjectMaterial(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]],0, model, txd, texture, color);
		 	SetDynamicObjectMaterial(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]],0, model, txd, texture, TextureMenuInfo[MenuID][textm_iSelectColor][textm_SelectedTile[playerid]]);

			MoveDynamicObject(TextureMenuInfo[MenuID][textm_iObjectID][textm_SelectedTile[playerid]], TextureMenuInfo[MenuID][textm_OrigPosX][textm_SelectedTile[playerid]] + TextureMenuInfo[MenuID][textm_AddX],
				TextureMenuInfo[MenuID][textm_OrigPosY][textm_SelectedTile[playerid]] + TextureMenuInfo[MenuID][textm_AddY], TextureMenuInfo[MenuID][textm_OrigPosZ][textm_SelectedTile[playerid]], 1.0);

			//if(funcidx("OnPlayerChange3DMenuBox") != -1) OnPlayerChange3DMenuBox(playerid, MenuID, textm_SelectedTile[playerid]); set txd name
			return 1;
		}
	}
	return 0;
}

static UpdateThemeTextures(playerid) {

	for(new i = 0; i < 16; i++) {

	   	if(PlayerTextureThemeIndex[playerid][PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex]+i] >= sizeof(arrTextures) - 1) continue;
		if(PlayerTextureThemeIndex[playerid][PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex]+i] == 0) {

	    	Set3DTextureMenuTile(PlayerTextureMenuInfo[playerid][ptextm_Menus3D],i,0,
				arrTextures[DEFAULT_TEXTURE][text_TModel],
				arrTextures[DEFAULT_TEXTURE][text_TXDName],
			   	arrTextures[DEFAULT_TEXTURE][text_TextureName],
			   	0, 0xFF999999);

		}
		else {

	    	Set3DTextureMenuTile(PlayerTextureMenuInfo[playerid][ptextm_Menus3D],i,0,
				arrTextures[PlayerTextureThemeIndex[playerid][i+PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex]]][text_TModel],
				arrTextures[PlayerTextureThemeIndex[playerid][i+PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex]]][text_TXDName],
				arrTextures[PlayerTextureThemeIndex[playerid][i+PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex]]][text_TextureName],
			   	0, 0xFF999999);
		}
	}
}

OnPlayerKeyStateChangeMenu(playerid,newkeys,oldkeys) {

	#pragma unused oldkeys
	
	if(newkeys & 16 || oldkeys & 16) return 0;
	//if(EditingMode[playerid] && GetEditMode(playerid) != EDIT_MODE_TEXTURING) return 0;

	// Scroll right
	if(newkeys & KEY_ANALOG_RIGHT || (((newkeys & (KEY_WALK | KEY_NO)) == (KEY_WALK | KEY_NO)) && ((oldkeys & (KEY_WALK | KEY_NO)) != (KEY_WALK | KEY_NO)))) {
		
		if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_ALLTEXTURES) {
			// Next 16 entries
			PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] += 16;

			// Too high of entries set default
			if(PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] >= sizeof(arrTextures)-1) PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = 1;
			else if(sizeof(arrTextures) - 1 - PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] - 16 < 0) PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = sizeof(arrTextures) - 16 - 1;

			// Update the textures
			for(new i = 0; i < 16; i++) {

				if(i+PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] >= sizeof(arrTextures) - 1) continue;
				Set3DTextureMenuTile(PlayerTextureMenuInfo[playerid][ptextm_Menus3D], i, 0, arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TModel],
		       		arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TXDName], arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TextureName], 0, 0xFF999999);
			}
		}
		else if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_THEME) {

			PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] += 16;

		    if(PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] >= MAX_THEME_TEXTURES - 1) PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] = 1;
		    else if(MAX_THEME_TEXTURES - 1 - PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] - 16 < 0) PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] = MAX_THEME_TEXTURES - 16 - 1;

            UpdateThemeTextures(playerid);
		}
		else if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_SEARCH) {

			// Next 16 entries
			PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] += 16;

			// Too high of entries set default
			if(PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] >= sizeof(arrTextures) - 1) PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = 1;
			else if(sizeof(arrTextures) - 1 - PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] - 16 < 0) PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = sizeof(arrTextures) - 16 - 1;

			// Update the textures
			for(new i = 0; i < 16; i++) {

				if(i+PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] >= sizeof(arrTextures) - 1) continue;
				Set3DTextureMenuTile(PlayerTextureMenuInfo[playerid][ptextm_Menus3D], i, 0, arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TModel],
					arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TXDName], arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TextureName], 0, 0xFF999999);
			}


		}
		// Update the info
		//UpdateTextureInfo(playerid, SelectedBox[playerid]);
		return 1;
	}

	// Pressed left (Same as right almost)
	else if(newkeys & KEY_ANALOG_LEFT || (((newkeys & (KEY_WALK | KEY_CTRL_BACK)) == (KEY_WALK | KEY_CTRL_BACK)) && ((oldkeys & (KEY_WALK | KEY_CTRL_BACK)) != (KEY_WALK | KEY_CTRL_BACK))))
	{
		if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
		{
	        // Last 16 entries
			PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] -= 16;

			// Too high of entries set default
			if(PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] < 1) PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = sizeof(arrTextures) - 16 - 1;

            // Update the textures
			if(PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] >= sizeof(arrTextures) - 1) PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = sizeof(arrTextures) - 1;
			for(new i = 0; i < 16; i++)
			{
				if(i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] >= sizeof(arrTextures) - 1) continue;
				Set3DTextureMenuTile(PlayerTextureMenuInfo[playerid][ptextm_Menus3D], i, 0, arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TModel],
					arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TXDName], arrTextures[i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]][text_TextureName], 0, 0xFF999999);
			}
		}
		else if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_THEME) {

	        PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] -= 16;
		    if(PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] < 1) PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] = MAX_THEME_TEXTURES - 16 - 1;
      		if(PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] >= MAX_THEME_TEXTURES - 1) PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex] = MAX_THEME_TEXTURES - 1;
			UpdateThemeTextures(playerid);
		}
		else if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_SEARCH) {

			// Last 16 entries
			PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] -= 16;

			// Too high of entries set default
			if(PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] < 1) PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = sizeof(arrTextures) - 16 - 1;

            // Update the textures
			if(PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] >= sizeof(arrTextures) - 1) PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] = sizeof(arrTextures) - 1;
			for(new i = 0; i < 16; i++) {

				if(i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] >= sizeof(arrTextures) - 1) continue;
				Set3DTextureMenuTile(PlayerTextureMenuInfo[playerid][ptextm_Menus3D], i, 0, arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TModel],
					arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TXDName], arrTextures[ListItemTextureTrackId[playerid][i + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]][text_TextureName], 0, 0xFF999999);
			}
		}

		// Update the info
        // UpdateTextureInfo(playerid, SelectedBox[playerid]);
		return 1;
	}
	else if(newkeys & KEY_SPRINT) {

		// Add to your theme
	    if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_ALLTEXTURES) {

			new addt = AddTextureToTheme(playerid, PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] + textm_SelectedTile[playerid]);
			if(addt >= 0) SendClientMessage(playerid, COLOR_GRAD1, "You successfully added the texture to your theme.");
			else if(addt == -1) SendClientMessage(playerid, COLOR_GRAD1, "This texture already exists in your theme.");
			else if(addt == -2) SendClientMessage(playerid, COLOR_GRAD1, "You cannot add more textures to your theme.");
			return 1;
		}
	}
	else if(newkeys & KEY_YES) {

		new iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING),
			iSlotID = GetPVarInt(playerid, PVAR_FURNITURE_SLOT),
			iTextSlot = GetPVarInt(playerid, "textslot"),
			iHouseID = GetHouseID(playerid),
			iTextID;
		
		if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_ALLTEXTURES) iTextID = PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex] + textm_SelectedTile[playerid];
		else if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_SEARCH) iTextID = ListItemTextureTrackId[playerid][textm_SelectedTile[playerid] + PlayerTextureMenuInfo[playerid][ptextm_CurrTextureIndex]]; 
		
		Exit3DTextureMenu(playerid);
		ProcessFurnitureTexture(iHouseID, iSlotID, iObjectID, iTextSlot, iTextID, 0, 1);
		DeletePVar(playerid, PVAR_FURNITURE_EDITING);
		DeletePVar(playerid, PVAR_FURNITURE_SLOT);
		DeletePVar(playerid, "textslot");
		DeletePVar(playerid, "color");
		SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture]: {CCCCCC}You successfully painted the furniture.");
		SelectTextDraw(playerid, 0xF6FBFCFF);
		return 1;

		/*
        else if(PlayerTextureMenuInfo[playerid][ptextm_TPreviewState] == PREVIEW_STATE_THEME)
        {
			if(TextureAll[playerid])
			{
				format(line, sizeof(line), "/mtsetall %i %i", CurrTexturingIndex[playerid], PlayerTextureThemeIndex[playerid][PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex]+SelectedBox[playerid]]);
				BroadcastCommand(playerid, line);
			}
			else
			{
				format(line, sizeof(line), "/mtset %i %i", CurrTexturingIndex[playerid], PlayerTextureThemeIndex[playerid][PlayerTextureMenuInfo[playerid][ptextm_CurrThemeIndex]+SelectedBox[playerid]]);
				BroadcastCommand(playerid, line);
			}
			return 1;
        }
        */
	}
	else if(newkeys & KEY_LOOK_BEHIND) {

	    Exit3DTextureMenu(playerid);
		DeletePVar(playerid, PVAR_FURNITURE_EDITING);
		DeletePVar(playerid, PVAR_FURNITURE_SLOT);
		DeletePVar(playerid, "color");
		DeletePVar(playerid, "textslot");
		SelectTextDraw(playerid, 0xF6FBFCFF);
	}
	return 0;
}

static AddTextureToTheme(playerid, index) {

	for(new i = 1; i < MAX_THEME_TEXTURES; i++) {

		if(index == PlayerTextureThemeIndex[playerid][i]) return -1; 
	}
    for(new i = 1; i < MAX_THEME_TEXTURES; i++)	{

		if(PlayerTextureThemeIndex[playerid][i] == 0) {

			PlayerTextureThemeIndex[playerid][i] = index;
			return i;
		}
	}
	return -2;
}


