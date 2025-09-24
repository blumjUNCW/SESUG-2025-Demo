*Report Example;
proc report data=sashelp.cars;
  column origin type msrp;/*1*/
  define origin / group 'Origin';/*2*/
  define type / group;
  define msrp / mean/*3*/ format=dollar12.2/*4*/;
run;
 
* Call Out List
1~The COLUMN statment chooses or defines columns.
2~DEFINE statements set roles and attributes for columns.
  GROUP acts like CLASS in MEANS, quoted text becomes
  the column label.
3~Stat keywords are available for numeric summaries,
    similar to MEANS.
4~Formats can be set with FORMAT= .
;
 
