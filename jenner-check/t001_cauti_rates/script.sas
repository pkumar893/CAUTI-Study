/* CAUTI-Study: recode of Y/N flags to 1/0, CAUTI date parse, and the
   derived-rate step (CHG %, meatal %, foley days, admission length),
   then PROC FREQ of the CAUTI outcome and PROC MEANS of the rates.
   Lifted from cauti 04_19_2024.sas.

   The leading DATA step is a small mock CAUTI cohort standing in for the
   study's "Cauti Study data 4-2024.xlsx" (5 patients, mixed Y/N/blank
   codes) so this file runs on its own. */

data table1;
  infile datalines dsd truncover;
  input PAT_MRN_ID PAT_AGE Gender :$8. DIABETES_ON_PROBLEM_LIST :$1.
        Bowel_Incontinence :$1. Urinary_Incontinence :$1. ORDER_FOR_FOLEY :$1.
        CAUTI_LDA :$1. CAUTI_Infection_date :$10.
        HOSP_ADMSN_TIME HOSP_DISCH_TIME
        CHG_NUMERATOR CHG_DENOMINATOR Meatal_Numerator Meatal_Denominator
        PLACEMENT_DATE REMOVAL_DATE;
  datalines;
1001,64,Male,Y,N,Y,Y,N,,23010,23016,3,4,2,3,23011,23015
1002,71,Female,N,,Y,Y,Y,04/12/2024,23020,23031,5,5,4,5,23021,23029
1003,55,Male,Y,Y,N,Y,N,,23040,23044,1,3,1,3,23041,23043
1004,80,Female,N,,,Y,N,,23050,23061,6,6,5,6,23051,23060
1005,47,Unknown,Y,N,Y,Y,N,,23070,23073,2,2,1,2,23071,23072
;
run;

data table1;
  set table1;
  if Gender="Male" then Gender=0;
  if Gender="Female" then Gender=1;
  if DIABETES_ON_PROBLEM_LIST="Y" then DIABETES_ON_PROBLEM_LIST=1;
  if DIABETES_ON_PROBLEM_LIST="N" then DIABETES_ON_PROBLEM_LIST=0;
  if Bowel_Incontinence="Y" then Bowel_Incontinence=1;
  if Bowel_Incontinence="" then Bowel_Incontinence=0;
  if Urinary_Incontinence="Y" then Urinary_Incontinence=1;
  if Urinary_Incontinence="" then Urinary_Incontinence=0;
  if ORDER_FOR_FOLEY="Y" then ORDER_FOR_FOLEY=1;
  if ORDER_FOR_FOLEY="" then ORDER_FOR_FOLEY=0;
  if CAUTI_LDA="Y" then CAUTI_LDA=1;
  if CAUTI_LDA="N" then CAUTI_LDA=0;
run;

data table1;
  set table1;
  CAUTI_Date = input(strip(CAUTI_Infection_date), MMDDYY10.);
  format CAUTI_Date DATE9.;
run;

data table4;
  set table1;
  admissionday = round(HOSP_DISCH_TIME-HOSP_ADMSN_TIME +1);
  CHG = CHG_NUMERATOR/CHG_DENOMINATOR*100;
  chg2 = CHG;
  if chg2 >= 100 then chg2=100;
  foleyday = intck('day',PLACEMENT_DATE, REMOVAL_DATE) +1;
  meatal = Meatal_Numerator/Meatal_Denominator*100;
  if meatal => 100 then meatal=100;
run;

proc freq data=table4;
  table CAUTI_LDA;
run;

proc means data=table4;
  var meatal chg2 foleyday;
run;
