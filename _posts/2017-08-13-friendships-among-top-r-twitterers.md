---
layout: post
title: 'Friendships among top R - Twitterers'
date: 2017-08-13
htmlwidget: true
---



Have you ever wondered whether the most active/popular R-twitterers are virtual friends? :) And by friends here I simply mean mutual followers on Twitter. In this post, I score and pick top 30 #rstats twitter users and analyse their Twitter friends' network. You'll see a lot of applications of `rtweet` and `ggraph` packages, as well as a very useful twist using `purrr` library, so let's begin!



### BEFORE I START: OFF - TOPIC ON PERFECTIONISM

After weeks and months (!!!) of not publishing anything, finally this post sees the light of day! It went through so many tests and changes - including conceptual ones! - that I'm relieved now that it's out and I can move on to another project. But I learned my lesson: perfectionism can be a real hurdle for any developer/data scientist and clearly, [I'm not alone with this experience](https://getpocket.com/a/read/1845363129). So, next time I'm not going to take that long to push something out - imperfect projects can improve and refine once they're out and I suppose they engage more people by provoking them to give ideas and suggest better solutions. Anyway, where were we...? :)



### IMPORTING #RSTATS USERS 

After loading my precious packages...






```r
library(rtweet)
library(dplyr)
library(purrr)
library(igraph)
library(ggraph)
```

... I searched for Twitter users that have `rstats` in their profile description. It definitely doesn't include ALL active and popular R - users, but it's a pretty reliable way of picking definite R - fans.


```r
r_users <- search_users("#rstats", n = 1000)
```

It's important to say, that in `rtweet::search_users()` even if you specify 1000 users to be extracted, I ended up with quite a few duplicates and the actual number of users I got was much smaller: 565


```r
r_users %>% summarise(n_users = n_distinct(screen_name))
```

```
##   n_users
## 1     564
```

Funnily enough, even though my profile description contains `#rstats`, I was not included in the search results (@KKulma), sic! Were you? :)



```r
 r_users %>% select(screen_name) %>% unique() %>%  arrange(screen_name)  %>% DT::datatable()
```

