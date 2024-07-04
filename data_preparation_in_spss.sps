* Encoding: UTF-8.

###########################################
#
# TABLE OF CONTENTS
# 1. Get data
# 2. Merge datasets
# 3. Manage data/create variables
#

# Initial data preparation in SPSS



### 1. Get data ----

# Get "PISA-TREE_2000_Version_2016.sav" dataset 

GET
  FILE='C:\Users\kaspa\Documents\TREE\TREE data release 2017\PISA-TREE_2000_Version_2016.sav'.



### 2. Merge datasets ----
    
# Merge the following datasets
    # PISA-TREE_2000_Version_2016.sav
    # 816_TREE_Data_C1_wave-1-2001_version_2016_DE_v1.sav
    # 816_TREE_Data_C1_wave-2-2002_version_2016_DE_v1.sav
    # 816_TREE_Data_C1_wave-3-2003_version_2016_DE_v1.sav
    # 816_TREE_Data_C1_wave-4-2004_version_2016_DE_v1.sav
    # 816_TREE_Data_C1_wave-5-2005_version_2016_DE_v1.sav
    # 816_TREE_Data_C1_wave-6-2006_version_2016_DE_v1.sav
    # 816_TREE_Data_C1_wave-7-2007_version_2016_DE_v1.sav
    # 816_TREE_Data_C1_wave-8-2010_version_2016_DE_v1.sav
    # 816_TREE_Data_C1_wave-9-2014_version_2016_DE_v1.sav
    
# ...using the following code which exemplifies how to merge two datasets; repeat until all datasets are merged

DATASET NAME DataSet1.
GET FILE='C:\Users\kaspa\Documents\TREE\TREE data release '+
    '2017\816_TREE_Data_C1_wave-1-2001_version_2016_DE_v1.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY id school student.
DATASET ACTIVATE DataSet2.
SORT CASES BY id school student.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY id school student.
EXECUTE.

# Save the newly created datasets; give the resulting final, merged, dataset a label: "PISATREEw1-9.sav"



### 3. Manage data/create variables ----
    
# Create a measure of educational activity at each wave
    # 0=vocational education, 1=academic education [prepares for university, vocational baccalaureate not included], 2=other [that is, additional school year, internship, language stay / au-pair, other type of education, NEET], 99=missing 

DATASET ACTIVATE DataSet1.
RECODE t1educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t1educ3conservative.
VARIABLE LABELS  t1educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

RECODE t2educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t2educ3conservative.
VARIABLE LABELS  t2educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

RECODE t3educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t3educ3conservative.
VARIABLE LABELS  t3educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

RECODE t4educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t4educ3conservative.
VARIABLE LABELS  t4educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

RECODE t5educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t5educ3conservative.
VARIABLE LABELS  t5educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

RECODE t6educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t6educ3conservative.
VARIABLE LABELS  t6educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

RECODE t7educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t7educ3conservative.
VARIABLE LABELS  t7educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

RECODE t8educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t8educ3conservative.
VARIABLE LABELS  t8educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

RECODE t9educ22 (1=2) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=1) (9 thru 14=0) (15=0) (16 thru 18=1) (19 thru 22=2) 
(90=2) (-1=99) (ELSE=Copy) INTO t9educ3conservative.
VARIABLE LABELS  t9educ3conservative 'vocational education: 0, academic education, conservative/preparation for Univ. or ETH: 1, other: 2'.
EXECUTE.

# Recode the educational activity measure to assess whether a participant has been enrolled at a university at t4, t5, t6, t7, t8, and/or t9: yes (1) or no (0):
    # 0=not enrolled at a university/ETH, 1=enrolled at a university/ETH, 99=missing 

DATASET ACTIVATE DataSet1.
RECODE t4educ22 (1 thru 15=0) (16 thru 18=1) (19 thru 22=0) (90=0) (-1=99) (ELSE=Copy) INTO t4educUniv.
VARIABLE LABELS  t4educUniv 'not enrolled at a university/ETH=0, enrolled at a Univ./ETH=1, missing=99'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE t5educ22 (1 thru 15=0) (16 thru 18=1) (19 thru 22=0) (90=0) (-1=99) (ELSE=Copy) INTO t5educUniv.
VARIABLE LABELS  t5educUniv 'not enrolled at a university/ETH=0, enrolled at a Univ./ETH=1, missing=99'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE t6educ22 (1 thru 15=0) (16 thru 18=1) (19 thru 22=0) (90=0) (-1=99) (ELSE=Copy) INTO t6educUniv.
VARIABLE LABELS  t6educUniv 'not enrolled at a university/ETH=0, enrolled at a Univ./ETH=1, missing=99'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE t7educ22 (1 thru 15=0) (16 thru 18=1) (19 thru 22=0) (90=0) (-1=99) (ELSE=Copy) INTO t7educUniv.
VARIABLE LABELS  t7educUniv 'not enrolled at a university/ETH=0, enrolled at a Univ./ETH=1, missing=99'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE t8educ22 (1 thru 15=0) (16 thru 18=1) (19 thru 22=0) (90=0) (-1=99) (ELSE=Copy) INTO t8educUniv.
VARIABLE LABELS  t8educUniv 'not enrolled at a university/ETH=0, enrolled at a Univ./ETH=1, missing=99'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE t9educ22 (1 thru 15=0) (16 thru 18=1) (19 thru 22=0) (90=0) (-1=99) (ELSE=Copy) INTO t9educUniv.
VARIABLE LABELS  t9educUniv 'not enrolled at a university/ETH=0, enrolled at a Univ./ETH=1, missing=99'.
EXECUTE.

