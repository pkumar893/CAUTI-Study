/* cap input rows for the captured run */
options obs=100;

/* Bundle setup: mock foley-episode records (one row per catheter
   placement within a hospital admission) supplying the columns the
   BY-group counting logic below reads. */
data table8;
  infile datalines dsd truncover;
  input PAT_MRN_ID HOSP_ADMSN_TIME PLACEMENT_DATE REMOVAL_DATE CAUTI_LDA2;
  format PLACEMENT_DATE REMOVAL_DATE date9.;
  datalines;
1001,23010,23011,23013,0
1001,23010,23016,23018,0
1001,23010,23025,23027,1
1002,23020,23021,23024,0
1002,23020,23025,23028,0
1003,23040,23041,23043,0
;
run;
