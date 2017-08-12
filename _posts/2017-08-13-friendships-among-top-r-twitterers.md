Have you ever wondered whether the most active/popular R-twitterers are virtual friends? :) And by friends here I simply mean mutual followers on Twitter. In this post, I score and pick top 30 \#rstats twitter users and analyse their Twitter friends' network. You'll see a lot of applications of `rtweet` and `ggraph` packages, as well as a very useful twist using `purrr` library, so let's begin!

### BEFORE I START: OFF - TOPIC ON PERFECTIONISM

After weeks and months (!!!) of not publishing anything, finally this post sees the light of day! It went through so many tests and changes - including conceptual ones! - that I'm relieved now that it's out and I can move on to another project. But I learned my lesson: perfectionism can be a real hurdle for any developer/data scientist and clearly, [I'm not alone with this experience](https://getpocket.com/a/read/1845363129). So, next time I'm not going to take that long to push something out - imperfect projects can improve and refine once they're out and I suppose they engage more people by provoking them to give ideas and suggest better solutions. Anyway, where were we...? :)

### IMPORTING \#RSTATS USERS

After loading my precious packages...

``` r
library(rtweet)
library(dplyr)
library(purrr)
library(igraph)
library(ggraph)
```

... I searched for Twitter users that have `rstats` in their profile description. It definitely doesn't include ALL active and popular R - users, but it's a pretty reliable way of picking definite R - fans.

``` r
r_users <- search_users("#rstats", n = 1000)
```

It's important to say, that in `rtweet::search_users()` even if you specify 1000 users to be extracted, I ended up with quite a few duplicates and the actual number of users I got was much smaller: 564

``` r
r_users %>% summarise(n_users = n_distinct(screen_name))
```

    ##   n_users
    ## 1     564

Funnily enough, even though my profile description contains `#rstats`, I was not included in the search results (@KKulma), sic! Were you? :)