<div class="figure">
<!--html_preserve--><div id="htmlwidget-a537de295a58c6a290c8" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-a537de295a58c6a290c8">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","255","256","257","258","259","260","261","262","263","264","265","266","267","268","269","270","271","272","273","274","275","276","277","278","279","280","281","282","283","284","285","286","287","288","289","290","291","292","293","294","295","296","297","298","299","300","301","302","303","304","305","306","307","308","309","310","311","312","313","314","315","316","317","318","319","320","321","322","323","324","325","326","327","328","329","330","331","332","333","334","335","336","337","338","339","340","341","342","343","344","345","346","347","348","349","350","351","352","353","354","355","356","357","358","359","360","361","362","363","364","365","366","367","368","369","370","371","372","373","374","375","376","377","378","379","380","381","382","383","384","385","386","387","388","389","390","391","392","393","394","395","396","397","398","399","400","401","402","403","404","405","406","407","408","409","410","411","412","413","414","415","416","417","418","419","420","421","422","423","424","425","426","427","428","429","430","431","432","433","434","435","436","437","438","439","440","441","442","443","444","445","446","447","448","449","450","451","452","453","454","455","456","457","458","459","460","461","462","463","464","465","466","467","468","469","470","471","472","473","474","475","476","477","478","479","480","481","482","483","484","485","486","487","488","489","490","491","492","493","494","495","496","497","498","499","500","501","502","503","504","505","506","507","508","509","510","511","512","513","514","515","516","517","518","519","520","521","522","523","524","525","526","527","528","529","530","531","532","533","534","535","536","537","538","539","540","541","542","543","544","545","546","547","548","549","550","551","552","553","554","555","556","557","558","559","560","561","562","563","564"],["_ambodi","_AntoineB","_ColinFay","_mikoontz","_NateF_","_NickGolding_","AaronJTrent","AbsLawson","adolfoalvarez","adrbart","afflorezr","aflyax","AgentZeroNine","agustindaco","aimeegott_R","aj2z","ajstewart_lang","aktilot","Alan_metcalfe22","alexk_z","alexwhan","alicesweeting","alinedeschamps","alspur","amandarchy","ameisen_strasse","andduer","andreamrau","andreas_io","AndriyGazin","andy_juan","andyofsmeg","andyteucher","AngelisAndrea","AnimalSpiritEd","AniMove","annakrystalli","apawlows","apreshill","AriBFriedman","AriLamstein","arvi1000","aschinchon","asheshwor","astrobob_tk","astroeringrand","AtokNiiro","AwfulDodger","awhstin","awmercer","awrno","AymericBds","azstrata","b_prasad26","BadHessian","bartonlorimor","BaseballRstats","BastiaanSjardin","BayeSNA","bdhary","bechhof","BeckySpake","beeonaposy","benavides_c_","BenCAugustine","BenDilday","benjaminlind","benjaminlmoore","bennetvoorhees","Bernardogza","beyondvalence","bhive01","BilguunU","Bill_Felix","BillPetti","bionicturtle","BohnenbergerF","brad_weiner","bradleyboehmke","BrentBrewington","BrockTibert","brols","BroVic","btorobrob","cadastreng","caioproiete","camhouser","carissa_shafto","CarlyleCam","carroll_jono","Cataranea","catherinezh","cchappas","cdChristinaDiaz","chainsawriot","Champ_Pairach","ChemEdLinks","chemstateric","chendaniely","ChetanChawla","ClarkGRichards","cloudyRproject","cmhmaliani","Cole_Kev","coleman","conradopreto","ConsolidataLtd","cpsievert","crab_chowder","csgillespie","cursoRstats","CVWickham","d4t4v1z","d4tagirl","daattali","DailyRpackage","dalejbarr","dalekube","danielequs","danielleodean","danielphadley","daroczig","data_wizard","dataJujitsu","dataknut","DataScience_Afr","DataScienTweets","datavisitor","DataWookie","DatazarHQ","davetang31","DavidZenz","dckallos","DeborahTannon","DEJPett","deksta","Dennis_l00","DianeBELDAME","dickoah","DiffusePrioR","dirk_sch","DistrictDataLab","dmi3k","dragonflystats","DrChavaZ","DrDanHolmes","dreeux","drob","DrScranto","dshkol","duc_qn","ecsalomon","edinb_r","edouard_lgp","eighteenchains","EJakobowicz","eleakin775","emilopezcano","EmorieBeck","eric_bickel","ErikaMudrak","evelgab","expersso","fellgernon","fghjorth","fledglingStat","flightmed1","ford_nik","FrankFarach","franzViz","frod_san","garyweissman","gauravsk_","gdequeiroz","gdisney_melb","gdlinguist","GenomicsIo","GillespieDuncan","giorapac","GISStackExchR","Griffin_KJ","groundwalkergmb","grserrano_","grssnbchr","GrunerDaniel","guillaupierre","GuillemSalazar","guyabelguyabel","gvegayon","h_feddersen","Hao_and_Y","haozhu233","HeathrTurnr","Hedgehealth","HeidiBaya","Heidit09","hidekoji","HighlandDataSci","HofrichterJh","HollySitters","HoustonUseRs","hrbrmstr","hspter","ianmcook","ibartomeus","iDATA_co","iganson","ikashnitsky","inesgn","itschekkers","ivacukic","J__Stock","jaap_w","jacobadler","Jacquelyn_Neal","jafflerbach","JakeRuss","JamesMeadow","JamesRstats","jasdumas","jasonparker83","jbkunst","JChase__","jclopeztavera","jdbk","JeffHemsley","JennyBryan","JeromyAnglim","JeseRStats","JGreenbrookHeld","jhollist","JHunterUnited","jjstache","JMateosGarcia","joermungandr","JohnBellettiere","johnlray","johnstorey","jon_c_silva","JonathanAFrye","jonesor","jonmcalder","jorsugar","josecamoessilva","joshjfink","jpbach","JSBreet","jsonbecker","JulHeimer","JuliaGustavsen","juliasilge","juliawatzek","JulienAssouline","junghwanyang","kaleimai","Kamandeh_","kara_woo","kathryn_tm","kayseeu","kearneymw","kerry_benjamin1","kevinkeenan_","kieranrcampbell","KingAquaticEco","KirkegaardEmil","kjhogo","KLdivergence","klmr","kok_chak","KrisEberwein","krstoffr","kylehamilton","LaliRStats","lapply","lars_vers","LauTor83","lenikrsova","leo_iam","LiangCZhang","LilithElina","LilyBentley","liz__is","longhowlam","lucaspuente","LucyStats","LuigiBiagini","LuisDVerde","m_a_upson","ma_salmon","MadreDeZanjas","Manish_Saraswt","manuchretien","Mapacino_","marcbeldata","MarchiMax","marcoarmello","mark_scheuerell","markfransham","markrobinsonca","marshprincess","marskar","martinjhnhadley","martinmolder","massyfigini","Matt_Craddock","MattDaviz","maxheld","mblum_g","McAleerP","mcpasin","Md_Harris","mdancho84","MicahCRDillard","mich_berr","Michael_Toth","MichelBallings","mickaeltemporao","micro_marian","MicrosoftR","mikedecr","mikelove","MikeRSpencer","mikkopiippo","milos_agathon","minebocek","Minkoo","mj_kallen","mjjacko","MMaechler","modernscientist","monkmanmh","monsterswell","MorphoFun","mritchieau","msgbi","munichrocker","mwgerber","n_ashutosh","najkoja","nareal","nathanrcarter","nbrodnax","nc233","netzstreuner","neurofreakPB","ngamita","ngil92","nhcooper123","nibrivia","nic_crane","NicolaPlowes","nicoleradziwill","nidhi225","Niels_Bremen","nierhoff","nimbusaeta","nj_clark","nj_tierney","NJBurgo","nmmichalak","noamross","noreastrconf","NovakSportSci","NPHard","Nujcharee","old_man_chester","orchid00","orlandomezquita","OSkorge","ozjimbob","p_barbera","pa_chevalier","Pachecovv","padpadpadpad","pageinini","palynivore","PaulLantos","pavanmirla","pawelsakowski","phchataignon","pherreraariza","philmikejones","Physical_Prep","Pierre_Pgt","pinkyprincess","pisa_turkiye","PlethodoNick","poiofint","polar_plankton","presidual","psforscher","pssGuy","PWaryszak","queermath","qx","R_Borat","R_Forwards","R_Graph_Gallery","R_Programming","R_Summit_Africa","r_world_news","RallidaeRule","RandyMays","rapporters","RCatLadies","realAashAnand","REALMattRichie","Rebitt","reid_jf","Remibacha","remington_moll","renkun_ken","rgfitzjohn","rgonzalezgil","riannone","ricardobion","richatmango","RichieLenne","Rick_Scavetta","RickSaporta","ricobert1","rinehart_rstats","RLadiesBA","RLadiesBCN","RLadiesBoston","RLadiesColumbus","RLadiesGlobal","RLadiesIstanbul","RLadiesLA","RLadiesLondon","RLadiesMAD","RLadiesNYC","RLadiesParis","RLadiesSF","RLangTip","rmflight","RobCalver5","robinson_es","robustgar","rogierK","RoKlemmensen","Ross_Dahlke","rstats","rstats_jm","rstats_tips","rstats1","RStats2","Rstats4Econ","rstats4twit","rstatsdata","RStatsJason","RStatsJobs","rstatsmob","RstatsNE","rstatsNEWS","rstatsninja","RStatsNotBot","rstatsocean","RStatsStExBot","rstatsUser","RTalkPodcast","rtraborn","rushworth_a","rweekly_live","rweekly_org","RWhytock","Sabina_Stanescu","sallyivens","samfirke","SanghaChick","satRdays_org","scarf_face12","schnee","ScienceScribe","sctyner","sean_tuck","SeanHacks","seankross","SeanSHLee","sekR4_rstats","sellorm","sergiouribe","sgrifter","shanemeister1","sharon000","Sheffield_R_","shobhitsinghIN","SienaDuplan","Simon14908399","simplRstats","snickolas","SoaRStats","SonjaEisenbeiss","spandyie","StackOverflowR","Stat_Ron","stat4decision","statisticsblog","statsepi","statsforbios","stephaniehicks","stephenconeill","stevenliaotw","stevenvmiller","StrimasMackey","tangming2005","tanyacash21","tcarpenter216","tcbanalytics","TechPizzaRstats","teouchanalytics","TeppoTammisto","TerryTangYuan","theRcast","TheScrogster","TheSmartJokes","thinkR_fr","thosjleeper","thw_ch","TilmanSheets","timknut","timothy_phan","timothycbates","TinaACormier","tjmahr","tmllr","TojYouSo","TomAugust85","tomhouslay","tomkXY","totteh","traims","tylerreny","tylerrinker","u_ribo","UC_Rstats","udansk","ukacz","UTVilla","vcarey2013","victoriabutt1","vijay_ivaturi","vinuct","vlookupchampion","Voovarb","vtd_f","wabarree","waltterval","waterlego","westgatecology","whoyos21","williamcmay","williamsanger","WillTaylorNZ","WolfeBarrett","wviechtb","xieyihui","yassoma","yichuanw","yrlaNor","yrochat","Zofiathewitch","ZoltanSzuhai","zu_gabe"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>screen_name<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"order":[],"autoWidth":false,"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">plot of chunk sorted_users</p>
</div>



#### SCORING AND CHOOSING TOP #RSTATS USERS 

Now, let's extract some useful information about those users:


```r
r_users_info <- lookup_users(r_users$screen_name)
```

You'll notice, that created data frame holds information about number of followers, friends (users they follow), lists they belong to, number of tweets (statuses) or how many times sometimes marked those tweets as their favourite.


```r
r_users_info %>% select(dplyr::contains("count")) %>% head()
```

```
##   followers_count friends_count listed_count favourites_count
## 1            8311           366          580             9325
## 2           44474            11         1298                3
## 3           11106           524          467            18495
## 4           12481           431          542             7222
## 5           15345          1872          680            27971
## 6            5122           700          549             2796
##   statuses_count
## 1          66117
## 2           1700
## 3           8853
## 4           6388
## 5          22194
## 6          10010
```

And these variables I use for building my 'top score': I simply calculate a percentile for each of those variables and sum it altogether. Given that each variable's percentile will give me a value between 0 and 1, The final score can have a maximum value of 5.


```r
r_users_ranking <- r_users_info %>%
  filter(protected == FALSE) %>% 
  select(screen_name, dplyr::contains("count")) %>% 
  unique() %>% 
  mutate(followers_percentile = ecdf(followers_count)(followers_count),
         friends_percentile = ecdf(friends_count)(friends_count),
         listed_percentile = ecdf(listed_count)(listed_count),
         favourites_percentile = ecdf(favourites_count)(favourites_count),
         statuses_percentile = ecdf(statuses_count)(statuses_count)
         ) %>% 
  group_by(screen_name) %>% 
  summarise(top_score = followers_percentile + friends_percentile + listed_percentile + favourites_percentile + statuses_percentile) %>% 
  ungroup() %>% 
  mutate(ranking = rank(-top_score))
```


All I need to do now is to pick top 30 users based on the score I calculated. Did you manage get onto the top 30 list? :)


