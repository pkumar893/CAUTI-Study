/* cap input rows for the captured run */
options obs=100;

/* Bundle setup: mock per-foley records carrying the numerator/denominator
   columns the PROC SQL step aggregates into per-episode totals. */
data table9;
  infile datalines dsd truncover;
  input new_id HOSP_ADMSN_TIME consec_foley
        Meatal_Denominator Meatal_Numerator CHG_DENOMINATOR CHG_numerator
        Num_Foley_Urine_Culture_Collecte Num_abnormal_Urine_Culture;
  datalines;
1,23010,1,3,2,4,3,2,0
1,23010,1,3,3,4,4,1,1
2,23020,1,5,4,5,5,3,0
2,23020,2,2,1,2,2,1,1
3,23040,1,3,1,3,2,0,0
;
run;