``` r
 r_users %>% select(screen_name) %>% unique() %>%  arrange(screen_name) 
```

    ##         screen_name
    ## 1           _ambodi
    ## 2         _AntoineB
    ## 3         _ColinFay
    ## 4         _mikoontz
    ## 5           _NateF_
    ## 6     _NickGolding_
    ## 7       AaronJTrent
    ## 8         AbsLawson
    ## 9     adolfoalvarez
    ## 10          adrbart
    ## 11        afflorezr
    ## 12           aflyax
    ## 13    AgentZeroNine
    ## 14      agustindaco
    ## 15      aimeegott_R
    ## 16             aj2z
    ## 17   ajstewart_lang
    ## 18          aktilot
    ## 19  Alan_metcalfe22
    ## 20          alexk_z
    ## 21         alexwhan
    ## 22    alicesweeting
    ## 23   alinedeschamps
    ## 24           alspur
    ## 25       amandarchy
    ## 26  ameisen_strasse
    ## 27          andduer
    ## 28       andreamrau
    ## 29       andreas_io
    ## 30      AndriyGazin
    ## 31        andy_juan
    ## 32       andyofsmeg
    ## 33      andyteucher
    ## 34    AngelisAndrea
    ## 35   AnimalSpiritEd
    ## 36          AniMove
    ## 37    annakrystalli
    ## 38         apawlows
    ## 39        apreshill
    ## 40     AriBFriedman
    ## 41      AriLamstein
    ## 42         arvi1000
    ## 43       aschinchon
    ## 44        asheshwor
    ## 45      astrobob_tk
    ## 46   astroeringrand
    ## 47        AtokNiiro
    ## 48      AwfulDodger
    ## 49          awhstin
    ## 50         awmercer
    ## 51            awrno
    ## 52       AymericBds
    ## 53         azstrata
    ## 54       b_prasad26
    ## 55       BadHessian
    ## 56    bartonlorimor
    ## 57   BaseballRstats
    ## 58  BastiaanSjardin
    ## 59          BayeSNA
    ## 60           bdhary
    ## 61          bechhof
    ## 62       BeckySpake
    ## 63       beeonaposy
    ## 64     benavides_c_
    ## 65    BenCAugustine
    ## 66        BenDilday
    ## 67     benjaminlind
    ## 68   benjaminlmoore
    ## 69   bennetvoorhees
    ## 70      Bernardogza
    ## 71    beyondvalence
    ## 72          bhive01
    ## 73         BilguunU
    ## 74       Bill_Felix
    ## 75        BillPetti
    ## 76     bionicturtle
    ## 77    BohnenbergerF
    ## 78      brad_weiner
    ## 79   bradleyboehmke
    ## 80  BrentBrewington
    ## 81      BrockTibert
    ## 82            brols
    ## 83           BroVic
    ## 84        btorobrob
    ## 85       cadastreng
    ## 86      caioproiete
    ## 87        camhouser
    ## 88   carissa_shafto
    ## 89       CarlyleCam
    ## 90     carroll_jono
    ## 91        Cataranea
    ## 92      catherinezh
    ## 93         cchappas
    ## 94  cdChristinaDiaz
    ## 95     chainsawriot
    ## 96    Champ_Pairach
    ## 97      ChemEdLinks
    ## 98     chemstateric
    ## 99      chendaniely
    ## 100    ChetanChawla
    ## 101  ClarkGRichards
    ## 102  cloudyRproject
    ## 103      cmhmaliani
    ## 104        Cole_Kev
    ## 105         coleman
    ## 106    conradopreto
    ## 107  ConsolidataLtd
    ## 108       cpsievert
    ## 109    crab_chowder
    ## 110     csgillespie
    ## 111     cursoRstats
    ## 112       CVWickham
    ## 113         d4t4v1z
    ## 114        d4tagirl
    ## 115        daattali
    ## 116   DailyRpackage
    ## 117       dalejbarr
    ## 118        dalekube
    ## 119      danielequs
    ## 120   danielleodean
    ## 121   danielphadley
    ## 122        daroczig
    ## 123     data_wizard
    ## 124     dataJujitsu
    ## 125        dataknut
    ## 126 DataScience_Afr
    ## 127 DataScienTweets
    ## 128     datavisitor
    ## 129      DataWookie
    ## 130       DatazarHQ
    ## 131      davetang31
    ## 132       DavidZenz
    ## 133        dckallos
    ## 134   DeborahTannon
    ## 135         DEJPett
    ## 136          deksta
    ## 137      Dennis_l00
    ## 138    DianeBELDAME
    ## 139         dickoah
    ## 140    DiffusePrioR
    ## 141        dirk_sch
    ## 142 DistrictDataLab
    ## 143           dmi3k
    ## 144  dragonflystats
    ## 145        DrChavaZ
    ## 146     DrDanHolmes
    ## 147          dreeux
    ## 148            drob
    ## 149       DrScranto
    ## 150          dshkol
    ## 151          duc_qn
    ## 152       ecsalomon
    ## 153         edinb_r
    ## 154     edouard_lgp
    ## 155  eighteenchains
    ## 156     EJakobowicz
    ## 157      eleakin775
    ## 158    emilopezcano
    ## 159      EmorieBeck
    ## 160     eric_bickel
    ## 161     ErikaMudrak
    ## 162         evelgab
    ## 163        expersso
    ## 164      fellgernon
    ## 165        fghjorth
    ## 166   fledglingStat
    ## 167      flightmed1
    ## 168        ford_nik
    ## 169     FrankFarach
    ## 170        franzViz
    ## 171        frod_san
    ## 172    garyweissman
    ## 173       gauravsk_
    ## 174      gdequeiroz
    ## 175    gdisney_melb
    ## 176      gdlinguist
    ## 177      GenomicsIo
    ## 178 GillespieDuncan
    ## 179        giorapac
    ## 180   GISStackExchR
    ## 181      Griffin_KJ
    ## 182 groundwalkergmb
    ## 183      grserrano_
    ## 184       grssnbchr
    ## 185    GrunerDaniel
    ## 186   guillaupierre
    ## 187  GuillemSalazar
    ## 188  guyabelguyabel
    ## 189        gvegayon
    ## 190     h_feddersen
    ## 191       Hao_and_Y
    ## 192       haozhu233
    ## 193     HeathrTurnr
    ## 194     Hedgehealth
    ## 195       HeidiBaya
    ## 196        Heidit09
    ## 197        hidekoji
    ## 198 HighlandDataSci
    ## 199    HofrichterJh
    ## 200    HollySitters
    ## 201    HoustonUseRs
    ## 202        hrbrmstr
    ## 203          hspter
    ## 204        ianmcook
    ## 205      ibartomeus
    ## 206        iDATA_co
    ## 207         iganson
    ## 208     ikashnitsky
    ## 209          inesgn
    ## 210     itschekkers
    ## 211        ivacukic
    ## 212        J__Stock
    ## 213          jaap_w
    ## 214      jacobadler
    ## 215  Jacquelyn_Neal
    ## 216     jafflerbach
    ## 217        JakeRuss
    ## 218     JamesMeadow
    ## 219     JamesRstats
    ## 220        jasdumas
    ## 221   jasonparker83
    ## 222         jbkunst
    ## 223        JChase__
    ## 224   jclopeztavera
    ## 225            jdbk
    ## 226     JeffHemsley
    ## 227      JennyBryan
    ## 228    JeromyAnglim
    ## 229      JeseRStats
    ## 230 JGreenbrookHeld
    ## 231        jhollist
    ## 232   JHunterUnited
    ## 233        jjstache
    ## 234   JMateosGarcia
    ## 235    joermungandr
    ## 236 JohnBellettiere
    ## 237        johnlray
    ## 238      johnstorey
    ## 239     jon_c_silva
    ## 240   JonathanAFrye
    ## 241         jonesor
    ## 242      jonmcalder
    ## 243        jorsugar
    ## 244 josecamoessilva
    ## 245       joshjfink
    ## 246          jpbach
    ## 247         JSBreet
    ## 248      jsonbecker
    ## 249       JulHeimer
    ## 250  JuliaGustavsen
    ## 251      juliasilge
    ## 252     juliawatzek
    ## 253 JulienAssouline
    ## 254    junghwanyang
    ## 255        kaleimai
    ## 256       Kamandeh_
    ## 257        kara_woo
    ## 258      kathryn_tm
    ## 259         kayseeu
    ## 260       kearneymw
    ## 261 kerry_benjamin1
    ## 262    kevinkeenan_
    ## 263 kieranrcampbell
    ## 264  KingAquaticEco
    ## 265  KirkegaardEmil
    ## 266          kjhogo
    ## 267    KLdivergence
    ## 268            klmr
    ## 269        kok_chak
    ## 270    KrisEberwein
    ## 271        krstoffr
    ## 272    kylehamilton
    ## 273      LaliRStats
    ## 274          lapply
    ## 275       lars_vers
    ## 276        LauTor83
    ## 277      lenikrsova
    ## 278         leo_iam
    ## 279     LiangCZhang
    ## 280     LilithElina
    ## 281     LilyBentley
    ## 282         liz__is
    ## 283      longhowlam
    ## 284     lucaspuente
    ## 285       LucyStats
    ## 286    LuigiBiagini
    ## 287      LuisDVerde
    ## 288       m_a_upson
    ## 289       ma_salmon
    ## 290   MadreDeZanjas
    ## 291  Manish_Saraswt
    ## 292    manuchretien
    ## 293       Mapacino_
    ## 294     marcbeldata
    ## 295       MarchiMax
    ## 296    marcoarmello
    ## 297 mark_scheuerell
    ## 298    markfransham
    ## 299  markrobinsonca
    ## 300   marshprincess
    ## 301         marskar
    ## 302 martinjhnhadley
    ## 303    martinmolder
    ## 304     massyfigini
    ## 305   Matt_Craddock
    ## 306       MattDaviz
    ## 307         maxheld
    ## 308         mblum_g
    ## 309        McAleerP
    ## 310         mcpasin
    ## 311       Md_Harris
    ## 312       mdancho84
    ## 313  MicahCRDillard
    ## 314       mich_berr
    ## 315    Michael_Toth
    ## 316  MichelBallings
    ## 317 mickaeltemporao
    ## 318    micro_marian
    ## 319      MicrosoftR
    ## 320        mikedecr
    ## 321        mikelove
    ## 322    MikeRSpencer
    ## 323     mikkopiippo
    ## 324   milos_agathon
    ## 325       minebocek
    ## 326          Minkoo
    ## 327       mj_kallen
    ## 328         mjjacko
    ## 329       MMaechler
    ## 330 modernscientist
    ## 331       monkmanmh
    ## 332    monsterswell
    ## 333       MorphoFun
    ## 334      mritchieau
    ## 335           msgbi
    ## 336    munichrocker
    ## 337        mwgerber
    ## 338      n_ashutosh
    ## 339         najkoja
    ## 340          nareal
    ## 341   nathanrcarter
    ## 342        nbrodnax
    ## 343           nc233
    ## 344    netzstreuner
    ## 345    neurofreakPB
    ## 346         ngamita
    ## 347          ngil92
    ## 348     nhcooper123
    ## 349        nibrivia
    ## 350       nic_crane
    ## 351    NicolaPlowes
    ## 352 nicoleradziwill
    ## 353        nidhi225
    ## 354    Niels_Bremen
    ## 355        nierhoff
    ## 356      nimbusaeta
    ## 357        nj_clark
    ## 358      nj_tierney
    ## 359         NJBurgo
    ## 360      nmmichalak
    ## 361        noamross
    ## 362    noreastrconf
    ## 363   NovakSportSci
    ## 364          NPHard
    ## 365       Nujcharee
    ## 366 old_man_chester
    ## 367        orchid00
    ## 368 orlandomezquita
    ## 369         OSkorge
    ## 370        ozjimbob
    ## 371       p_barbera
    ## 372    pa_chevalier
    ## 373       Pachecovv
    ## 374    padpadpadpad
    ## 375       pageinini
    ## 376      palynivore
    ## 377      PaulLantos
    ## 378      pavanmirla
    ## 379   pawelsakowski
    ## 380    phchataignon
    ## 381   pherreraariza
    ## 382   philmikejones
    ## 383   Physical_Prep
    ## 384      Pierre_Pgt
    ## 385   pinkyprincess
    ## 386    pisa_turkiye
    ## 387    PlethodoNick
    ## 388        poiofint
    ## 389  polar_plankton
    ## 390       presidual
    ## 391      psforscher
    ## 392          pssGuy
    ## 393       PWaryszak
    ## 394       queermath
    ## 395              qx
    ## 396         R_Borat
    ## 397      R_Forwards
    ## 398 R_Graph_Gallery
    ## 399   R_Programming
    ## 400 R_Summit_Africa
    ## 401    r_world_news
    ## 402    RallidaeRule
    ## 403       RandyMays
    ## 404      rapporters
    ## 405      RCatLadies
    ## 406   realAashAnand
    ## 407  REALMattRichie
    ## 408          Rebitt
    ## 409         reid_jf
    ## 410       Remibacha
    ## 411  remington_moll
    ## 412      renkun_ken
    ## 413      rgfitzjohn
    ## 414    rgonzalezgil
    ## 415        riannone
    ## 416     ricardobion
    ## 417     richatmango
    ## 418     RichieLenne
    ## 419   Rick_Scavetta
    ## 420     RickSaporta
    ## 421       ricobert1
    ## 422 rinehart_rstats
    ## 423       RLadiesBA
    ## 424      RLadiesBCN
    ## 425   RLadiesBoston
    ## 426 RLadiesColumbus
    ## 427   RLadiesGlobal
    ## 428 RLadiesIstanbul
    ## 429       RLadiesLA
    ## 430   RLadiesLondon
    ## 431      RLadiesMAD
    ## 432      RLadiesNYC
    ## 433    RLadiesParis
    ## 434       RLadiesSF
    ## 435        RLangTip
    ## 436        rmflight
    ## 437      RobCalver5
    ## 438     robinson_es
    ## 439       robustgar
    ## 440         rogierK
    ## 441    RoKlemmensen
    ## 442     Ross_Dahlke
    ## 443          rstats
    ## 444       rstats_jm
    ## 445     rstats_tips
    ## 446         rstats1
    ## 447         RStats2
    ## 448     Rstats4Econ
    ## 449     rstats4twit
    ## 450      rstatsdata
    ## 451     RStatsJason
    ## 452      RStatsJobs
    ## 453       rstatsmob
    ## 454        RstatsNE
    ## 455      rstatsNEWS
    ## 456     rstatsninja
    ## 457    RStatsNotBot
    ## 458     rstatsocean
    ## 459   RStatsStExBot
    ## 460      rstatsUser
    ## 461    RTalkPodcast
    ## 462        rtraborn
    ## 463     rushworth_a
    ## 464    rweekly_live
    ## 465     rweekly_org
    ## 466        RWhytock
    ## 467 Sabina_Stanescu
    ## 468      sallyivens
    ## 469        samfirke
    ## 470     SanghaChick
    ## 471    satRdays_org
    ## 472    scarf_face12
    ## 473          schnee
    ## 474   ScienceScribe
    ## 475         sctyner
    ## 476       sean_tuck
    ## 477       SeanHacks
    ## 478       seankross
    ## 479       SeanSHLee
    ## 480    sekR4_rstats
    ## 481         sellorm
    ## 482     sergiouribe
    ## 483        sgrifter
    ## 484   shanemeister1
    ## 485       sharon000
    ## 486    Sheffield_R_
    ## 487  shobhitsinghIN
    ## 488     SienaDuplan
    ## 489   Simon14908399
    ## 490     simplRstats
    ## 491       snickolas
    ## 492       SoaRStats
    ## 493 SonjaEisenbeiss
    ## 494        spandyie
    ## 495  StackOverflowR
    ## 496        Stat_Ron
    ## 497   stat4decision
    ## 498  statisticsblog
    ## 499        statsepi
    ## 500    statsforbios
    ## 501  stephaniehicks
    ## 502  stephenconeill
    ## 503    stevenliaotw
    ## 504   stevenvmiller
    ## 505   StrimasMackey
    ## 506    tangming2005
    ## 507     tanyacash21
    ## 508   tcarpenter216
    ## 509    tcbanalytics
    ## 510 TechPizzaRstats
    ## 511 teouchanalytics
    ## 512   TeppoTammisto
    ## 513   TerryTangYuan
    ## 514        theRcast
    ## 515    TheScrogster
    ## 516   TheSmartJokes
    ## 517       thinkR_fr
    ## 518     thosjleeper
    ## 519          thw_ch
    ## 520    TilmanSheets
    ## 521         timknut
    ## 522    timothy_phan
    ## 523   timothycbates
    ## 524    TinaACormier
    ## 525          tjmahr
    ## 526           tmllr
    ## 527        TojYouSo
    ## 528     TomAugust85
    ## 529      tomhouslay
    ## 530          tomkXY
    ## 531          totteh
    ## 532          traims
    ## 533       tylerreny
    ## 534     tylerrinker
    ## 535          u_ribo
    ## 536       UC_Rstats
    ## 537          udansk
    ## 538           ukacz
    ## 539         UTVilla
    ## 540      vcarey2013
    ## 541   victoriabutt1
    ## 542   vijay_ivaturi
    ## 543          vinuct
    ## 544 vlookupchampion
    ## 545         Voovarb
    ## 546           vtd_f
    ## 547        wabarree
    ## 548      waltterval
    ## 549       waterlego
    ## 550  westgatecology
    ## 551        whoyos21
    ## 552     williamcmay
    ## 553   williamsanger
    ## 554    WillTaylorNZ
    ## 555    WolfeBarrett
    ## 556        wviechtb
    ## 557        xieyihui
    ## 558         yassoma
    ## 559        yichuanw
    ## 560         yrlaNor
    ## 561         yrochat
    ## 562   Zofiathewitch
    ## 563    ZoltanSzuhai
    ## 564         zu_gabe