```r
top_30 <- r_users_ranking %>% arrange(desc(top_score)) %>% head(30) %>% arrange(desc(top_score))
top_30 %>% as.data.frame() %>% select(screen_name) %>% DT::datatable()
```

<div class="figure">
<!--html_preserve--><div id="htmlwidget-71c101c916367c777cd6" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-71c101c916367c777cd6">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"],["hspter","RallidaeRule","DEJPett","modernscientist","nicoleradziwill","tomhouslay","ChetanChawla","TheSmartJokes","Physical_Prep","Cataranea","noamross","b_prasad26","AriBFriedman","thosjleeper","mikkopiippo","kerry_benjamin1","AbsLawson","rogierK","PlethodoNick","JonathanAFrye","yrochat","ozjimbob","JennyBryan","BillPetti","kara_woo","nhcooper123","rtraborn","hrbrmstr","statsepi","juliasilge"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>screen_name<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"order":[],"autoWidth":false,"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">plot of chunk top_30</p>
</div>

I must say I'm incredibly impressed by these scores: @hpster, THE top R - twitterer managed to obtain a score of over 4.8 out of 5! Also, @Physical_Prep and @TheSmartJokes managed to tie 8th place, which I thought was unlikely to happed, given how granular the score is. 

Anyway! To add some more depth to my list, I tried to identify those users' gender, to see how many top users are women. I had to do it manually (sic!), as the Twitter API's data doesn't provide this, AFAIK. Let me know if you spot any mistakes!



```r
top30_lookup <- r_users_info %>%
  filter(screen_name %in% top_30$screen_name) %>% 
  select(screen_name, user_id)

top30_lookup$gender <- c("M", "F", "F", "F", "F",
                         "M", "M", "M", "F", "F", 
                         "F", "M", "M", "M", "F", 
                         "F", "M", "M", "M", "M", 
                         "M", "M", "M", "F", "M",
                         "M", "M", "M", "M", "M")

table(top30_lookup$gender)
```

```
## 
##  F  M 
## 10 20
```

It looks like a third of all top users are womes, but in the top 10 users there are 6 women. Better than I expected, actually. So, well done, ladies!

#### GETTING FRIENDS NETWORK

Now, this was the trickiest part of this project: extracting top users' friends list and putting it all in one data frame. As you ma be aware, Twitter API has a limit od downloading information on 15 accounts in 15 minutes. So for my list, I had to break it up into 2 steps, 15 users each and then I named each list according to the top user they refer to:


```r
top_30_usernames <- top30_lookup$screen_name

friends_top30a <-   map(top_30_usernames[1:15 ], get_friends)
names(friends_top30a) <- top_30_usernames[1:15]

# 15 minutes later....
friends_top30b <- map(top_30_usernames[16:30], get_friends)
```

After this I end up with two lists, each containing all friends' IDs for top and bottom 15 users respectively. Here's an example: 


```r
str(friends_top30b)
```

```
## List of 15
##  $ modernscientist:'data.frame':	1752 obs. of  1 variable:
##   ..$ user_id: chr [1:1752] "18153864" "19187806" "2785337469" "586883143" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ Physical_Prep  :'data.frame':	2390 obs. of  1 variable:
##   ..$ user_id: chr [1:2390] "62836649" "228664938" "1941843097" "2523165143" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ BillPetti      :'data.frame':	1140 obs. of  1 variable:
##   ..$ user_id: chr [1:1140] "119802433" "109303284" "482232051" "49155222" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ JonathanAFrye  :'data.frame':	2611 obs. of  1 variable:
##   ..$ user_id: chr [1:2611] "34006491" "23342797" "64229716" "75051887" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ ChetanChawla   :'data.frame':	1365 obs. of  1 variable:
##   ..$ user_id: chr [1:1365] "3362913279" "851583986270957568" "449588356" "15227791" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ rogierK        :'data.frame':	1359 obs. of  1 variable:
##   ..$ user_id: chr [1:1359] "4427052929" "3315236924" "2976444713" "3865005196" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ AriBFriedman   :'data.frame':	1414 obs. of  1 variable:
##   ..$ user_id: chr [1:1414] "805181039245225984" "740985271026491392" "2534410031" "720675478193971200" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ yrochat        :'data.frame':	533 obs. of  1 variable:
##   ..$ user_id: chr [1:533] "2827803498" "311905244" "74398697" "3645507015" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ TheSmartJokes  :'data.frame':	5000 obs. of  1 variable:
##   ..$ user_id: chr [1:5000] "891529978201780224" "811251016410664960" "891556417739608064" "843245938449833984" ...
##   ..- attr(*, "next_cursor")= chr "1545261800668264448"
##  $ mikkopiippo    :'data.frame':	4860 obs. of  1 variable:
##   ..$ user_id: chr [1:4860] "770326630145282048" "703923734" "49542761" "122129148" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ rtraborn       :'data.frame':	1073 obs. of  1 variable:
##   ..$ user_id: chr [1:1073] "369101147" "81882372" "2639088547" "33867913" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ b_prasad26     :'data.frame':	2426 obs. of  1 variable:
##   ..$ user_id: chr [1:2426] "75321229" "15851807" "484023344" "177444328" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ ozjimbob       :'data.frame':	980 obs. of  1 variable:
##   ..$ user_id: chr [1:980] "17707546" "804157677177868288" "916685508" "2546258378" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ ricobert1      :'data.frame':	707 obs. of  1 variable:
##   ..$ user_id: chr [1:707] "88731801" "153234994" "19878055" "2743609942" ...
##   ..- attr(*, "next_cursor")= chr "0"
##  $ PlethodoNick   :'data.frame':	1961 obs. of  1 variable:
##   ..$ user_id: chr [1:1961] "42486688" "15576928" "2154127088" "337318821" ...
##   ..- attr(*, "next_cursor")= chr "0"
```


So what I need to do now is i) append the two lists, ii) create a variable stating top users' name in each of those lists and iii) turn lists into data frames. All this can be done in 3 lines of code. And brace yourself: here comes the `purrr` trick I've been going on about! Simply using `purrr:::map2_df` I can take a single list of lists, create a name variable in each of those lists based on the list name (`twitter_top_user`) and convert the result into the data frame. BRILLIANT!!



