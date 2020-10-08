*-----------------*
Filename: read_beers2015

Description: This SAS macro reads in a dataset with all medications, flagged by class in the Beers Criteria from 2015.
			 Then, it reads in a file containing one row per medication and flags the Beers 2015 category of each.

Inputs:

	drugref_filepath: 	enter the path of the SAS dataset that contains all Beers flags and medication IDs (with quotes)
	drugref_filename: 	enter the name of the SAS dataset that contains all Beers flags and medication IDs (with quotes)
	drug_filepath: 		enter the path of the SAS dataset with one row per medication (no quotes)
	drug_filename: 		enter the name of the SAS dataset with one row per medication (no quotes)
	out_filepath: 		enter the path to where you want to save your flagged drug file, which will be called "beers_final" (with quotes)
	drugid_var: 		enter the name of the variable that identifies your drugid
	patid_var: 			enter the name of variable that identifies patient id in your drug file
	sex_flag: 			enter 1 if you do have a sex variable in your drug file, 0 if you do not
	sex_var: 			enter the name of the sex variable in your drug file. if it does not exist, leave blank
	female_value: 		enter the value of the sex variable that indicates female sex (include quotes if character). if it does not exist, leave blank

Created by Ashley I. Martinez, PharmD, PhD
January 24, 2018
*-----------------*;


%macro read_beers2015(drugref_filepath=
				, drugref_filename=
				, drug_filepath=
				, drug_filename=
				, out_filepath=
				, drugid_var=
				, patid_var=
				, sex_flag=
				, sex_var=
				, female_value=
				);


/* get two files into work directory */
libname beers &drugref_filepath.;
libname in &drug_filepath.;
libname out &out_filepath.;

data cat_flags; set beers.&drugref_filename.; run;
data testfile; set in.&drug_filename.; run;

/* flag the testfile */
proc sql;
	create table testfile_flags as
	select *
		, case when &drugid_var. in (select drugid from cat_flags where beers=1) then 1 else 0 end as beers
		, case when &drugid_var. in (select drugid from cat_flags where antihis=1) then 1 else 0 end as antihis
		, case when &drugid_var. in (select drugid from cat_flags where antipark=1) then 1 else 0 end as antipark
		, case when &drugid_var. in (select drugid from cat_flags where antispas=1) then 1 else 0 end as antispas
		, case when &drugid_var. in (select drugid from cat_flags where antithrom=1) then 1 else 0 end as antithrom
		, case when &drugid_var. in (select drugid from cat_flags where pa1b=1) then 1 else 0 end as pa1b
		, case when &drugid_var. in (select drugid from cat_flags where cab=1) then 1 else 0 end as cab
		, case when &drugid_var. in (select drugid from cat_flags where cv_othr=1) then 1 else 0 end as cv_othr
		, case when &drugid_var. in (select drugid from cat_flags where antidep=1) then 1 else 0 end as antidep
		, case when &drugid_var. in (select drugid from cat_flags where antipsy=1) then 1 else 0 end as antipsy
		, case when &drugid_var. in (select drugid from cat_flags where barb=1) then 1 else 0 end as barb
		, case when &drugid_var. in (select drugid from cat_flags where bzd=1) then 1 else 0 end as bzd
		, case when &drugid_var. in (select drugid from cat_flags where nbzd=1) then 1 else 0 end as nbzd
		, case when &drugid_var. in (select drugid from cat_flags where cns_othr=1) then 1 else 0 end as cns_othr
		, case when &drugid_var. in (select drugid from cat_flags where andro=1) then 1 else 0 end as andro
		, case when &drugid_var. in (select drugid from cat_flags where endo_othr=1) then 1 else 0 end as endo_othr
		, case when &drugid_var. in (select drugid from cat_flags where sulf=1) then 1 else 0 end as sulf
		, case when &drugid_var. in (select drugid from cat_flags where metoc=1) then 1 else 0 end as metoc
		, case when &drugid_var. in (select drugid from cat_flags where mineral=1) then 1 else 0 end as mineral
		, case when &drugid_var. in (select drugid from cat_flags where ppi=1) then 1 else 0 end as ppi
		, case when &drugid_var. in (select drugid from cat_flags where pain_othr=1) then 1 else 0 end as pain_othr
		, case when &drugid_var. in (select drugid from cat_flags where nsaid=1) then 1 else 0 end as nsaid
		, case when &drugid_var. in (select drugid from cat_flags where smr=1) then 1 else 0 end as smr
		, case when &drugid_var. in (select drugid from cat_flags where desmo=1) then 1 else 0 end as desmo
		, case when &drugid_var. in (select drugid from cat_flags where acei=1) then 1 else 0 end as acei
		, case when &drugid_var. in (select drugid from cat_flags where antichol=1) then 1 else 0 end as antichol
		, case when &drugid_var. in (select drugid from cat_flags where cns=1) then 1 else 0 end as cns
		, case when &drugid_var. in (select drugid from cat_flags where steroid=1) then 1 else 0 end as steroid
		, case when &drugid_var. in (select drugid from cat_flags where lith=1) then 1 else 0 end as lith
		, case when &drugid_var. in (select drugid from cat_flags where amil=1) then 1 else 0 end as amil
		, case when &drugid_var. in (select drugid from cat_flags where triam=1) then 1 else 0 end as triam
		, case when &drugid_var. in (select drugid from cat_flags where theo=1) then 1 else 0 end as theo
		, case when &drugid_var. in (select drugid from cat_flags where cimet=1) then 1 else 0 end as cimet
		, case when &drugid_var. in (select drugid from cat_flags where warf=1) then 1 else 0 end as warf
		, case when &drugid_var. in (select drugid from cat_flags where amio=1) then 1 else 0 end as amio
		, case when &drugid_var. in (select drugid from cat_flags where loop=1) then 1 else 0 end as loop
	from testfile;
