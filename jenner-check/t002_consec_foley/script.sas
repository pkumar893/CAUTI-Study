/* CAUTI-Study: within-admission foley bookkeeping. Counts catheters per
   admission (first./retain), computes the gap between one removal and the
   next placement via LAG + INTCK, and increments a consecutive-episode
   counter when that gap exceeds a day. Lifted from cauti 04_19_2024.sas. */

proc sort data=table8;
  by PAT_MRN_ID HOSP_ADMSN_TIME PLACEMENT_DATE;
run;

data table8;
  set table8;
  by PAT_MRN_ID HOSP_ADMSN_TIME;
  retain num_foleys;
  if first.HOSP_ADMSN_TIME then num_foleys=1;
  else num_foleys=num_foleys+1;
run;

data table8;
  set table8;
  by PAT_MRN_ID HOSP_ADMSN_TIME;
  retain foley_gap;
  r_date=lag(REMOVAL_DATE);
  format r_date ddmmyy6.;
  if first.HOSP_ADMSN_TIME then foley_gap=0;
  else foley_gap= intck('day',r_date, PLACEMENT_DATE);
run;

data table8;
  set table8;
  by PAT_MRN_ID HOSP_ADMSN_TIME;
  retain consec_foley;
  if first.HOSP_ADMSN_TIME then consec_foley=1;
  if foley_gap >1 then consec_foley=consec_foley+1;
  else consec_foley=consec_foley+0;
run;

proc print data=table8;
  var PAT_MRN_ID HOSP_ADMSN_TIME PLACEMENT_DATE REMOVAL_DATE num_foleys foley_gap consec_foley;
run;