```r
# turning lists into data frames and putting them together
friends_top30 <- append(friends_top30a, friends_top30b)
names(friends_top30) <- top_30_usernames

# purrr - trick I've been banging on about!
friends_top <- map2_df(friends_top30, names(friends_top30), ~ mutate(.x, twitter_top_user = .y)) %>% 
  rename(friend_id = user_id) %>% select(twitter_top_user, friend_id)

# are we missing any users?
friends_top %>% summarize(dist = n_distinct(twitter_top_user))
```

```
##   dist
## 1   30
```

Here's the last bit that I need to correct before we move to plotting the friends networks: for some reason, using `purrr::map()` with `rtweet:::get_friends()` gives me only 5000 friends, whereas the true value is over 8000. As it's the only top user with more than 5000 friends, I'll download his friends separately...


```r
# getting a full list of friends
SJ1 <- get_friends("TheSmartJokes")
SJ2 <- get_friends("TheSmartJokes", page = next_cursor(SJ1))

# putting the data frames together 
SJ_friends <-rbind(SJ1, SJ2) %>%  
  rename(friend_id = user_id) %>% 
  mutate(twitter_top_user = "TheSmartJokes") %>% 
  select(twitter_top_user, friend_id)

# the final results - over 8000 friends, rather than 5000
str(SJ_friends) 
```

