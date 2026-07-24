****import dataset***;
proc import out=work.Stroke
  datafile="/home/u64135940/ILE Intl Stroke Trial/DataIST.csv" 
  DBMS=csv replace;   
  getnames=yes;
run;

proc means data=work.stroke;
run;

***Accounting for missing observations***;
data stroke_clean;
set work.stroke;

*Numeric missing codes;
if HOURLOCAL   = 99 then HOURLOCAL = .;
if MINLOCAL    = 99 then MINLOCAL  = .;
if OCCODE      = 0  then OCCODE    = .;
else if OCCODE = 9  then OCCODE    = .;

*Baseline deficit variables Y/N/C where C = can't assess;
if RDEF1 = 'C' then RDEF1 = '';
if RDEF2 = 'C' then RDEF2 = '';
if RDEF3 = 'C' then RDEF3 = '';
if RDEF4 = 'C' then RDEF4 = '';
if RDEF5 = 'C' then RDEF5 = '';
if RDEF6 = 'C' then RDEF6 = '';
if RDEF7 = 'C' then RDEF7 = '';
if RDEF8 = 'C' then RDEF8 = '';

*14-day/discharge treatment variables: Y/N/U where U = unknown;
if DASP14   = 'U' then DASP14   = '';
if DASPLT   = 'U' then DASPLT   = '';
if DLH14    = 'U' then DLH14    = '';
if DMH14    = 'U' then DMH14    = '';
if DSCH     = 'U' then DSCH     = '';
if DIVH     = 'U' then DIVH     = '';
if DAP      = 'U' then DAP      = '';
if DOAC     = 'U' then DOAC     = '';
if DGORM    = 'U' then DGORM    = '';
if DSTER    = 'U' then DSTER    = '';
if DCAA     = 'U' then DCAA     = '';
if DHAEMD   = 'U' then DHAEMD   = '';
if DCAREND  = 'U' then DCAREND  = '';
if DTHROMB  = 'U' then DTHROMB  = '';
if DMAJNCH  = 'U' then DMAJNCH  = '';
if DSIDE    = 'U' then DSIDE    = '';

*Final Diagnosis variables: Y/N/U where U = unlknown;
if DDIAGISC = 'U' then DDIAGISC = '';
if DDIAGHA  = 'U' then DDIAGHA  = '';
if DDIAGUN  = 'U' then DDIAGUN  = '';
if DNOSTRK  = 'U' then DNOSTRK  = '';

*Recurrent Stroke within 14 days where Y/N/U where U = unknown;
if DRSISC   = 'U' then DRSISC   = '';
if DRSH     = 'U' then DRSH     = '';
if DRSUNK   = 'U' then DRSUNK   = '';

*Other events within 14 days: Y/N/U where U = unknown;
if DPE      = 'U' then DPE      = '';
if DALIVE   = 'U' then DALIVE   = '';
if DDEAD    = 'U' then DDEAD    = '';

*Discharge destination / follow-up residence where U = unknown;
if DPLACE   = 'U' then DPLACE   = '';
if FPLACE   = 'U' then FPLACE   = '';

*6-month follow-up variables: Y/N/U where U = unknown;
if FDEAD    = 'U' then FDEAD    = '';
if FRECOVER = 'U' then FRECOVER = '';
if FDENNIS  = 'U' then FDENNIS  = '';
if FAP      = 'U' then FAP      = '';
if FOAC     = 'U' then FOAC     = '';

*Cause of death variables where 0 = unknown;
if DDEADC = 0 then DDEADC = .;
if FDEADC = 0 then FDEADC = .;

*Create numeric 6-month mortality variable;
if FDEAD = 'Y' then FDEAD_num = 1;
else if FDEAD = 'N' then FDEAD_num = 0;

*Recode pilot phase medium heparin (H) to main trial coding (M) to consolidate into single category;
if RXHEP = 'H' then RXHEP = 'M';

run;

***QC checks post data step***;

*Confirm RXHEP has only 3 levels (N, L, M) with no H remaining;
proc freq data=stroke_clean;
tables RXHEP;
run;

*Confirm FDEAD_num is binary with no unexpected values;
proc freq data=stroke_clean;
tables FDEAD_num FDEAD*FDEAD_num / nocum;
run;

*Confirm missing handling - check key analysis variables for missing counts;
proc means data=stroke_clean nmiss;
var AGE RSBP FDEAD_num;
run;

proc freq data=stroke_clean;
tables RXASP RATRIAL RCONSC STYPE SEX / missing nocum;
run;

*Confirm RATRIAL missingness;
proc freq data=stroke_clean;
tables RATRIAL / missing nocum;
run;

***Descriptive statistics***;

*Continuous Variables;
proc means data=stroke_clean maxdec=2 n mean std;
class RXASP;
var AGE RSBP;
run;

*Categorical Variables;
proc freq data=stroke_clean;
tables RXASP*(SEX RCONSC STYPE RXHEP RATRIAL FDEAD_num) / nocol nopercent;
run;

proc freq data=stroke_clean;
tables RXASP*RATRIAL / chisq;
run;

***Regression Models***;

*Crude logistic regression model;
proc logistic data=stroke_clean descending;
where SEX NE '' and RCONSC NE '' and STYPE NE '' and RATRIAL NE '' and AGE NE . and RSBP NE .;
class RXASP (ref='N') / param=ref;
model FDEAD_num(event='1') = RXASP;
run;

*Multivariable logistic regression model;
proc logistic data=stroke_clean descending;
class RXASP (ref='N') SEX(ref='M') RCONSC (ref='F') STYPE (ref='LACS') RATRIAL (ref='N') / param=ref;
model FDEAD_num(event='1') = RXASP AGE SEX RSBP RCONSC STYPE RATRIAL;
run;

***Interaction Models***;

*Interaction Model;
proc logistic data=stroke_clean descending;
class RXASP (ref='N') SEX(ref='M') RCONSC (ref='F') STYPE (ref='LACS') RATRIAL (ref='N') / param=ref;
model FDEAD_num(event='1') = RXASP AGE SEX RSBP RCONSC STYPE RATRIAL RXASP*RATRIAL;
run;

*Stratified model - No atrial fibrillation;
proc logistic data=stroke_clean descending;
where RATRIAL = 'N';
class RXASP (ref='N') SEX(ref='M') RCONSC (ref='F') STYPE (ref='LACS') / param=ref;
model FDEAD_num(event='1') = RXASP AGE SEX RSBP RCONSC STYPE;
run;

*Stratified model - Atrial fibrillation;
proc logistic data=stroke_clean descending;
where RATRIAL = 'Y';
class RXASP (ref='N') SEX(ref='M') RCONSC (ref='F') STYPE (ref='LACS') / param=ref;
model FDEAD_num(event='1') = RXASP AGE SEX RSBP RCONSC STYPE;
run;