#### SCORING AND CHOOSING TOP \#RSTATS USERS

Now, let's extract some useful information about those users:

``` r
r_users_info <- lookup_users(r_users$screen_name)
```

You'll notice, that created data frame holds information about number of followers, friends (users they follow), lists they belong to, number of tweets (statuses) or how many times sometimes marked those tweets as their favourite.

``` r
r_users_info %>% select(dplyr::contains("count")) %>% head()
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

And these variables I use for building my 'top score': I simply calculate a percentile for each of those variables and sum it altogether. Given that each variable's percentile will give me a value between 0 and 1, The final score can have a maximum value of 5.

``` r
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

``` r
top_30 <- r_users_ranking %>% arrange(desc(top_score)) %>% head(30) %>% arrange(desc(top_score))
top_30 
```

    ## # A tibble: 30 x 3
    ##        screen_name top_score ranking
    ##              <chr>     <dbl>   <dbl>
    ##  1          hspter  4.877005       1
    ##  2    RallidaeRule  4.839572       2
    ##  3         DEJPett  4.771836       3
    ##  4 modernscientist  4.752228       4
    ##  5 nicoleradziwill  4.700535       5
    ##  6      tomhouslay  4.684492       6
    ##  7    ChetanChawla  4.639929       7
    ##  8   TheSmartJokes  4.627451       8
    ##  9   Physical_Prep  4.625668       9
    ## 10       Cataranea  4.602496      10
    ## # ... with 20 more rows