quit;

/* count up categories by patient */
data counts; set testfile_flags;
	by &patid_var. ;
	if first.&patid_var. then do;
		beersct=0;
		antihisct=0;
		antiparkct=0;
		antispasct=0;
		antithromct=0;
		pa1bct=0;
		cabct=0;
		cv_othrct=0;
		antidepct=0;
		antipsyct=0;
		barbct=0;
		bzdct=0;
		nbzdct=0;
		cns_othrct=0;
		androct=0;
		endo_othrct=0;
		sulfct=0;
		metocct=0;
		mineralct=0;
		ppict=0;
		pain_othrct=0;
		nsaidct=0;
		smrct=0;
		desmoct=0;
		aceict=0;
		anticholct=0;
		cnsct=0;
		steroidct=0;
		lithct=0;
		amilct=0;
		triamct=0;
		theoct=0;
		cimetct=0;
		warfct=0;
		amioct=0;
		loopct=0;
	end;
	beersct+beers;
	antihisct+antihis;
	antiparkct+antipark;
	antispasct+antispas;
	antithromct+antithrom;
	pa1bct+pa1b;
	cabct+cab;
	cv_othrct+cv_othr;
	antidepct+antidep;
	antipsyct+antipsy;
	barbct+barb;
	bzdct+bzd;
	nbzdct+nbzd;
	cns_othrct+cns_othr;
	androct+andro;
	endo_othrct+endo_othr;
	sulfct+sulf;
	metocct+metoc;
	mineralct+mineral;
	ppict+ppi;
	pain_othrct+pain_othr;
	nsaidct+nsaid;
	smrct+smr;
	desmoct+desmo;
	aceict+acei;
	anticholct+antichol;
	cnsct+cns;
	steroidct+steroid;
	lithct+lith;
	amilct+amil;
	triamct+triam;
	theoct+theo;
	cimetct+cimet;
	warfct+warf;
	amioct+amio;
	loopct+loop;
run;

/* only keep one row per pt visit; already one "visit" per pt */
data counts2; set counts; 
	keep &patid_var. beersct--loopct;
run;

/* add back in each drug row */
data counts3;
	merge counts counts2;
	by &patid_var. ;
run;

/* flag interactions */
data inx; set counts3;
	by &patid_var. ;
inx_acei_amil=0;
	if (acei=1) and (acei>0 and amil>0) then inx_acei_amil=1;
inx_acei_triam=0;
	if (acei=1) and (acei>0 and triamct>0) then inx_acei_triam=1;
inx_ac_ac=0;
	if anticholct>1 then inx_ac_ac=1;
inx_cnsct=0;
	if cnsct>=3 then inx_cnsct=1;
inx_steroid_nsaid=0;
	if steroid=1 and (steroidct>0 and nsaidct>0) then inx_steroid_nsaid=1;
inx_lith_acei=0;
	if lith=1 and (lithct>0 and aceict>0) then inx_lith_acei=1;
inx_lith_loop=0;
	if lith=1 and (lithct>0 and loopct>0) then inx_lith_loop=1;
if &sex_flag. = 1 then do;
	inx_pa1b_loop=0;
	if pa1b=1 and (pa1bct>0 and loopct>0) and (&sex_var. = &female_value.) then inx_pa1b_loop=1;
end;
else if &sex_flag. = 0 then do;
	inx_pa1b_loop=0;
end;
inx_theo_cimet=0;
	if theo=1 and (theoct>0 and cimetct>0) then inx_theo_cimet=1;
inx_warf_amio=0;
	if warf=1 and (warfct>0 and amioct>0) then inx_warf_amio=1;
inx_warf_nsaid=0;
	if warf=1 and (warfct>0 and nsaidct>0) then inx_warf_nsaid=1;
inx=0;
	if inx_acei_amil=1 or inx_acei_triam=1 or inx_ac_ac>=1 or inx_cnsct>=1 or inx_steroid_nsaid=1 or inx_lith_acei=1 or inx_lith_loop=1
		or inx_pa1b_loop=1 or inx_theo_cimet=1 or inx_warf_amio=1 or inx_warf_nsaid=1
	then inx=1;
inx_cnsany=0;
	if cns=1 and inx=1 then inx_cnsany=1;
run;

data beers_final;
	set inx;
	by &patid_var.;
	if first.&patid_var. then do; 
		totalmeds = 0; inxct = 0; inx_cnsanyct = 0; 
	end;
	inxct + inx;
	inx_cnsanyct + inx_cnsany;
	totalmeds + 1;
	if last.&patid_var.;
run;

data beers_final1; set beers_final; keep &patid_var. beers--inx_cnsanyct; run;

data out.beers_final; set beers_final1; run;

%mend;
