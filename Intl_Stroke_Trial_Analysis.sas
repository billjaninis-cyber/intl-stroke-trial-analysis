****import dataset***;
proc import out=work.Stroke
  datafile="/home/u64135940/ILE Intl Stroke Trial/DataIST.csv" 
  DBMS=csv replace;   
  getnames=yes;
run;

*Check dataset;
proc contents data=work.stroke;
run;

proc print data=work.stroke (obs=20);
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
array rdef{8} RDEF1 - RDEF8;

do i=1 to 8;
if rdef{i} = 'C' then rdef{i}  = '';
end;

*Variables coded Y/N/U where U = unknown;
array unknown{33} 

DASP14 DASPLT DLH14 DMH14 DSCH DIVH DAP DOAC DGORM
DSTER DCAA DHAEMD DCAREND DTHROMB DMAJNCH DSIDE
DDIAGISC DDIAGHA DDIAGUN DNOSTRK DRSISC
DRSH DRSUNK DPE DALIVE DDEAD DPLACE FPLACE FDEAD 
FRECOVER FDENNIS FAP FOAC;   

do i=1 to 33;
if unknown{i} = 'U' then unknown{i} = '';
end;

*Cause of death variables where 0 = unknown;
if DDEADC = 0 then DDEADC = .;
if FDEADC = 0 then FDEADC = .;

*Create numeric 6-month mortality variable;
if FDEAD = 'Y' then FDEAD_num = 1;
else if FDEAD = 'N' then FDEAD_num = 0;

*Recode pilot phase medium heparin (H) to main trial coding (M) to consolidate into single category;
if RXHEP = 'H' then RXHEP = 'M';

drop i;

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

ods output ParameterEstimates=adjusted_estimates OddsRatios=adjusted_oddsratios;

proc logistic data=stroke_clean descending;
class RXASP (ref='N') SEX(ref='M') RCONSC (ref='F') STYPE (ref='LACS') RATRIAL (ref='N') / param=ref;
model FDEAD_num(event='1') = RXASP AGE SEX RSBP RCONSC STYPE RATRIAL;
run;

ods output close;

***Interaction Models***;

*Interaction Model;

ods output ParameterEstimates=interaction_estimates;
    
proc logistic data=stroke_clean descending;
class RXASP (ref='N') SEX(ref='M') RCONSC (ref='F') STYPE (ref='LACS') RATRIAL (ref='N') / param=ref;
model FDEAD_num(event='1') = RXASP AGE SEX RSBP RCONSC STYPE RATRIAL RXASP*RATRIAL;
run;

ods output close;

*Macro for Stratified Model - Atrial fibrillation;

%macro af_model(af);

ods output
    ParameterEstimates=af_&af._estimates
    OddsRatios=af_&af._oddsratios;
    
proc logistic data=stroke_clean descending;
where RATRIAL = "&af";
class RXASP (ref='N') SEX(ref='M') RCONSC (ref='F') STYPE (ref='LACS') / param=ref;
model FDEAD_num(event='1') = RXASP AGE SEX RSBP RCONSC STYPE;
run;

ods output close;

%mend af_model;

%af_model(N); *No atrial fibrillation;
%af_model(Y); *Atrial fibrillation;