I must say I'm incredibly impressed by these scores: @hpster, THE top R - twitterer managed to obtain a score of over 4.8 out of 5! Also, @Physical\_Prep and @TheSmartJokes managed to tie 8th place, which I thought was unlikely to happed, given how granular the score is.

Anyway! To add some more depth to my list, I tried to identify those users' gender, to see how many top users are women. I had to do it manually (sic!), as the Twitter API's data doesn't provide this, AFAIK. Let me know if you spot any mistakes!

``` r
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

    ## 
    ##  F  M 
    ## 10 20

It looks like a third of all top users are womes, but in the top 10 users there are 6 women. Better than I expected, actually. So, well done, ladies!

#### GETTING FRIENDS NETWORK

Now, this was the trickiest part of this project: extracting top users' friends list and putting it all in one data frame. As you ma be aware, Twitter API has a limit od downloading information on 15 accounts in 15 minutes. So for my list, I had to break it up into 2 steps, 15 users each and then I named each list according to the top user they refer to:

``` r
top_30_usernames <- top30_lookup$screen_name

friends_top30a <-   map(top_30_usernames[1:15 ], get_friends)
names(friends_top30a) <- top_30_usernames[1:15]

# 15 minutes later....
friends_top30b <- map(top_30_usernames[16:30], get_friends)
```

After this I end up with two lists, each containing all friends' IDs for top and bottom 15 users respectively. Here's an example:

``` r
str(friends_top30b)
```

    ## List of 15
    ##  $ modernscientist:'data.frame': 1752 obs. of  1 variable:
    ##   ..$ user_id: chr [1:1752] "18153864" "19187806" "2785337469" "586883143" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ Physical_Prep  :'data.frame': 2390 obs. of  1 variable:
    ##   ..$ user_id: chr [1:2390] "62836649" "228664938" "1941843097" "2523165143" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ BillPetti      :'data.frame': 1140 obs. of  1 variable:
    ##   ..$ user_id: chr [1:1140] "119802433" "109303284" "482232051" "49155222" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ JonathanAFrye  :'data.frame': 2611 obs. of  1 variable:
    ##   ..$ user_id: chr [1:2611] "34006491" "23342797" "64229716" "75051887" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ ChetanChawla   :'data.frame': 1365 obs. of  1 variable:
    ##   ..$ user_id: chr [1:1365] "3362913279" "851583986270957568" "449588356" "15227791" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ rogierK        :'data.frame': 1359 obs. of  1 variable:
    ##   ..$ user_id: chr [1:1359] "4427052929" "3315236924" "2976444713" "3865005196" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ AriBFriedman   :'data.frame': 1414 obs. of  1 variable:
    ##   ..$ user_id: chr [1:1414] "805181039245225984" "740985271026491392" "2534410031" "720675478193971200" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ yrochat        :'data.frame': 533 obs. of  1 variable:
    ##   ..$ user_id: chr [1:533] "2827803498" "311905244" "74398697" "3645507015" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ TheSmartJokes  :'data.frame': 5000 obs. of  1 variable:
    ##   ..$ user_id: chr [1:5000] "891529978201780224" "811251016410664960" "891556417739608064" "843245938449833984" ...
    ##   ..- attr(*, "next_cursor")= chr "1545261800668264448"
    ##  $ mikkopiippo    :'data.frame': 4860 obs. of  1 variable:
    ##   ..$ user_id: chr [1:4860] "770326630145282048" "703923734" "49542761" "122129148" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ rtraborn       :'data.frame': 1073 obs. of  1 variable:
    ##   ..$ user_id: chr [1:1073] "369101147" "81882372" "2639088547" "33867913" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ b_prasad26     :'data.frame': 2426 obs. of  1 variable:
    ##   ..$ user_id: chr [1:2426] "75321229" "15851807" "484023344" "177444328" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ ozjimbob       :'data.frame': 980 obs. of  1 variable:
    ##   ..$ user_id: chr [1:980] "17707546" "804157677177868288" "916685508" "2546258378" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ ricobert1      :'data.frame': 707 obs. of  1 variable:
    ##   ..$ user_id: chr [1:707] "88731801" "153234994" "19878055" "2743609942" ...
    ##   ..- attr(*, "next_cursor")= chr "0"
    ##  $ PlethodoNick   :'data.frame': 1961 obs. of  1 variable:
    ##   ..$ user_id: chr [1:1961] "42486688" "15576928" "2154127088" "337318821" ...
    ##   ..- attr(*, "next_cursor")= chr "0"

So what I need to do now is i) append the two lists, ii) create a variable stating top users' name in each of those lists and iii) turn lists into data frames. All this can be done in 3 lines of code. And brace yourself: here comes the `purrr` trick I've been going on about! Simply using `purrr:::map2_df` I can take a single list of lists, create a name variable in each of those lists based on the list name (`twitter_top_user`) and convert the result into the data frame. BRILLIANT!!

``` r
# turning lists into data frames and putting them together
friends_top30 <- append(friends_top30a, friends_top30b)
names(friends_top30) <- top_30_usernames

