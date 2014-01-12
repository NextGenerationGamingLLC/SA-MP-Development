#include <a_samp>
#include <streamer>

new Text3D:newyear, timesync, balldrop[2];
new stagespawned, paused, inittime;

enum NEWYEAR_INFO {
	timestamp,
	locations[500]
}

stock const NEWYEAR_DATA[39][NEWYEAR_INFO] = {
	{1325325600, "Samoa, Tokelau and Christmas Island/Kiribati"},
	{1325326500, "Chatham Islands/New Zealand"},
	{1325329200, "New Zealand, Antartica, Tonga, Fiji, and Phoenix Islands/Kiribati"},
	{1325332800, "Russia, Marshall Islands, Kiribati, Wallis and Futuna, Nauru, Wake Island/U.S.A. and Tuvalu"},
	{1325334600, "Norfolk Island"},
	{1325336400, "Australia, Russia, Ponape/Micronesia, New Caledonia/France, Solomon Islands, Antarctica and Vanuatu"},
	{1325338200, "Australia"},
	{1325340000, "Queensland/Australia, Micronesia, Northern Mariana Islands, Guam, Papua New Guinea and Russia"},
	{1325341800, "Northern Territory/Australia"},
	{1325343600, "Japan, South Korea, Papua/Indonesia, Russia, Palau, North Korea and Timor-Leste"},
	{1325344500, "Western Australia"},
	{1325347200, "China, Indonesia, Philippines, Western Australia, Malaysia, Taiwan, Russia, Mongolia, Hong Kong, Brunei, Macau and Singapore"},
	{1325350800, "Indonesia, Russia, Thailand, Vietnam, Cambodia, Laos, Australia and Mongolia "},
	{1325352600, "Myanmar and Cocos Islands"},
	{1325354400, "Bangladesh, Russia, Kazakhstan, Kyrgyzstan, Bhutan and British Indian Ocean Territory"},
	{1325355300, "Nepal"},
	{1325356200, "India and Sri Lanka"},
	{1325358000, "Pakistan, Kazakhstan, Uzbekistan, Antarctica, Kerguelen Islands, Turkmenistan, Tajikistan and Maldives"},
	{1325359800, "Afghanistan"},
	{1325361600, "Russia, United Arab Emirates, Reunion (French), Armenia, Oman, Georgia, Seychelles, Azerbaijan and Mauritius"},
	{1325363400, "Iran"},
	{1325365200, "Iraq, Saudi Arabia, Tanzania, Kenya, Somalia, Uganda, Ethiopia, Yemen, Bahrain, Russia, Comoros, Kuwait, Djibouti, Qatar, Eritrea, Belarus, Mayotte, South Sudan, Madagascar and Sudan"},
	{1325368800, "Greece, Israel, Finland, South Africa, Ukraine, Turkey, Cyprus, Libya, Romania, West Bank, Bulgaria, Malawi, Syria, Egypt, Lithuania, Zimbabwe, Moldova, Zambia, Botswana, Congo Dem.Rep., Swaziland, Burundi, Jordan, Latvia, Rwanda, Mozambique, Lesotho, Gaza Strip, Estonia, Namibia and Lebanon"},
	{1325372400, "Germany, France, Poland, Norway, Netherlands, Austria, Sweden, Switzerland, Italy, Barcelona/Spain, Belgium, Denmark, Nigeria, Czech Republic, Croatia, Slovenia, Luxembourg, Angola, Slovakia, Bosnia-Herzegovina, Hungary, Cameroon, Benin, Republic of Macedonia, Central African Republic, Tunisia, Equatorial Guinea, Serbia, Vatican City State, Gabon, Liechtenstein, Congo Dem.Rep., San Marino, Monaco, Congo, Algeria, Chad, Gibraltar, Kosovo, Niger, Montenegro, Malta, Albania and Andorra"},
	{1325376000, "United Kingdom, Portugal, Morocco, Ireland, Spain, Iceland, Cote d'Ivoire (Ivory Coast), Mali, Togo, Senegal, Gambia, Faroe Islands, Guinea-Bissau, Isle of Man, Greenland, Saint Helena, Mauritania, Sao Tome and Principe, Guinea, Western Sahara, Ghana, Burkina Faso, Sierra Leone and Liberia"},
	{1325379600, "Cape Verde, Greenland and Portugal"},
	{1325383200, "Brazil, Uruguay and South Georgia/Sandwich Is."},
	{1325386800, "Argentina, Brazil, Chile, Greenland, Falkland Islands, Suriname, Saint Pierre and Miquelon, Paraguay and French Guiana"},
	{1325388600, "Newfoundland and Labrador/Canada"},
	{1325390400, "Canada, Bolivia, Amazonas/Brazil, Dominican Republic, Dominica, Grenada, Guadeloupe, Puerto Rico, Martinique, Bermuda, Montserrat, Anguilla, Curaçao, Aruba, Saint Kitts and Nevis, Netherlands, Saint Lucia, Barbados, Saint Vincent and Grenadines, Trinidad and Tobago, US Virgin Islands, British Virgin Islands, Sint Maarten, Guyana, Antigua and Barbuda and Greenland"},
	{1325392200, "Venezuela"},
	{1325394000, "U.S.A., Canada, Colombia, Peru, Ecuador, Cuba, Panama, Bahamas, Haiti, Turks and Caicos Islands, Chile, Cayman Islands and Jamaica"},
	{1325397600, "U.S.A., Canada, Mexico, Honduras, El Salvador, Guatemala, Nicaragua, Belize, Costa Rica and Ecuador"},
	{1325401200, "U.S.A., Canada and Mexico"},
	{1325404800, "U.S.A., Canada, Baja California/Mexico and Pitcairn Islands"},
	{1325408400, "Alaska/U.S.A. and French Polynesia"},
	{1325410200, "Marquesas Islands/France"},
	{1325412000, "U.S.A., Tahiti/France and Cook Islands"},
	{1325415600, "American Samoa, Midway Islands/U.S.A. and Niue"}
};

