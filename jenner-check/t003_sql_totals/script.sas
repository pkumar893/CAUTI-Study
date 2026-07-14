/* CAUTI-Study: PROC SQL that remerges group sums back onto detail rows
   (SAS's grouped-aggregate-without-collapse behavior) to build per-episode
   meatal-care and CHG numerator/denominator totals, then a DATA step turns
   those totals into rounded percentages. Lifted from cauti 04_19_2024.sas. */

proc sql;
  create table consec_foleys_new_id as
  select new_id, HOSP_ADMSN_TIME, consec_foley,
         Meatal_Denominator, Meatal_Numerator, CHG_DENOMINATOR, CHG_numerator,
         sum(Meatal_Denominator) as tot_meatal_denom,
         sum(Meatal_Numerator) as tot_meatal_numer,
         sum(CHG_denominator) as tot_CHG_denom,
         sum(CHG_numerator) as tot_CHG_numer,
         sum(Num_Foley_Urine_Culture_Collecte) as Tot_Foley_UC_Collected,
         sum(Num_abnormal_Urine_Culture) as Tot_abnormal_UC
  from table9
  group by new_id, HOSP_ADMSN_TIME, consec_foley;
quit;

data table13;
  set consec_foleys_new_id;
  tot_meatal=(tot_meatal_numer/tot_meatal_denom)*100;
  tot_chg=(tot_CHG_numer/tot_CHG_denom)*100;
  tot_meatal=round(tot_meatal);
  tot_chg=round(tot_chg);
run;

proc print data=table13;
  var new_id consec_foley tot_meatal_denom tot_meatal_numer tot_meatal tot_chg Tot_Foley_UC_Collected;
run;