```
## 'data.frame':	0 obs. of  2 variables:
##  $ twitter_top_user: chr 
##  $ friend_id       : chr
```


... and use it to replace those that are already in the final friends list.


```r
friends_top30 <- friends_top %>% 
  filter(twitter_top_user != "TheSmartJokes") %>% 
  rbind(SJ_friends) 
```


Some final data cleaning: filtering out friends that are not among the top 30 R - users, replacing their IDs with twitter names and adding gender for top users and their friends... Tam, tam, tam: here we are! Here's the final data frame we'll use for visualising the friends networks!


```r
# select friends that are top30 users
final_friends_top30 <- friends_top  %>% 
  filter(friend_id %in% top30_lookup$user_id)

# add friends' screen_name
final_friends_top30$friend_name <- top30_lookup$screen_name[match(final_friends_top30$friend_id, top30_lookup$user_id)]

# add users' and friends' gender
final_friends_top30$user_gender <- top30_lookup$gender[match(final_friends_top30$twitter_top_user, top30_lookup$screen_name)]
final_friends_top30$friend_gender <- top30_lookup$gender[match(final_friends_top30$friend_name, top30_lookup$screen_name)]

## final product!!!
final <- final_friends_top30 %>% select(-friend_id)

head(final)
```

```
##   twitter_top_user     friend_name user_gender friend_gender
## 1         hrbrmstr nicoleradziwill           M             F
## 2         hrbrmstr        kara_woo           M             F
## 3         hrbrmstr      juliasilge           M             F
## 4         hrbrmstr        noamross           M             M
## 5         hrbrmstr      JennyBryan           M             F
## 6         hrbrmstr     thosjleeper           M             M
```