forward Countdown();
public Countdown()
{
	new string[630];
	
	if(paused)
	{
	    new const colors[][] = {"FF0000", "00FF00", "0000FF", "FFFF00", "CCFF33"};
	    format(string, sizeof(string), "{%s}HAPPY {%s}NEW{%s}YEAR{%s}!", colors[random(sizeof(colors))], colors[random(sizeof(colors))], colors[random(sizeof(colors))], colors[random(sizeof(colors))]);
		UpdateDynamic3DTextLabelText(newyear, 0xFFFFFFFF, string);
	}
	else
	{
		for(new x;x<sizeof(NEWYEAR_DATA);x++)
		{
		    if((NEWYEAR_DATA[x][timestamp]-21600)-gettimet() > 0)
		    {
				new seconds=(NEWYEAR_DATA[x][timestamp]-21600)-gettimet();
				if(seconds < 1)
				{
					pause();
				}
				if(seconds < 15)
				{
				    MoveDynamicObject(balldrop[0], 901.18688965,-1948.02282715,9.2+(0.624066976*seconds), 0.8);
				    MoveDynamicObject(balldrop[1], 901.28308105,-1947.96704102,10.35110588+(0.624066976*seconds), 0.8);
				    SetTimer("pause", 12500, false);
				}
				if(stagespawned == 0 && seconds < 10800)
		        {
					SpawnStage();
		        }
				if(seconds > 86400)
				{
				    if(floatround((seconds/86400), floatround_floor) > 1) format(string, sizeof(string), "{FF0000}%d {FFFF00}days", floatround((seconds/86400), floatround_floor));
					else format(string, sizeof(string), "{FF0000}%d {FFFF00}day", floatround((seconds/86400), floatround_floor));
					seconds=seconds-((floatround((seconds/86400), floatround_floor))*86400);
				}
				if(seconds > 3600)
				{
				    if(floatround((seconds/3600), floatround_floor) > 1) format(string, sizeof(string), "%s\n{FF0000}%d {FFFF00}hours", string, floatround((seconds/3600), floatround_floor));
				    else format(string, sizeof(string), "%s\n{FF0000}%d {FFFF00}hour", string, floatround((seconds/3600), floatround_floor));
					seconds=seconds-((floatround((seconds/3600), floatround_floor))*3600);
				}
				if(seconds > 60)
				{
				    if(floatround((seconds/60), floatround_floor) > 1) format(string, sizeof(string), "%s\n{FF0000}%d {FFFF00}minutes", string, floatround((seconds/60), floatround_floor));
				    else format(string, sizeof(string), "%s\n{FF0000}%d {FFFF00}minute", string, floatround((seconds/60), floatround_floor));
					seconds=seconds-((floatround((seconds/60), floatround_floor))*60);
				}
				if(seconds > 1) format(string, sizeof(string), "%s\n{FF0000}%d {FFFF00}seconds\nuntil the {FF0000}New Year {FFFF00}in\n", string, seconds);
				else format(string, sizeof(string), "%s\n{FF0000}%d {FFFF00}second\nuntil the {FF0000}New Year {FFFF00}in\n", string, seconds);
				format(string, sizeof(string), "%s %s", string, NEWYEAR_DATA[x][locations]);
				UpdateDynamic3DTextLabelText(newyear, 0xFFFFFFFF, string);
				break;
			}
		}
	}
}

//Degugtime ver, script always starts with 15 seconds until new years
stock gettimet()
{
	return gettime()+inittime;
}

forward pause();
public pause()
{
	paused=1;
	SetTimer("Backyougo", 60000, false);
}

forward Backyougo();
public Backyougo()
{
	paused=0;
	MoveDynamicObject(balldrop[0], 901.18688965,-1948.02282715,21.56100464, 0.8);
    MoveDynamicObject(balldrop[1], 901.28308105,-1947.96704102,22.71211052, 0.8);
}

forward SyncCountdown();
public SyncCountdown()
{
	if(gettime() == timesync)
	{
    	SetTimer("Countdown", 500, true);
	}
    else
	{
	    SetTimer("SyncCountdown", 1, false);
	}
}

public OnFilterScriptInit()
{
	inittime=(1325304000-gettime())+880;
	newyear=CreateDynamic3DTextLabel("", 0xFFFFFFFF, 901.3, -1947.94, 10.86, 100.0);

	timesync=gettime()+1;
	SetTimer("SyncCountdown", 1, false);
}