#  Compute an indicator of whether a participant has ever been enrolled at Univ./ETH between t4 and t9 

COMPUTE University_t4_9=ANY(1, t4educUniv TO t9educUniv).
EXECUTE.

# Create dummy variables for lower-secondary education tracks
    # Version (1): When using the following coding, leave out the last, "notracking", variable in the regression 

DATASET ACTIVATE DataSet1.
RECODE typ (1=1) (MISSING=SYSMIS) (2 thru 4=0) INTO hightrack.
VARIABLE LABELS  hightrack 'pre-gymnasial (ref. group: no tracking)'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE typ (2=1) (MISSING=SYSMIS) (1=0) (3 thru 4=0) INTO intermediatetrack.
VARIABLE LABELS  intermediatetrack 'intermediate / extended acad. requirements (ref. group: no tracking)'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE typ (3=1) (1 thru 2=0) (4=0) (MISSING=SYSMIS) INTO lowtrack.
VARIABLE LABELS  lowtrack 'low track / basic acad. requirements (ref. group: no tracking)'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE typ (4=1) (1 thru 3=0) (MISSING=SYSMIS) INTO notracking.
VARIABLE LABELS  notracking 'no (formal) tracking'.
EXECUTE.

# Create dummy variables for lower-secondary-education school type: reference group "no (formal) tracking"
    # Version (2): when using this coding scheme, enter all four dummy variables in the regression 

DATASET ACTIVATE DataSet1.
RECODE typ (1=1) (MISSING=SYSMIS) (2 thru 4=0) INTO hightrack.
VARIABLE LABELS  hightrack 'pre-gymnasial (ref. group: "no (formal) tracking")'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE typ (2=1) (MISSING=SYSMIS) (1=0) (3 thru 4=0) INTO intermediatetrack.
VARIABLE LABELS  intermediatetrack 'intermediate track / extended acad. requirements (ref. group: "no (formal) tracking")'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE typ (3=1) (1 thru 2=0) (4=0) (MISSING=SYSMIS) INTO lowtrack.
VARIABLE LABELS  lowtrack 'low track / basic acad. requirements (ref. group: "no (formal) tracking")'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE typ (1 thru 4=0) (MISSING=SYSMIS) INTO notracking.
VARIABLE LABELS  notracking 'no (formal) tracking (dummy)'.
EXECUTE.

# Create dummy variables for upper-secondary education type (vocational, academic, other) based on t1educ3conservative-t9educ3conservative

DATASET ACTIVATE DataSet1.
RECODE t2educ3conservative (0=1) (1 thru 2=0) (99=99) INTO t2vocedu.
VARIABLE LABELS  t2vocedu 't2 vocational education (ref. cat.: other educ. activity)'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE t2educ3conservative (1=1) (0=0) (2=0) (99=99) INTO t2acadedu.
VARIABLE LABELS  t2acadedu 't2 academic education (ref. cat.: other educ. activity)'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE t2educ3conservative (2=1) (0=0) (1=0) (99=99) INTO t2otheredu.
VARIABLE LABELS  t2otheredu 't2 other educational activity: zusätzliches Schuljahr, Praktikum, Sprachaufenthalt/Au-Pair, Vorkurs/-schule, andere Ausbildung, keine Ausbildung (dummy)'.
EXECUTE.

# Create indicators to measure  immigrant status, sex, and age in years

DATASET ACTIVATE DataSet1.
RECODE st16q01 (1=0) (2=1) (7 thru 9=SYSMIS) (SYSMIS=SYSMIS) INTO immig.
VARIABLE LABELS  immig '1st generation immigrant (born abroad)'.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE sex (1=0) (2=1) INTO sex01.
VARIABLE LABELS  sex01 'sex (0=female, 1=male)'.
EXECUTE.

DATASET ACTIVATE DataSet1.
COMPUTE age_y=age / 12.
EXECUTE.

# Create indicator of parental involvement

DATASET ACTIVATE DataSet1.
COMPUTE parinvol=MEAN(st20q01, st20q02).
EXECUTE.

# Recode typ variable to distinguish lower-secondary school tracks in one indicator

DATASET ACTIVATE DataSet1.
RECODE typ (4=1) (1=2) (2=3) (3=4) INTO typ_r.
VARIABLE LABELS  typ_r 'lower secondary track_recoded (1 = non-tracked, 2 = high track, 3 = '+
    'intermediate track, 4 = low track)'.
EXECUTE.

# Generate dataset with valid information on University_t4_9

DATASET COPY  PISATREE_as.
DATASET ACTIVATE  PISATREE_as.
FILTER OFF.
USE ALL.
SELECT IF (University_t4_9 = 0 | University_t4_9 = 1).
EXECUTE.
DATASET ACTIVATE  DataSet1.

# Subsetting variables/creating a working file 

DATASET ACTIVATE DataSet1.
SAVE OUTFILE='C:\Users\burkas\Mes documents\TREE\TREE full merged dataset (release 2017)\PISATREE_2.sav'
    /KEEP id hisei bthr immig sex01 age_y typ_r t2vocedu t2acadedu t2otheredu hightrack intermediatetrack lowtrack 
    notracking wleread parinvol t2clis1 t2clis2 t2clis3
/COMPRESSED.




