#include <a_samp>
#include <zcmd>

new szMiscArray[512],
	previousQuestion = -1,
	currentQuestion = -1,
	bool:ActiveQuestion = false,
	ActiveQuestionTimer = -1;

#define QA_COUNT 144
new QuestionsAndAnswers[QA_COUNT][][] =
{
	{"In the earliest Olympic games, athletes competed wearing..", "loincloths"},
	{"In the past, were slaves allowed to watch or participate in the Olympics?", "No"},
	{"In honor of which Greek god te Olympics were held?", "Zeus"},
	{"What is the long-distance race known as the marathon named for?", "A town north of Athens"},
	{"What were winners of Olympic events crowned with?", "chaplets of wild olive"},
	{"Athletes sought to bring glory and honor not only to themselves but to their..", "Cities"},
	{"What is an Olympiad?", "An ancient Greek unit of time"},
	{"Olympia, site of the games, was also home to one of the seven wonders of the ancient world. Which wonder was it?", "The ivory"},
	{"Which event was not an Olympic event?", "The mounted archery"},
	{"To be eligible to compete in the games athletes had to..", "Train faithfully for ten months before the games."},
	{"Hodori and Hosuni, the mascots of the 1988 Olympic Games in Seoul, South Korea, were what type of animal?", "tigers"},
	{"In which Olympics did \"Schuss\", a skiing cartoon character, appear as the first unofficial Olympic Mascot?", "1968 Grenoble"},
	{"Perhaps the most maligned Olympic mascot ever, \"Izzy\" (1996 Atlanta) was derived from what original name?", "Whatizit"},
	{"The full name of the Russian Bear mascot of the 1980 Moscow Games was \"Mikhail Potapych Toptygin.\" What was he better known as?", "Misha"},
	{"While Schuss was the first unofficial mascot, which of the following was the first official mascot at an Olympic Games?", "Waldi the Dachshund"},
	{"Hakon and Kristin, two blond-haired, blue-eyed children are the mascots for which Olympics?", "1994 Lillehammer"},
	{"Was the mascot of Schneemann in the 1976 Innsbruck Games?", "Snowman"},
	{"There were three Olympic mascots for the 2000 Sydney Games. Which one of the following animals was not one of them?", "kangaroo"},
	{"Nagano's mascots were four snow owls named Sukki, Nokki, Lekki and Tsukki. But what was the original Nagano mascot supposed to be...", "a weasel"},
	{"Cobi, the mascot of the 1992 Barcelona Games, was what type of animal?", "Dog"},
	{"Which country has won the most medals at the Olympic games—without ever hosting the games?", "Hungary"},
	{"Which busy European port city was nearly destroyed by a German invasion during World War I but recovered 20 months after the war's end to host the Summer Games?", "Antwerp"},
	{"Which city hosted the first Olympic Summer Games to be held south of the equator?", "Melbourne"},
	{"Located 7,400 feet above sea level, this city is by far the highest to ever be host. What is it?", "Mexico City"},
	{"After hosting its first Olympic games, the organizing committee for this city reconvened in 1939 and participated in every Olympic bid competition for the next 39 years. In 1984, which city joined Athens, London, and Paris as two-time hosts?", "Los Angeles"},
	{"This bridesmaid city lost bids to: Paris in 1924, Berlin in 1936, Tokyo in 1940, and Munich in 1972. It finally got its chance to host two decades later during the 500th anniversary of Christopher Columbus' voyage to the Americas. What is it?", "Barcelona"},
	{"Which Asian city was two votes shy of Sydney in its bid to host the 2000 Summer Games?", "Beijing"},
	{"This European city was originally awarded the 1908 Summer Games, but had to relinquish it to London after the costly destruction caused by the 1906 eruption of Mt. Vesuvius.", "Rome"},
	{"Due to extravagant building before the games, the residents of this North American host city needed 17 years to raise the money needed to pay off their Olympic debt.", "Montreal"},
	{"The Olympic torch relay to this Olympic city bypassed the Pacific Island of Fiji because of mob violence provoked by an attempted coup d'etat. Which city is this?", "Sydney"},
	{"When was the first Olympics held?", "776 BC"},
	{"How often was the original Olympics held? Every..", "4 years"},
	{"Which requirement was not a requirement of the athletes that participated in the Olympics? They must be...", "Slaves"},
	{"What type of event was the only event in the first Olympics? It was a …", "200 meter sprint"},
	{"What was the event in the first Olympics called?", "Stadion"},
	{"Was boxing a part of the pentathlon event?", "No"},
	{"True or false: The athletes that won the Olympics were considered big heroes in Greece.", "True"},
	{"What happened to a boxer if he killed another boxer in the ring? He would...", "lose"},
	{"In what way was politics involved in the Olympics? Athletes were allowed to pass freely through..", "enemy territory"},
	{"London hosts/hosted the 2012 Olympic Games. In which previous years have London hosted the games? DATE and DATE?", "1948 and 1908"},
	{"In the 1994 Winter Olympics, how many athletes represented Israel?", "1"},
	{"What connects the following athletes: runners Zola Budd and Bernard Lagat and basketball player Becky Hammon? They each change their _.", "citizenship"},
	{"How old was Linford Christie when he won gold for the 100m in Barcelona (a record age)?", "32"},
	{"Which Olympic sport is played with stones and brooms?", "Curling"},
	{"Which racket sport made its Olympic debut in 1992?", "Badminton"},
	{"What colours make up the Olympic rings? Blue, Black, Red, Yellow and…?", "Green"},
	{"Which Summer Olympic Games was the first to be televised live? Germany Olympics.. (DATE)?", "1936"},
	{"Considering that India has a population exceeding one billion people, how many gold medals did India win at the Beijing games of 2008?", "1"},
	{"How many national Olympic committees exist (Plus or minus five)?", "204"},
	{"The first disabled athlete to compete in the Olympic Games was American George Eyser in 1904, he had one artificial leg. In which event did he compete?", "Gymnastics"},
	{"Which track athlete won the gold medal in both the 200 and 400 metres in gold shoes at the 1996 Olympics?", "Michael Johnson"},
	{"What is the Basque country's national game?", "pelota"},
	{"Since 1968, which two countries have had the most athletes tested positive for doping? (It's the usual suspects)", "Bulgaria and Hungary"},
	{"Which four cities have twice hosted the summer Olympics?", "Athens, Paris, London & L.A."},
	{"Which Summer Olympic Games were boycotted by the majority of African countries?", "Montreal 1976"},
	{"Papa doc Duvallier had threatened to execute any athletes from his country that did not cross the finish line at the 1976 games in Montreal. Duvallier was the dictator of which country?", "Haiti"},
	{"The following are all members of a bronze medal winning team at the 1904 games in St. Louis. Which sport might it be ? Spotted Tail, Lightfoot, Red Jacket, Rain in Face, Man Afraid Soap, Blackhawk, Black Eagle, Almighty Voice, Flat Iron, Halfmoon and Snake Eater. clue, it's no longer Olympic", "Lacrosse"},
	{"A touring Australian team won gold at the 1908 games in London with the battle cry 'cripple every opponent'. What sport might that have been? Clue, it too is no longer Olympic", "Rugby"},
	{"The Swede Oscar Swahn is the oldest medal winner at the Olympic games. Plus or minus four years, how old was he?", "72"},
	{"The modern Olympic marathon is full of unbelievable stories. Which one of the following is not true ? Velokas, Yamasini and Lentauw or Spirodon Louis", "Velokas"},
	{"The man who has won the most gold medals, namely ten, suffered from polio as a child !!  What was his name ?", "Ray Ewry"},
	{"At which Olympic games in the USA were there special events for 'ethnic minorities'?", "Saint Louis 1904"},
	{"The playing of which instrument was once an Olympic discipline in ancient Greece?", "Trumpet"},
	{"What was unusual about two time Olympic marathon winner Abebe Bikila's running style at the 1960 games?", "barefoot"},
	{"How were false starters punished in ancient Greece? They were..", "Whipped"},
	{"In which discipline did each of the following superstars excel? Wassil Aleksejew/Bruce Jenner/Edwin Moses/Larissa Latynina.", "weightlifting, decathalon, hurdles, gymnastics and high jumping."},
	{"The stadium in Athens for the 1896 games was built from which material?", "marble"},
	{"Which Finnish star won nine gold medals before he was unfairly barred from the 1932 games in L.A.?", "Paavo Nurmi"},
	{"What do Ben Johnson and Waterford Crystal both have in common? They were both disqualified for...", "doping"},
	{"Which two sports that start with the letter C are no longer Olympic?", "Cricket and Croquet"},
	{"Which one of the following was never a modern Olympic discipline? Tumbling/horseshoes/club swinging", "horseshoes"},
	{"Gold, silver and bronze. What do participants who achieve 4th to 8th place receive? A _.", "diploma"},
	{"Which was the only country to host the summer Olympics and not win a single gold medal?", "Canada"},
	{"In which discipline did the father of the modern Olympics, Pierre de Coubertin, win an Olympic gold medal?", "Literature"},
	{"Winners of which Olympic games never had to pay any tax again for the rest of their lives? The ancient games in…?", "Greece"},
	{"Plus or minus five, how many pigeons did Leon de Lunden manage to kill while winning gold in the living pigeon shooting event at the Paris games in 1900?", "21"},
	{"Edward Eagan is the only person in modern Olympic history to win a gold in both a _ and _ Olympiad.", "summer and winter"},
	{"What is the only city in the world named after an Olympic gold medalist?", "Jim Thorpe Town"},
	{"After losing a wrestling bout against the German Jakob Brendel at the 1932 games in L.A., the Sizilian Marcello Nizzola went to the dressing room and attacked his _.  (the word starts with the letter “O” and ends with a “t”)", "opponent"},
	{"Marathon runner Dorando Pietri enters the stadium exhausted to the roar of the crowd and proceeds to run in the wrong direction.At this moment, a British writer helps him to his feet and over the line, where he passes out, only to awake hours later and discover he has been disqualified. Who was the famous writer?", "Arthur Conan Doyle"},
	{"It is common knowledge that the Modern Olympic Games are modeled after the ancient Olympic Games of Greece, but what year was the first modern games held?", "1896"},
	{"Early Olympians competed in the nude. True or False?", "True"},
	{"Who responsible for the revival of the Olympics?", "Baron Pierre de Couberin"},
	{"Since the revival of the Olympics, they have been held every four years except for which years? CLUE: they are three years", "1916, 1940 and 1944"},
	{"What time period were the first Olympic games held? 776 BC to _ AD", "393"},
	{"The five rings of the Olympics symbolise what?", "The five continents"},
	{"Where will the next Summer and Winter Games be held?", "Brazil and South Korea"},
	{"The colors of the Olympic rings are blue, yellow, black, green and red. Why were these colors chosen? At least one of these colors appear on every _ _ in the world", "national flag"},
	{"What is the motto of the Modern Olympics?", "Swifter, higher and stronger."},
	{"The Winter Olympics in Sochi, Russia cost how much? About _ million dollars per event", "520"},
	{"This year in Sochi, 98 Olympic events will be held. How many of those events are new this year to the Olympics?", "12"},
	{"In Sochi Olympics, 2850 athletes competed representing how many countries?", "88"},
	{"At which Olympics did women first compete?", "Paris 1900"},
	{"The International Olympic Committee (IOC) has its headquarters in which country?", "Switzerland"},
	{"Traditionally, which team enters the stadium on the opening night of the Olympics first?", "Greece"},
	{"COMPLETE THE MISSING WORDS: After the 388 B.C. Olympic Games, a bronze statue of Zeus was built on the road to Olympia’s stadium. Why? Four men were caught in a _ _ involving a boxing match and were fined. The penalty money was used to build the bronze statue of Zeus.", "cheating scandal"},
	{"The ancient Greek Games were as much a religious event as a sporting event and were held in honor of the Greek God, Zeus. What traditionally happened at the games to honor the patron-God? 100 _ would be sacrificed", "oxen"},
	{"The prize for the victors in the ancient Greek games was? An _ leaf wreath crown and a large sum of money.", "olive"},
	{"What is an Olympic Truce? A _ between political enemies so that athletes and spectators could travel safely to the games", "truce"},
	{"Which event was NOT included in the Ancient Greek Games?", "Swimming"},
	{"In addition to Seiko, what other watch manufacturer is the only company in the world that meets Olympic timekeeping standards?", "Omega"},
	{"Where is the Olympic torch first lit before each Olympiad? The Temple of _.", "Hera"},
	{"Which Olympics' opening ceremonies saw a man fly into the central stadium on a jet pack?", "Los Angeles 1984"},
	{"What did China do in preparation for the 2008 Beijing Olympics? _ _ at clouds to make them rain", "shot cannons"},
	{"It was reported that as many as 3,500 children born in China around the 2008 games were named \"Olympics\" by their parents. For what other Olympic theme were as many as 4,000 Chinese children named? An _ mascot", "Olympic"},
	{"The pole vaulting event finds its roots in what real-world application? Using poles to cross _.", "canales"},
	{"In the Olympic fencing event, the weapon used is called a…", "foil"},
	{"Which event made its debut at the 1972 Olympics?", "white-water canoe racing"},
	{"Which Canadian sprinter was stripped of a gold medal at the 1988 Olympics in Seoul, South Korea, after testing positive for anabolic steroids?", "Ben Johnson"},
	{"Which Native American won two gold medals for the United States in the 1912 Olympics before going on to become a football star?", "Jim Thorpe"},
	{"In which city were the first Modern Olympics held?", "Athens"},
	{"In which year were the first Modern Olympics held?", "1896"},
	{"When was the original Olympiad first held?", "776 BC"},
	{"Who has won the maximum number of gold medals at a single Olympic Games in the history of the Olympics?", "Michael Phelps"},
	{"Who set a record for the most gold medals in a single Olympic Games at the 1972 Munich Olympics?", "Mark Spitz"},
	{"Name the person who has won the maximum number of total career gold medals (i.e., cumulative gold medals over a period of time) in the Olympics.", "Michael Phelps"},
	{"Name the person who has won the maximum number of total career Olympic medals (i.e., cumulative Olympic medals over a period of time).", "Larissa Latynina"},
	{"Who was the first winner in modern Olympics?", "James Connelly"},
	{"Who was the first gymnast to score a perfect 10 seven times at the Olympics?", "Nadia Comaneci"},
	{"What is the distance of the marathon race in the Olympics? _ miles and _ yards.", "25 and 385"},
	{"What is the meaning of the motto 'Citius, Altius, Fortius' of the Olympic Games?", "Faster, Higher, Stronger"},
	{"Who is the only athlete to win the Olympic marathon title twice in succession?", "Abebe Bikila"},
	{"Who is the athlete to win the Olympic marathon barefoot?", "Abebe Bikila"},
	{"What is the winning team of the Handball men’s Final at London 2012?", "France"},
	{"What is the serial number of the 2008 Beijing Olympics?", "XXIX"},
	{"At what frequency are the Olympic Games held? Every _ years.", "4"},
	{"Which country's team always marches last in the March Past at the Opening Ceremony of the Olympics?", "host country"},
	{"In which Olympics did the world-famous American boxer Muhammad Ali win the light heavyweight boxing title?", "Rome 1960"},
	{"When was the first time the Olympic Games moved to Asia?", "1964"},
	{"Which Olympics are called the 'high level upsets' Olympics?", "Mexico 1968"},
	{"Which country has won the maximum number of gold medals since the inception of the Olympic Games?", "USA"},
	{"Which new game was introduced at the 2000 Sydney Olympics?", "Triathlon"},
	{"Which country's team remained undefeated in field hockey between 1928 and 1956?", "India"},
	{"What object did the archers hit during the competition before the target board was introduced?", "bird"},
	{"Which American diver won a double gold at the 1988 Seoul Olympics in spite of hitting his head on the 3-m springboard?", "Greg Louganis"},
	{"What metal is used in the third-place medal?", "bronze"},
	{"Which is the 'Black September Day' in Olympic history? September _, 1972.", "5"},
	{"Who duplicated Jesse Owens' 1936 feat by winning four golds in track and field in the 1984 Los Angeles Olympics?", "Carl Lewis"},
	{"Which animals were the three mascots of the 2000 Sydney Olympics?", "Echidna, Platypus and a Kookoburra"},
	{"Which character designs are incorporated in the five 'good luck dolls' that are the mascots of the 2008 Beijing Olympics?", "Fish, Giant Panda, Fire, Tibetan Antelope and Swallow"},
	{"In which city were the Olympics in 2004 held?", "Athens"},
	{"In which city were the Olympics in 2012 held?", "London"},
	{"Which country won the men's Basketball competition in 2012 Olympics?", "USA"},
	{"Which country won the men's Football competition in 2004 Olympics?", "Argentina"}
};

