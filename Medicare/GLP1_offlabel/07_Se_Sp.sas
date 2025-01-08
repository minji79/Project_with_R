
* MA claim ;

* PTCD_INDICATOR;
proc contents data=plan20.plan_char_2020;
  title "plan20.plan_char_2020";
run;

proc contents data=mbsf20.mbsf_abcd_summary_2020;
  title "mbsf20.mbsf_abcd_summary_2020";
run;

proc print data=mbsf20.mbsf_abcd_summary_2020 (obs=20);
  var BENE_ID PTC_CNTRCT_ID_01 PTC_PLAN_TYPE_CD_01;
  title "mbsf20.mbsf_abcd_summary_2020";
run;