# purrr - trick I've been banging on about!
friends_top <- map2_df(friends_top30, names(friends_top30), ~ mutate(.x, twitter_top_user = .y)) %>% 
  rename(friend_id = user_id) %>% select(twitter_top_user, friend_id)

# are we missing any users?
friends_top %>% summarize(dist = n_distinct(twitter_top_user))
```

    ##   dist
    ## 1   30

Here's the last bit that I need to correct before we move to plotting the friends networks: for some reason, using `purrr::map()` with `rtweet:::get_friends()` gives me only 5000 friends, whereas the true value is over 8000. As it's the only top user with more than 5000 friends, I'll download his friends separately...

``` r
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

    ## 'data.frame':    8611 obs. of  2 variables:
    ##  $ twitter_top_user: chr  "TheSmartJokes" "TheSmartJokes" "TheSmartJokes" "TheSmartJokes" ...
    ##  $ friend_id       : chr  "390877754" "6085962" "88540151" "108186743" ...

... and use it to replace those that are already in the final friends list.

``` r
friends_top30 <- friends_top %>% 
  filter(twitter_top_user != "TheSmartJokes") %>% 
  rbind(SJ_friends) 
```

Some final data cleaning: filtering out friends that are not among the top 30 R - users, replacing their IDs with twitter names and adding gender for top users and their friends... Tam, tam, tam: here we are! Here's the final data frame we'll use for visualising the friends networks!