stock SpawnStage()
{
	stagespawned=1;
    //---------------------------------------------New Year Map---------------------------------------------------------------
	CreateDynamicObject(18766,892.08203125,-1947.94726562,7.35938168,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (24)
	CreateDynamicObject(18766,892.06079102,-1947.96020508,2.40937304,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (21)
	CreateDynamicObject(3440,901.15454102,-1948.00451660,9.96092415,0.00000000,0.00000000,359.98901367, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (13)
	CreateDynamicObject(3440,901.15429688,-1948.00390625,14.58591843,0.00000000,0.00000000,359.98901367, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (14)
	CreateDynamicObject(3440,901.15429688,-1948.00390625,19.31090736,0.00000000,0.00000000,359.98901367, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (15)
	CreateDynamicObject(18766,902.05383301,-1947.96496582,2.40937304,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (22)
    CreateDynamicObject(18766,910.30029297,-1947.95007324,2.40937304,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (23)
    CreateDynamicObject(18766,910.29980469,-1947.94921875,7.35938168,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (26)
    CreateDynamicObject(18766,902.02862549,-1947.96179199,7.35938168,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (27)
	balldrop[0] = CreateDynamicObject(3054,901.18688965,-1948.02282715,21.56100464,180.00000000,0.00000000,180.00000000, .interiorid = 0, .worldid = 0); //object(dyn_wreking_ball) (1)
    balldrop[1] = CreateDynamicObject(354,901.28308105,-1947.96704102,22.71211052,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(1)

	CreateDynamicObject(19121,819.57714844,-1793.78906250,13.44611454,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (1)
    CreateDynamicObject(19122,825.98358154,-1793.78991699,13.44611454,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (3)
    CreateDynamicObject(19123,829.08947754,-1793.84472656,13.44611454,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (4)
    CreateDynamicObject(19124,832.40472412,-1793.78991699,13.44611454,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (5)
    CreateDynamicObject(19125,835.94238281,-1793.78906250,13.44611454,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (6)
    CreateDynamicObject(19126,843.23199463,-1793.78991699,13.44611454,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (8)
    CreateDynamicObject(19127,818.54187012,-1796.28283691,13.27111721,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (9)
    CreateDynamicObject(19121,818.54315186,-1799.04687500,13.04612064,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (10)
    CreateDynamicObject(19122,843.25476074,-1797.12414551,13.24611759,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (12)
    CreateDynamicObject(19123,843.25476074,-1800.52197266,12.99612141,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (13)
    CreateDynamicObject(19124,854.60003662,-1826.46667480,11.77114010,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (14)
    CreateDynamicObject(19125,854.60003662,-1824.19128418,11.77114010,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (15)
    CreateDynamicObject(19126,854.60003662,-1821.88952637,11.77114010,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (16)
    CreateDynamicObject(19127,854.60003662,-1819.26232910,11.77114010,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (17)
    CreateDynamicObject(19121,818.41082764,-1823.31042480,12.02113628,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (18)
    CreateDynamicObject(19122,818.41082764,-1821.37548828,12.02113628,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (19)
    CreateDynamicObject(19123,818.41082764,-1819.57873535,12.02113628,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (20)
    CreateDynamicObject(19124,818.41082764,-1817.77380371,12.02113628,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (21)
    CreateDynamicObject(19125,818.41082764,-1815.85400391,12.02113628,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (22)
    CreateDynamicObject(19126,818.41082764,-1813.87536621,11.99613667,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (23)
    CreateDynamicObject(19127,818.41082764,-1812.09448242,12.04613590,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (24)
    CreateDynamicObject(19121,818.41082764,-1810.10571289,12.17113400,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (25)
    CreateDynamicObject(19122,845.47918701,-1800.50744629,13.24611759,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (26)
    CreateDynamicObject(19123,818.41082764,-1808.18164062,12.37113094,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (27)
    CreateDynamicObject(19124,816.45007324,-1807.84692383,12.59612751,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (28)
    CreateDynamicObject(19125,814.50170898,-1807.84692383,12.59612751,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (29)
    CreateDynamicObject(19126,812.67492676,-1807.84692383,12.59612751,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cuntetownrd4) (30)
    CreateDynamicObject(18783,911.15936279,-1905.40759277,-2.20000004,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (1)
    CreateDynamicObject(18783,891.19342041,-1925.40417480,-0.16562633,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (2)
    CreateDynamicObject(18783,891.17584229,-1905.41113281,-2.20000004,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (3)
    CreateDynamicObject(18783,891.18627930,-1925.39807129,-2.29062581,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (4)
    CreateDynamicObject(18783,911.16265869,-1925.39855957,-2.29062581,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (5)
    CreateDynamicObject(18783,911.13635254,-1925.40405273,-0.16562633,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (6)
    CreateDynamicObject(18766,910.78546143,-1928.78149414,4.83437204,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (1)
    CreateDynamicObject(18766,917.67230225,-1925.00000000,4.83437204,0.00000000,0.00000000,62.00000000, .interiorid = 0, .worldid = 0); //object(inner) (2)
    CreateDynamicObject(18766,884.63201904,-1925.00000000,4.83437204,0.00000000,0.00000000,298.00415039, .interiorid = 0, .worldid = 0); //object(inner) (3)
    CreateDynamicObject(18766,901.28112793,-1928.78149414,4.83437204,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (4)
    CreateDynamicObject(18766,891.41400146,-1928.78149414,4.83437204,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (5)
    CreateDynamicObject(18761,831.42089844,-1793.75683594,16.24213791,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(thebowl17) (1)
    CreateDynamicObject(18761,832.19268799,-1823.83557129,16.19213867,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(thebowl17) (2)
    CreateDynamicObject(18761,836.75677490,-1864.22167969,16.19213867,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(thebowl17) (3)
    CreateDynamicObject(18761,837.39379883,-1903.82568359,16.19213867,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(thebowl17) (4)
    CreateDynamicObject(18761,836.96899414,-1948.04748535,16.19213867,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(thebowl17) (5)
    CreateDynamicObject(18761,837.08398438,-1991.43457031,16.19213867,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(thebowl17) (6)
    CreateDynamicObject(18655,901.19506836,-1972.61511230,0.75000072,0.00000000,0.00000000,275.99993896, .interiorid = 0, .worldid = 0); //object(carter-stairs01) (1)
    CreateDynamicObject(18654,881.41748047,-1952.92993164,0.85000110,0.00000000,0.00000000,135.49475098, .interiorid = 0, .worldid = 0); //object(mansion-light05) (2)
    CreateDynamicObject(18653,881.42803955,-1972.51684570,0.75000060,0.00000000,0.00000000,228.00000000, .interiorid = 0, .worldid = 0); //object(chairs) (2)
    CreateDynamicObject(18766,916.17315674,-1915.88195801,-0.14062606,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (7)
    CreateDynamicObject(18766,906.18927002,-1915.88720703,-0.14062606,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (8)
    CreateDynamicObject(18766,896.18615723,-1915.88598633,-0.14062606,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (9)
    CreateDynamicObject(18766,886.18939209,-1915.88598633,-0.14062606,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (10)
    CreateDynamicObject(18766,916.15930176,-1934.91015625,-0.11562606,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (11)
    CreateDynamicObject(18766,906.16204834,-1934.91015625,-0.11562606,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (12)
    CreateDynamicObject(18766,896.17340088,-1934.91015625,-0.11562606,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (13)
    CreateDynamicObject(18766,886.16949463,-1934.90759277,-0.11562606,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (14)
    CreateDynamicObject(11472,908.79626465,-1916.21594238,-0.91562545,0.00000000,0.00000000,270.00000000, .interiorid = 0, .worldid = 0); //object(des_swtstairs1) (1)
    CreateDynamicObject(11472,907.22973633,-1916.21081543,-0.91562545,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(des_swtstairs1) (2)
    CreateDynamicObject(11472,905.65032959,-1916.20349121,-0.91562545,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(des_swtstairs1) (3)
	CreateDynamicObject(5992,909.71630859,-1938.34570312,3.43794727,0.00000000,0.00000000,270.00000000, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (1)
    CreateDynamicObject(5992,907.80078125,-1938.34118652,1.66294980,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (2)
    CreateDynamicObject(5992,905.89562988,-1938.34118652,3.00000000,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (3)
    CreateDynamicObject(5992,903.98754883,-1938.34118652,0.20000000,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (4)
    CreateDynamicObject(5992,902.08154297,-1938.34118652,1.66294980,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (5)
    CreateDynamicObject(5992,900.20019531,-1938.34118652,0.10000000,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (6)
    CreateDynamicObject(5992,898.29443359,-1938.34118652,3.00000000,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (7)
    CreateDynamicObject(5992,896.41088867,-1938.34118652,1.66294980,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (8)
    CreateDynamicObject(5992,894.50219727,-1938.34118652,3.44999981,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (9)
    CreateDynamicObject(5992,892.59399414,-1938.34118652,1.66294980,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (10)
    CreateDynamicObject(5992,911.62145996,-1938.34118652,1.66294980,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ltsreg01_lawn) (11)
	CreateDynamicObject(18766,910.91894531,-1928.78149414,9.20942307,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (16)
    CreateDynamicObject(18766,917.67187500,-1925.00000000,9.80936050,0.00000000,0.00000000,61.99584961, .interiorid = 0, .worldid = 0); //object(inner) (17)
    CreateDynamicObject(18766,891.41308594,-1928.78149414,9.35942078,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (18)
    CreateDynamicObject(18766,884.63183594,-1925.00000000,9.80941391,0.00000000,0.00000000,297.99865723, .interiorid = 0, .worldid = 0); //object(inner) (19)
    CreateDynamicObject(18766,901.28027344,-1928.78149414,9.80941391,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (20)
    CreateDynamicObject(18783,911.17755127,-1943.70141602,-1.71562505,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (7)
    CreateDynamicObject(18783,891.21374512,-1943.69091797,-1.71562505,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (8)
    CreateDynamicObject(18783,891.20892334,-1963.67810059,-1.71562505,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (9)
    CreateDynamicObject(18783,911.17602539,-1963.69494629,-1.71562505,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(kickramp04) (10)
	CreateDynamicObject(19129,891.19366455,-1962.70471191,0.80468857,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(sw_trainbridge1) (3)
    CreateDynamicObject(19129,911.19824219,-1962.70971680,0.80468857,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(sw_trainbridge1) (4)
    CreateDynamicObject(18653,921.01861572,-1952.92321777,0.75000060,0.00000000,0.00000000,51.99926758, .interiorid = 0, .worldid = 0); //object(chairs) (3)
    CreateDynamicObject(18654,920.95074463,-1972.45825195,0.85000110,0.00000000,0.00000000,315.49438477, .interiorid = 0, .worldid = 0); //object(mansion-light05) (3)
    CreateDynamicObject(18766,920.70855713,-1930.41967773,-0.11562606,0.00000000,0.00000000,90.00000000, .interiorid = 0, .worldid = 0); //object(inner) (28)
    CreateDynamicObject(18766,920.66925049,-1921.19165039,-0.11562606,0.00000000,0.00000000,90.00000000, .interiorid = 0, .worldid = 0); //object(inner) (29)
    CreateDynamicObject(18766,881.66894531,-1929.47949219,-0.11562606,0.00000000,0.00000000,90.00000000, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,881.67742920,-1920.44250488,-0.11562606,0.00000000,0.00000000,90.00000000, .interiorid = 0, .worldid = 0); //object(inner) (31)
    CreateDynamicObject(18766,901.61602783,-1952.13244629,-0.11562695,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (32)
    CreateDynamicObject(18766,896.46679688,-1950.13220215,-2.64062691,0.00000000,90.00000000,270.00000000, .interiorid = 0, .worldid = 0); //object(inner) (33)
    CreateDynamicObject(18766,906.11621094,-1950.13061523,-2.64062691,0.00000000,90.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(inner) (34)
    CreateDynamicObject(2395,905.68701172,-1951.56372070,2.37500238,270.00000000,179.99853516,269.99856567, .interiorid = 0, .worldid = 0); //object(cj_sports_wall) (6)
    CreateDynamicObject(2395,902.96002197,-1951.20629883,2.37500238,270.00000000,179.99853516,269.99850464, .interiorid = 0, .worldid = 0); //object(cj_sports_wall) (7)
    CreateDynamicObject(2395,900.22100830,-1951.18005371,2.37500238,270.00000000,180.00152588,270.00146484, .interiorid = 0, .worldid = 0); //object(cj_sports_wall) (8)
    CreateDynamicObject(2395,899.38354492,-1951.18237305,2.35000229,270.00000000,179.99450684,269.99450684, .interiorid = 0, .worldid = 0); //object(cj_sports_wall) (9)
    CreateDynamicObject(18655,906.03479004,-1952.00329590,1.42500007,0.00000000,0.00000000,67.99853516, .interiorid = 0, .worldid = 0); //object(carter-stairs01) (3)
    CreateDynamicObject(18655,896.53363037,-1952.00854492,1.42500007,0.00000000,0.00000000,119.99435425, .interiorid = 0, .worldid = 0); //object(carter-stairs01) (4)
    CreateDynamicObject(996,913.60034180,-1895.60546875,0.93312943,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(lhouse_barrier1) (1)
    CreateDynamicObject(996,881.97570801,-1895.66137695,0.93312943,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(lhouse_barrier1) (2)
    CreateDynamicObject(996,892.02502441,-1895.64086914,0.93312943,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(lhouse_barrier1) (3)
    CreateDynamicObject(996,902.95263672,-1895.59277344,0.93312943,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(lhouse_barrier1) (4)
    CreateDynamicObject(996,921.02374268,-1904.45568848,0.93312943,0.00000000,0.00000000,90.00000000, .interiorid = 0, .worldid = 0); //object(lhouse_barrier1) (5)
    CreateDynamicObject(996,881.26977539,-1904.21496582,0.93312943,0.00000000,0.00000000,90.00000000, .interiorid = 0, .worldid = 0); //object(lhouse_barrier1) (6)
    CreateDynamicObject(996,881.26483154,-1913.90112305,0.93312943,0.00000000,0.00000000,90.00000000, .interiorid = 0, .worldid = 0); //object(lhouse_barrier1) (7)
    CreateDynamicObject(996,921.04956055,-1913.96569824,0.93312943,0.00000000,0.00000000,90.00000000, .interiorid = 0, .worldid = 0); //object(lhouse_barrier1) (8)
    CreateDynamicObject(3886,926.04229736,-1899.70568848,-0.62259519,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(ws_jettynol_sfx) (1)
    CreateDynamicObject(3886,926.03936768,-1910.16394043,-0.54759526,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(ws_jettynol_sfx) (2)
    CreateDynamicObject(3886,926.04669189,-1920.63647461,-0.47259527,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(ws_jettynol_sfx) (3)
    CreateDynamicObject(3886,926.04119873,-1931.09631348,-0.37259525,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(ws_jettynol_sfx) (4)
    CreateDynamicObject(3886,923.19171143,-1941.57067871,-0.14759520,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(ws_jettynol_sfx) (5)
    CreateDynamicObject(3886,927.22125244,-1941.56860352,-0.14759520,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(ws_jettynol_sfx) (7)
    CreateDynamicObject(3361,909.31170654,-1949.58984375,0.22387430,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cxref_woodstair) (1)
    CreateDynamicObject(3361,893.21618652,-1949.50073242,0.22387430,0.00000000,0.00000000,180.00000000, .interiorid = 0, .worldid = 0); //object(cxref_woodstair) (2)
    CreateDynamicObject(2232,897.19317627,-1952.75427246,1.44085419,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (1)
    CreateDynamicObject(2232,905.32489014,-1952.76721191,1.44085419,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (2)
    CreateDynamicObject(2232,900.60314941,-1952.75585938,1.44085419,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (3)
    CreateDynamicObject(2232,901.77722168,-1952.76452637,1.44085419,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (4)
    CreateDynamicObject(2232,899.43933105,-1952.26806641,2.96585703,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (5)
    CreateDynamicObject(2232,900.14508057,-1952.26806641,2.96585703,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (6)
    CreateDynamicObject(2232,900.84423828,-1952.26806641,2.96585703,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (7)
    CreateDynamicObject(2232,901.54296875,-1952.26806641,2.96585703,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (8)
    CreateDynamicObject(2232,902.24291992,-1952.26806641,2.96585703,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (9)
    CreateDynamicObject(2232,902.92517090,-1952.26806641,2.96585703,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (10)
    CreateDynamicObject(2232,888.79656982,-1948.44812012,6.51585436,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (11)
    CreateDynamicObject(2232,888.79589844,-1948.44726562,5.34084988,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (12)
    CreateDynamicObject(2232,888.79589844,-1948.44726562,4.16585207,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (13)
    CreateDynamicObject(2232,888.79589844,-1948.44726562,2.99085236,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (14)
    CreateDynamicObject(2232,888.79589844,-1948.44726562,1.81585228,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (15)
    CreateDynamicObject(2232,913.54425049,-1948.45898438,6.51585436,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (16)
    CreateDynamicObject(2232,913.54394531,-1948.45898438,5.34084988,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (17)
    CreateDynamicObject(2232,913.54394531,-1948.45898438,4.16584826,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (18)
    CreateDynamicObject(2232,913.54394531,-1948.45898438,2.99084949,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (19)
    CreateDynamicObject(2232,913.54394531,-1948.45898438,1.81584883,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (20)
    CreateDynamicObject(2232,917.60870361,-1924.20837402,7.71585703,0.00000000,0.00000000,241.75001526, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (21)
    CreateDynamicObject(2232,917.60839844,-1924.20800781,6.51585722,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (22)
    CreateDynamicObject(2232,917.60839844,-1924.20800781,5.34085655,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (23)
    CreateDynamicObject(2232,917.60839844,-1924.20800781,4.16585779,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (24)
    CreateDynamicObject(2232,916.41436768,-1926.44714355,4.16585779,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (25)
    CreateDynamicObject(2232,916.41406250,-1926.44628906,5.36585951,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (26)
    CreateDynamicObject(2232,916.41406250,-1926.44628906,6.54086018,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (27)
    CreateDynamicObject(2232,916.41406250,-1926.44628906,7.74085999,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (28)
    CreateDynamicObject(2232,918.83801270,-1921.94299316,7.71585703,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (29)
    CreateDynamicObject(2232,918.83789062,-1921.94238281,6.51585531,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (30)
    CreateDynamicObject(2232,918.83789062,-1921.94238281,5.36585665,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (31)
    CreateDynamicObject(2232,918.83789062,-1921.94238281,4.21585703,0.00000000,0.00000000,241.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (32)
    CreateDynamicObject(2232,885.11206055,-1924.91467285,7.71585703,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (33)
    CreateDynamicObject(2232,885.11132812,-1924.91406250,6.54085732,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (34)
    CreateDynamicObject(2232,885.11132812,-1924.91406250,5.39085865,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (35)
    CreateDynamicObject(2232,885.11132812,-1924.91406250,4.21586084,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (36)
    CreateDynamicObject(2232,884.01818848,-1922.94360352,7.71585703,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (37)
    CreateDynamicObject(2232,884.01757812,-1922.94335938,6.51585245,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (38)
    CreateDynamicObject(2232,884.01757812,-1922.94335938,5.36585093,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (39)
    CreateDynamicObject(2232,884.01757812,-1922.94335938,4.21585512,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (40)
    CreateDynamicObject(2232,886.14965820,-1926.90905762,7.71585703,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (41)
    CreateDynamicObject(2232,886.14941406,-1926.90820312,6.51585722,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (42)
    CreateDynamicObject(2232,886.14941406,-1926.90820312,5.36585855,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (43)
    CreateDynamicObject(2232,886.14941406,-1926.90820312,4.24085712,0.00000000,0.00000000,118.25134277, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (44)
    CreateDynamicObject(16151,906.83508301,-1946.41064453,1.13437462,0.00000000,0.00000000,270.00000000, .interiorid = 0, .worldid = 0); //object(ufo_bar) (1)
    CreateDynamicObject(16151,896.15429688,-1946.40527344,1.13437462,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(ufo_bar) (2)
    CreateDynamicObject(2208,902.45117188,-1951.60253906,2.33086634,0.00000000,0.00000000,180.00000000, .interiorid = 0, .worldid = 0); //object(med_office7_unit_1) (1)
    CreateDynamicObject(1679,892.98876953,-1941.45812988,1.24817979,0.00000000,0.00000000,40.00000000, .interiorid = 0, .worldid = 0); //object(chairsntableml) (1)
    CreateDynamicObject(1679,896.56787109,-1938.58435059,1.24817979,0.00000000,0.00000000,13.99572754, .interiorid = 0, .worldid = 0); //object(chairsntableml) (2)
    CreateDynamicObject(1679,899.41070557,-1941.86669922,1.24817979,0.00000000,0.00000000,13.99108887, .interiorid = 0, .worldid = 0); //object(chairsntableml) (3)
    CreateDynamicObject(1679,902.35266113,-1938.65441895,1.24817979,0.00000000,0.00000000,49.99108887, .interiorid = 0, .worldid = 0); //object(chairsntableml) (4)
    CreateDynamicObject(1679,905.06500244,-1941.76110840,1.24817979,0.00000000,0.00000000,49.98779297, .interiorid = 0, .worldid = 0); //object(chairsntableml) (5)
    CreateDynamicObject(1679,908.63079834,-1938.49609375,1.24817979,0.00000000,0.00000000,59.98779297, .interiorid = 0, .worldid = 0); //object(chairsntableml) (6)
    CreateDynamicObject(1679,911.64404297,-1942.41943359,1.24817979,0.00000000,0.00000000,59.98535156, .interiorid = 0, .worldid = 0); //object(chairsntableml) (7)
    CreateDynamicObject(1679,913.82556152,-1939.29858398,1.24817979,0.00000000,0.00000000,89.98535156, .interiorid = 0, .worldid = 0); //object(chairsntableml) (8)
    CreateDynamicObject(1679,914.98559570,-1944.39099121,1.24817979,0.00000000,0.00000000,89.98352051, .interiorid = 0, .worldid = 0); //object(chairsntableml) (9)
    CreateDynamicObject(1679,890.00897217,-1938.08886719,1.24817979,0.00000000,0.00000000,69.98352051, .interiorid = 0, .worldid = 0); //object(chairsntableml) (10)
    CreateDynamicObject(1679,888.64892578,-1942.12878418,1.24817979,0.00000000,0.00000000,89.98291016, .interiorid = 0, .worldid = 0); //object(chairsntableml) (11)
    CreateDynamicObject(1548,895.05920410,-1945.47692871,1.75211847,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cj_drip_tray) (1)
    CreateDynamicObject(1548,905.63739014,-1945.44067383,1.75211847,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(cj_drip_tray) (2)
    CreateDynamicObject(1541,895.06408691,-1945.89221191,1.93585563,0.00000000,0.00000000,180.00000000, .interiorid = 0, .worldid = 0); //object(cj_beer_taps_1) (1)
    CreateDynamicObject(1541,905.66339111,-1945.90209961,1.93585563,0.00000000,0.00000000,179.99450684, .interiorid = 0, .worldid = 0); //object(cj_beer_taps_1) (2)
    CreateDynamicObject(3472,818.81402588,-1807.13354492,11.84890175,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(circuslampost03) (1)
    CreateDynamicObject(3472,843.26812744,-1807.18762207,11.84890175,0.00000000,0.00000000,296.00000000, .interiorid = 0, .worldid = 0); //object(circuslampost03) (2)
    CreateDynamicObject(3472,849.29827881,-1845.59948730,11.84890175,0.00000000,0.00000000,295.99914551, .interiorid = 0, .worldid = 0); //object(circuslampost03) (3)
    CreateDynamicObject(3472,823.89477539,-1845.64270020,11.84890175,0.00000000,0.00000000,231.99914551, .interiorid = 0, .worldid = 0); //object(circuslampost03) (4)
    CreateDynamicObject(3472,824.39819336,-1884.19836426,11.84890175,0.00000000,0.00000000,231.99830627, .interiorid = 0, .worldid = 0); //object(circuslampost03) (5)
    CreateDynamicObject(3472,849.47857666,-1884.16845703,11.84890175,0.00000000,0.00000000,173.99829102, .interiorid = 0, .worldid = 0); //object(circuslampost03) (6)
    CreateDynamicObject(3472,850.01501465,-1927.66625977,11.84890175,0.00000000,0.00000000,173.99597168, .interiorid = 0, .worldid = 0); //object(circuslampost03) (7)
    CreateDynamicObject(3472,822.60150146,-1927.65551758,11.84890175,0.00000000,0.00000000,357.99603271, .interiorid = 0, .worldid = 0); //object(circuslampost03) (8)
    CreateDynamicObject(3472,823.11248779,-1970.20446777,11.84890175,0.00000000,0.00000000,357.99499512, .interiorid = 0, .worldid = 0); //object(circuslampost03) (9)
    CreateDynamicObject(3472,849.84454346,-1970.19946289,11.84890175,0.00000000,0.00000000,179.99499512, .interiorid = 0, .worldid = 0); //object(circuslampost03) (10)
    CreateDynamicObject(3472,849.00097656,-2012.34472656,11.84890175,0.00000000,0.00000000,179.99450684, .interiorid = 0, .worldid = 0); //object(circuslampost03) (11)
    CreateDynamicObject(3472,822.55975342,-2012.35339355,11.84890175,0.00000000,0.00000000,357.99453735, .interiorid = 0, .worldid = 0); //object(circuslampost03) (12)
    CreateDynamicObject(3872,910.96838379,-1922.64868164,6.44934368,0.00000000,0.00000000,334.00000000, .interiorid = 0, .worldid = 0); //object(ws_floodbeams) (1)
    CreateDynamicObject(3872,890.99884033,-1922.28283691,6.44934368,0.00000000,0.00000000,207.99534607, .interiorid = 0, .worldid = 0); //object(ws_floodbeams) (2)
    CreateDynamicObject(3872,901.30419922,-1921.90270996,6.44934368,0.00000000,0.00000000,269.99319458, .interiorid = 0, .worldid = 0); //object(ws_floodbeams) (3)
    CreateDynamicObject(2232,914.25805664,-1925.78515625,2.89085293,0.00000000,0.00000000,213.74865723, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (45)
    CreateDynamicObject(2232,913.67150879,-1926.16772461,2.89085293,0.00000000,0.00000000,213.74450684, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (46)
    CreateDynamicObject(2232,913.09118652,-1926.55908203,2.89085293,0.00000000,0.00000000,213.74450684, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (47)
    CreateDynamicObject(2232,914.25781250,-1925.78515625,4.01585722,0.00000000,0.00000000,213.74450684, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (48)
    CreateDynamicObject(2232,913.67089844,-1926.16699219,4.01585722,0.00000000,0.00000000,213.74450684, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (49)
    CreateDynamicObject(2232,913.09082031,-1926.55859375,4.01585245,0.00000000,0.00000000,213.74450684, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (50)
    CreateDynamicObject(2232,889.22766113,-1925.93420410,2.89085293,0.00000000,0.00000000,146.25552368, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (51)
    CreateDynamicObject(2232,889.79516602,-1926.30920410,2.89085293,0.00000000,0.00000000,146.25000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (52)
    CreateDynamicObject(2232,888.66052246,-1925.54223633,2.89085293,0.00000000,0.00000000,146.25000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (53)
    CreateDynamicObject(2232,888.66015625,-1925.54199219,4.09084892,0.00000000,0.00000000,146.25000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (54)
    CreateDynamicObject(2232,889.22753906,-1925.93359375,4.09085655,0.00000000,0.00000000,146.25000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (55)
    CreateDynamicObject(2232,889.79492188,-1926.30859375,4.09085274,0.00000000,0.00000000,146.25000000, .interiorid = 0, .worldid = 0); //object(med_speaker_4) (56)
    CreateDynamicObject(3657,915.63952637,-1907.91259766,0.72758627,0.00000000,0.00000000,354.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (1)
    CreateDynamicObject(3657,911.96911621,-1907.52270508,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (2)
    CreateDynamicObject(3657,908.31396484,-1907.13574219,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (3)
    CreateDynamicObject(3657,908.52178955,-1905.24328613,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (4)
    CreateDynamicObject(3657,912.18212891,-1905.63012695,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (5)
    CreateDynamicObject(3657,915.84979248,-1906.00793457,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (6)
    CreateDynamicObject(3657,916.17205811,-1904.00708008,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (7)
    CreateDynamicObject(3657,912.49865723,-1903.62036133,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (8)
    CreateDynamicObject(3657,908.83001709,-1903.23303223,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (9)
    CreateDynamicObject(3657,916.38800049,-1901.98693848,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (10)
    CreateDynamicObject(3657,912.71997070,-1901.60095215,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (11)
    CreateDynamicObject(3657,909.05145264,-1901.21398926,0.72758627,0.00000000,0.00000000,353.99597168, .interiorid = 0, .worldid = 0); //object(airseata_las) (12)
    CreateDynamicObject(3657,903.22326660,-1906.97070312,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (13)
    CreateDynamicObject(3657,899.56903076,-1906.97094727,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (14)
    CreateDynamicObject(3657,903.20324707,-1905.01696777,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (15)
    CreateDynamicObject(3657,899.50689697,-1905.02075195,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (16)
    CreateDynamicObject(3657,903.18334961,-1903.04077148,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (17)
    CreateDynamicObject(3657,899.50640869,-1903.04003906,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (18)
    CreateDynamicObject(3657,903.18493652,-1901.10729980,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (19)
    CreateDynamicObject(3657,899.50872803,-1901.10705566,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (20)
    CreateDynamicObject(3657,894.52685547,-1907.16552734,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (21)
    CreateDynamicObject(3657,890.88244629,-1907.55004883,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (22)
    CreateDynamicObject(3657,887.27697754,-1907.92382812,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (23)
    CreateDynamicObject(3657,894.24768066,-1905.31030273,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (24)
    CreateDynamicObject(3657,890.61663818,-1905.68872070,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (25)
    CreateDynamicObject(3657,886.96075439,-1906.07202148,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (26)
    CreateDynamicObject(3657,893.95458984,-1903.25390625,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (27)
    CreateDynamicObject(3657,890.28991699,-1903.64013672,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (28)
    CreateDynamicObject(3657,886.63421631,-1904.02502441,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (29)
    CreateDynamicObject(3657,893.71301270,-1901.26721191,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (30)
    CreateDynamicObject(3657,890.06103516,-1901.65100098,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (31)
    CreateDynamicObject(3657,886.39898682,-1902.03820801,0.72758627,0.00000000,0.00000000,6.00402832, .interiorid = 0, .worldid = 0); //object(airseata_las) (32)
    CreateDynamicObject(3657,903.17736816,-1899.19531250,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (33)
    CreateDynamicObject(3657,899.49041748,-1899.19494629,0.72758627,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(airseata_las) (34)
    CreateDynamicObject(1679,890.49707031,-1931.85717773,2.82318115,0.00000000,0.00000000,89.98291016, .interiorid = 0, .worldid = 0); //object(chairsntableml) (12)
    CreateDynamicObject(1679,895.17340088,-1932.97534180,2.82318115,0.00000000,0.00000000,61.97802734, .interiorid = 0, .worldid = 0); //object(chairsntableml) (13)
    CreateDynamicObject(1679,899.23352051,-1931.38671875,2.82318115,0.00000000,0.00000000,61.97387695, .interiorid = 0, .worldid = 0); //object(chairsntableml) (14)
    CreateDynamicObject(1679,903.35272217,-1933.21435547,2.82318115,0.00000000,0.00000000,91.97387695, .interiorid = 0, .worldid = 0); //object(chairsntableml) (15)
    CreateDynamicObject(1679,907.82019043,-1931.55761719,2.82318115,0.00000000,0.00000000,63.97204590, .interiorid = 0, .worldid = 0); //object(chairsntableml) (16)
    CreateDynamicObject(1679,912.22692871,-1932.90625000,2.82318115,0.00000000,0.00000000,93.96789551, .interiorid = 0, .worldid = 0); //object(chairsntableml) (17)
    CreateDynamicObject(3361,882.95025635,-1938.25549316,0.22387430,0.00000000,0.00000000,270.00000000, .interiorid = 0, .worldid = 0); //object(cxref_woodstair) (3)
    CreateDynamicObject(3361,919.09655762,-1938.12207031,0.22387430,0.00000000,0.00000000,269.99450684, .interiorid = 0, .worldid = 0); //object(cxref_woodstair) (4)
    CreateDynamicObject(18646,903.60467529,-1952.70678711,1.60312152,90.00000000,180.00000000,180.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (17)
    CreateDynamicObject(18646,888.02288818,-1965.18347168,0.47812298,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (18)
    CreateDynamicObject(18646,898.90771484,-1952.72583008,1.60312152,90.00000000,179.99450684,179.99450684, .interiorid = 0, .worldid = 0); //object(girders11) (19)
    CreateDynamicObject(18646,897.72473145,-1963.97497559,0.47812298,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (20)
    CreateDynamicObject(18646,909.78955078,-1964.15429688,0.47812298,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (21)
    CreateDynamicObject(18646,916.16113281,-1964.04199219,0.47812298,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (22)
    CreateDynamicObject(18646,897.95635986,-1952.13549805,2.45311999,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (23)
    CreateDynamicObject(18646,904.58666992,-1952.16052246,2.45311999,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (24)
    CreateDynamicObject(18646,889.18176270,-1922.88012695,1.35312271,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (25)
    CreateDynamicObject(18646,913.77416992,-1923.12988281,1.35312271,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (26)
    CreateDynamicObject(18646,901.21057129,-1923.10363770,1.35312271,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(girders11) (27)
    CreateDynamicObject(18653,912.25701904,-1927.28125000,2.25937295,0.00000000,0.00000000,298.00000000, .interiorid = 0, .worldid = 0); //object(chairs) (4)
    CreateDynamicObject(18653,890.36798096,-1927.30908203,2.25937295,0.00000000,0.00000000,234.00134277, .interiorid = 0, .worldid = 0); //object(chairs) (5)
    CreateDynamicObject(18655,916.49182129,-1924.96362305,2.33437371,0.00000000,0.00000000,328.75000000, .interiorid = 0, .worldid = 0); //object(carter-stairs01) (5)
    CreateDynamicObject(18655,886.06799316,-1925.57666016,2.33437371,0.00000000,0.00000000,209.24938965, .interiorid = 0, .worldid = 0); //object(carter-stairs01) (6)
    CreateDynamicObject(3472,895.17828369,-1885.05371094,3.32390642,0.00000000,0.00000000,197.99598694, .interiorid = 0, .worldid = 0); //object(circuslampost03) (14)
    CreateDynamicObject(3472,910.40289307,-1885.93823242,2.89890480,0.00000000,0.00000000,243.99562073, .interiorid = 0, .worldid = 0); //object(circuslampost03) (15)
    CreateDynamicObject(3472,928.15441895,-1885.91479492,2.923904895,0.00000000,0.00000000,297.99536133, .interiorid = 0, .worldid = 0); //object(circuslampost03) (16)
    CreateDynamicObject(3472,879.29132080,-1885.28588867,2.848904609,0.00000000,0.00000000,297.99316406, .interiorid = 0, .worldid = 0); //object(circuslampost03) (17)
    CreateDynamicObject(3472,850.99951172,-2055.83618164,11.84890175,0.00000000,0.00000000,179.99450684, .interiorid = 0, .worldid = 0); //object(circuslampost03) (11)
    CreateDynamicObject(3472,822.14599609,-2055.87963867,11.84890175,0.00000000,0.00000000,7.99450684, .interiorid = 0, .worldid = 0); //object(circuslampost03) (11)
    CreateDynamicObject(18761,837.35357666,-2033.33276367,16.19213867,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(thebowl17) (6)
    CreateDynamicObject(1342,825.93811035,-2050.41772461,12.90088081,0.00000000,0.00000000,28.00000000, .interiorid = 0, .worldid = 0); //object(noodlecart_prop) (1)
    CreateDynamicObject(1341,826.12731934,-2040.34082031,12.86977386,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(icescart_prop) (1)
    CreateDynamicObject(1340,847.68499756,-2042.35974121,12.99477386,0.00000000,0.00000000,180.00000000, .interiorid = 0, .worldid = 0); //object(chillidogcart) (1)
    CreateDynamicObject(2600,846.79663086,-2067.06274414,12.63945961,0.00000000,0.00000000,16.00000000, .interiorid = 0, .worldid = 0); //object(cj_view_tele) (1)
    CreateDynamicObject(2600,842.43493652,-2066.89135742,12.63945961,0.00000000,0.00000000,351.99609375, .interiorid = 0, .worldid = 0); //object(cj_view_tele) (2)
    CreateDynamicObject(2600,838.57409668,-2067.00756836,12.63945961,0.00000000,0.00000000,5.99096680, .interiorid = 0, .worldid = 0); //object(cj_view_tele) (3)
    CreateDynamicObject(2600,835.27758789,-2067.11401367,12.63945961,0.00000000,0.00000000,5.98754883, .interiorid = 0, .worldid = 0); //object(cj_view_tele) (4)
    CreateDynamicObject(2600,831.99511719,-2066.91967773,12.63945961,0.00000000,0.00000000,347.98754883, .interiorid = 0, .worldid = 0); //object(cj_view_tele) (5)
    CreateDynamicObject(2600,828.17150879,-2066.86474609,12.63945961,0.00000000,0.00000000,5.98645020, .interiorid = 0, .worldid = 0); //object(cj_view_tele) (6)
    CreateDynamicObject(2600,824.06604004,-2066.92871094,12.63945961,0.00000000,0.00000000,341.98205566, .interiorid = 0, .worldid = 0); //object(cj_view_tele) (7)
    CreateDynamicObject(1243,902.65258789,-2022.15783691,-2.99999523,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(bouy) (1)
    CreateDynamicObject(1243,901.79003906,-2064.27343750,-2.99999523,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(bouy) (3)
    CreateDynamicObject(18766,810.73730469,-2173.00805664,-0.19062607,90.00000000,180.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,820.75115967,-2173.00805664,-0.19062607,90.00000000,180.00549316,359.98901367, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,830.62042236,-2173.00805664,-0.19062607,90.00000000,180.00549316,359.98352051, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,840.25408936,-2173.00805664,-0.19062607,90.00000000,179.99450684,359.99447632, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,850.00738525,-2173.00805664,-0.19062607,90.00000000,180.00549316,359.97805786, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,859.54956055,-2173.00805664,-0.19062607,90.00000000,180.00549316,359.97805786, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,869.16625977,-2173.00805664,-0.19062607,90.00000000,179.99450684,359.98901367, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,879.16082764,-2173.00805664,-0.19062607,90.00000000,179.99450684,359.98352051, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,888.57092285,-2173.00805664,-0.19062607,90.00000000,179.99450684,359.98352051, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,898.40612793,-2173.00805664,-0.19062607,90.00000000,179.99450684,359.98352051, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(18766,908.05346680,-2173.00805664,-0.19062607,90.00000000,179.99450684,359.98352051, .interiorid = 0, .worldid = 0); //object(inner) (30)
    CreateDynamicObject(1342,847.55895996,-2049.11132812,12.90088081,0.00000000,0.00000000,169.99865723, .interiorid = 0, .worldid = 0); //object(noodlecart_prop) (2)
    CreateDynamicObject(14820,901.20416260,-1951.58654785,3.19615960,0.00000000,0.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(dj_stuff) (1)
    CreateDynamicObject(19279,909.86730957,-1917.97656250,2.57845974,0.00000000,0.00000000,148.00000000, .interiorid = 0, .worldid = 0); //object(des_rockgp1_03) (1)
    CreateDynamicObject(19279,907.81359863,-1917.29772949,2.57845974,0.00000000,0.00000000,173.99841309, .interiorid = 0, .worldid = 0); //object(des_rockgp1_03) (3)
    CreateDynamicObject(19279,905.94146729,-1917.17785645,2.57845974,0.00000000,0.00000000,177.99597168, .interiorid = 0, .worldid = 0); //object(des_rockgp1_03) (4)
    CreateDynamicObject(19279,897.60418701,-1917.26989746,2.57845974,0.00000000,0.00000000,177.99499512, .interiorid = 0, .worldid = 0); //object(des_rockgp1_03) (5)
    CreateDynamicObject(19279,895.64678955,-1917.37280273,2.57845974,0.00000000,0.00000000,187.99499512, .interiorid = 0, .worldid = 0); //object(des_rockgp1_03) (6)
    CreateDynamicObject(19279,893.70391846,-1917.84826660,2.57845974,0.00000000,0.00000000,213.99255371, .interiorid = 0, .worldid = 0); //object(des_rockgp1_03) (7)
    CreateDynamicObject(3440,908.71069336,-1928.74560547,11.91092110,0.00000000,91.24990845,0.00000000, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (1)
    CreateDynamicObject(3440,908.77398682,-1928.80395508,13.36089897,0.00018311,135.24682617,359.24975586, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (2)
    CreateDynamicObject(3440,908.75988770,-1928.75842285,15.73589706,0.00000000,67.24148560,359.99450684, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (3)
    CreateDynamicObject(3440,904.36584473,-1928.80261230,14.36090279,0.00000000,0.00000000,359.99450684, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (4)
    CreateDynamicObject(3440,902.56109619,-1928.74426270,12.63593292,0.00000000,90.00000000,0.00000000, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (5)
    CreateDynamicObject(3440,902.55517578,-1928.72998047,16.91093254,0.00000000,91.24694824,0.00000000, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (6)
    CreateDynamicObject(3440,900.68627930,-1928.84606934,14.36090279,0.00000000,0.00000000,359.98901367, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (7)
    CreateDynamicObject(3440,897.65820312,-1928.69604492,13.66091347,0.00000000,0.00000000,359.98901367, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (8)
    CreateDynamicObject(3440,897.65820312,-1928.69531250,14.71092415,0.00000000,0.00000000,359.98901367, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (9)
    CreateDynamicObject(3440,893.67413330,-1928.84179688,11.91092110,0.00000000,91.24694824,0.00000000, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (10)
    CreateDynamicObject(3440,893.82635498,-1928.87854004,13.36089897,0.00000000,135.24169922,359.24743652, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (11)
    CreateDynamicObject(3440,893.74420166,-1928.80957031,15.73589706,0.00000000,67.23632812,359.99450684, .interiorid = 0, .worldid = 0); //object(arptpillar01_lvs) (12)
}