#### VISUALIZATING FRIENDS NETWORKS

After turning our data frame into something more usable by `igraph` and `ggraph`...


```r
f1 <- graph_from_data_frame(final, directed = TRUE, vertices = NULL)
V(f1)$Popularity <- degree(f1, mode = 'in')
```


... let's have a quick overview of all the connections:


```r
ggraph(f1, layout='kk') + 
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity)) +
  theme_graph( fg_text_colour = 'black') 
```

![plot of chunk pure_graph](/img/2017-08-13-friendships-among-top-r-twitterers/pure_graph-1.png)

Keep in mind that `Popularity` -  defined as the number of edges that go **into** the node - determines node size. It's all pretty, but I'd like to see how nodes correspond to Twitter users' names:


```r
ggraph(f1, layout='kk') + 
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity)) +
  geom_node_text(aes(label = name, fontface='bold'), 
                 color = 'white', size = 3) +
  theme_graph(background = 'dimgray', text_colour = 'white',title_size = 30) 
```

![plot of chunk names_graph](/img/2017-08-13-friendships-among-top-r-twitterers/names_graph-1.png)

So interesting! You see the core of the graph consisting of mainly female users: @hpster, @JennyBryan, @juliasilge, @karawoo, but also a couple of male R - users: @hrbrmstr and @noamross. Who do they follow? Men or women?