``` r
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

    ##   twitter_top_user     friend_name user_gender friend_gender
    ## 1         hrbrmstr nicoleradziwill           M             F
    ## 2         hrbrmstr        kara_woo           M             F
    ## 3         hrbrmstr      juliasilge           M             F
    ## 4         hrbrmstr        noamross           M             M
    ## 5         hrbrmstr      JennyBryan           M             F
    ## 6         hrbrmstr     thosjleeper           M             M

#### VISUALIZATING FRIENDS NETWORKS

After turning our data frame into something more usable by `igraph` and `ggraph`...

``` r
f1 <- graph_from_data_frame(final, directed = TRUE, vertices = NULL)
V(f1)$Popularity <- degree(f1, mode = 'in')
```

... let's have a quick overview of all the connections:

``` r
ggraph(f1, layout='kk') + 
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity)) +
  theme_graph( fg_text_colour = 'black') 
```

![generic_pure](/img/2017-08-13-friendships-among-top-r-twitterers_files/figure-markdown_github/pure_graph-1.png)

Keep in mind that `Popularity` - defined as the number of edges that go **into** the node - determines node size. It's all pretty, but I'd like to see how nodes correspond to Twitter users' names:

``` r
ggraph(f1, layout='kk') + 
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity)) +
  geom_node_text(aes(label = name, fontface='bold'), 
                 color = 'white', size = 3) +
  theme_graph(background = 'dimgray', text_colour = 'white',title_size = 30) 
