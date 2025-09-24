%let path=~/Demo2025;
/**Path to the main directory (where Code and Output folders are located).**/
%let CodeFileName=Example;
/**No .sas extension included.
   Name of this file also becomes prefix for naming of code and
   output files**/
%let rc=%sysfunc(dlgcdir("&path/Output"));
/**Sets working directory to a subfolder
   named Output in the chosen path. Make
   sure this folder exists**/

ods noproctitle;/**Defaults to suppressing procedure titles**/
title;
footnote;/**Make sure no title or footnote statements linger**/
options nodate nonumber;/**No dates or numbering on output**/

proc template;
   define style styles.test;
     parent=styles.rtf;
     style body from document /
           leftmargin=1.55in
           rightmargin=1.55in;
   end;
run;

ods rtf
      file = "&CodeFileName.RawTables.rtf"
      style = styles.test;
ods tagsets.colorlatex 
      file = "&CodeFileName.RawTables.tex" (notop nobot)
      stylesheet = "SAS.sty"
      ;

/**"ProgramName" should also serve as the label in all
   LaTeX Program and Output boxes and in LSTLISTING and
   CFBT(ExecuteMetaData) references**/

ods select all;/**See Note 1 Below**/
proc odstext;
  p "TableRows=";/**If you want to limit output rows,
                    specify here. Blank produces the
                    full table**/
  p "%<*ReportEx>";
run;

*ReportEx.StartCode | Report Example;
proc report data=sashelp.cars;
  column origin type msrp;/*1*/
  define origin / group 'Origin';/*2*/
  define type / group;
  define msrp / mean/*3*/ format=dollar12.2/*4*/;
run;
*EndCode;

*%<*ReportEx.Enumerate>
1~The COLUMN statment chooses or defines columns.
2~DEFINE statements set roles and attributes for columns.
  GROUP acts like CLASS in MEANS, quoted text becomes
  the column label.
3~Stat keywords are available for numeric summaries,
    similar to MEANS.
4~Formats can be set with FORMAT= .
%</ReportEx.Enumerate>;

ods select all;/**See Note 1 Below**/
proc odstext;
  p "%</ReportEx>";
run;


ods rtf close;
ods tagsets.colorlatex close;

libname LaTeXSAS '~/LaTeXSAS';
options sasmstore=LaTeXSAS mstored;
/**Compiled versions of the cleaing macros are stored in
   this repository which is assigned as library with a matching libref.
   Default parameter settings given below should work**/ 
%ConvertCode(CodePath=&path/Code, SASCodeFile=&CodeFileName);
%OutputClean(OutputPath=&path/Output,OutputName=&CodeFileName);