public OnFilterScriptInit()
{
	//ActivateRandomQuestion();
	return 1;
}

forward ActivateRandomQuestion();
public ActivateRandomQuestion()
{
	currentQuestion = random(QA_COUNT);
	while(currentQuestion == previousQuestion) currentQuestion = random(QA_COUNT);
	ActiveQuestion = true;
	ActiveQuestionTimer = SetTimerEx("DisableActiveQuestion", 180000, false, "i", 1);
	printf("%d) %s(%d) | %s", currentQuestion, QuestionsAndAnswers[currentQuestion][0], strlen(QuestionsAndAnswers[currentQuestion][0]), QuestionsAndAnswers[currentQuestion][1]);
	format(szMiscArray, sizeof(szMiscArray), "RANDOM QUESTION: %s", QuestionsAndAnswers[currentQuestion][0]);
	if(strlen(szMiscArray) > 140)
	{
		new firstline[144], secondline[144], thirdline[144];
		strmid(firstline, szMiscArray, 0, 140);
		strmid(secondline, szMiscArray, 140, 280);
		strmid(thirdline, szMiscArray, 280, strlen(szMiscArray));
		format(firstline, sizeof(firstline), "%s...", firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		format(thirdline, sizeof(thirdline), "...%s", thirdline);
		SendClientMessageToAll(-1, firstline);
		SendClientMessageToAll(-1, secondline);
		if(strlen(thirdline) > 3) SendClientMessageToAll(-1, thirdline);
	}
	else SendClientMessageToAll(-1, szMiscArray);
	return 1;
}

forward DisableActiveQuestion(expired);
public DisableActiveQuestion(expired)
{
	ActiveQuestion = false;
	if(expired)
	{
		format(szMiscArray, sizeof(szMiscArray), "{3366ff}** The question has now expired and no answers were found. Answer: %s **", QuestionsAndAnswers[currentQuestion][1]);
		SendClientMessageToAll(-1, szMiscArray);
	}
	previousQuestion = currentQuestion;
	currentQuestion = -1;
	KillTimer(ActiveQuestionTimer);
	ActiveQuestionTimer = -1;
	return 1;
}

CMD:randq(playerid, params)
{
	if(GetPVarInt(playerid, "aLvl") < 4) return 1;
	if(ActiveQuestion) DisableActiveQuestion(0);
	ActivateRandomQuestion();
	return 1;
}

CMD:oanswer(playerid, params[])
{
	if(!ActiveQuestion) return SendClientMessage(playerid, -1, "There is currently no active question.");
	if(isnull(params)) return SendClientMessage(playerid, -1, "USAGE: /oanswer [answer]");
	if(!strcmp(QuestionsAndAnswers[currentQuestion][1], params, true))
	{
		format(szMiscArray, sizeof(szMiscArray), "{3366ff}** %s has correctly answered the random question. Answer: %s **", GetPlayerNameEx(playerid), QuestionsAndAnswers[currentQuestion][1]);
		SendClientMessageToAll(-1, szMiscArray);
		DisableActiveQuestion(0);
		CallRemoteFunction("GiftPlayer_", "iii", MAX_PLAYERS, playerid, 2);
	}
	else
	{
		SendClientMessage(playerid, -1, "Wrong answer, please try again!");
	}
	return 1;
}

stock GetPlayerNameEx(playerid) {

	new
		szName[MAX_PLAYER_NAME],
		iPos;

	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	while ((iPos = strfind(szName, "_", false, iPos)) != -1) szName[iPos] = ' ';
	return szName;
}