```

![generic_names](/img/2017-08-13-friendships-among-top-r-twitterers_files/figure-markdown_github/names_graph-1.png)

So interesting! You see the core of the graph consisting of mainly female users: @hpster, @JennyBryan, @juliasilge, @karawoo, but also a couple of male R - users: @hrbrmstr and @noamross. Who do they follow? Men or women?

``` r
ggraph(f1, layout='kk') + 
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity)) +
  theme_graph( fg_text_colour = 'black') +
  geom_edge_link(aes(colour = friend_gender)) +
  scale_edge_color_brewer(palette = 'Set1') + 
  labs(title='Top 30 #rstats users and gender of their friends')
```

![generic_with_gender](/img/2017-08-13-friendships-among-top-r-twitterers_files/figure-markdown_github/user_gender-1.png)

It's difficult to say definitely, but superficially I see A LOT of red, suggesting that our top R - users often follow female top twitterers. Let's have a closer look and split graphs by user gender and see if there's any difference in the gender of users they follow:

``` r
ggraph(f1, layout='kk') + 
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity)) +
  theme_graph( fg_text_colour = 'black') +
  facet_edges(~user_gender) +
  geom_edge_link(aes(colour = friend_gender)) +
  scale_edge_color_brewer(palette = 'Set1') +
  labs(title='Top 30 #rstats users and gender of their friends', subtitle='Graphs are separated by top user gender, edge colour indicates their friend gender' )
```

![gender_with_gender](/img/2017-08-13-friendships-among-top-r-twitterers_files/figure-markdown_github/user_gender2-1.png)

Ha! look at this! Obviously, Female users' graph will be less dense as there are fewer of them in the dataset, however, you can see that they tend to follow male users more often than male top users do. Is that impression supported by raw numbers?

``` r
final %>% 
  group_by(user_gender, friend_gender) %>% 
  summarize(n = n()) %>% 
  group_by(user_gender) %>% 
  mutate(sum = sum(n),
         percent = round(n/sum, 2)) 
```

    ## # A tibble: 4 x 5
    ## # Groups:   user_gender [2]
    ##   user_gender friend_gender     n   sum percent
    ##         <chr>         <chr> <int> <int>   <dbl>
    ## 1           F             F    26    57    0.46
    ## 2           F             M    31    57    0.54
    ## 3           M             F    55   101    0.54
    ## 4           M             M    46   101    0.46

It looks so, although to the lesser extend than suggested by the network graphs: Female top users follower other female top users 46% of time, whereas male top users follow female top user 54% of time. So what do you have to say about that?
