### deploy_api.r
### deploy xbgoost mortality prediction api
### asa wilks 06.02.2019

#install.packages("xgboost")
#install.packages('rsconnect')
#install.packages('jsonline')
#install.packages('rpart')
#install.packages('plumber')

#library(rpart)
#library(jsonlite)
#library(rsconnect)
library(xgboost)
#library(plumber)

#setwd("~/UCLA/STAT413/git/mimic/csv")

rm(list=ls())
xgbfit <- xgb.load("xgboost.model.1JUN2019")

predict.death.rate <- function(
  HAS_CHARTEVENTS_DATA=NA,
  ADMISSION_TYPE=NA,
  MARITAL_STATUS=NA,
  ADMISSION_LOCATION=NA,
  INSURANCE=NA,
  ETHNICITY=NA,
  LANGUAGE=NA,
  RELIGION=NA,
  DX1=NA,
  DX2=NA,
  DX3=NA,
  DX4=NA,
  DX5=NA
) {
  
    # create vector of zeros for inputs
  inp <- matrix(0, ncol = 1232, nrow = 1)
 
  colnames(inp) <- c("HAS_CHARTEVENTS_DATA","MARITAL_STATUS.","MARITAL_STATUS.DIVORCED","MARITAL_STATUS.LIFE.PARTNER","MARITAL_STATUS.MARRIED","MARITAL_STATUS.SEPARATED","MARITAL_STATUS.SINGLE","MARITAL_STATUS.UNKNOWN..DEFAULT.","MARITAL_STATUS.WIDOWED","ADMISSION_TYPE.ELECTIVE","ADMISSION_TYPE.EMERGENCY","ADMISSION_TYPE.NEWBORN","ADMISSION_TYPE.URGENT","ADMISSION_LOCATION....INFO.NOT.AVAILABLE...","ADMISSION_LOCATION.CLINIC.REFERRAL.PREMATURE","ADMISSION_LOCATION.EMERGENCY.ROOM.ADMIT","ADMISSION_LOCATION.HMO.REFERRAL.SICK","ADMISSION_LOCATION.PHYS.REFERRAL.NORMAL.DELI","ADMISSION_LOCATION.TRANSFER.FROM.HOSP.EXTRAM","ADMISSION_LOCATION.TRANSFER.FROM.OTHER.HEALT","ADMISSION_LOCATION.TRANSFER.FROM.SKILLED.NUR","ADMISSION_LOCATION.TRSF.WITHIN.THIS.FACILITY","INSURANCE.Government","INSURANCE.Medicaid","INSURANCE.Medicare","INSURANCE.Private","INSURANCE.Self.Pay","RELIGION.","RELIGION.7TH.DAY.ADVENTIST","RELIGION.BAPTIST","RELIGION.BUDDHIST","RELIGION.CATHOLIC","RELIGION.CHRISTIAN.SCIENTIST","RELIGION.EPISCOPALIAN","RELIGION.GREEK.ORTHODOX","RELIGION.HEBREW","RELIGION.HINDU","RELIGION.JEHOVAH.S.WITNESS","RELIGION.JEWISH","RELIGION.LUTHERAN","RELIGION.METHODIST","RELIGION.MUSLIM","RELIGION.NOT.SPECIFIED","RELIGION.OTHER","RELIGION.PROTESTANT.QUAKER","RELIGION.ROMANIAN.EAST..ORTH","RELIGION.UNITARIAN.UNIVERSALIST","RELIGION.UNOBTAINABLE","ETHNICITY.AMERICAN.INDIAN.ALASKA.NATIVE","ETHNICITY.AMERICAN.INDIAN.ALASKA.NATIVE.FEDERALLY.RECOGNIZED.TRIBE","ETHNICITY.ASIAN","ETHNICITY.ASIAN...ASIAN.INDIAN","ETHNICITY.ASIAN...CAMBODIAN","ETHNICITY.ASIAN...CHINESE","ETHNICITY.ASIAN...FILIPINO","ETHNICITY.ASIAN...JAPANESE","ETHNICITY.ASIAN...KOREAN","ETHNICITY.ASIAN...OTHER","ETHNICITY.ASIAN...THAI","ETHNICITY.ASIAN...VIETNAMESE","ETHNICITY.BLACK.AFRICAN","ETHNICITY.BLACK.AFRICAN.AMERICAN","ETHNICITY.BLACK.CAPE.VERDEAN","ETHNICITY.BLACK.HAITIAN","ETHNICITY.CARIBBEAN.ISLAND","ETHNICITY.HISPANIC.OR.LATINO","ETHNICITY.HISPANIC.LATINO...CENTRAL.AMERICAN..OTHER.","ETHNICITY.HISPANIC.LATINO...COLOMBIAN","ETHNICITY.HISPANIC.LATINO...CUBAN","ETHNICITY.HISPANIC.LATINO...DOMINICAN","ETHNICITY.HISPANIC.LATINO...GUATEMALAN","ETHNICITY.HISPANIC.LATINO...HONDURAN","ETHNICITY.HISPANIC.LATINO...MEXICAN","ETHNICITY.HISPANIC.LATINO...PUERTO.RICAN","ETHNICITY.HISPANIC.LATINO...SALVADORAN","ETHNICITY.MIDDLE.EASTERN"
                  ,"ETHNICITY.MULTI.RACE.ETHNICITY","ETHNICITY.NATIVE.HAWAIIAN.OR.OTHER.PACIFIC.ISLANDER","ETHNICITY.OTHER","ETHNICITY.PATIENT.DECLINED.TO.ANSWER","ETHNICITY.PORTUGUESE","ETHNICITY.SOUTH.AMERICAN","ETHNICITY.UNABLE.TO.OBTAIN","ETHNICITY.UNKNOWN.NOT.SPECIFIED","ETHNICITY.WHITE","ETHNICITY.WHITE...BRAZILIAN","ETHNICITY.WHITE...EASTERN.EUROPEAN","ETHNICITY.WHITE...OTHER.EUROPEAN","ETHNICITY.WHITE...RUSSIAN","LANGUAGE.","LANGUAGE...BE","LANGUAGE...FU","LANGUAGE....T","LANGUAGE...SH","LANGUAGE...TO","LANGUAGE..AMH","LANGUAGE..ARA","LANGUAGE..ARM","LANGUAGE..BEN","LANGUAGE..BOS","LANGUAGE..BUL","LANGUAGE..BUR","LANGUAGE..CAN","LANGUAGE..CDI","LANGUAGE..CHI","LANGUAGE..CRE","LANGUAGE..DEA","LANGUAGE..DUT","LANGUAGE..FAR","LANGUAGE..FIL","LANGUAGE..FUL","LANGUAGE..GUJ","LANGUAGE..HUN","LANGUAGE..IBO","LANGUAGE..KHM","LANGUAGE..LEB","LANGUAGE..LIT","LANGUAGE..MAN","LANGUAGE..MOR","LANGUAGE..NEP","LANGUAGE..PER","LANGUAGE..PHI","LANGUAGE..PUN","LANGUAGE..ROM","LANGUAGE..RUS","LANGUAGE..SPA","LANGUAGE..TAM","LANGUAGE..TEL","LANGUAGE..TOI","LANGUAGE..TOY","LANGUAGE..URD","LANGUAGE..YID","LANGUAGE..YOR","LANGUAGE.ALBA","LANGUAGE.AMER","LANGUAGE.ARAB","LANGUAGE.BENG","LANGUAGE.CAMB","LANGUAGE.CANT","LANGUAGE.CAPE","LANGUAGE.ENGL","LANGUAGE.ETHI","LANGUAGE.FREN","LANGUAGE.GERM","LANGUAGE.GREE","LANGUAGE.HAIT","LANGUAGE.HIND","LANGUAGE.ITAL","LANGUAGE.JAPA","LANGUAGE.KORE","LANGUAGE.LAOT","LANGUAGE.MAND","LANGUAGE.PERS","LANGUAGE.POLI","LANGUAGE.PORT","LANGUAGE.PTUN","LANGUAGE.RUSS","LANGUAGE.SERB","LANGUAGE.SOMA","LANGUAGE.SPAN","LANGUAGE.TAGA","LANGUAGE.THAI","LANGUAGE.TURK","LANGUAGE.URDU","LANGUAGE.VIET","DX00845","DX0088","DX0380","DX03810","DX03811","DX03812","DX03819","DX0382","DX0383","DX03840","DX03842","DX03843","DX03849","DX0388","DX0389","DX04104","DX04111","DX0413","DX0414","DX0417","DX04185","DX04186","DX042","DX07030","DX07032","DX07044","DX07051","DX07054","DX07070","DX07071","DX0785","DX07999","DX1120","DX1122","DX1125","DX11284","DX11289","DX1173","DX1179","DX135","DX1363","DX1505","DX1508","DX1510","DX1533","DX1534","DX1536","DX1541","DX1550","DX1551","DX1552","DX1561","DX1570","DX1578","DX1622","DX1623","DX1624","DX1625","DX1628","DX1629","DX1748","DX1830","DX185","DX1888","DX1890","DX1911","DX1912","DX1913","DX1918","DX1919","DX193","DX1960","DX1961"
                  ,"DX1962","DX1963","DX1970","DX1971","DX1972","DX1973","DX1974","DX1975","DX1976","DX1977","DX1978","DX1981","DX1983","DX1984","DX1985","DX1987","DX19882","DX19889","DX1991","DX20190","DX20280","DX20300","DX20400","DX20410","DX20500","DX20510","DX2113","DX2127","DX2252","DX2273","DX2375","DX2387","DX23875","DX24290","DX2440","DX2449","DX25000","DX25001","DX25002","DX25010","DX25011","DX25012","DX25013","DX25022","DX25040","DX25041","DX25043","DX25050","DX25051","DX25053","DX25060","DX25061","DX25062","DX25063","DX25070","DX25080","DX25081","DX25082","DX25083","DX2532","DX2535","DX2536","DX2554","DX25541","DX261","DX262","DX2639","DX2662","DX2720","DX2724","DX2749","DX2753","DX27541","DX2760","DX2761","DX2762","DX2763","DX2764","DX2765","DX27650","DX27651","DX27652","DX2766","DX27669","DX2767","DX2768","DX27730","DX27739","DX27788","DX27800","DX27801","DX27803","DX2800","DX2809","DX28249","DX2830","DX2839","DX2841","DX28419","DX2848","DX28489","DX2851","DX28521","DX28529","DX2859","DX2860","DX2866","DX2867","DX2869","DX2873","DX28731","DX2874","DX2875","DX2880","DX28800","DX28860","DX28981","DX2910","DX29181","DX2920","DX29281","DX2930","DX2939","DX29410","DX2948","DX29530","DX29562","DX29570","DX29590","DX29620","DX29650","DX2967","DX29680","DX29689","DX30000","DX3004","DX30300","DX30301","DX30390","DX30391","DX30401","DX30421","DX30500","DX30501","DX3051","DX30550","DX30560","DX30561","DX30590","DX30981","DX311","DX31401","DX319","DX3229","DX3239","DX3240","DX3241","DX32723","DX3310","DX3313","DX3314","DX3320","DX33520","DX3361","DX3363","DX3371","DX33818","DX33829","DX340","DX34200","DX34290","DX34291","DX34292","DX34400","DX3441","DX34510","DX3453","DX34540","DX34550","DX34580","DX34590","DX34690","DX3481","DX34830","DX34831","DX34839","DX3484","DX3485","DX3488","DX34889","DX34982","DX3569","DX3570","DX3572","DX35800","DX35801","DX36201","DX3659","DX3941","DX3942","DX3960","DX3962","DX3963","DX3968","DX3970","DX39891","DX4010","DX4011","DX4019","DX40291","DX40300","DX40301","DX40390","DX40391","DX41001","DX41011","DX41021","DX41031","DX41041","DX41051","DX41061","DX41071","DX41072","DX41081","DX41091","DX4110","DX4111","DX41189","DX412","DX4139","DX41400","DX41401","DX41402","DX41410","DX41412","DX4142","DX4148","DX41511","DX41512","DX41519","DX4160"
                  ,"DX4162","DX4168","DX42090","DX42091","DX42099","DX4210","DX4230","DX4231","DX4232","DX4233","DX4238","DX4239","DX4240","DX4241","DX4242","DX4251","DX4254","DX4255","DX4258","DX4260","DX42611","DX42612","DX42613","DX4263","DX4270","DX4271","DX42731","DX42732","DX42741","DX4275","DX42781","DX42789","DX4280","DX42820","DX42821","DX42822","DX42823","DX42830","DX42831","DX42832","DX42833","DX42840","DX42841","DX42842","DX42843","DX4295","DX42971","DX42983","DX4299","DX430","DX431","DX4321","DX4329","DX43301","DX43310","DX43311","DX43320","DX43330","DX43331","DX43401","DX43411","DX43491","DX4359","DX4370","DX4372","DX4373","DX43820","DX43889","DX4400","DX4401","DX44020","DX44021","DX44022","DX44023","DX44024","DX44031","DX44101","DX44102","DX44103","DX4412","DX4413","DX4414","DX4417","DX4422","DX4423","DX44321","DX44322","DX44324","DX44329","DX4439","DX4440","DX4441","DX44421","DX44422","DX44481","DX44489","DX4464","DX4465","DX4466","DX45182","DX452","DX4532","DX45340","DX45341","DX45342","DX4538","DX45381","DX4550","DX4552","DX4560","DX4561","DX45620","DX45621","DX4568","DX4580","DX4582","DX45829","DX4588","DX4589","DX4590","DX4592","DX4659","DX4660","DX47831","DX4786","DX47874","DX481","DX4820","DX4821","DX4822","DX48241","DX48242","DX48282","DX48283","DX48284","DX4829","DX4846","DX485","DX486","DX4870","DX4871","DX49121","DX49122","DX4928","DX49320","DX49322","DX49390","DX49391","DX49392","DX4940","DX4941","DX496","DX5070","DX5100","DX5109","DX5110","DX5118","DX51181","DX51189","DX5119","DX5121","DX5128","DX5130","DX514","DX515","DX5168","DX5178","DX5180","DX5184","DX5185","DX51851","DX51852","DX51881","DX51882","DX51883","DX51884","DX51889","DX51902","DX51909","DX5191","DX51919","DX5192","DX53010","DX53019","DX53020","DX53021","DX5303","DX5304","DX5307","DX53081","DX53082","DX53085","DX53100","DX53140","DX53200","DX53240","DX53440","DX53541","DX53550","DX53551","DX53560","DX53561","DX5363","DX53642","DX5370","DX53783","DX53784","DX53789","DX5400","DX55221","DX5523","DX5531","DX55321","DX5533","DX5559","DX5566","DX5569","DX5570","DX5571","DX5579","DX5589","DX5601","DX5602","DX56039","DX56081","DX56089","DX5609","DX56210","DX56211","DX56212","DX56213","DX56400","DX5641","DX566","DX5672","DX56721","DX56722","DX56723","DX56729","DX5679","DX5680","DX56881"
                  ,"DX5693","DX56941","DX5695","DX56969","DX56981","DX56982","DX56983","DX56985","DX570","DX5711","DX5712","DX5715","DX5716","DX5718","DX5720","DX5722","DX5723","DX5724","DX5728","DX5733","DX5738","DX57400","DX57410","DX57420","DX57450","DX57451","DX57491","DX5750","DX57511","DX5761","DX5762","DX5768","DX5770","DX5771","DX5772","DX5780","DX5781","DX5789","DX5793","DX58089","DX58281","DX58381","DX5845","DX5848","DX5849","DX585","DX5853","DX5854","DX5855","DX5856","DX5859","DX58881","DX59010","DX59080","DX591","DX5920","DX5921","DX59381","DX5939","DX5990","DX5997","DX6000","DX60000","DX60001","DX6820","DX6821","DX6822","DX6823","DX6826","DX6827","DX6930","DX6961","DX7070","DX70703","DX70705","DX70707","DX70709","DX70712","DX70713","DX70714","DX70715","DX70719","DX70723","DX70724","DX7100","DX7101","DX71106","DX7140","DX71535","DX71536","DX71590","DX7210","DX7211","DX7213","DX72210","DX72402","DX7242","DX7245","DX725","DX72886","DX72888","DX72889","DX7291","DX72989","DX73007","DX73008","DX73027","DX73028","DX73300","DX73313","DX73342","DX73382","DX73390","DX73730","DX73819","DX7424","DX7452","DX7454","DX7455","DX74602","DX7464","DX74689","DX7470","DX7473","DX74781","DX7503","DX75251","DX75261","DX75312","DX75329","DX75733","DX7580","DX75989","DX7625","DX76407","DX76408","DX76502","DX76503","DX76514","DX76515","DX76516","DX76517","DX76518","DX76519","DX76523","DX76524","DX76525","DX76526","DX76527","DX76528","DX76529","DX7660","DX7661","DX76621","DX76719","DX769","DX7700","DX7702","DX7706","DX7707","DX7708","DX77081","DX77082","DX77083","DX77089","DX7718","DX77181","DX77183","DX77211","DX7726","DX7731","DX7732","DX7742","DX7746","DX7750","DX7755","DX7756","DX7757","DX7761","DX7766","DX7775","DX7783","DX7784","DX7786","DX7788","DX7790","DX7793","DX77981","DX77989","DX78001","DX78009","DX7802","DX78039","DX78057","DX7806","DX78060","DX78062","DX78097","DX7812","DX7813","DX78194","DX7824","DX7840","DX7843","DX7847","DX7850","DX7852","DX7854","DX78550","DX78551","DX78552","DX78559","DX7856","DX78609","DX7863","DX78630","DX78650","DX78659","DX78701","DX7872","DX78720","DX78791","DX78820","DX78829","DX78830","DX7885","DX78900","DX7895","DX78951","DX78959","DX79001","DX7904","DX7907","DX79092","DX79902","DX7991","DX7994","DX80101","DX80120","DX80121","DX80122"
                  ,"DX80125","DX80126","DX8020","DX8024","DX8026","DX8028","DX80501","DX80502","DX80504","DX80505","DX80506","DX80507","DX80508","DX8052","DX8054","DX8056","DX80600","DX80605","DX8064","DX80701","DX80702","DX80703","DX80704","DX80705","DX80706","DX80707","DX80708","DX80709","DX8072","DX8074","DX8080","DX8082","DX80841","DX81000","DX81342"
                  ,"DX82009","DX82021","DX82022","DX8208","DX82101","DX82123","DX82300","DX82302","DX82332","DX85011","DX8505","DX85180","DX85181","DX85182","DX85186","DX85200","DX85201","DX85202","DX85205","DX85206","DX85220","DX85221","DX85222","DX85225","DX85226","DX85300","DX85301","DX85302","DX85306","DX8600","DX8602","DX8604","DX86121","DX86402","DX86403","DX86405","DX86500","DX86501","DX86502","DX86503","DX86504","DX86509","DX86602","DX8670","DX86803","DX86804","DX8708","DX8730","DX87342","DX87343","DX8910","DX9100","DX920","DX9331","DX9341","DX9351","DX9584","DX9587","DX9630","DX96500","DX96501","DX96509","DX9654","DX9663","DX9690","DX9693","DX9694","DX9708","DX9800","DX9950","DX9951","DX99591","DX99592","DX99593","DX99594","DX99601","DX99602","DX99604","DX9961","DX9962","DX99649","DX99659","DX99661","DX99662","DX99663","DX99664","DX99666","DX99667","DX99669","DX99671","DX99672","DX99673","DX99674","DX99679","DX99681","DX99682","DX99685","DX99702","DX99709","DX9971","DX9972","DX9973","DX99731","DX99739","DX9974","DX99749","DX9975","DX99762","DX99779","DX9980","DX99811","DX99812","DX99813","DX9982","DX99831","DX99832","DX99859","DX9986","DX99881","DX99883","DX99889","DX9992","DX99931","DX9998","DX99999","DXE8120","DXE8121","DXE8122","DXE8147","DXE8150","DXE8160","DXE8161","DXE8162","DXE8190","DXE8261","DXE8490","DXE8495","DXE8497","DXE8498","DXE8499","DXE8781","DXE8782","DXE8786","DXE8788","DXE8790","DXE8792","DXE8798","DXE8799","DXE8809","DXE8810","DXE882","DXE8844","DXE8849","DXE8859","DXE8881","DXE8889","DXE915","DXE9289","DXE9320","DXE9331","DXE9342","DXE9359","DXE9429","DXE9478","DXE9500","DXE9503","DXE9504","DXE9600","DXE966","DXE9689","DXV053","DXV071","DXV08","DXV090","DXV1005","DXV1011","DXV103","DXV1046","DXV1051","DXV1052","DXV1082","DXV1083","DXV1251","DXV1254","DXV1259","DXV153","DXV1581","DXV1582","DXV173","DXV202","DXV290","DXV293","DXV298","DXV3000","DXV3001","DXV3100","DXV3101","DXV3401","DXV420","DXV422","DXV427","DXV4281","DXV4282","DXV4283","DXV433","DXV4364","DXV4365","DXV440","DXV441","DXV4501","DXV4502","DXV451","DXV4511","DXV4581","DXV4582","DXV4586","DXV4611","DXV462","DXV4983","DXV4986","DXV502","DXV550","DXV5811","DXV5861","DXV5865","DXV5867","DXV600","DXV6284","DXV641","DXV667","DXV707","DXV721","DXV850","DXV854","DXV8541")
  
  MARITAL_STATUS <- noquote(MARITAL_STATUS)
  ADMISSION_TYPE <- noquote(ADMISSION_TYPE)
  ADMISSION_LOCATION <- noquote(ADMISSION_LOCATION)
  INSURANCE <- noquote(INSURANCE)
  LANGUAGE <- noquote(LANGUAGE)
  RELIGION <- noquote(RELIGION)
  ETHNICITY <- noquote(ETHNICITY)
  
  if (!is.na(HAS_CHARTEVENTS_DATA)){
    if (HAS_CHARTEVENTS_DATA==1){inp[,"HAS_CHARTEVENTS_DATA"] <- 1}
  }
  
  if (!is.na(ADMISSION_TYPE)){
  if (ADMISSION_TYPE == "ELECTIVE"){inp[,"ADMISSION_TYPE.ELECTIVE"] <- 1}
  if (ADMISSION_TYPE == "EMERGENCY"){inp[,"ADMISSION_TYPE.EMERGENCY"] <- 1}
  if (ADMISSION_TYPE == "NEWBORN"){inp[,"ADMISSION_TYPE.NEWBORN"] <- 1}
  if (ADMISSION_TYPE == "URGENT"){inp[,"ADMISSION_TYPE.URGENT"] <- 1}
  }
  
  if (!is.na(ADMISSION_LOCATION)){
  if (ADMISSION_LOCATION == "UNK"){inp[,"ADMISSION_LOCATION....INFO.NOT.AVAILABLE..."] <- 1}
  if (ADMISSION_LOCATION == "EMERGENCY_ROOM"){inp[,"ADMISSION_LOCATION.EMERGENCY.ROOM.ADMIT"] <- 1}
  if (ADMISSION_LOCATION == "TRANSFER_WITHIN"){inp[,"ADMISSION_LOCATION.TRSF.WITHIN.THIS.FACILITY"] <- 1}
  }
  
  if (!is.na(INSURANCE)){
  if (INSURANCE == "GOVERNMENT"){inp[,"INSURANCE.Government"] <- 1}
  if (INSURANCE == "MEDICAID"){inp[,"INSURANCE.Medicaid"] <- 1}
  if (INSURANCE == "MEDICARE"){inp[,"INSURANCE.Medicare"] <- 1}
  if (INSURANCE == "PRIVATE"){inp[,"INSURANCE.Private"] <- 1}
  if (INSURANCE == "SELFPAY"){inp[,"INSURANCE.Self.Pay"] <- 1}
  }
  
  if (!is.na(MARITAL_STATUS)){
  if (MARITAL_STATUS == "UNK"){inp[,"MARITAL_STATUS."] <- 1}
  if (MARITAL_STATUS == "DIVORCED"){inp[,"MARITAL_STATUS.DIVORCED"] <- 1}
  if (MARITAL_STATUS == "LIFE.PARTNER"){inp[,"MARITAL_STATUS.LIFE.PARTNER"] <- 1}
  if (MARITAL_STATUS == "MARRIED"){inp[,"MARITAL_STATUS.MARRIED"] <- 1}
  if (MARITAL_STATUS == "SEPARATED"){inp[,"MARITAL_STATUS.SEPARATED"] <- 1}
  if (MARITAL_STATUS == "SINGLE"){inp[,"MARITAL_STATUS.SINGLE"] <- 1}
  if (MARITAL_STATUS == "WIDOWED"){inp[,"MARITAL_STATUS.WIDOWED"] <- 1}
  }
  
  if (!is.na(RELIGION)){
    if (RELIGION == "UNK"){inp[,"RELIGION."] <- 1}
    if (RELIGION == "CATHOLIC"){inp[,"RELIGION.CATHOLIC"] <- 1}
    if (RELIGION == "JEWISH"){inp[,"RELIGION.JEWISH"] <- 1}
    if (RELIGION == "MUSLIM"){inp[,"RELIGION.MUSLIM"] <- 1}
  }
  
  if (!is.na(LANGUAGE)){
    if (LANGUAGE == "UNK"){inp[,"LANGUAGE."] <- 1}
    if (LANGUAGE == "ENGLISH"){inp[,"LANGUAGE.ENGL"] <- 1}
    if (LANGUAGE == "SPANISH"){inp[,"LANGUAGE.SPAN"] <- 1}
    if (LANGUAGE == "KOREAN"){inp[,"LANGUAGE.KORE"] <- 1}
    }
  
  if (!is.na(ETHNICITY)){
    if (ETHNICITY == "WHITE"){inp[,"ETHNICITY.WHITE"] <- 1}
    if (ETHNICITY == "BLACK"){inp[,"ETHNICITY.BLACK.AFRICAN.AMERICAN"] <- 1}
    if (ETHNICITY == "ASIAN"){inp[,"ETHNICITY.ASIAN"] <- 1}
    if (ETHNICITY == "LATINO"){inp[,"ETHNICITY.HISPANIC.OR.LATINO"] <- 1}
  }
  
  ###
  # turn on indicator flags based on value of DX variables
  ###
  
  DX1 <- noquote(DX1)
  DX2 <- noquote(DX2)
  DX3 <- noquote(DX3)
  DX4 <- noquote(DX4)
  DX5 <- noquote(DX5)

  if (!is.na(DX1)){
    dxcall <- paste("inp","[,'",eval(parse(text = 'DX1')), "']", "<-1",sep='')
    eval(parse(text=dxcall))
  }
  
  if (!is.na(DX2)){
    dxcall <- paste("inp","[,'",eval(parse(text = 'DX2')), "']", "<-1",sep='')
    eval(parse(text=dxcall))
  }
  
  if (!is.na(DX3)){
    dxcall <- paste("inp","[,'",eval(parse(text = 'DX3')), "']", "<-1",sep='')
    eval(parse(text=dxcall))
  }
  
  if (!is.na(DX4)){
    dxcall <- paste("inp","[,'",eval(parse(text = 'DX4')), "']", "<-1",sep='')
    eval(parse(text=dxcall))
  }
  
  if (!is.na(DX5)){
    dxcall <- paste("inp","[,'",eval(parse(text = 'DX5')), "']", "<-1",sep='')
    eval(parse(text=dxcall))
  }
  
  print(DX1)
  print(inp["DX51551"])
  
  # load model and predict
  
  inp.m <- as.data.frame(inp)
  pred <- predict(xgbfit, newdata=as.matrix(inp))
  
  return(pred)
}

# 
# predict.death.rate(HAS_CHARTEVENTS_DATA = 1,
#                    MARITAL_STATUS = "DIVORCED",
#                    ADMISSION_TYPE = "EMERGENCY",
#                    ADMISSION_LOCATION = "UNK",
#                    INSURANCE = "MEDICARE",
#                    LANGUAGE = "ENGLISH",
#                    RELIGION = "JEWISH",
#                    ETHNICITY = "WHITE",
#                    DX1="DX51881",
#                    DX2="DX0389",
#                    DX3="DX27650",
#                    DX4="DX41401"
# )
