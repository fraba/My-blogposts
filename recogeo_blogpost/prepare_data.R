# Sources: https://www.istat.it/it/archivio/222527
#          http://dati.istat.it/Index.aspx?QueryId=18540


require(rgdal)
require(sf)

piedmont_1991.sp <-
  readOGR('~/Downloads/Limiti1991_g/Com1991_g/',
          'Com1991_g_WGS84',
          stringsAsFactors = F)
piedmont_1991.sp <- 
  piedmont_1991.sp[piedmont_1991.sp$COD_REG == 1,]
piedmont_1991.sf <- 
  st_as_sf(piedmont_1991.sp)

piedmont_2018.sp <-
  readOGR('~/Downloads/Limiti01012018_g/Com01012018_g/',
          'Com01012018_g', stringsAsFactors = F)
piedmont_2018.sp <- 
  piedmont_2018.sp[piedmont_2018.sp$COD_REG == 1,]
piedmont_2018.sf <- 
  st_as_sf(piedmont_2018.sp)

require(readr)
DCIS_POPRES1_30012019055642397 <- 
  read_csv("~/Downloads/DCIS_POPRES1_30012019070404457.csv")
require(dplyr)
DCIS_POPRES1_30012019055642397 <-
  DCIS_POPRES1_30012019055642397 %>%
  dplyr::filter(Sesso == 'totale' &
         `Stato civile` == 'totale') %>%
  dplyr::group_by(ITTER107) %>%
  dplyr::summarize(POP_2018 = sum(Value))


piedmont_2018.sf$POP_2018 <-
  DCIS_POPRES1_30012019055642397$POP_2018[match(
    piedmont_2018.sf$PRO_COM_T,
    DCIS_POPRES1_30012019055642397$ITTER107
    )]

piedmont_1991.sf <-
  piedmont_1991.sf %>%
  dplyr::select(PRO_COM_T, COMUNE, POP_1991)

piedmont_2018.sf <- 
  piedmont_2018.sf %>%
  dplyr::select(PRO_COM_T, COMUNE, POP_2018)

piedmont_1991.sf$POP_1991 <- as.numeric(piedmont_1991.sf$POP_1991)
piedmont_2018.sf$POP_2018 <- as.numeric(piedmont_2018.sf$POP_2018)

save(piedmont_1991.sf, piedmont_2018.sf, file = "data/spatial_objs.rda")

  