```r
ggraph(f1, layout='kk') + 
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity)) +
  theme_graph( fg_text_colour = 'black') +
  geom_edge_link(aes(colour = friend_gender)) +
  scale_edge_color_brewer(palette = 'Set1') + 
  labs(title='Top 30 #rstats users and gender of their friends')
```

![plot of chunk user_gender](/img/2017-08-13-friendships-among-top-r-twitterers/user_gender-1.png)


It's difficult to say definitely, but superficially I see A LOT of red, suggesting that our top R - users often follow female top twitterers. Let's have a closer look and split graphs by user gender and see if there's any difference in the gender of users they follow:



```r
ggraph(f1, layout='kk') + 
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity)) +
  theme_graph( fg_text_colour = 'black') +
  facet_edges(~user_gender) +
  geom_edge_link(aes(colour = friend_gender)) +
  scale_edge_color_brewer(palette = 'Set1') +
  labs(title='Top 30 #rstats users and gender of their friends', subtitle='Graphs are separated by top user gender, edge colour indicates their friend gender' )
```

![plot of chunk user_gender2](/img/2017-08-13-friendships-among-top-r-twitterers/user_gender2-1.png)

Ha! look at this! Obviously, Female users' graph will be less dense as there are fewer of them in the dataset, however, you can see that they tend to follow male users more often than male top users do. Is that impression supported by raw numbers?


```r
final %>% 
  group_by(user_gender, friend_gender) %>% 
  summarize(n = n()) %>% 
  group_by(user_gender) %>% 
  mutate(sum = sum(n),
         percent = round(n/sum, 2)) 
```

```
## # A tibble: 4 x 5
## # Groups:   user_gender [2]
##   user_gender friend_gender     n   sum percent
##         <chr>         <chr> <int> <int>   <dbl>
## 1           F             F    26    57    0.46
## 2           F             M    31    57    0.54
## 3           M             F    55   101    0.54
## 4           M             M    46   101    0.46
```

It looks so, although to the lesser extend than suggested by the network graphs: Female top users follower other female top users 46% of time, whereas male top users follow female top user 54% of time. So what do you have to say about that?
