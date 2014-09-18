#include <a_samp>
#include <streamer>

public OnFilterScriptExit()
{
    for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0) TogglePlayerControllable(i, false);
	}
}

public OnFilterScriptInit()
{
    for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0) TogglePlayerControllable(i, false);
	}

///////Mapping
	//Richard_Diaz Custom coding 48195
    CreateDynamicObject(6300, -404.5, 296.10000610352, -7, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(6300, -465, 302.5, -7, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -372.10000610352, 316.5, 1.8999999761581, 0, 0, 264, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -372.89999389648, 308.79998779297, 1.8999999761581, 0, 0, 263.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -385.10000610352, 332.70001220703, 1.8999999761581, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -388.7998046875, 295.7998046875, 1.8999999761581, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -431.10000610352, 300.39999389648, 2, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -460.39999389648, 303.5, 2, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3749, -410.3994140625, 296.3994140625, 6.9000000953674, 0, 0, 353.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -414.5, 335.79998779297, 1.8999999761581, 0, 0, 173.74597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -444, 339, 1.7999999523163, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -473.3994140625, 342.099609375, 1.7999999523163, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3524, -404.3994140625, 293.3994140625, 3.7000000476837, 0, 0, 353.49609375, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3524, -416.89999389648, 294.60000610352, 3.7000000476837, 0, 0, 355.5, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -393.60000610352, 296, 3.7000000476837, 0, 0, 314, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -380.89999389648, 294.70001220703, 3.7000000476837, 0, 0, 313.99475097656, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -373.5, 301.099609375, 3.7000000476837, 0, 0, 44.247436523438, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -372.10000610352, 314.70001220703, 3.7000000476837, 0, 0, 43.994750976563, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -371, 324.60000610352, 3.7000000476837, 0, 0, 43.994750976563, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -376.79998779297, 331.79998779297, 3.7000000476837, 0, 0, 313.99475097656, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -390.39999389648, 333.29998779297, 3.7000000476837, 0, 0, 313.99475097656, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -404.10000610352, 334.79998779297, 3.5999999046326, 0, 0, 313.99475097656, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -417.70001220703, 336.20001220703, 3.5999999046326, 0, 0, 313.99475097656, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -431.29998779297, 337.60000610352, 3.5999999046326, 0, 0, 313.99475097656, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -445, 339.10000610352, 3.5999999046326, 0, 0, 313.99475097656, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -458.599609375, 340.5, 3.5999999046326, 0, 0, 313.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -472.29998779297, 342, 3.5999999046326, 0, 0, 313.99475097656, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -478, 305.29998779297, 2, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -426.19921875, 299.69921875, 3.7999999523163, 0, 0, 313.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -439.89999389648, 301, 3.7999999523163, 0, 0, 313.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -453.60000610352, 302.5, 3.7999999523163, 0, 0, 313.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -467.29998779297, 303.79998779297, 3.7999999523163, 0, 0, 313.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -480.89999389648, 305.20001220703, 3.7999999523163, 0, 0, 313.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -476.39999389648, 342.39999389648, 1.7999999523163, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3525, -417.89999389648, 299.39999389648, 4.9000000953674, 0, 0, 174, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3525, -402.5, 297.89999389648, 4.8000001907349, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -480.29998779297, 305.39999389648, 2.0999999046326, 0, 0, 173.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -484.099609375, 343.2998046875, 3.5999999046326, 0, 0, 313.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -487.89999389648, 306, 3.7999999523163, 0, 0, 313.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3524, -482.5, 317.79998779297, 2.9000000953674, 0, 0, 83.490600585938, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3524, -482.89999389648, 314.20001220703, 2.9000000953674, 0, 0, 83.485107421875, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3471, -482.5, 314.20001220703, 2.2999999523163, 0, 0, 353.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3471, -482.29998779297, 317.79998779297, 2.2999999523163, 0, 0, 353.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(14707, -364.20001220703, 349.39999389648, 667.5, 0, 0, 249.99499511719, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1337, -413.89999389648, 207.60000610352, -10, 356.05999755859, 22.054901123047, 189.84460449219, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1337, -416.20001220703, 207.30000305176, -9.1999998092651, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1337, -414.29998779297, 207.5, -9.1999998092651, 0, 358, 178, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1337, -415.20001220703, 207.30000305176, -9.3000001907349, 0, 271.99996948242, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1337, -415, 207.30000305176, -9.8999996185303, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(10010, -217.60000610352, 442.89999389648, 1668, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3606, -488.20001220703, 316.60000610352, 4.4000000953674, 0, 0, 84, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3604, -486.89999389648, 335.29998779297, 3.0999999046326, 0, 0, 83.999938964844, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -492.79998779297, 329.29998779297, 1.7999999523163, 0, 0, 263.99597167969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(8652, -493.29998779297, 321.60000610352, 1.7999999523163, 0, 0, 83.995941162109, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -492.10000610352, 336.89999389648, 3.5999999046326, 0, 0, 223.9892578125, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -493.39999389648, 325.39999389648, 3.5999999046326, 0, 0, 223.98376464844, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(4100, -494.39999389648, 313.70001220703, 3.5999999046326, 0, 0, 223.98376464844, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(362, -382, 354.20001220703, 664.40002441406, 0, 28, 60, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(361, -382.29998779297, 353.60000610352, 664.29998779297, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(370, -382.5, 353.70001220703, 664.29998779297, 0, 0, 340, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(373, -382.60000610352, 351.29998779297, 664.90002441406, 355.30773925781, 305.73394775391, 357.51333618164, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(360, -382.39999389648, 352.29998779297, 664.29998779297, 0, 328, 261.99996948242, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(351, -382.79998779297, 350.79998779297, 664.59997558594, 0, 0, 255.99996948242, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3066, -382.60000610352, 353.89999389648, 663, 0, 0, 340, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(14399, -365.5, 362, 662.79998779297, 0, 0, 158.99987792969, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1484, -366.20001220703, 360.89999389648, 664.20001220703, 0, 115.99993896484, 191.99995422363, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1829, -351.70001220703, 342.60000610352, 663.29998779297, 0, 0, 254, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1829, -351.60000610352, 344.5, 663.40002441406, 0, 0, 275.99841308594, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(1829, -353, 341, 663.40002441406, 0, 0, 187.99841308594, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(14467, -357.20001220703, 359.39999389648, 664.90002441406, 0, 0, 290, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(3524, -356.79998779297, 359.79998779297, 664, 0, 0, 268, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(2946, -377.89999389648, 354.70001220703, 667.20001220703, 0, 0, 340, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(658, -396.60000610352, 295.39999389648, 0.80000001192093, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(658, -483.89999389648, 326.79998779297, 1, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(658, -375.10000610352, 295, 0.89999997615814, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(658, -371.29998779297, 330.79998779297, 1.2000000476837, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(658, -420.5, 299, 0.80000001192093, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(658, -490.70001220703, 343.5, 0.40000000596046, 0, 0, 0, .worldid = 0, .streamdistance =200);
    CreateDynamicObject(658, -493.89999389648, 307.39999389648, 1.5, 0, 0, 0, .worldid = 0, .streamdistance =200);

	//Liam_Wallinger custom coding 44242
    CreateDynamicObject(5428, 3198.6005859375, -1995.2294921875, 2.5, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3599, 3189.3701171875, -1995.0234375, 8.0823402404785, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(671, 3207.953125, -2005.53125, 2.040712594986, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3179.482421875, -1970.712890625, 16.836765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3177.9658203125, -2007.2294921875, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3177.9677734375, -2018.9345703125, 16.836765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3178.732421875, -1982.2646484375, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8172, 3214.8662109375, -2053.96484375, 3.4997730255127, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3196.2255859375, -2034.126953125, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3180.2297363281, -2034.1394042969, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3164.2509765625, -2034.1494140625, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3211.9990234375, -2034.119140625, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(14394, 3189.1140136719, -2032.8383789063, 2.6333775520325, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8658, 3185.1616210938, -2046.5096435547, 2.4812135696411, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8658, 3193.1057128906, -2046.1940917969, 2.4812135696411, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3166.546875, -2026.0029296875, 0.52748668193817, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3169.181640625, -2029.4013671875, -2.1225073337555, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3169.1904296875, -2013.412109375, -2.1225073337555, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3166.5478515625, -2010.0224609375, 0.52748668193817, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3173.2600097656, -1955.6107177734, -1.7250002622604, 44.75, 0, 353.99633789063, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3181.9113769531, -1954.2706298828, -3.3249998092651, 44.75, 0, 33.995971679688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3223.7761230469, -2027.9918212891, -1.8249996900558, 0, 0, 245.97839355469, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3223.2180175781, -2030.1860351563, -1.1999998092651, 0, 0, 149.97839355469, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3186.0451660156, -1953.1419677734, -3.4250001907349, 110.74731445313, 122, 165.99169921875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3192.9870605469, -1952.7830810547, -3.4250001907349, 110.7421875, 121.99768066406, 235.98693847656, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3198.1098632813, -1953.2919921875, -3.4250001907349, 110.7421875, 121.99768066406, 153.986328125, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3205.8952636719, -1955.5384521484, -3.4250001907349, 110.7421875, 121.99768066406, 25.984375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3211.1457519531, -1954.03125, -3.4250001907349, 110.7421875, 121.99768066406, 209.98266601563, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3217.0659179688, -1954.0231933594, -3.4250001907349, 110.7421875, 121.99768066406, 209.98168945313, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3223.0654296875, -1954.013671875, -3.4250001907349, 110.7421875, 121.99768066406, 171.98168945313, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3229.3188476563, -1957.5045166016, -3.4250001907349, 110.7421875, 121.99768066406, 171.97998046875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3228.7797851563, -1963.4992675781, -3.4250001907349, 110.7421875, 121.99768066406, 87.97998046875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3228.1691894531, -1969.865234375, -3.4250001907349, 110.7421875, 121.99768066406, 275.978515625, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3228.3037109375, -1975.865234375, -3.4250001907349, 110.7421875, 121.99768066406, 275.9765625, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3227.5297851563, -1981.5131835938, -3.4250001907349, 110.7421875, 121.99768066406, 189.9765625, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3228.89453125, -1985.771484375, -3.4250001907349, 110.7421875, 121.99768066406, 63.9755859375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3225.1103515625, -2005.5712890625, -3.4250001907349, 110.7421875, 121.99768066406, 299.97106933594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3224.1376953125, -2011.3212890625, -3.4250001907349, 110.7421875, 121.99768066406, 83.970703125, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3224.494140625, -2018.208984375, -3.4250001907349, 110.7421875, 121.99768066406, 83.968505859375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3168.962890625, -1958.5458984375, -1.7250002622604, 44.747314453125, 0, 81.990966796875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3166.9794921875, -1965.5493164063, -1.7250002622604, 44.747314453125, 0, 21.990966796875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3167.2436523438, -1971.2974853516, -1.7250002622604, 44.747314453125, 0, 245.98913574219, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3167.1088867188, -1980.9952392578, -1.7250002622604, 44.747314453125, 0, 103.98388671875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3165.3249511719, -1987.0310058594, -1.7250002622604, 44.747314453125, 0, 25.980102539063, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3165.0202636719, -1993.3173828125, -1.7250002622604, 44.747314453125, 0, 207.97717285156, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3164.3479003906, -1998.4312744141, -1.1000003814697, 44.747314453125, 0, 353.97155761719, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3164.8818359375, -2002.73046875, -1.6000003814697, 44.747314453125, 0, 357.96752929688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11495, 3150.9992675781, -2009.4631347656, 0.49631789326668, 0, 0, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11495, 3151.0139160156, -2020.3800048828, 0.49631789326668, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11495, 3151.0798339844, -2032.9382324219, 0.49631789326668, 0, 0, 269.99450683594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3148.2568359375, -2034.1467285156, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3142.080078125, -2034.23046875, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3181.35546875, -2016.4007568359, 4.9507060050964, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3181.1586914063, -2009.0443115234, 4.9507060050964, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3196.7204589844, -2009.1068115234, 4.9507060050964, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3196.2280273438, -2016.6135253906, 4.9507060050964, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3208.9104003906, -2016.0504150391, 4.9507060050964, 0, 0, 24, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3206.7250976563, -2008.7556152344, 4.9507060050964, 0, 0, 23.999633789063, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3212.5725097656, -2002.3176269531, 4.9507060050964, 0, 0, 65.999633789063, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3219.3813476563, -2003.8979492188, 4.9507060050964, 0, 0, 65.994873046875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3220.9555664063, -1991.7060546875, 4.9507060050964, 0, 0, 83.994873046875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3213.8098144531, -1991.3292236328, 4.9507060050964, 0, 0, 83.990478515625, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3211.5483398438, -1981.4205322266, 4.9507060050964, 0, 0, 127.99047851563, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3216.5283203125, -1976.5704345703, 4.9507060050964, 0, 0, 127.98522949219, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3203.3415527344, -1973.412109375, 4.9507060050964, 0, 0, 178.98522949219, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3203.1137695313, -1980.25, 4.9507060050964, 0, 0, 178.98376464844, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3188.3076171875, -1980.1929931641, 4.9507060050964, 0, 0, 178.98376464844, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3188.021484375, -1973.5189208984, 4.9507060050964, 0, 0, 178.98376464844, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3172.0849609375, -1973.4814453125, 4.9507060050964, 0, 0, 178.97827148438, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1231, 3172.2351074219, -1980.3067626953, 4.9507060050964, 0, 0, 178.98376464844, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(14394, 3167.892578125, -2012.990234375, 1.5058156251907, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2765, 3166.6979980469, -2008.5235595703, 0.72748506069183, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2765, 3168.6906738281, -2009.4670410156, 0.72748506069183, 0, 0, 180, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2765, 3166.7055664063, -2008.5238037109, 1.2774850130081, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2765, 3168.6904296875, -2009.466796875, 1.277484536171, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2765, 3166.5041503906, -2016.5493164063, 0.72748506069183, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2765, 3168.4814453125, -2017.5017089844, 0.72748506069183, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2765, 3168.4814453125, -2017.5009765625, 1.3024845123291, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2765, 3166.50390625, -2016.548828125, 1.3024845123291, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4242, 3209.369140625, -2005.6589355469, -3.2493858337402, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3170.3215332031, -2018.9919433594, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3170.3088378906, -2023.3464355469, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3170.4235839844, -2028.1401367188, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3170.3447265625, -2033.3173828125, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3173.3334960938, -1961.6752929688, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3171.2182617188, -1967.8677978516, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3172.8698730469, -1964.9920654297, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3176.6840820313, -1960.28515625, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(9833, 3174.8530273438, -1963.0609130859, 4.3697319030762, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3179.3200683594, -1958.1148681641, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(869, 3178.2412109375, -1959.4088134766, 2.6920096874237, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(869, 3174.5620117188, -1960.5086669922, 2.6920096874237, 0, 0, 20, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(869, 3172.625, -1963.18359375, 2.6920096874237, 0, 0, 63.9951171875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(869, 3172.0952148438, -1966.3765869141, 2.6920096874237, 0, 0, 63.989868164063, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1280, 3186.54296875, -1956.8017578125, 2.643542766571, 0, 0, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1504, 3183.0009765625, -2003.0986328125, 2.319442987442, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1504, 3194.9921875, -1987.353515625, 2.2694427967072, 0, 0, 88.74755859375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3182.9907226563, -2033.9935302734, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3178.7646484375, -2033.9906005859, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3174.5620117188, -2033.9881591797, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3170.3608398438, -2033.9844970703, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3166.13671875, -2033.9810791016, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3161.9379882813, -2033.9769287109, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3195.3295898438, -2034.0556640625, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3199.6042480469, -2034.0327148438, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3203.8532714844, -2034.0599365234, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3208.2036132813, -2034.060546875, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3212.4028320313, -2034.0637207031, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(970, 3216.6486816406, -2034.0422363281, 4.0445003509521, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3215.9931640625, -2029.0710449219, 6.9072937965393, 0, 0, 42, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3216.1359863281, -2031.9425048828, 16.661767959595, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3213.81640625, -2032.1633300781, 6.9072937965393, 0, 0, 317.99523925781, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(869, 3215.8278808594, -2029.3758544922, 2.4126081466675, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(869, 3214.3842773438, -2030.7758789063, 2.4126081466675, 0, 0, 49.5, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(869, 3214.1240234375, -2032.7587890625, 1.9876066446304, 0, 0, 49.498901367188, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(869, 3216.3764648438, -2032.5236816406, 2.4376082420349, 0, 0, 49.498901367188, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(745, 3205.587890625, -2026.6877441406, 1.8912220001221, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3461, 3174.6203613281, -1999.8216552734, 0.69486474990845, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3461, 3174.6584472656, -2000.3256835938, 0.69486474990845, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3461, 3174.0947265625, -1999.7878417969, 0.69486474990845, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3461, 3174.1650390625, -2000.3375244141, 0.69486474990845, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1463, 3174.5510253906, -1999.7495117188, 2.5465886592865, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3222.1967773438, -1961.6911621094, 15.336765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3216.1086425781, -1958.4925537109, 15.336765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3214.1528320313, -1964.0131835938, 15.336765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3222.1784667969, -1967.7083740234, 15.336765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3217.1948242188, -1970.0837402344, 15.336765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3210.4072265625, -1970.4604492188, 15.336765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(710, 3222.6264648438, -1971.8054199219, 15.336765289307, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3211.6713867188, -1967.0374755859, 6.9072937965393, 0, 0, 41.995239257813, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3218.404296875, -1965.1196289063, 6.9072937965393, 0, 0, 41.995239257813, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3211.0556640625, -1959.4111328125, 6.9072937965393, 0, 0, 41.98974609375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3219.2761230469, -1973.2905273438, 6.9072937965393, 0, 0, 41.995239257813, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(758, 3214.779296875, -1970.2900390625, 2.0190060138702, 0, 0, 1.99951171875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3211.0434570313, -1959.2147216797, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3211.5964355469, -1967.1651611328, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3210.9289550781, -1969.0306396484, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3211.5205078125, -1970.4086914063, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3212.8454589844, -1971.7178955078, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3214.7272949219, -1972.2989501953, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3216.0048828125, -1971.0141601563, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3215.7260742188, -1968.8963623047, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3213.9362792969, -1967.1995849609, 2.4605574607849, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3219.2141113281, -1973.2552490234, 2.4639480113983, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(870, 3218.3432617188, -1965.1440429688, 2.4639480113983, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(872, 3222.8745117188, -1961.4267578125, 2.2102489471436, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(872, 3223.4345703125, -1971.7331542969, 2.2102489471436, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(872, 3214.5810546875, -1963.6114501953, 2.2102489471436, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(872, 3216.8627929688, -1958.3480224609, 2.2102489471436, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(872, 3210.6926269531, -1970.4914550781, 2.2102489471436, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(872, 3217.6733398438, -1969.6320800781, 2.2102489471436, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(873, 3214.7707519531, -2029.0095214844, 2.0857524871826, 0, 0, 168, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1281, 3200.8405761719, -2020.8104248047, 3.1177351474762, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1281, 3208.2165527344, -2020.9658203125, 3.1177351474762, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(951, 3162.4819335938, -2014.4758300781, 1.4776659011841, 0, 0, 244, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(951, 3162.40234375, -2026.5402832031, 1.4776659011841, 0, 0, 273.99536132813, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11489, 3173.5063476563, -1961.7235107422, 1.8751964569092, 0, 0, 53, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(642, 3182.0676269531, -2028.9995117188, 3.6604194641113, 0, 0, 49.995361328125, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1211, 3201.0070800781, -2009.4656982422, 2.6311185359955, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3182.7797851563, -2069.4421386719, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3202.1328125, -2069.4360351563, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3220.7602539063, -2069.2414550781, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3239.0812988281, -2069.3205566406, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3294.2939453125, -2038.6862792969, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3239.2744140625, -2038.6591796875, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3222.4145507813, -2038.5986328125, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3204.02734375, -2038.5443115234, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3183.076171875, -2038.5216064453, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3151.7731933594, -2038.4379882813, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3152.1533203125, -2069.0874023438, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1226, 3167.3623046875, -2032.7763671875, 4.5769047737122, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1226, 3167.4521484375, -2025.8874511719, 4.5769047737122, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1226, 3167.4272460938, -2018.2258300781, 4.5769047737122, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1226, 3167.3295898438, -2007.3995361328, 4.5769047737122, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1478, 3162.1826171875, -2010.5355224609, 1.3356174230576, 0, 0, 269.5, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2215, 3201.267578125, -2020.5560302734, 3.2003738880157, 334.25, 22, 274, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2217, 3207.4782714844, -2020.5830078125, 3.2003738880157, 334.25, 23.25, 266, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2342, 3209.0148925781, -2021.2608642578, 3.2592248916626, 0, 0, 214, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1359, 3171.6594238281, -2017.1959228516, 3.1165761947632, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8615, 3182.91015625, -1994.5626220703, 3.871973991394, 0, 0, 270.24548339844, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(18368, 3158.7185058594, -1976.2397460938, -1.4354181289673, 0, 0, 182, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3065, 3203.7727050781, -2021.5948486328, 2.3988018035889, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2780, 3177.0966796875, -1964.6818847656, -4.0078125, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3524, 3162.7116699219, -2007.6066894531, -0.63073945045471, 0, 0, 310.25, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3524, 3162.8247070313, -2033.4173583984, -0.63073945045471, 0, 0, 234.24841308594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(7916, 3152.767578125, -1972.2603759766, -1.6245241165161, 0, 0, 268, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3160.2895507813, -1957.3041992188, -6.4750003814697, 44.747314453125, 0, 81.990966796875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3162.544921875, -1974.6166992188, -3.4750003814697, 44.747314453125, 0, 81.990966796875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(10829, 3189.1960449219, -1988.3734130859, 9.5352573394775, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3934, 3190.4445800781, -1988.5521240234, 12.981147766113, 0, 0, 269.75, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8841, 3276.9174804688, -2053.7961425781, 6.8103885650635, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3134.2890625, -2042.1761474609, -1.0475077629089, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3134.29296875, -2056.2036132813, -1.0475077629089, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3134.2844238281, -2066.0109863281, -1.0475077629089, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8661, 3274.7954101563, -2024.14453125, 3.4841480255127, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8661, 3276.5512695313, -2083.9069824219, 3.5074801445007, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3230.8784179688, -2034.0522460938, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3246.861328125, -2034.0565185547, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3254.8923339844, -2026.0313720703, -1.0475077629089, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3254.88671875, -2022.0057373047, -1.0475077629089, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3262.7136230469, -2014.2006835938, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3278.4772949219, -2014.2264404297, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3286.8872070313, -2014.2412109375, -1.0475077629089, 0, 270, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3256.6318359375, -2081.93359375, -0.99750781059265, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3256.6728515625, -2085.93359375, -0.99750781059265, 0, 270, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3294.9682617188, -2069.4719238281, 4.0484714508057, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3297.2854003906, -2017.0482177734, -2.0999989509583, 110.7421875, 121.99768066406, 107.96850585938, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3298.4660644531, -2022.8118896484, -1.7499990463257, 154.7421875, 121.99768066406, 33.968139648438, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3297.5346679688, -2030.6019287109, -1.7499990463257, 154.73693847656, 121.99768066406, 305.96423339844, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3299.3603515625, -2038.4620361328, -1.7499990463257, 154.7314453125, 121.99768066406, 275.96374511719, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3297.0087890625, -2044.3858642578, -1.7499990463257, 180.7314453125, 121.99768066406, 191.96008300781, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3296.5400390625, -2049.4436035156, -1.7499990463257, 180.73059082031, 121.99768066406, 111.95861816406, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3298.681640625, -2053.83203125, -1.7499990463257, 234.73059082031, 121.99768066406, 111.95617675781, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3297.3383789063, -2063.4130859375, -1.7499990463257, 234.72839355469, 197.99768066406, 29.95068359375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3296.6616210938, -2069.3212890625, -1.7499990463257, 234.72290039063, 197.99560546875, 311.94873046875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3298.34375, -2076.8095703125, -1.7499990463257, 294.72290039063, 197.99560546875, 331.94580078125, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3299.8239746094, -2083.5646972656, -1.7499990463257, 344.71923828125, 197.99560546875, 331.94091796875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(898, 3301.4240722656, -2088.8498535156, -1.7499990463257, 344.71801757813, 197.99560546875, 289.94091796875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3264.4978027344, -2093.7443847656, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3280.2775878906, -2093.7404785156, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3296.2497558594, -2093.7314453125, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3287.5693359375, -2014.1097412109, 5.1446886062622, 0, 0, 320, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3273.7749023438, -2014.0687255859, 5.1446886062622, 0, 0, 319.99877929688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3262.0334472656, -2014.1358642578, 5.1446886062622, 0, 0, 319.99877929688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3263.7768554688, -2093.8239746094, 5.1446886062622, 0, 0, 319.99877929688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3277.4919433594, -2093.8876953125, 5.1446886062622, 0, 0, 319.99877929688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3291.2241210938, -2093.9060058594, 5.1446886062622, 0, 0, 319.99877929688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3254.8083496094, -2020.6923828125, 5.1446886062622, 0, 0, 50.248779296875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3254.8266601563, -2026.7412109375, 5.1446886062622, 0, 0, 50.245971679688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3256.5688476563, -2080.6101074219, 5.1446886062622, 0, 0, 50.245971679688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4100, 3256.5620117188, -2086.6879882813, 5.1446886062622, 0, 0, 50.245971679688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3248.5671386719, -2073.8305664063, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3232.5810546875, -2073.826171875, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3216.6252441406, -2073.8203125, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3200.6538085938, -2073.81640625, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3184.6843261719, -2073.8117675781, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3168.7026367188, -2073.8054199219, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3152.7058105469, -2073.7990722656, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3142.1887207031, -2073.7805175781, -0.99750781059265, 0, 270, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(14872, 3172.1479492188, -1998.046875, 2.6883902549744, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(14872, 3172.9016113281, -2002.2237548828, 2.6883902549744, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(14872, 3176.5854492188, -2002.2164306641, 2.6883902549744, 0, 0, 60, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(14872, 3177.595703125, -1998.4748535156, 2.6883902549744, 0, 0, 129.99633789063, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(14872, 3174.8068847656, -1996.0758056641, 2.6883902549744, 0, 0, 197.99572753906, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3170.4770507813, -2005.6948242188, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3170.4108886719, -1989.0009765625, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3180.8637695313, -1993.5384521484, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(842, 3174.7275390625, -1999.3234863281, 2.3786590099335, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(841, 3212.1247558594, -1964.9241943359, 2.3738129138947, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(841, 3173.1215820313, -1968.6987304688, 2.3738129138947, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(840, 3199.21875, -1960.498046875, 3.5576858520508, 0, 0, 73.998413085938, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(758, 3201.09375, -1960.9898681641, 2.0190060138702, 0, 0, 87.99951171875, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3189.1352539063, -1959.4125976563, 6.9072937965393, 0, 0, 41.98974609375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3192.416015625, -1967.9921875, 6.9072937965393, 0, 0, 41.984252929688, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3205.5317382813, -1964.3248291016, 6.9072937965393, 0, 0, 41.98974609375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1280, 3198.2434082031, -1957.0982666016, 2.643542766571, 0, 0, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1280, 3207.3073730469, -1957.3271484375, 2.643542766571, 0, 0, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(740, 3226.0852050781, -1968.9837646484, 2.2421875, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(740, 3209.0344238281, -1962.6380615234, 2.2421875, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(671, 3210.0698242188, -1984.4727783203, 2.040712594986, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3183.8020019531, -1991.2252197266, 6.1824417114258, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3183.8010253906, -1994.6608886719, 6.1824417114258, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3183.8002929688, -1987.7896728516, 6.1824417114258, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3183.80078125, -1984.3551025391, 6.1824417114258, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3183.8564453125, -1991.921875, 9.65744972229, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3183.8549804688, -1995.3922119141, 9.65744972229, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3183.8649902344, -1998.8728027344, 9.65744972229, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3185.6047363281, -1990.1773681641, 9.65744972229, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3185.5300292969, -1982.6185302734, 6.1824417114258, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3181.4025878906, -2005.7647705078, 6.1824417114258, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3181.4091796875, -2002.2386474609, 6.1824417114258, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3183.2314453125, -2007.5343017578, 6.1824417114258, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3850, 3186.7075195313, -2007.5242919922, 6.1824417114258, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1504, 3185.9580078125, -2005.6947021484, 5.5917677879333, 0, 0, 88.74755859375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1504, 3185.9772949219, -1984.7805175781, 5.5917677879333, 0, 0, 88.74755859375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1504, 3185.9516601563, -1998.4300537109, 9.1167640686035, 0, 0, 88.74755859375, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1483, 3156.3427734375, -2018.4633789063, 2.6738317012787, 0, 0, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1483, 3156.1472167969, -2011.412109375, 2.6738317012787, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1483, 3149.6901855469, -2018.4559326172, 2.6738317012787, 0, 0, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1483, 3149.4443359375, -2011.427734375, 2.6738317012787, 0, 0, 270, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1458, 3169.8857421875, -1993.7730712891, 2.442004442215, 0, 0, 224, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1454, 3205.8386230469, -1990.2004394531, 3.1171164512634, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1454, 3207.2138671875, -1995.1704101563, 3.1171164512634, 0, 0, 340, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1451, 3207.0734863281, -1984.8946533203, 3.0776200294495, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11480, 3239.8544921875, -1997.6201171875, 2.3000631332397, 0, 0, 84.74853515625, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3228.8000488281, -1995.6575927734, 0.077485978603363, 0, 0, 354.24450683594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(14394, 3227.8098144531, -1995.7794189453, 0.95581495761871, 0, 0, 173.75, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11496, 3222.2775878906, -1995.50390625, 1.6024842262268, 0, 0, 352.9931640625, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11495, 3244.6125488281, -1993.7601318359, 0, 0, 0, 84.5, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11495, 3243.5490722656, -2002.3804931641, 0, 0, 0, 264.74584960938, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11480, 3239.8552246094, -1997.6206054688, 2.3000631332397, 0, 0, 84.75, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(11480, 3246.1547851563, -1998.1947021484, 2.3000631332397, 0, 0, 84.74853515625, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1290, 3190.6437988281, -1963.6527099609, 8.2656087875366, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1290, 3205.517578125, -2030.1394042969, 8.2656087875366, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3254.3479003906, -2002.7094726563, 0.76744818687439, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3233.3542480469, -1988.73046875, 1.4418108463287, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3255.26953125, -1995.5126953125, 0.76744818687439, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1215, 3231.9499511719, -2003.2775878906, 1.4418108463287, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8658, 3214.5393066406, -1990.4108886719, 0.78371322154999, 0, 0, 264, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8658, 3213.6313476563, -1998.4377441406, 0.78371322154999, 0, 0, 263.99597167969, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1697, 3191.5183105469, -2004.8131103516, 12.528469085693, 0, 0, 180, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1697, 3184.0395507813, -2004.8269042969, 12.528469085693, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(7979, 3142.6242675781, -2054.6960449219, 6.5460801124573, 0, 0, 90, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(4832, 3271.1945800781, -2023.2025146484, 2.3745346069336, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(8550, 3286.9951171875, -2024.4855957031, 7.7322311401367, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3462, 3201.7919921875, -2027.1416015625, 3.7110013961792, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(754, 3180.7377929688, -2033.0700683594, 2.0056414604187, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(754, 3182.5588378906, -2033.0860595703, 2.0056414604187, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(16325, 3201.3371582031, -2021.4885253906, 1.3324685096741, 0, 0, 92, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1594, 3176.2390136719, -2029.1771240234, 2.7953977584839, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1594, 3179.9658203125, -2023.9412841797, 2.7953977584839, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1594, 3173.80859375, -2023.3389892578, 2.7953977584839, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1594, 3181.9968261719, -2028.9361572266, 2.7953977584839, 0, 0, 78, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(642, 3176.2292480469, -2029.2158203125, 3.6604194641113, 0, 0, 153.99536132813, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(642, 3173.7319335938, -2023.3305664063, 3.6604194641113, 0, 0, 153.99536132813, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(642, 3179.9956054688, -2023.8955078125, 3.6604194641113, 0, 0, 43.995361328125, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(711, 3181.658203125, -2033.0936279297, 6.9822940826416, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(754, 3170.3024902344, -2028.1080322266, 2.1116225719452, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(754, 3170.2939453125, -2023.3530273438, 2.1116225719452, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(754, 3170.3698730469, -2019.0155029297, 2.1116225719452, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(754, 3170.4304199219, -2033.1184082031, 2.1116225719452, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3243, 3184.8996582031, -1964.5695800781, 2.2421875, 0, 0, 210, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3243, 3207.9479980469, -1966.6156005859, 2.2421875, 0, 0, 125.99816894531, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(841, 3199.1840820313, -1968.1407470703, 2.3738129138947, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(841, 3199.0810546875, -1967.65234375, 2.3738129138947, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3461, 3198.8295898438, -1968.1398925781, 0.61719918251038, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3461, 3199.361328125, -1967.7785644531, 0.64219915866852, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3461, 3199.4575195313, -1968.6302490234, 0.61719918251038, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3198.2224121094, -1967.4698486328, 2.1684355735779, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3198.3249511719, -1967.9761962891, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3198.5480957031, -1968.5767822266, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3199.0534667969, -1969.0252685547, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3199.6215820313, -1968.9758300781, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3200.1440429688, -1968.6130371094, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3200.4375, -1968.1059570313, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3200.36328125, -1967.37890625, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3199.9130859375, -1966.76171875, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3199.3706054688, -1966.6623535156, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3199.0012207031, -1966.8746337891, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3930, 3198.5246582031, -1967.1177978516, 2.2684359550476, 117.99865722656, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3929, 3195.9926757813, -1969.1334228516, 2.4970562458038, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3929, 3198.3745117188, -1971.111328125, 2.4970562458038, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3929, 3202.2177734375, -1969.7954101563, 2.4970562458038, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3929, 3202.52734375, -1966.4018554688, 2.4970562458038, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(3929, 3198.0739746094, -1964.8940429688, 2.4970562458038, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(829, 3191.373046875, -1970.8698730469, 2.6186861991882, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(760, 3192.3310546875, -1967.8731689453, 1.8597221374512, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1255, 3206.1457519531, -1998.0600585938, 2.8318476676941, 0, 0, 0, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(1255, 3207.69140625, -2000.9185791016, 2.7568473815918, 0, 0, 58, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2103, 3206.3425292969, -2000.1306152344, 2.2529125213623, 0, 0, 124, .worldid = 0, .streamdistance = 200);
    CreateDynamicObject(2816, 3208.0676269531, -1998.7581787109, 2.2540259361267, 0, 0, 0, .worldid = 0, .streamdistance = 200);

	//Dakota Cro Custom Coding Project EXTERIOR [OID Approved per Devin for 80m IG]
	CreateDynamicObject(1079, 2582.099609375, -2121.599609375, 11.699999809265, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1079, 2580.9899902344, -2121.599609375, 11.699999809265, 0, 0, 269.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1079, 2579.919921875, -2121.599609375, 11.699999809265, 0, 0, 269.98901367188, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1079, 2583.25, -2121.599609375, 11.699999809265, 0, 0, 269.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1079, 2584.3999023438, -2121.599609375, 11.699999809265, 0, 0, 269.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11480, 2610.5, -2147.19921875, 1, 0, 0, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11480, 2610.5, -2155, 1, 0, 0, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11480, 2610.5, -2162.69921875, 1, 0, 0, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11480, 2610.5, -2170.3500976563, 1, 0, 0, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2613.1999511719, -2246.1999511719, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2613.19921875, -2237.3999023438, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2613.19921875, -2228.6999511719, -2.1389999389648, 0, 358, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2613.19921875, -2219.9899902344, -2.5799999237061, 0, 356, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2613.19921875, -2211.2199707031, -3.194000005722, 0, 355.99548339844, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2619.1000976563, -2249.9299316406, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2619.1000976563, -2251.8999023438, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2619.1000976563, -2253.8999023438, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2619.099609375, -2253.8994140625, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2613.19921875, -2255, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2619.099609375, -2255.8898925781, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2627.8999023438, -2255.8896484375, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2627.8999023438, -2253.8994140625, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2627.8999023438, -2251.8994140625, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2627.8994140625, -2249.9296875, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2636.69921875, -2255.8896484375, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2636.6999511719, -2253.8994140625, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2636.6999511719, -2251.8994140625, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2636.6999511719, -2249.9296875, -2, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2639.580078125, -2261.8000488281, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2634, -2261.8000488281, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2628.5500488281, -2261.7998046875, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2623, -2261.7998046875, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2617.1999511719, -2261.7998046875, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(4874, 2679, -2260.5, 0.62999999523163, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1698, 2640.1999511719, -2250.6999511719, 0.15999999642372, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1698, 2640.3999023438, -2250.69921875, 0.38999998569489, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1698, 2640.6298828125, -2250.69921875, 0.60000002384186, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11454, 2558, -2182, -1.2000000476837, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(9221, 2602.8000488281, -2130.3999023438, 1.2599999904633, 0, 0, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1766, 2609.5, -2175.3999023438, -1.1000000238419, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1766, 2612.8000488281, -2176.6999511719, -1.1000000238419, 1, 0, 272, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1766, 2611.5, -2180, -1.1000000238419, 0.999755859375, 0, 179.99951171875, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1766, 2608, -2178.8000488281, -1.1000000238419, 0.9942626953125, 0, 91.994506835938, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2126, 2609.8999023438, -2178.1999511719, -1.1000000238419, 0, 0, 0.75, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(6300, 2572.599609375, -2238, -7.3000001907349, 356.99523925781, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(6300, 2658.484375, -2240.8994140625, -8.1069984436035, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 2542.6000976563, -2246.5500488281, 1, 0, 358, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 2542.599609375, -2258.5498046875, 1.4199999570847, 0, 357.98950195313, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2613.19921875, -2261.8000488281, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3406, 2615.1999511719, -2261.8000488281, -2, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2566.3994140625, -2249.69921875, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2622, -2249.69921875, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2675.2197265625, -2249.69921875, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 2526.8193359375, -2249.8994140625, 12.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3932, 2587.5, -2206, 0.69999998807907, 0, 356, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3932, 2579.599609375, -2206, 0.69999998807907, 0, 356, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3932, 2571.69921875, -2206, 0.69999998807907, 0, 357, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3279, 2547.2998046875, -2255, 1.2999999523163, 358.99475097656, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3794, 2680.8994140625, -2249.8994140625, 0.69999998807907, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3797, 2611, -2247.6999511719, 7.8000001907349, 0, 0, 54, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3797, 2555.3999023438, -2247.8000488281, 7.8000001907349, 0, 0, 115.99780273438, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1622, 2574.1499023438, -2114.5, 10, 350, 350, 218, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1614, 2589.7998046875, -2116, 6.1999998092651, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3785, 2614.099609375, -2210.8994140625, 3, 0, 0, 173.99597167969, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3785, 2614.1000976563, -2220.3000488281, 3.2999999523163, 0, 0, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3785, 2614.1000976563, -2229.6000976563, 3.5, 0, 0, 220, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3785, 2614.099609375, -2237.099609375, 3.7000000476837, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3785, 2614.1000976563, -2244.8000488281, 3.7000000476837, 0, 0, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(9167, 2549.1899414063, -2159, 2.9000000953674, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8879, 2649.1000976563, -2252.5, 6.1999998092651, 0, 0, 226, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3116, 2587.1000976563, -2225.6000976563, 8, 0, 0, 70, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1079, 2579.919921875, -2121.599609375, 11.699999809265, 0, 0, 269.98901367188, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(9167, 2549.3999023438, -2145.5, 2.9000000953674, 0, 0, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1010, 2572.9072265625, -2132.224609375, -0.9998055100441, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(964, 2583.599609375, -2207.8994140625, -1, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(964, 2676.2998046875, -2250.3994140625, 0.10000000149012, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2574.5, -2125.2900390625, 6.3000001907349, 0, 90, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2576.6000976563, -2125.2900390625, 6.3000001907349, 0, 90, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2578.6999511719, -2125.2900390625, 6.3000001907349, 0, 90, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2580.8000488281, -2125.2900390625, 6.3000001907349, 0, 90, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2582.8999023438, -2125.2900390625, 6.3000001907349, 0, 90, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2585, -2125.2900390625, 6.3000001907349, 0, 90, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2587.1000976563, -2125.2900390625, 6.3000001907349, 0, 90, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2589.1999511719, -2125.2900390625, 6.3000001907349, 0, 90, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2576.599609375, -2124.4499511719, 4.6999998092651, 0, 180, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2578.69921875, -2124.4499511719, 4.6999998092651, 0, 180, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2582.8994140625, -2124.4499511719, 4.6999998092651, 0, 180, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2580.7998046875, -2124.4499511719, 4.6999998092651, 0, 180, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2585, -2124.4499511719, 4.6999998092651, 0, 180, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2589.19921875, -2124.4499511719, 4.6999998092651, 0, 180, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2587.099609375, -2124.4499511719, 4.6999998092651, 0, 180, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2574.5, -2124.4499511719, 4.6999998092651, 0, 180, 180, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2574.5, -2123.5500488281, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2576.599609375, -2123.5500488281, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2578.69921875, -2123.5500488281, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2580.7998046875, -2123.5500488281, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2582.8994140625, -2123.5500488281, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2585, -2123.5500488281, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2587.099609375, -2123.5500488281, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2589.19921875, -2123.5498046875, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2589.19921875, -2124.44921875, 7.9770002365112, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2587.099609375, -2124.44921875, 7.9770002365112, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2585, -2124.44921875, 7.9770002365112, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2582.8994140625, -2124.44921875, 7.9770002365112, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2580.7998046875, -2124.44921875, 7.9770002365112, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2578.69921875, -2124.44921875, 7.9770002365112, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2576.599609375, -2124.44921875, 7.9770002365112, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2574.5, -2124.44921875, 7.9770002365112, 0, 0, 179.99450683594, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2730.7199707031, -2249.69921875, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2736, -2249.5500488281, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 2542.599609375, -2264.169921875, 1.6100000143051, 0, 357.98950195313, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2676.1000976563, -2145, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 2542.599609375, -2258.5498046875, 1.4199999570847, 0, 357.98950195313, 270, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2620.4499511719, -2145, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2564.8000488281, -2144.8999023438, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8210, 2509.3000488281, -2144.6999511719, 15.60000038147, 0, 0, 0, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3117, 2589.19921875, -2123.5498046875, 6.3000001907349, 0, 90, 90, .worldid = 0, .streamdistance = 150);

		// Computrix - Order ID: Free per Exeuctive Administrators - House ID: N/A(EXTERIOR) (ISLAND)
	CreateDynamicObject(5145, 2802.49121094, 3967.23632812, 9.30000305,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2802.49121094, 3967.23632812, 9.30000305,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2802.49121094, 3967.23632812, -12.19999695,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2802.49121094, 3967.23632812, -33.44999695,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2802.49121094, 3967.23632812, -54.69999695,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2802.49121094, 3967.23632812, -54.69999695,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2802.49121094, 3967.23632812, -75.44999695,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2831.90234375, 4107.18457031, 9.30000305,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2831.90234375, 4107.18457031, -12.19999695,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2831.90234375, 4107.18457031, -33.44999695,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2831.90234375, 4107.18457031, -54.69999695,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5145, 2831.90234375, 4107.18457031, -75.44999695,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10775, 2804.98339844, 4035.79492188, 40.90860748,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10775, 2832.45898438, 4038.30273438, 40.90700150,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11102, 2757.75097656, 4026.72924805, 21.81334496,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5706, 2801.43847656, 4028.26782227, 20.75059891,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18553, 2796.62768555, 4012.40942383, 21.07846069,   0.00000000, 0.00000000, 77.50000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5043, 2852.41235352, 4008.17431641, 21.08847427,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5043, 2856.84741211, 4007.23144531, 21.08846474,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(13817, 2777.45654297, 4067.53930664, 21.26686287,   0.00000000, 0.00000000, 256.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(13817, 2782.26611328, 4066.51635742, 21.26474953,   0.00000000, 0.00000000, 255.99792480, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11102, 2876.77929688, 4047.94653320, 21.81528282,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8357, 2843.88867188, 4179.34277344, 19.84000015,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16771, 2926.13769531, 4112.88574219, 26.39999962,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3689, 2745.73266602, 4098.08642578, 27.02872086,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3755, 2842.84423828, 4123.22998047, 25.16661644,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3620, 2951.46215820, 4072.96655273, 32.87036896,   0.00000000, 0.00000000, 79.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3620, 2942.47802734, 4030.21728516, 32.87036896,   0.00000000, 0.00000000, 79.99145508, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16613, 2698.92822266, 3921.91821289, 24.03013611,   0.00000000, 0.00000000, 167.99768066, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(7979, 2949.51562500, 4156.78466797, 22.66275787,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10763, 2899.24829102, 4186.18310547, 32.68964767,   0.00000000, 0.00000000, 304.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3753, 2915.14746094, 4190.86669922, 10.38531113,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10832, 2774.87231445, 4042.59033203, 50.34900665,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3934, 2819.22412109, 4035.98315430, 48.54923248,   0.00000000, 0.00000000, 77.99740601, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(12861, 2804.00341797, 4098.70556641, 19.77527618,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(12859, 2914.58007812, 4052.01367188, 19.74337387,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3567, 2843.47998047, 4092.13012695, 20.66767120,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3567, 2850.62329102, 4090.80712891, 20.66767120,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16271, 2917.36596680, 3990.75292969, 33.94543076,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(13198, 2901.10449219, 3960.08398438, 25.03750610,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4825, 2862.03906250, 3903.87890625, 17.08443451,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4825, 2862.28320312, 3903.82421875, -7.16556549,   359.99453735, 179.99450684, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4826, 2853.15429688, 3861.79980469, 28.71131897,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(6873, 2793.62011719, 3960.64355469, -48.10909271,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5763, 2796.85913086, 3972.09106445, 19.66777802,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5763, 2793.15307617, 3958.03930664, 19.66777802,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1694, 2764.94628906, 3974.15820312, 115.47668457,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1595, 2761.54980469, 3963.83886719, 112.00028229,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3877, 2774.08837891, 3980.06616211, 108.35352325,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3877, 2770.03222656, 3960.95117188, 108.35352325,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3877, 2757.79858398, 3982.27416992, 108.35352325,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3877, 2754.32495117, 3965.81420898, 108.35352325,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18553, 2773.12182617, 3972.34863281, 92.83910370,   0.00000000, 0.00000000, 347.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3934, 2787.35058594, 3967.23999023, 91.54715729,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3934, 2803.10058594, 3963.90209961, 91.54715729,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1687, 2774.28710938, 3962.31811523, 92.35855103,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1687, 2815.69604492, 3968.86230469, 92.35855103,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1689, 2815.89550781, 3956.64208984, 92.75803375,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3877, 2835.40478516, 3967.28564453, 93.21289825,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3877, 2831.10229492, 3947.80761719, 93.21289825,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(7344, 2937.09008789, 3912.89672852, -27.81975746,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11295, 2901.87011719, 3902.50317383, 25.60938644,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16532, 2750.62646484, 4019.83154297, 23.24460983,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16532, 2709.50537109, 4054.46752930, 23.45404434,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16532, 2730.86010742, 4129.14990234, 23.45404434,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3675, 2704.31201172, 4073.49462891, 15.78500366,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3049, 2893.03710938, 4008.98535156, 22.01869965,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3049, 2906.09399414, 4006.15307617, 22.01869965,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(967, 2896.12060547, 4006.74926758, 19.77656555,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(967, 2907.27001953, 4007.14697266, 19.77656555,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9244, 2691.92382812, 3947.63476562, 24.90182495,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10843, 2720.13964844, 3999.55468750, 27.37225723,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11244, 2715.03173828, 3972.91870117, 22.87097359,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16400, 2923.32910156, 4018.20605469, 19.77656555,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1555, 2891.75195312, 4195.23339844, 9.35760689,   0.00000000, 0.00000000, 350.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(12930, 2701.44116211, 3992.74438477, 20.58127594,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(12930, 2698.98193359, 3993.20068359, 20.58127594,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(929, 2707.46997070, 4013.03369141, 20.73862648,   0.00000000, 0.00000000, 255.99792480, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3287, 2892.22558594, 4034.20117188, 24.51561165,   0.00000000, 0.00000000, 345.99792480, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3637, 2761.97021484, 4060.83691406, 22.36212730,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3643, 2726.60839844, 4152.00830078, 24.25683403,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(6930, 2735.21093750, 3903.49707031, 29.00380898,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11486, 2643.20288086, 3883.42871094, 1.59000003,   0.00000000, 0.00000000, 123.99996948, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(12912, 2756.73193359, 3897.29956055, 31.28089333,   0.00000000, 0.00000000, 346.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11486, 2913.80908203, 3825.88256836, 1.59000003,   0.00000000, 0.00000000, 211.99719238, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11486, 2990.44213867, 4191.91601562, 1.59000003,   0.00000000, 0.00000000, 305.99221802, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11486, 2720.66284180, 4248.15917969, 1.59000003,   0.00000000, 0.00000000, 31.99124146, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16314, 2902.99707031, 3983.02587891, 36.51369858,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(17055, 2706.24243164, 4017.32983398, 22.11915207,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16599, 2753.19995117, 4174.50000000, 24.50000000,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8884, 2860.34643555, 4094.14624023, 23.22042084,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(7025, 2870.37207031, 4090.10546875, 23.22289467,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5262, 2696.27197266, 3974.67456055, 22.74312973,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5260, 2688.67675781, 3961.42333984, 21.49478531,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5260, 2688.67675781, 3961.42285156, 24.74478531,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3574, 2857.32470703, 3957.85449219, 22.46825790,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3572, 2866.97265625, 3953.82226562, 21.12450600,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3566, 2897.88183594, 4019.22753906, 22.14018440,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3378, 2700.75097656, 3981.60424805, 20.94464684,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3378, 2700.75097656, 3981.60351562, 23.19464684,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3172, 2776.03759766, 4125.48681641, 19.77656555,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(17697, 2803.61938477, 3892.00170898, 24.41314888,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(17699, 2787.19360352, 3892.54150391, 24.41643906,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2776.88574219, 3904.40747070, 21.24536133,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2761.90722656, 3890.81640625, 21.24605179,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3109, 2703.48583984, 3933.24804688, 20.97222137,   0.00000000, 0.00000000, 213.99993896, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(17951, 2706.58227539, 3928.47973633, 21.55853653,   0.00000000, 0.00000000, 32.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8247, 2862.47167969, 3937.54101562, 23.70435333,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9241, 2856.72094727, 3910.33178711, 21.08546448,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2842.04614258, 3900.66918945, 22.42727470,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2847.15405273, 3924.70898438, 22.42727470,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2871.15795898, 3919.79467773, 22.42727470,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2866.06518555, 3895.51245117, 22.42727470,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2643.26904297, 3883.47143555, 35.33208466,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2913.78076172, 3825.93920898, 35.32723236,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2990.35766602, 4191.88916016, 35.31771088,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2720.69506836, 4248.06250000, 35.31487656,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2950.41650391, 4172.58105469, 20.33806038,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2944.07299805, 4142.25000000, 20.33806038,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2743.51953125, 4216.43652344, 20.33806038,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2737.18701172, 4186.20654297, 20.34587097,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3242, 2795.57812500, 4065.99438477, 21.71285820,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3569, 2811.32104492, 4064.53637695, 22.14018440,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(13025, 2838.95751953, 4007.01147461, 22.70855141,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5299, 2905.90893555, 3916.97314453, 19.23482704,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3932, 2869.50488281, 4007.42114258, 21.54124260,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3932, 2877.12109375, 4005.94628906, 21.54124260,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1596, 2905.82983398, 4135.97998047, 31.03957558,   0.00000000, 0.00000000, 202.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1684, 2775.82470703, 4119.74755859, 21.36644173,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1684, 2876.38940430, 3927.01123047, 21.36644173,   0.00000000, 0.00000000, 76.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1684, 2876.36132812, 3927.05737305, 24.32999992,   0.00000000, 0.00000000, 255.99792480, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8884, 2902.63964844, 4053.69165039, 22.45838356,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5244, 2916.73071289, 4082.54272461, 22.25852013,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2738.15136719, 3925.01391602, 21.25920868,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(14409, 2738.24536133, 3918.96655273, 18.46505928,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2720.44238281, 3928.75683594, 21.25183868,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2711.13769531, 3909.70092773, 21.24072647,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2714.87011719, 3927.31738281, 21.25058365,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2712.73535156, 3917.25488281, 21.24261093,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18553, 2737.11914062, 3914.07714844, 23.09453583,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2930, 2725.43627930, 3927.69897461, 22.40816498,   0.00000000, 0.00000000, 125.99996948, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2930, 2726.54150391, 3926.17602539, 22.40816498,   0.00000000, 0.00000000, 125.99670410, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2685.80249023, 3931.88110352, 21.24340820,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2684.73339844, 3926.83813477, 21.24340820,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2682.59619141, 3916.76049805, 21.24340820,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1506, 2786.95410156, 3897.63183594, 20.72844315,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1506, 2804.95996094, 3896.48437500, 21.15807915,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3753, 2765.36523438, 3871.78222656, 10.25000000,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3753, 2765.36523438, 3871.78222656, -12.79999733,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3753, 2765.36523438, 3871.78222656, -36.67999268,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3753, 2765.36523438, 3871.78222656, -59.41999054,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3886, 2782.52124023, 3854.09838867, 8.50000000,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3361, 2776.57885742, 3857.75805664, 7.18691444,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3361, 2770.71289062, 3859.02929688, 3.18691444,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2763.82495117, 3860.49707031, -0.75000000,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2755.28002930, 3862.33227539, -0.75000000,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2746.76123047, 3864.16821289, -0.75000000,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3886, 2786.38574219, 3871.76342773, -22.75000000,   299.99993896, 180.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2741.96289062, 3860.31103516, -0.75000000,   0.00000000, 0.00000000, 77.99740601, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2740.15844727, 3851.78979492, -0.75000000,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2750.64624023, 3858.33325195, -0.75000000,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2748.82934570, 3849.81835938, -0.75000000,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2763.45703125, 3858.53027344, -0.75000000,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2771.99707031, 3856.71411133, -0.75000000,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2758.79321289, 3854.58813477, -0.75000000,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2756.96435547, 3846.03442383, -0.75000000,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2767.50561523, 3852.84667969, -0.75000000,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2765.67944336, 3844.33886719, -0.75000000,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16773, 2949.04199219, 4130.31250000, 23.78425407,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2963.38500977, 4159.49218750, 20.40798950,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2958.05566406, 4134.48925781, 20.40798950,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2960.70996094, 4146.99316406, 20.40798950,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(983, 2965.03881836, 4167.29394531, 20.45486450,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9131, 2961.82421875, 4173.83007812, 20.90548134,   0.00000000, 0.00000000, 305.99670410, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9131, 2964.36157227, 4170.35302734, 20.90022469,   0.00000000, 0.00000000, 35.99670410, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2944.49682617, 4179.10156250, 20.41324615,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2956.98925781, 4176.45898438, 20.41324615,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2932.00439453, 4181.73925781, 20.41324615,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2919.51196289, 4184.38964844, 20.41324615,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2860.83984375, 4196.89062500, 20.46012115,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2885.86914062, 4191.55371094, 20.45486450,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2760.76098633, 4218.21728516, 20.45540619,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2835.82617188, 4202.22167969, 20.45541000,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2810.82031250, 4207.56250000, 20.45540619,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2785.78027344, 4212.88964844, 20.45540619,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2746.67578125, 4221.20166016, 20.40853500,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2732.76342773, 4207.21826172, 20.46012115,   0.00000000, 0.00000000, 169.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2727.88623047, 4182.12255859, 20.46012115,   0.00000000, 0.00000000, 168.99719238, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2722.81787109, 4157.05615234, 20.46012115,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2717.48193359, 4132.05224609, 20.46012115,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2712.13183594, 4107.04980469, 20.46012115,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2706.80664062, 4082.01831055, 20.46012115,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2701.32861328, 4057.02148438, 20.46012115,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2706.82421875, 4021.52929688, 21.24227142,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2699.28491211, 4023.11718750, 21.24199295,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2697.04052734, 4036.69384766, 20.46012115,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2693.14184570, 4019.14184570, 21.24261093,   0.00000000, 0.00000000, 77.99740601, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2690.98559570, 4009.06469727, 21.24258423,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2686.68164062, 3988.93017578, 21.24254608,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2688.82226562, 3999.01367188, 21.24253845,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2684.53637695, 3978.86401367, 21.24253845,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2702.57397461, 3953.91748047, 21.26243210,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2680.29345703, 3958.70922852, 21.24262238,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2678.17456055, 3948.63940430, 21.24266434,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2681.76977539, 3941.48681641, 21.24195480,   0.00000000, 0.00000000, 155.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2674.40551758, 3931.07495117, 20.45486450,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2671.40991211, 3917.00585938, 20.45486450,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2749.57763672, 3882.79956055, 21.23822403,   0.00000000, 0.00000000, 167.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2729.60522461, 3887.04687500, 21.23822403,   0.00000000, 0.00000000, 167.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2689.68164062, 3895.54443359, 21.24348068,   0.00000000, 0.00000000, 167.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2709.63867188, 3891.30175781, 21.24348068,   0.00000000, 0.00000000, 167.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4100, 2680.46972656, 3897.52343750, 21.47823524,   0.00000000, 0.00000000, 308.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2682.40722656, 3968.77929688, 21.24256897,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2705.73803711, 3968.39355469, 21.26243210,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2794.92041016, 3872.88842773, 20.46012115,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2819.91259766, 3867.54809570, 20.45538330,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(984, 2833.98681641, 3864.55688477, 20.40850830,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(983, 2839.99243164, 3860.11596680, 20.26017761,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(983, 2864.50317383, 3854.82568359, 20.26017761,   0.00000000, 0.00000000, 350.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2877.58447266, 3855.26513672, 20.45537949,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(983, 2891.67065430, 3852.28588867, 20.45538330,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2906.75561523, 3891.91186523, 20.46012115,   0.00000000, 0.00000000, 168.40002441, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(982, 2901.53906250, 3866.82421875, 20.46012115,   0.00000000, 0.00000000, 168.39843750, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4100, 2915.58593750, 3937.92016602, 21.47823524,   0.00000000, 0.00000000, 38.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18257, 2893.25756836, 4027.58666992, 19.77656555,   0.00000000, 0.00000000, 237.99998474, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3577, 2876.51904297, 4007.17553711, 20.55907249,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18257, 2883.30297852, 4007.32324219, 19.77656555,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(925, 2878.68872070, 4004.87353516, 20.83847046,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16309, 2888.43798828, 3986.53930664, 32.19808960,   0.00000000, 20.00000000, 167.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16083, 2878.90722656, 3988.71801758, 24.36502647,   0.00000000, 0.00000000, 336.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3529, 2898.57128906, 3983.68457031, 27.34936714,   0.00000000, 202.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3529, 2884.98730469, 3986.72167969, 22.72905159,   0.00000000, 201.99462891, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3529, 2885.23388672, 3987.94726562, 22.72905159,   0.00000000, 201.99462891, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3529, 2898.79711914, 3984.80004883, 27.34936714,   0.00000000, 201.99462891, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3529, 2899.64208984, 3984.61376953, 22.97905159,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3529, 2899.39941406, 3983.64355469, 22.97905159,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18553, 2883.50415039, 4046.51147461, 21.09976196,   0.00000000, 0.00000000, 77.50000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1768, 2939.75292969, 4093.94897461, 19.84531212,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(937, 2940.36791992, 4088.86279297, 20.32002449,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(936, 2938.41577148, 4089.26489258, 20.32002449,   0.00000000, 0.00000000, 166.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1429, 2940.36547852, 4089.17480469, 21.04836845,   0.00000000, 0.00000000, 166.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2147, 2936.57324219, 4089.55078125, 19.84531212,   0.00000000, 0.00000000, 170.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2752.32519531, 3865.22607422, 10.87417030,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2742.25976562, 3867.38183594, 10.87417030,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2739.36083984, 3878.56054688, 10.87417030,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2750.77856445, 3873.35742188, 12.90132809,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2750.77832031, 3873.35742188, 15.65132809,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2752.59375000, 3866.70849609, 9.87417030,   0.00000000, 90.00000000, 79.99871826, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2738.29394531, 3873.50976562, 10.87417030,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2752.32519531, 3865.22558594, 13.62417030,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2742.25976562, 3867.38183594, 13.62417030,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2738.29394531, 3873.50976562, 13.62417030,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2739.36035156, 3878.56054688, 13.62417030,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2753.57812500, 3871.86572266, 9.87417030,   0.00000000, 90.00000000, 259.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(967, 2754.40747070, 3865.91870117, 9.40725422,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(967, 2752.38330078, 3872.00219727, 9.21093750,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2930, 2753.33129883, 3870.48608398, 11.84779358,   0.00000000, 0.00000000, 100.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2930, 2752.83862305, 3868.10400391, 11.84779358,   0.00000000, 0.00000000, 269.99975586, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18257, 2782.11889648, 3868.27026367, 9.21093750,   0.00000000, 0.00000000, 260.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3262, 2769.12011719, 3856.28808594, 1.40282989,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3264, 2780.51928711, 3859.60961914, 9.40725422,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1233, 2794.17065430, 3929.17309570, 21.34661865,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1320, 2753.84692383, 3983.59155273, 21.29219055,   0.00000000, 0.00000000, 260.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1321, 2853.31933594, 3977.34228516, 21.26094055,   0.00000000, 0.00000000, 259.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1321, 2782.85937500, 4105.51757812, 21.26094055,   0.00000000, 0.00000000, 77.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1320, 2880.35449219, 4089.52929688, 21.29219055,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3601, 2762.73950195, 3971.77050781, 95.47223663,   0.00000000, 270.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3602, 2827.56250000, 3959.20507812, 72.84542847,   270.00000000, 179.30389404, 77.30386353, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2755.80053711, 3976.78906250, 97.53962708,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2754.46875000, 3970.52636719, 92.42031860,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2755.79980469, 3976.78906250, 99.78962708,   270.00000000, 180.11007690, 168.11010742, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2834.84082031, 3959.69140625, 70.19808197,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2833.57250977, 3953.72314453, 74.98994446,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2833.57226562, 3953.72265625, 77.23994446,   270.00000000, 179.97930908, 167.97937012, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3256, 2741.49145508, 3897.04321289, 2.27948761,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3258, 2873.65136719, 4031.81835938, 62.25856018,   0.00000000, 0.00000000, 259.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3258, 2763.65332031, 4042.22851562, 62.25856018,   0.00000000, 0.00000000, 79.99740601, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2649, 2775.68627930, 3976.63549805, 92.02938080,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3643, 2906.93603516, 3921.90405273, 29.38960648,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1697, 2909.36230469, 3930.55151367, 25.83670235,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3876, 2856.36987305, 3876.08056641, 14.56881142,   0.00000000, 0.00000000, 50.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8345, 2870.86425781, 3866.97998047, -9.00000000,   0.00000000, 0.00000000, 212.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9958, 2899.91479492, 3808.45361328, -0.90206337,   0.00000000, 0.00000000, 227.99792480, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3852, 2706.60083008, 4071.40161133, 21.58580017,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3287, 2733.96752930, 3984.59863281, 24.53055763,   0.00000000, 0.00000000, 347.99792480, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5302, 2754.53442383, 3969.18627930, 22.13160133,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3407, 2789.00537109, 3912.49414062, 19.78099251,   0.00000000, 0.00000000, 349.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3407, 2806.63378906, 3908.86425781, 19.78102112,   0.00000000, 0.00000000, 349.99145508, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3447, 2720.34497070, 3922.90600586, 27.26942444,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11489, 2764.15869141, 3895.25195312, 19.78342438,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10183, 2777.91015625, 4142.78271484, 19.80502701,   0.00000000, 0.00000000, 124.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2800.00341797, 3917.15991211, 20.15299606,   0.00000000, 0.00000000, 167.99993896, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2739.54858398, 3966.50878906, 20.16862106,   0.00000000, 0.00000000, 255.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2858.95971680, 4003.49780273, 20.13737106,   0.00000000, 0.00000000, 255.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2761.70507812, 4020.31542969, 20.16862106,   0.00000000, 0.00000000, 255.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2889.37817383, 4081.41430664, 20.16862106,   0.00000000, 0.00000000, 255.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2842.02148438, 3927.91894531, 20.14426041,   0.00000000, 0.00000000, 255.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2788.04052734, 4130.45751953, 20.13737106,   0.00000000, 0.00000000, 255.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2775.46386719, 4071.67382812, 20.13737106,   0.00000000, 0.00000000, 255.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1211, 2835.34106445, 4146.40966797, 20.14774323,   0.00000000, 0.00000000, 345.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1244, 2723.39990234, 3942.39990234, 20.70000076,   0.00000000, 0.00000000, 75.99792480, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3459, 2725.15649414, 3931.33886719, 27.28403473,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3459, 2732.07031250, 3960.51855469, 27.28403473,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3459, 2736.86108398, 3983.26904297, 27.28403473,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3459, 2743.47753906, 4012.78002930, 27.28403473,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1290, 2892.74194336, 4005.72143555, 25.79998779,   0.00000000, 0.00000000, 34.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1290, 2881.69897461, 4133.13671875, 21.93659210,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1290, 2858.75488281, 4138.21679688, 21.93659210,   0.00000000, 0.00000000, 345.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1290, 2834.70263672, 4143.20361328, 21.93659210,   0.00000000, 0.00000000, 345.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1290, 2812.19067383, 4148.07714844, 21.93659210,   0.00000000, 0.00000000, 345.99243164, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2809.39746094, 4089.12402344, 33.96498108,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2851.25732422, 4080.29541016, 33.96498108,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2905.60009766, 4075.60009766, 34.00000000,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2921.42749023, 4048.01293945, 33.96498108,   0.00000000, 0.00000000, 167.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2867.47656250, 3961.55126953, 33.96498108,   0.00000000, 0.00000000, 167.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2894.25292969, 3943.22753906, 33.96498108,   0.00000000, 0.00000000, 345.98693848, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2707.41113281, 3964.37988281, 33.96498108,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2939.77734375, 4177.30419922, 33.96498108,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2887.35815430, 4188.75927734, 33.96498108,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2827.28662109, 4201.73486328, 33.96498108,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2768.24096680, 4214.57421875, 33.96498108,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2754.13452148, 3928.53222656, 24.13843918,   0.00000000, 0.00000000, 254.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2816.97070312, 3914.87792969, 24.12683487,   0.00000000, 0.00000000, 253.99841309, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2786.94726562, 3921.17382812, 24.15466690,   0.00000000, 0.00000000, 253.99841309, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2746.56640625, 3954.76147461, 24.13843918,   0.00000000, 0.00000000, 347.99841309, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2751.47753906, 3977.73291016, 24.13843918,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2841.40625000, 3929.83300781, 24.12683487,   0.00000000, 0.00000000, 347.99841309, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2851.06591797, 3973.18481445, 24.12683487,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2836.52099609, 3997.67578125, 24.12683487,   0.00000000, 0.00000000, 77.99740601, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2815.47021484, 4002.09277344, 24.12683487,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2788.80419922, 4007.75634766, 24.12683487,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2756.10351562, 4000.28222656, 24.13843918,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2766.35278320, 4012.79077148, 24.12683487,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2789.50781250, 4093.22802734, 24.13843918,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2794.11694336, 4114.47070312, 24.13843918,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2799.16967773, 4138.93750000, 24.13843918,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2888.39453125, 4084.05273438, 24.12683487,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2892.84936523, 4104.83642578, 24.12683487,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2896.09790039, 4126.13525391, 24.12683487,   0.00000000, 0.00000000, 1.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2916.12524414, 4139.16357422, 24.30265999,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1294, 2943.34130859, 4133.59912109, 24.30265999,   0.00000000, 0.00000000, 257.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1244, 2722.30004883, 3937.10009766, 20.70000076,   0.00000000, 0.00000000, 75.99792480, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3287, 2697.08911133, 3957.44506836, 24.54122543,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1372, 2699.92749023, 3940.99218750, 19.77940178,   0.00000000, 0.00000000, 350.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1372, 2754.43334961, 3973.18017578, 19.82549095,   0.00000000, 0.00000000, 349.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1372, 2752.73583984, 3973.50341797, 19.80781555,   0.00000000, 0.00000000, 349.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1372, 2929.11767578, 4021.59106445, 19.77656555,   0.00000000, 0.00000000, 167.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1365, 2864.51196289, 4053.30883789, 20.93799210,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1365, 2830.03686523, 4059.58862305, 20.92388725,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1358, 2887.83374023, 3979.11035156, 20.98011208,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18248, 2825.18725586, 4094.51513672, 27.84817886,   0.00000000, 0.00000000, 251.99993896, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3572, 2823.57202148, 4091.00927734, 29.62930870,   0.00000000, 0.00000000, 33.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3572, 2823.58007812, 4091.02001953, 27.00000000,   0.00000000, 179.99450684, 33.99172974, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18248, 2777.26367188, 4092.85180664, 27.84309387,   0.00000000, 0.00000000, 71.99890137, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9237, 2851.34130859, 3853.26733398, 32.61659241,   0.00000000, 0.00000000, 92.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2688.45581055, 3996.60839844, 33.96498108,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2696.44921875, 4031.01513672, 33.96498108,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2706.71362305, 4079.41894531, 33.96498108,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2716.46850586, 4125.14941406, 33.96498108,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2724.89282227, 4165.25000000, 33.96498108,   0.00000000, 0.00000000, 77.98645020, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2768.35913086, 3869.61230469, 16.52243423,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2773.57666016, 3868.50292969, 16.46732903,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2768.35839844, 3869.61230469, 18.77243423,   0.00000000, 90.00000000, 347.99996948, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2842.75830078, 4056.71582031, 36.97924423,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2836.88549805, 4057.96557617, 36.84874344,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2842.75781250, 4056.71582031, 39.22924423,   0.00000000, 269.00000000, 350.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2795.07128906, 4017.29882812, 36.83915710,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2800.70214844, 4016.18041992, 36.83915710,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3440, 2795.07128906, 4017.29882812, 39.08915710,   0.00000000, 270.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3096, 2702.19726562, 3947.49194336, 26.54215813,   0.00000000, 0.00000000, 80.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2921, 2854.45629883, 3881.36743164, 25.35809517,   0.00000000, 0.00000000, 266.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2922, 2734.90136719, 3914.54882812, 23.28427696,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2922, 2704.41308594, 3931.82006836, 21.10980988,   0.00000000, 0.00000000, 299.99996948, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3279, 2771.43359375, 4170.27587891, 19.77656746,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4825, 2862.28320312, 3903.82421875, -21.41556549,   359.99453735, 179.99450684, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4825, 2862.28320312, 3903.82421875, -35.91556549,   359.99453735, 179.99450684, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4825, 2862.28320312, 3903.82421875, -50.41556549,   359.99453735, 179.99450684, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(4825, 2862.28320312, 3903.82421875, -64.91556549,   359.99450684, 179.99450684, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3273, 2752.46801758, 3907.52270508, 31.92758751,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3273, 2720.50610352, 3914.32104492, 31.92758751,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2758.09375000, 3920.78417969, 21.24831772,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2784.01757812, 3913.11181641, 21.24780273,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2814.25976562, 3906.65820312, 21.24779510,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2801.67089844, 3909.34179688, 21.24779892,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2796.61132812, 3910.42089844, 21.24779892,   0.00000000, 0.00000000, 347.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2765.76464844, 3908.95117188, 21.24588013,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2777.60864258, 3889.95263672, 21.24194336,   0.00000000, 0.00000000, 303.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8674, 2783.46875000, 3880.55761719, 21.23999786,   0.00000000, 0.00000000, 257.99719238, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2817.22753906, 3895.84008789, 21.24536133,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8673, 2813.71264648, 3879.52148438, 21.24128723,   0.00000000, 0.00000000, 77.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3407, 2806.32421875, 3908.91650391, 19.78101730,   0.00000000, 0.00000000, 349.99145508, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10794, 2973.10815430, 4043.41870117, 4.25000000,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3753, 2947.56640625, 4053.02539062, 10.25000000,   0.00000000, 0.00000000, 257.99194336, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10795, 2972.50000000, 4041.00000000, 14.19999981,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(10793, 2957.30004883, 3969.62988281, 32.70000076,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8075, 2964.67089844, 4001.99584961, 17.47938728,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8077, 2976.17944336, 4019.98779297, 17.47938538,   0.00000000, 0.00000000, 168.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(8078, 2963.94824219, 4022.56152344, 17.47938538,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(5259, 2977.21459961, 4005.38061523, 13.48124981,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3722, 2977.22412109, 4061.30004883, 17.89953232,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(17055, 2955.07714844, 4008.04833984, 15.82342339,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3171, 2955.83496094, 4134.38281250, 19.77130890,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3172, 2943.14355469, 4101.12548828, 19.84531212,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9131, 2894.13183594, 3853.41284180, 20.90113640,   0.00000000, 0.00000000, 299.99670410, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9131, 2670.01367188, 3904.02734375, 20.90022469,   0.00000000, 0.00000000, 213.99169922, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9131, 2672.39160156, 3900.50292969, 20.90548134,   0.00000000, 0.00000000, 123.99169922, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9131, 2897.76171875, 3855.69726562, 20.90548134,   0.00000000, 0.00000000, 213.99169922, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9131, 2736.74755859, 4218.37255859, 20.90548134,   0.00000000, 0.00000000, 31.99169922, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(9131, 2740.31640625, 4220.55273438, 20.90022469,   0.00000000, 0.00000000, 119.98718262, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3109, 2986.01489258, 4187.77392578, 20.96907616,   0.00000000, 0.00000000, 36.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3109, 2724.51074219, 4243.47070312, 20.96907616,   0.00000000, 0.00000000, 119.99816895, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3109, 2909.95947266, 3830.57031250, 20.96907616,   0.00000000, 0.00000000, 301.99670410, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3109, 2647.76245117, 3887.42553711, 20.96907616,   0.00000000, 0.00000000, 213.99218750, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(18452, 2723.00000000, 3939.80004883, 22.70000076,   0.00000000, 0.00000000, 348.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3627, 2912.50000000, 4083.19995117, 23.60000038,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3361, 2950.60009766, 4082.80004883, 7.19999981,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3361, 2951.87988281, 4088.80004883, 3.11999989,   0.00000000, 0.00000000, 77.99743652, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3406, 2953.50000000, 4096.50000000, -1.00000000,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11292, 2901.19995117, 3892.89990234, 21.20000076,   0.00000000, 0.00000000, 260.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(17037, 2901.00000000, 3886.10009766, 22.29999924,   0.00000000, 0.00000000, 260.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1496, 2900.10009766, 3895.89990234, 19.56999969,   0.00000000, 0.00000000, 156.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(11631, 2903.19995117, 3895.89990234, 21.20000076,   0.00000000, 0.00000000, 260.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2308, 2901.50000000, 3891.19995117, 20.00000000,   0.00000000, 0.00000000, 260.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2310, 2901.50000000, 3890.30004883, 20.50000000,   0.00000000, 0.00000000, 260.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1810, 2902.69995117, 3895.80004883, 20.00000000,   0.00000000, 0.00000000, 80.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(16377, 2899.60009766, 3889.39990234, 21.00000000,   0.00000000, 0.00000000, 324.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2824, 2902.10009766, 3891.10009766, 20.79999924,   0.00000000, 0.00000000, 350.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2066, 2901.19995117, 3888.89990234, 20.00000000,   0.00000000, 0.00000000, 170.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2066, 2901.79980469, 3888.79980469, 20.00000000,   0.00000000, 0.00000000, 169.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2286, 2899.60009766, 3892.19995117, 21.60000038,   0.00000000, 0.00000000, 80.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2776, 2902.69995117, 3892.50000000, 20.50000000,   0.00000000, 0.00000000, 352.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2776, 2901.89990234, 3892.60009766, 20.50000000,   0.00000000, 0.00000000, 349.99645996, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2007, 2900.89990234, 3896.69995117, 20.00000000,   0.00000000, 0.00000000, 350.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(2190, 2901.65991211, 3891.45996094, 20.78000069,   0.00000000, 0.00000000, 350.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2778.80004883, 4208.89990234, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2772.39990234, 4179.00000000, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2801.89990234, 4204.20019531, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2795.30004883, 4174.00000000, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2822.19995117, 4168.20019531, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2829.69995117, 4198.10009766, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2859.00000000, 4191.89990234, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2852.39990234, 4161.70019531, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2881.30004883, 4155.70019531, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2887.60009766, 4185.89990234, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3666, 2913.19921875, 4180.39941406, 20.29999924,   0.00000000, 0.00000000, 0.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3258, 2761.80004883, 4033.39990234, 62.29999924,   0.00000000, 0.00000000, 347.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3258, 2875.69995117, 4040.69995117, 62.29999924,   0.00000000, 0.00000000, 167.99694824, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(13367, 2871.89990234, 4017.10009766, 37.50000000,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(3398, 2905.10009766, 3889.39990234, 34.00000000,   0.00000000, 0.00000000, 258.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);
	CreateDynamicObject(1223, 2757.19995117, 3865.30004883, 9.39999962,   0.00000000, 0.00000000, 78.00000000, .interiorid = -1, .worldid = -1, .streamdistance = 400);

	//Island for Steve_Y._Young lost in last gcustom
	CreateDynamicObject(9946,3779.69995117,1982.30004883,2.00000000,0.00000000,0.01998901,90.00000000, .worldid = 0, .streamdistance = 300); //object(pyrground_sfe) (1)
	CreateDynamicObject(3607,3826.30004883,2040.50000000,8.19999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(bevman2_law2) (1)
	CreateDynamicObject(9946,3826.39941406,2039.59960938,2.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(pyrground_sfe) (2)
	CreateDynamicObject(9946,3873.50000000,1980.90002441,2.00000000,0.00000000,0.01647949,270.00000000, .worldid = 0, .streamdistance = 300); //object(pyrground_sfe) (5)
	CreateDynamicObject(13681,3873.69995117,1982.09997559,7.00000000,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(tcehilhouse03) (1)
	CreateDynamicObject(13681,3777.60009766,1982.40002441,6.90000010,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(tcehilhouse03) (2)
	CreateDynamicObject(5812,3813.69995117,1973.50000000,1.91999996,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(grasspatchlawn) (1)
	CreateDynamicObject(5812,3837.89941406,1973.29980469,1.75000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(grasspatchlawn) (2)
	CreateDynamicObject(711,3828.89990234,1926.00000000,7.80000019,0.00000000,0.00000000,120.00000000, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (1)
	CreateDynamicObject(711,3823.00000000,1926.19995117,7.80000019,0.00000000,0.00000000,119.99813843, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (2)
	CreateDynamicObject(711,3823.10009766,1940.69995117,7.80000019,0.00000000,0.00000000,179.99816895, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (3)
	CreateDynamicObject(711,3829.00000000,1940.50000000,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (4)
	CreateDynamicObject(711,3828.89990234,1953.59997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (5)
	CreateDynamicObject(711,3823.19995117,1953.40002441,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (6)
	CreateDynamicObject(711,3823.19995117,1968.50000000,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (7)
	CreateDynamicObject(711,3828.80004883,1968.30004883,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (8)
	CreateDynamicObject(711,3828.80004883,1981.09997559,7.80000019,0.00000000,0.00000000,177.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (9)
	CreateDynamicObject(711,3823.39990234,1981.09997559,7.80000019,0.00000000,0.00000000,177.98950195, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (10)
	CreateDynamicObject(711,3823.39990234,1997.00000000,7.80000019,0.00000000,0.00000000,177.98950195, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (11)
	CreateDynamicObject(711,3828.80004883,1997.00000000,7.80000019,0.00000000,0.00000000,177.98950195, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (12)
	CreateDynamicObject(711,3822.80004883,2012.59997559,7.80000019,0.00000000,0.00000000,177.98950195, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (13)
	CreateDynamicObject(711,3828.89990234,2012.69995117,7.80000019,0.00000000,0.00000000,177.98950195, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (14)
	CreateDynamicObject(9833,3814.10009766,1973.80004883,5.00000000,0.00000000,0.00000000,32.00000000, .worldid = 0, .streamdistance = 300); //object(fountain_sfw) (1)
	CreateDynamicObject(9833,3839.39990234,1973.69995117,5.00000000,0.00000000,0.00000000,235.99731445, .worldid = 0, .streamdistance = 300); //object(fountain_sfw) (2)
	CreateDynamicObject(3515,3838.69995117,1957.90002441,2.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsfountain) (1)
	CreateDynamicObject(3515,3838.60009766,1987.50000000,2.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsfountain) (2)
	CreateDynamicObject(3515,3814.60009766,1988.69995117,2.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsfountain) (3)
	CreateDynamicObject(3515,3814.80004883,1957.90002441,2.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsfountain) (4)
	CreateDynamicObject(8623,3838.89990234,1973.40002441,3.09999990,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(bush03_lvs) (1)
	CreateDynamicObject(8623,3814.80004883,1974.09997559,3.29999995,0.00000000,0.00000000,358.00000000, .worldid = 0, .streamdistance = 300); //object(bush03_lvs) (2)
	CreateDynamicObject(3660,3809.69921875,2021.50000000,4.19999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (1)
	CreateDynamicObject(3660,3800.00000000,2030.05004883,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (2)
	CreateDynamicObject(3660,3800.00000000,2049.67993164,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (3)
	CreateDynamicObject(3660,3808.55395508,2059.80004883,4.19999981,0.00000000,0.00000000,180.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (4)
	CreateDynamicObject(3660,3828.00000000,2059.79980469,4.19999981,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (5)
	CreateDynamicObject(3660,3844.00000000,2059.79980469,4.19999981,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (6)
	CreateDynamicObject(3660,3852.60009766,2051.25000000,4.19999981,0.00000000,0.00000000,89.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (7)
	CreateDynamicObject(3660,3852.59960938,2032.00000000,4.19999981,0.00000000,0.00000000,89.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (8)
	CreateDynamicObject(3660,3844.05004883,2021.50000000,4.19999981,0.00000000,0.00000000,359.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (9)
	CreateDynamicObject(3660,3837.74194336,2021.50000000,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (10)
	CreateDynamicObject(3660,3813.98999023,2021.50000000,4.19999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (11)
	CreateDynamicObject(3660,3852.59960938,2010.59997559,4.19999981,0.00000000,0.00000000,89.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (13)
	CreateDynamicObject(3660,3852.59960938,1991.00000000,4.19999981,0.00000000,0.00000000,89.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (14)
	CreateDynamicObject(3660,3852.59960938,1965.40002441,4.19999981,0.00000000,0.00000000,89.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (15)
	CreateDynamicObject(3660,3863.50000000,1956.31994629,4.19999981,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (16)
	CreateDynamicObject(3660,3883.00000000,1956.31933594,4.19999981,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (17)
	CreateDynamicObject(3660,3894.00000000,1956.69995117,4.19999981,0.00000000,0.00000000,269.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (18)
	CreateDynamicObject(3660,3894.00000000,1976.19995117,4.19999981,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (19)
	CreateDynamicObject(3660,3894.00000000,1995.80004883,4.19999981,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (20)
	CreateDynamicObject(3660,3884.89990234,2006.80004883,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (21)
	CreateDynamicObject(3660,3863.00000000,2006.80004883,4.19999981,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (22)
	CreateDynamicObject(3660,3852.59960938,1960.00000000,4.19999981,0.00000000,0.00000000,89.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (23)
	CreateDynamicObject(3660,3852.59960938,1935.09997559,4.19999981,0.00000000,0.00000000,89.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (24)
	CreateDynamicObject(3660,3844.00000000,1926.45776367,4.19999981,0.00000000,0.00000000,359.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (25)
	CreateDynamicObject(3660,3837.72998047,1926.45703125,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (26)
	CreateDynamicObject(3660,3814.25000000,1926.45703125,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (27)
	CreateDynamicObject(3660,3808.55004883,1926.45703125,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (28)
	CreateDynamicObject(3660,3800.00000000,1936.80004883,4.19999981,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (29)
	CreateDynamicObject(3660,3800.00000000,1959.00000000,4.19999981,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (30)
	CreateDynamicObject(3660,3800.00000000,1970.00000000,4.19999981,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (31)
	CreateDynamicObject(3660,3800.00000000,2001.00000000,4.19999981,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (32)
	CreateDynamicObject(3660,3789.10009766,1956.69995117,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (33)
	CreateDynamicObject(3660,3769.50000000,1956.69921875,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (34)
	CreateDynamicObject(3660,3759.50000000,1984.80004883,4.19999981,0.00000000,0.00000000,269.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (35)
	CreateDynamicObject(3660,3759.50000000,1965.24414062,4.19999981,0.00000000,0.00000000,269.97802734, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (36)
	CreateDynamicObject(3660,3759.50000000,2000.00000000,4.19999981,0.00000000,0.00000000,269.97802734, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (37)
	CreateDynamicObject(3660,3788.98999023,2008.50000000,4.19999981,0.00000000,0.00000000,179.97802734, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (38)
	CreateDynamicObject(3660,3769.89990234,2008.50000000,4.19999981,0.00000000,0.00000000,179.97253418, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (39)
	CreateDynamicObject(3660,3800.00000000,2020.00000000,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (40)
	CreateDynamicObject(3660,3822.80004883,2012.40002441,4.19999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (41)
	CreateDynamicObject(3660,3822.79980469,1993.00000000,4.19999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (42)
	CreateDynamicObject(3660,3822.79980469,1985.00000000,4.19999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (43)
	CreateDynamicObject(3660,3822.79980469,1954.00000000,4.19999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (44)
	CreateDynamicObject(3660,3822.79980469,1935.00000000,4.19999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (45)
	CreateDynamicObject(3660,3829.19995117,1935.09997559,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (46)
	CreateDynamicObject(3660,3829.19921875,1954.50000000,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (47)
	CreateDynamicObject(3660,3829.19921875,1960.00000000,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (48)
	CreateDynamicObject(3660,3829.19921875,1993.59997559,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (49)
	CreateDynamicObject(3660,3829.19921875,2012.00000000,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (50)
	CreateDynamicObject(3660,3863.39990234,1926.45703125,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (51)
	CreateDynamicObject(3660,3882.88989258,1926.45703125,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (52)
	CreateDynamicObject(3660,3894.00000000,1937.09997559,4.19999981,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (55)
	CreateDynamicObject(3660,3893.39990234,1897.90002441,4.19999981,0.00000000,0.00000000,89.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (57)
	CreateDynamicObject(3243,3872.19995117,1951.80004883,1.39999998,0.00000000,0.00000000,181.99548340, .worldid = 0, .streamdistance = 300); //object(tepee_room_) (2)
	CreateDynamicObject(3243,3880.10009766,1949.00000000,1.39999998,0.00000000,0.00000000,141.99548340, .worldid = 0, .streamdistance = 300); //object(tepee_room_) (3)
	CreateDynamicObject(3243,3864.39990234,1937.59997559,1.39999998,0.00000000,0.00000000,303.99511719, .worldid = 0, .streamdistance = 300); //object(tepee_room_) (5)
	CreateDynamicObject(3243,3883.60009766,1941.40002441,1.39999998,0.00000000,0.00000000,89.99548340, .worldid = 0, .streamdistance = 300); //object(tepee_room_) (6)
	CreateDynamicObject(3243,3879.10009766,1934.59997559,1.39999998,0.00000000,0.00000000,39.99023438, .worldid = 0, .streamdistance = 300); //object(tepee_room_) (8)
	CreateDynamicObject(3243,3871.69995117,1933.09997559,1.39999998,0.00000000,0.00000000,353.99084473, .worldid = 0, .streamdistance = 300); //object(tepee_room_) (9)
	CreateDynamicObject(3243,3864.50000000,1949.19995117,1.39999998,0.00000000,0.00000000,217.99401855, .worldid = 0, .streamdistance = 300); //object(tepee_room_) (12)
	CreateDynamicObject(12814,3867.79980469,1941.09960938,1.39999998,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(cuntyeland04) (1)
	CreateDynamicObject(1463,3873.80004883,1942.69995117,1.70000005,0.00000000,37.99621582,0.00000000, .worldid = 0, .streamdistance = 300); //object(dyn_woodpile2) (3)
	CreateDynamicObject(1463,3873.19995117,1942.00000000,1.70000005,0.00000000,37.99072266,283.99658203, .worldid = 0, .streamdistance = 300); //object(dyn_woodpile2) (5)
	CreateDynamicObject(1463,3872.39990234,1942.30004883,1.70000005,0.00000000,37.99072266,193.99658203, .worldid = 0, .streamdistance = 300); //object(dyn_woodpile2) (6)
	CreateDynamicObject(1463,3873.00000000,1943.19995117,1.70000005,0.00000000,37.98522949,93.99108887, .worldid = 0, .streamdistance = 300); //object(dyn_woodpile2) (7)
	CreateDynamicObject(3461,3872.89990234,1942.69995117,0.80000001,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(tikitorch01_lvs) (1)
	CreateDynamicObject(3461,3872.89990234,1942.09997559,0.80000001,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(tikitorch01_lvs) (2)
	CreateDynamicObject(3886,3796.69995117,1951.09997559,1.10000002,0.00000000,0.00000000,180.00000000, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (2)
	CreateDynamicObject(3886,3796.69995117,1940.59997559,1.10000002,0.00000000,0.00000000,180.00000000, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (4)
	CreateDynamicObject(3886,3796.69921875,1930.59960938,1.10000002,0.00000000,0.00000000,180.00000000, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (5)
	CreateDynamicObject(3886,3790.00000000,1953.29980469,1.10000002,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (6)
	CreateDynamicObject(3886,3779.80004883,1953.30004883,1.10000002,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (8)
	CreateDynamicObject(3886,3768.89941406,1927.50000000,1.10000002,0.00000000,0.00000000,89.98901367, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (9)
	CreateDynamicObject(3886,3779.30004883,1927.50000000,1.10000002,0.00000000,0.00000000,89.98901367, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (10)
	CreateDynamicObject(3886,3769.39990234,1953.30004883,1.10000002,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (11)
	CreateDynamicObject(3886,3789.69921875,1927.59960938,1.10000002,0.00000000,0.00000000,89.97802734, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (15)
	CreateDynamicObject(3660,3759.50000000,1965.24414062,4.19999981,0.00000000,0.00000000,269.97802734, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (58)
	CreateDynamicObject(3886,3763.39990234,1953.30004883,1.10000002,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (17)
	CreateDynamicObject(3660,3759.50000000,1961.19995117,4.19999981,0.00000000,0.00000000,269.97802734, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (62)
	CreateDynamicObject(3886,3761.00000000,1927.50000000,1.10000002,0.00000000,0.00000000,89.98901367, .worldid = 0, .streamdistance = 300); //object(ws_jettynol_sfx) (18)
	CreateDynamicObject(3660,3789.00000000,1926.45703125,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (63)
	CreateDynamicObject(3660,3766.00000000,1926.45703125,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (64)
	CreateDynamicObject(3660,3770.00000000,1926.45703125,4.19999981,0.00000000,0.00000000,359.99450684, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (65)
	CreateDynamicObject(3660,3822.79980469,1960.00000000,4.19999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (66)
	CreateDynamicObject(3660,3829.19921875,1985.00000000,4.19999981,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (67)
	CreateDynamicObject(3660,3800.00000000,1995.00000000,4.19999981,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (68)
	CreateDynamicObject(8355,3825.00000000,1908.40002441,1.29999995,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(vgssairportland18) (1)
	CreateDynamicObject(3660,3893.39990234,1917.50000000,4.19999981,0.00000000,0.00000000,89.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (69)
	CreateDynamicObject(3660,3870.00000000,2006.80004883,4.19999981,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (70)
	CreateDynamicObject(3660,3883.00000000,1889.40002441,4.19999981,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (71)
	CreateDynamicObject(3660,3864.00000000,1889.39941406,4.19999981,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (72)
	CreateDynamicObject(3660,3844.39990234,1889.39941406,4.19999981,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (73)
	CreateDynamicObject(3660,3824.80004883,1889.39941406,4.19999981,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (74)
	CreateDynamicObject(3660,3805.19995117,1889.39941406,4.19999981,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (75)
	CreateDynamicObject(3660,3785.60009766,1889.39941406,4.19999981,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (76)
	CreateDynamicObject(3660,3766.00000000,1889.39941406,4.19999981,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (77)
	CreateDynamicObject(3660,3757.10009766,1897.90002441,3.00000000,0.00000000,0.00000000,269.98352051, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (79)
	CreateDynamicObject(3660,3757.10009766,1917.40002441,3.00000000,0.00000000,0.00000000,269.97802734, .worldid = 0, .streamdistance = 300); //object(lasairfbed_las) (80)
	CreateDynamicObject(711,3757.10009766,1889.09997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (15)
	CreateDynamicObject(711,3770.89990234,1889.00000000,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (16)
	CreateDynamicObject(711,3790.19995117,1889.09997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (17)
	CreateDynamicObject(711,3809.89990234,1889.09997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (18)
	CreateDynamicObject(711,3829.89990234,1889.09997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (19)
	CreateDynamicObject(711,3848.69995117,1889.19995117,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (20)
	CreateDynamicObject(711,3869.00000000,1889.40002441,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (21)
	CreateDynamicObject(711,3888.39990234,1889.30004883,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (23)
	CreateDynamicObject(711,3888.30004883,1926.19995117,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (24)
	CreateDynamicObject(711,3867.80004883,1926.50000000,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (25)
	CreateDynamicObject(711,3845.80004883,1926.09997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (26)
	CreateDynamicObject(711,3811.39990234,1926.00000000,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (27)
	CreateDynamicObject(711,3793.60009766,1926.40002441,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (28)
	CreateDynamicObject(711,3773.69921875,1926.39941406,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (29)
	CreateDynamicObject(3511,3852.80004883,1939.40002441,1.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (1)
	CreateDynamicObject(3511,3852.89990234,1967.59997559,2.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (2)
	CreateDynamicObject(3511,3852.89990234,1992.59997559,2.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (3)
	CreateDynamicObject(3511,3853.00000000,2015.09997559,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (4)
	CreateDynamicObject(3511,3799.80004883,2015.30004883,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (5)
	CreateDynamicObject(3511,3799.30004883,1990.90002441,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (6)
	CreateDynamicObject(3511,3799.39990234,1965.80004883,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (7)
	CreateDynamicObject(3511,3799.50000000,1941.89941406,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (8)
	CreateDynamicObject(3511,3799.80004883,2034.90002441,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (9)
	CreateDynamicObject(3511,3800.09960938,2060.00000000,2.79999995,0.00000000,0.00000000,358.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (10)
	CreateDynamicObject(3511,3815.89990234,2060.10009766,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (11)
	CreateDynamicObject(3511,3852.50000000,2059.89990234,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (12)
	CreateDynamicObject(3511,3852.80004883,2036.90002441,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (13)
	CreateDynamicObject(3511,3836.89990234,2059.89990234,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(vgsn_nitree_b01) (14)
	CreateDynamicObject(711,3793.30004883,1956.59997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (30)
	CreateDynamicObject(711,3774.19995117,1956.69995117,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (31)
	CreateDynamicObject(711,3759.69995117,1956.30004883,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (32)
	CreateDynamicObject(711,3759.50000000,1980.00000000,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (33)
	CreateDynamicObject(711,3759.39990234,2008.59997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (34)
	CreateDynamicObject(711,3778.30004883,2008.59997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (35)
	CreateDynamicObject(711,3871.39990234,2006.59997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (36)
	CreateDynamicObject(711,3893.19995117,2006.50000000,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (37)
	CreateDynamicObject(711,3893.60009766,1987.69995117,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (38)
	CreateDynamicObject(711,3893.69995117,1970.50000000,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (39)
	CreateDynamicObject(711,3894.00000000,1952.30004883,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (40)
	CreateDynamicObject(711,3877.39990234,1956.59997559,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (41)
	CreateDynamicObject(16151,3817.39990234,2046.90002441,3.29999995,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(ufo_bar) (1)
	CreateDynamicObject(1825,3840.50000000,2050.39941406,2.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (1)
	CreateDynamicObject(1825,3833.89990234,2050.69995117,2.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (2)
	CreateDynamicObject(1825,3810.69995117,2051.00000000,2.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (4)
	CreateDynamicObject(1825,3816.30004883,2051.30004883,2.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (5)
	CreateDynamicObject(2614,3825.30004883,2027.59997559,8.39999962,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(cj_us_flag) (1)
	CreateDynamicObject(1274,3785.69995117,1969.90002441,6.50000000,0.00000000,0.00000000,263.99694824, .worldid = 0, .streamdistance = 300); //object(bigdollar) (2)
	CreateDynamicObject(8615,3773.50000000,1997.90002441,5.15000010,0.00000000,0.00000000,178.00000000, .worldid = 0, .streamdistance = 300); //object(vgssstairs04_lvs) (1)
	CreateDynamicObject(8615,3877.89990234,1966.40002441,5.19999981,0.00000000,0.00000000,359.99499512, .worldid = 0, .streamdistance = 300); //object(vgssstairs04_lvs) (2)
	CreateDynamicObject(640,3836.10009766,1944.09997559,2.70000005,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (1)
	CreateDynamicObject(640,3841.50000000,1944.09997559,2.70000005,0.00000000,0.00000000,270.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (2)
	CreateDynamicObject(640,3844.39990234,1951.00000000,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (3)
	CreateDynamicObject(640,3844.39941406,1946.50000000,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (4)
	CreateDynamicObject(640,3844.39941406,1956.40002441,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (5)
	CreateDynamicObject(640,3844.39941406,1961.69995117,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (6)
	CreateDynamicObject(640,3844.39941406,1967.00000000,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (7)
	CreateDynamicObject(640,3844.39941406,1972.00000000,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (8)
	CreateDynamicObject(640,3844.39941406,1977.00000000,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (9)
	CreateDynamicObject(640,3844.39941406,1982.00000000,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (10)
	CreateDynamicObject(640,3844.39941406,1987.00000000,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (11)
	CreateDynamicObject(640,3844.39941406,1992.30004883,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (12)
	CreateDynamicObject(640,3844.39941406,1996.80004883,2.70000005,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (13)
	CreateDynamicObject(640,3879.50000000,1997.30004883,7.69999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (14)
	CreateDynamicObject(640,3835.89990234,1999.59997559,2.70000005,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (15)
	CreateDynamicObject(640,3833.39990234,1997.09997559,2.70000005,0.00000000,0.00000000,180.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (16)
	CreateDynamicObject(640,3833.39990234,1991.80004883,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (17)
	CreateDynamicObject(640,3833.39990234,1986.50000000,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (18)
	CreateDynamicObject(640,3833.39990234,1981.19995117,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (19)
	CreateDynamicObject(640,3833.39990234,1976.00000000,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (20)
	CreateDynamicObject(640,3833.39990234,1970.80004883,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (21)
	CreateDynamicObject(640,3833.39990234,1965.59997559,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (22)
	CreateDynamicObject(640,3833.39990234,1960.40002441,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (23)
	CreateDynamicObject(640,3833.39990234,1955.19995117,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (24)
	CreateDynamicObject(640,3833.39990234,1949.90002441,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (25)
	CreateDynamicObject(640,3833.39990234,1946.40002441,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (26)
	CreateDynamicObject(640,3809.19995117,1997.30004883,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (27)
	CreateDynamicObject(640,3809.19995117,1992.00000000,2.70000005,0.00000000,0.00000000,180.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (28)
	CreateDynamicObject(640,3809.19995117,1986.59997559,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (29)
	CreateDynamicObject(640,3809.19995117,1981.30004883,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (30)
	CreateDynamicObject(640,3809.19995117,1976.00000000,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (31)
	CreateDynamicObject(640,3809.19995117,1970.69995117,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (32)
	CreateDynamicObject(640,3809.19995117,1965.40002441,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (33)
	CreateDynamicObject(640,3809.19995117,1960.19995117,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (34)
	CreateDynamicObject(640,3809.19995117,1955.00000000,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (35)
	CreateDynamicObject(640,3809.19995117,1949.69995117,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (36)
	CreateDynamicObject(640,3809.19995117,1946.90002441,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (37)
	CreateDynamicObject(640,3811.60009766,1944.50000000,2.70000005,0.00000000,0.00000000,269.99447632, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (38)
	CreateDynamicObject(640,3817.50000000,1944.40002441,2.70000005,0.00000000,0.00000000,269.98901367, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (39)
	CreateDynamicObject(640,3820.19995117,1946.90002441,2.70000005,0.00000000,0.00000000,359.98901367, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (40)
	CreateDynamicObject(640,3820.19995117,1952.00000000,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (41)
	CreateDynamicObject(640,3820.19995117,1957.19995117,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (42)
	CreateDynamicObject(640,3820.19995117,1962.40002441,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (43)
	CreateDynamicObject(640,3820.19995117,1967.69995117,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (44)
	CreateDynamicObject(640,3820.19995117,1972.90002441,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (45)
	CreateDynamicObject(640,3820.19995117,1978.19995117,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (46)
	CreateDynamicObject(640,3820.19995117,1983.50000000,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (47)
	CreateDynamicObject(640,3820.19995117,1988.59997559,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (48)
	CreateDynamicObject(640,3820.19995117,1993.59997559,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (49)
	CreateDynamicObject(640,3820.19995117,1997.30004883,2.70000005,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (50)
	CreateDynamicObject(640,3817.80004883,1999.69995117,2.70000005,0.00000000,0.00000000,89.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (51)
	CreateDynamicObject(640,3811.60009766,1999.69995117,2.70000005,0.00000000,0.00000000,89.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (52)
	CreateDynamicObject(869,3814.60009766,1958.00000000,3.40000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(veg_pflowerswee) (1)
	CreateDynamicObject(869,3814.50000000,1988.90002441,3.40000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(veg_pflowerswee) (2)
	CreateDynamicObject(869,3838.50000000,1987.80004883,3.40000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(veg_pflowerswee) (3)
	CreateDynamicObject(869,3838.69995117,1958.00000000,3.40000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(veg_pflowerswee) (4)
	CreateDynamicObject(4585,3778.50000000,1986.09997559,-98.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (1)
	CreateDynamicObject(4585,3778.30004883,1974.69995117,-98.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (2)
	CreateDynamicObject(4585,3816.10009766,1940.30004883,-99.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (3)
	CreateDynamicObject(4585,3779.69995117,1908.80004883,-99.00000000,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (4)
	CreateDynamicObject(4585,3814.69995117,1908.90002441,-99.00000000,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (5)
	CreateDynamicObject(4585,3852.00000000,1908.90002441,-99.00000000,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (6)
	CreateDynamicObject(4585,3870.60009766,1908.69995117,-98.90000153,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (7)
	CreateDynamicObject(4585,3870.60009766,1943.80004883,-98.90000153,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (8)
	CreateDynamicObject(4585,3870.80004883,1976.40002441,-98.50000000,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (9)
	CreateDynamicObject(4585,3871.00000000,1987.00000000,-98.40000153,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (10)
	CreateDynamicObject(4585,3822.60009766,2024.30004883,-98.50000000,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (11)
	CreateDynamicObject(4585,3830.30004883,2040.90002441,-98.19999695,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (12)
	CreateDynamicObject(4585,3822.50000000,2041.19995117,-98.19999695,0.00000000,0.00000000,89.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (13)
	CreateDynamicObject(4585,3794.60009766,1985.50000000,-99.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (15)
	CreateDynamicObject(640,3809.19921875,1992.00000000,2.70000005,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (53)
	CreateDynamicObject(711,3757.69995117,1926.19995117,7.80000019,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(vgs_palm02) (29)
	CreateDynamicObject(3472,3765.80004883,1925.59997559,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (1)
	CreateDynamicObject(3472,3784.50000000,1926.00000000,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (2)
	CreateDynamicObject(3472,3803.69995117,1925.80004883,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (3)
	CreateDynamicObject(3472,3817.30004883,1925.59997559,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (4)
	CreateDynamicObject(3472,3837.60009766,1925.69995117,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (5)
	CreateDynamicObject(3472,3857.50000000,1925.80004883,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (6)
	CreateDynamicObject(3472,3879.10009766,1926.00000000,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (7)
	CreateDynamicObject(3472,3880.00000000,1888.90002441,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (8)
	CreateDynamicObject(3472,3859.19995117,1888.69995117,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (9)
	CreateDynamicObject(3472,3840.30004883,1889.40002441,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (10)
	CreateDynamicObject(3472,3820.10009766,1888.59997559,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (11)
	CreateDynamicObject(3472,3800.69995117,1888.69995117,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (12)
	CreateDynamicObject(3472,3780.39990234,1888.59997559,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (13)
	CreateDynamicObject(3472,3763.69995117,1889.50000000,2.79999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (14)
	CreateDynamicObject(1232,3799.19995117,1979.09997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (2)
	CreateDynamicObject(1232,3799.80004883,1985.59997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (4)
	CreateDynamicObject(1232,3800.30004883,1997.09997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (5)
	CreateDynamicObject(1232,3800.10009766,2008.59997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (6)
	CreateDynamicObject(1232,3788.69995117,2009.30004883,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (7)
	CreateDynamicObject(1232,3775.10009766,2009.00000000,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (8)
	CreateDynamicObject(1232,3760.60009766,2008.90002441,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (9)
	CreateDynamicObject(1232,3759.30004883,1996.69995117,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (10)
	CreateDynamicObject(1232,3758.80004883,1983.50000000,3.00000000,0.00000000,0.00000000,26.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (11)
	CreateDynamicObject(1232,3759.30004883,1967.19995117,3.00000000,0.00000000,0.00000000,25.99914551, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (12)
	CreateDynamicObject(1232,3758.39990234,1952.30004883,3.00000000,0.00000000,0.00000000,25.99914551, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (13)
	CreateDynamicObject(1232,3768.50000000,1956.40002441,3.00000000,0.00000000,0.00000000,25.99914551, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (14)
	CreateDynamicObject(1232,3782.89990234,1956.59997559,3.00000000,0.00000000,0.00000000,25.99914551, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (15)
	CreateDynamicObject(1232,3799.80004883,1957.00000000,3.00000000,0.00000000,0.00000000,25.99914551, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (16)
	CreateDynamicObject(1232,3799.30004883,1967.30004883,3.00000000,0.00000000,0.00000000,25.99914551, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (17)
	CreateDynamicObject(1232,3853.00000000,2006.09997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (18)
	CreateDynamicObject(1232,3852.00000000,1995.00000000,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (19)
	CreateDynamicObject(1232,3852.60009766,1982.09997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (20)
	CreateDynamicObject(1232,3852.39990234,1974.59997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (21)
	CreateDynamicObject(1232,3852.50000000,1964.69995117,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (22)
	CreateDynamicObject(1232,3852.50000000,1956.69995117,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (23)
	CreateDynamicObject(1232,3852.60009766,1950.59997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (24)
	CreateDynamicObject(1232,3852.60009766,1944.19995117,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (25)
	CreateDynamicObject(1232,3852.50000000,1935.30004883,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (26)
	CreateDynamicObject(1232,3893.00000000,1935.00000000,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (27)
	CreateDynamicObject(1232,3893.69995117,1948.40002441,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (28)
	CreateDynamicObject(1232,3893.50000000,1956.50000000,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (29)
	CreateDynamicObject(1232,3882.30004883,1956.30004883,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (30)
	CreateDynamicObject(1232,3866.89990234,1956.59997559,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (31)
	CreateDynamicObject(1232,3893.89990234,1973.50000000,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (32)
	CreateDynamicObject(1232,3893.80004883,1991.30004883,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (33)
	CreateDynamicObject(1232,3894.00000000,2003.00000000,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (34)
	CreateDynamicObject(1232,3878.39990234,2006.50000000,3.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (35)
	CreateDynamicObject(1232,3864.60009766,2006.09997559,3.00000000,0.00000000,0.00000000,14.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (36)
	CreateDynamicObject(1232,3822.10009766,2021.59997559,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (37)
	CreateDynamicObject(1232,3828.10009766,2021.50000000,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (39)
	CreateDynamicObject(1232,3821.80004883,2008.90002441,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (40)
	CreateDynamicObject(1232,3828.60009766,2008.90002441,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (42)
	CreateDynamicObject(1232,3828.19995117,1997.59997559,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (43)
	CreateDynamicObject(1232,3822.50000000,1997.59997559,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (44)
	CreateDynamicObject(1232,3821.69995117,1983.40002441,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (45)
	CreateDynamicObject(1232,3828.00000000,1983.50000000,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (46)
	CreateDynamicObject(1232,3828.10009766,1963.40002441,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (47)
	CreateDynamicObject(1232,3822.80004883,1963.09997559,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (48)
	CreateDynamicObject(1232,3822.19995117,1950.69995117,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (49)
	CreateDynamicObject(1232,3828.00000000,1951.40002441,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (50)
	CreateDynamicObject(1232,3822.30004883,1936.40002441,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (51)
	CreateDynamicObject(1232,3828.00000000,1936.59997559,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (53)
	CreateDynamicObject(782,3865.10009766,1933.30004883,1.39999998,0.00000000,0.00000000,130.00000000, .worldid = 0, .streamdistance = 300); //object(elmtreegrn_hism) (1)
	CreateDynamicObject(782,3874.39990234,1929.90002441,1.39999998,0.00000000,0.00000000,167.99572754, .worldid = 0, .streamdistance = 300); //object(elmtreegrn_hism) (2)
	CreateDynamicObject(782,3884.80004883,1935.19995117,1.39999998,0.00000000,0.00000000,219.99194336, .worldid = 0, .streamdistance = 300); //object(elmtreegrn_hism) (3)
	CreateDynamicObject(782,3886.00000000,1947.59997559,1.39999998,0.00000000,0.00000000,289.99023438, .worldid = 0, .streamdistance = 300); //object(elmtreegrn_hism) (4)
	CreateDynamicObject(782,3877.60009766,1953.09997559,1.39999998,0.00000000,0.00000000,319.98962402, .worldid = 0, .streamdistance = 300); //object(elmtreegrn_hism) (5)
	CreateDynamicObject(782,3867.39990234,1952.80004883,1.39999998,0.00000000,0.00000000,7.98779297, .worldid = 0, .streamdistance = 300); //object(elmtreegrn_hism) (6)
	CreateDynamicObject(782,3862.19995117,1946.19995117,1.39999998,0.00000000,0.00000000,81.98706055, .worldid = 0, .streamdistance = 300); //object(elmtreegrn_hism) (7)
	CreateDynamicObject(782,3860.89990234,1939.19995117,1.39999998,0.00000000,0.00000000,91.98547363, .worldid = 0, .streamdistance = 300); //object(elmtreegrn_hism) (8)
	CreateDynamicObject(640,3785.50000000,1985.59997559,7.59999990,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (55)
	CreateDynamicObject(640,3785.50000000,1980.40002441,7.59999990,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (56)
	CreateDynamicObject(640,3785.50000000,1975.09997559,7.59999990,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (57)
	CreateDynamicObject(640,3785.50000000,1969.69995117,7.59999990,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (58)
	CreateDynamicObject(640,3783.00000000,1967.30004883,7.59999990,0.00000000,0.00000000,269.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (59)
	CreateDynamicObject(640,3780.30004883,1967.30004883,7.59999990,0.00000000,0.00000000,269.97802734, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (60)
	CreateDynamicObject(640,3771.80004883,1967.30004883,7.59999990,0.00000000,0.00000000,269.97802734, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (61)
	CreateDynamicObject(640,3769.30004883,1969.69995117,7.59999990,0.00000000,0.00000000,179.97802734, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (62)
	CreateDynamicObject(640,3769.30004883,1974.90002441,7.59999990,0.00000000,0.00000000,179.97253418, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (63)
	CreateDynamicObject(640,3769.30004883,1980.30004883,7.59999990,0.00000000,0.00000000,179.97253418, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (64)
	CreateDynamicObject(640,3769.30004883,1985.59997559,7.59999990,0.00000000,0.00000000,179.97253418, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (65)
	CreateDynamicObject(640,3769.30004883,1990.50000000,7.59999990,0.00000000,0.00000000,179.97253418, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (66)
	CreateDynamicObject(640,3769.30004883,1994.59997559,7.59999990,0.00000000,0.00000000,179.97253418, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (67)
	CreateDynamicObject(640,3776.80004883,1967.30004883,7.59999990,0.00000000,0.00000000,269.97802734, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (68)
	CreateDynamicObject(640,3785.50000000,1990.00000000,7.59999990,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (69)
	CreateDynamicObject(16151,3776.60009766,1988.30004883,7.19999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(ufo_bar) (3)
	CreateDynamicObject(1825,3773.89990234,1982.30004883,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (3)
	CreateDynamicObject(1825,3778.39990234,1982.09997559,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (11)
	CreateDynamicObject(1825,3782.19995117,1982.00000000,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (12)
	CreateDynamicObject(1825,3782.19995117,1977.50000000,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (13)
	CreateDynamicObject(1825,3777.89990234,1977.50000000,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (14)
	CreateDynamicObject(1825,3773.69995117,1977.80004883,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (15)
	CreateDynamicObject(1825,3773.80004883,1973.30004883,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (17)
	CreateDynamicObject(1825,3778.19995117,1973.30004883,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (18)
	CreateDynamicObject(1825,3782.00000000,1973.09997559,6.90000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_table_chairs1) (19)
	CreateDynamicObject(1568,3769.60009766,1967.50000000,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (1)
	CreateDynamicObject(1568,3777.89990234,1967.40002441,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (2)
	CreateDynamicObject(1568,3785.19995117,1967.40002441,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (3)
	CreateDynamicObject(1568,3785.39990234,1974.69995117,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (4)
	CreateDynamicObject(1568,3785.60009766,1986.09997559,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (5)
	CreateDynamicObject(1568,3769.39990234,1975.40002441,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (6)
	CreateDynamicObject(1568,3769.50000000,1982.40002441,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (7)
	CreateDynamicObject(1568,3769.50000000,1988.90002441,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (8)
	CreateDynamicObject(1568,3785.50000000,1980.30004883,6.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(chinalamp_sf) (9)
	CreateDynamicObject(1232,3810.10009766,2021.59997559,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (54)
	CreateDynamicObject(1232,3799.39990234,2022.59997559,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (55)
	CreateDynamicObject(1232,3800.30004883,2032.50000000,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (56)
	CreateDynamicObject(1232,3799.69995117,2041.80004883,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (57)
	CreateDynamicObject(1232,3799.39990234,2051.30004883,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (60)
	CreateDynamicObject(1232,3803.80004883,2060.00000000,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (61)
	CreateDynamicObject(1232,3812.80004883,2059.80004883,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (62)
	CreateDynamicObject(1232,3820.80004883,2059.89990234,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (63)
	CreateDynamicObject(1232,3830.60009766,2059.80004883,2.00000000,0.00000000,0.00000000,14.00000000, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (64)
	CreateDynamicObject(1232,3844.30004883,2059.80004883,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (65)
	CreateDynamicObject(1232,3852.30004883,2056.39990234,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (66)
	CreateDynamicObject(1232,3852.19995117,2045.69995117,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (67)
	CreateDynamicObject(1232,3852.10009766,2032.80004883,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (68)
	CreateDynamicObject(1232,3851.50000000,2020.90002441,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (69)
	CreateDynamicObject(1232,3839.39990234,2020.69995117,2.00000000,0.00000000,0.00000000,13.99658203, .worldid = 0, .streamdistance = 300); //object(streetlamp1) (70)
	CreateDynamicObject(3472,3800.30004883,2021.59997559,1.29999995,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (15)
	CreateDynamicObject(3472,3852.80004883,2021.90002441,2.09999990,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (16)
	CreateDynamicObject(3472,3851.39990234,2058.50000000,3.40000010,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (17)
	CreateDynamicObject(3472,3802.60009766,2059.80004883,2.20000005,0.00000000,0.00000000,2.00000000, .worldid = 0, .streamdistance = 300); //object(circuslampost03) (18)
	CreateDynamicObject(4585,3830.30004883,2021.40002441,-98.50000000,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(towerlan2) (16)
	CreateDynamicObject(640,3842.09960938,1999.59960938,2.70000005,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (70)
	CreateDynamicObject(640,3874.30004883,1997.30004883,7.69999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (71)
	CreateDynamicObject(640,3869.19995117,1997.30004883,7.69999981,0.00000000,0.00000000,90.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (72)
	CreateDynamicObject(640,3865.89990234,1995.00000000,7.69999981,0.00000000,0.00000000,180.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (73)
	CreateDynamicObject(640,3865.89990234,1989.69995117,7.69999981,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (74)
	CreateDynamicObject(640,3865.89990234,1984.50000000,7.69999981,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (75)
	CreateDynamicObject(640,3865.89990234,1979.40002441,7.69999981,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (76)
	CreateDynamicObject(640,3865.89990234,1975.59997559,7.69999981,0.00000000,0.00000000,179.99450684, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (77)
	CreateDynamicObject(640,3882.00000000,1994.69995117,7.69999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (78)
	CreateDynamicObject(640,3882.00000000,1989.50000000,7.69999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (79)
	CreateDynamicObject(640,3882.00000000,1984.30004883,7.69999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (80)
	CreateDynamicObject(640,3882.00000000,1979.00000000,7.69999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (81)
	CreateDynamicObject(640,3882.00000000,1973.80004883,7.69999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (82)
	CreateDynamicObject(640,3882.00000000,1970.00000000,7.69999981,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (83)
	CreateDynamicObject(3934,3874.80004883,1992.00000000,7.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(helipad01) (1)
	CreateDynamicObject(3934,3875.00000000,1981.90002441,7.00000000,0.00000000,0.00000000,0.00000000, .worldid = 0, .streamdistance = 300); //object(helipad01) (2)
	CreateDynamicObject(640,3788.10009766,1967.50000000,2.79999995,0.00000000,0.00000000,89.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (84)
	CreateDynamicObject(640,3791.89990234,1967.50000000,2.79999995,0.00000000,0.00000000,89.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (85)
	CreateDynamicObject(640,3794.19995117,1970.09997559,2.79999995,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (86)
	CreateDynamicObject(640,3788.50000000,1972.40002441,2.79999995,0.00000000,0.00000000,89.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (87)
	CreateDynamicObject(640,3796.50000000,1972.40002441,2.79999995,0.00000000,0.00000000,89.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (88)
	CreateDynamicObject(640,3794.10009766,1974.69995117,2.79999995,0.00000000,0.00000000,359.98352051, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (89)
	CreateDynamicObject(640,3790.89990234,1974.80004883,2.79999995,0.00000000,0.00000000,359.97802734, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (90)
	CreateDynamicObject(640,3790.89990234,1980.19995117,2.79999995,0.00000000,0.00000000,359.97253418, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (91)
	CreateDynamicObject(640,3796.60009766,1979.40002441,2.79999995,0.00000000,0.00000000,89.97802734, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (92)
	CreateDynamicObject(640,3794.10009766,1977.00000000,2.79999995,0.00000000,0.00000000,359.97802734, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (93)
	CreateDynamicObject(640,3790.89990234,1985.40002441,2.79999995,0.00000000,0.00000000,359.96704102, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (94)
	CreateDynamicObject(640,3796.10009766,1985.50000000,2.79999995,0.00000000,0.00000000,269.96704102, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (95)
	CreateDynamicObject(640,3793.80004883,1987.90002441,2.79999995,0.00000000,0.00000000,359.96160889, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (96)
	CreateDynamicObject(640,3793.80004883,1993.09997559,2.79999995,0.00000000,0.00000000,359.96154785, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (97)
	CreateDynamicObject(640,3790.89990234,1990.40002441,2.79999995,0.00000000,0.00000000,359.96154785, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (98)
	CreateDynamicObject(640,3790.89990234,1994.19995117,2.79999995,0.00000000,0.00000000,359.96154785, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (99)
	CreateDynamicObject(640,3793.80004883,1996.50000000,2.79999995,0.00000000,0.00000000,359.96154785, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (100)
	CreateDynamicObject(640,3793.80004883,2001.59997559,2.79999995,0.00000000,0.00000000,359.96154785, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (101)
	CreateDynamicObject(640,3788.60009766,1996.69995117,2.79999995,0.00000000,0.00000000,89.96154785, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (102)
	CreateDynamicObject(640,3793.80004883,2006.19995117,2.79999995,0.00000000,0.00000000,359.95605469, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (104)
	CreateDynamicObject(9833,3796.60009766,1975.80004883,4.00000000,0.00000000,0.00000000,356.00000000, .worldid = 0, .streamdistance = 300); //object(fountain_sfw) (3)
	CreateDynamicObject(9833,3796.50000000,1988.30004883,4.00000000,0.00000000,0.00000000,355.99548340, .worldid = 0, .streamdistance = 300); //object(fountain_sfw) (4)
	CreateDynamicObject(640,3796.10009766,1992.00000000,2.79999995,0.00000000,0.00000000,271.96154785, .worldid = 0, .streamdistance = 300); //object(kb_planter_bush2) (105)

	for(new i, Float: fPlayerPos[3]; i < MAX_PLAYERS; i++)
	{
	    if(GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0)
		{
			Streamer_UpdateEx(i, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
			GetPlayerPos(i, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
			SetPlayerPos(i, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2] + 2.5);
			TogglePlayerControllable(i, true);
		}
	}
	// Headroom for static objects - streamed limits are completely independent (cause of old crashing)
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 965);
}

public OnPlayerConnect(playerid)
{
	
	return 1;
}
