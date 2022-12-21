* Encoding: UTF-8.
*Introduction to SPSS software.
*This is how you write a comment in SPSS.

*Setting the working directory.

cd "C:\Users\LAB PC\Desktop\SPSS Files".

GET
  FILE='HLTH1025_2016.sav'.

DATASET NAME HLTH1025_2016 window=front.

*/compressed - data file to save some space.

SAVE
 OUTFILE = "HLTH1025_2016.sav"/COMPRESSED.

*Inspecting my data. - 1. codebook ; 2. display ; 3. dictionary



DATASET ACTIVATE DataSet1.
CODEBOOK  IDnumber [s] age [s] sex [n] workstat [n] increg [n] incmnth [s] incwk [s] housing [n] 
    living [n] homepay [n] homecost [s] homecostwk [s] mobile [n] mobilepay [n] mobilecost [s] 
    mobilecostwk [s] transport [s] food [s] entertain [s] privhlth [n] fs_illness [n] fs_accident [n] 
    fs_death [n] fs_mtlillness [n] fs_disability [n] fs_divsep [n] fs_nogetjob [n] fs_lossofjob [n] 
    fs_alcdrug [n] fs_witviol [n] fs_absvcrim [n] fs_police [n] fs_gambling [n] famstress [n] drivelic 
    [n] mvacc [n] mvaccinj [n] smokeyn [n] smokereg [n] smokestat [n] suffact [n] veg [s] fruit [s] 
    medication [n] sf1 [n] height [s] weight [s] asthma [n] cancer [n] cvcondition [n] arthritis [n] 
    osteop [n] diabetes [n] mtlstress [n] anxiety [n] depress [n] mtlother [n] mntlcond [n] mntlcurr [n]    
  /VARINFO POSITION LABEL TYPE FORMAT MEASURE ROLE VALUELABELS MISSING ATTRIBUTES
  /OPTIONS VARORDER=VARLIST SORT=ASCENDING MAXCATS=200
  /STATISTICS COUNT PERCENT MEAN STDDEV QUARTILES.

display DICTIONARY.

VARIABLE LABELS sex Sex of respondent.

VALUE LABELS sex 1 'Male' 2 'Female'.

*sorting the data

SORT CASES by sex(A).

SORT CASES by housing(D).

*Merging

GET
  FILE='HLTH1025-2016-yr.sav'.
DATASET NAME HLTH1025_2016_yr window=front.

DATASET ACTIVATE HTLH1025_2016.
SORT CASES by IDnumber(A).

DATASET ACTIVATE HLTH1025_2016_yr.
SORT CASES by IDnumber(A).

*Merging - sorted dataset

DATASET ACTIVATE HTLH1025_2016.

*Describing the data

FREQUENCIES smokestat.

DESCRIPTIVES age.



DATASET ACTIVATE HLTH1025_2016_yr.
CROSSTABS
  /TABLES=sex BY smokestat
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT ROW COLUMN TOTAL 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=sex BY smokestat
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN TOTAL 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=sex BY smokestat
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ CORR RISK 
  /CELLS=COUNT ROW COLUMN TOTAL 
  /COUNT ROUND CELL.

EXAMINE VARIABLES=age BY smokestat
  /PLOT BOXPLOT STEMLEAF
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

BAYES ANOVA age BY smokestat
  /CRITERIA CILEVEL=95
  /INFERENCE ANALYSIS=POSTERIOR
  /PRIOR TYPE=REFERENCE
  /PLOT ERRORVAR=FALSE.



DATASET ACTIVATE HLTH1025_2016_yr.
CORRELATIONS
  /VARIABLES=height weight
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*TRY - BIVARIATE - 1. One Tailed
*TRY - 1.Contingency coeff  2. Gamma

CORRELATIONS
  /VARIABLES=height weight
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
NONPAR CORR
  /VARIABLES=height weight
  /PRINT=BOTH TWOTAIL NOSIG
  /MISSING=PAIRWISE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT smokestat
  /METHOD=ENTER age.

STATS REGRESS PLOT YVARS=age XVARS=smokestat 
/OPTIONS CATEGORICAL=BARS GROUP=1 BOXPLOTS INDENT=15 YSCALE=75 
/FITLINES APPLYTO=TOTAL.

*MODIFY the DATA-Compute

COMPUTE height = height/100.
EXECUTE.

COMPUTE bmi  = weight/height**2.
EXECUTE.

*Recode

Recode bmi (SYSMIS = SYSMIS)
(lowest thru 18.499999=1) (18.5 thru 24.99999=2) (25.0 thru 29.99999=3)
(30 thru Highest=4) into bmicat.
EXECUTE.


