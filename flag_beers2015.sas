*-----------------*
Filename: flag_beers2015

Description: This SAS macro takes in a patient-level dataset with medication information and identifies the number of medications
			 that are included in Beers Criteria 2015. The input dataset must be "wide," with one row per patient and one column 
			 per medication.

Inputs:
			inpath:			enter the path of the SAS dataset with one row per patient (with quotes)
			infile:			enter the name of the SAS dataset with one row per patient (no quotes)
			outpath:		enter the path to where you want to save your flagged drug file (with quotes)
			maxdrugs: 		enter the maximum number of drugs in a row (i.e. x, where columns are Drug1-Drugx)
			schizo_var:		enter the variable name that flags the presence of schizophrenia with a 1/0
			bipol_var:		enter the variable name that flags the presence of bipolar disorder with a 1/0
			chf_var:		enter the variable name that flags the presence of CHF with a 1/0
			sz_var:			enter the variable name that flags the presence of seizure disorder with a 1/0
			dmta_var:		enter the variable name that flags the presence of dementia with a 1/0
			insom_var:		enter the variable name that flags the presence of insomnia with a 1/0
			pd_var:			enter the variable name that flags the presence of Parkinson's disease with a 1/0
			sex_var:		enter the variable name that flags sex with a 2 for female
			incontu_var:	enter the variable name that flags the presence of urinary incontinence with a 1/0

Output:
			This SAS macro outputs a dataset called "beers_final" that includes all the variables from the input dataset, a
			variable for each medication category delineated in Beers Criteria 2015, and the following summary variables:
				beers_pim:	A count of the number of medications from the input dataset that are in Beers Criteria 2015 (PIMs)
				beers_ddzi: A count of the number of drug-disease interactions from Beers Criteria 2015
				beers_ddi: A count of the number of drug-drug interactions from Beers Criteria 2015
				beers_total: A count of the total number of PIMs, drug-disease, and drug-drug interactions from Beers Criteria 2015
				beers_any: 	A flag for any medication that meets Beers Criteria 2015

Created by Ashley I. Martinez, PharmD, PhD
January 24, 2018

*-----------------*;

%macro flag_beers2015(inpath=
				, infile=
				, outpath=
				, maxdrugs=
				, schizo_var=
				, bipol_var=
				, chf_var=
				, sz_var=
				, dmta_var=
				, insom_var=
				, pd_var=
				, sex_var=
				, incontu_var=
				);


/* get two files into work directory */
libname in &inpath.;
libname out &outpath.;

/* now create drug group variables */
data nacc_drugs; set in.&infile.;
	antihis=0;
	array medss {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if medss(i) in ("BROMPHENIRAINE" "CARBINOXAMINE" "CHLORPHENIRAMINE" "CLEMASTINE" "CYPROHEPTADINE" "DEXBROMPHENIRAMINE" "DEXCHLORPHENIRAMINE" 
			"DIMENHYDRINATE" "DIPHENHYDRAMINE" "DOXYLAMINE" "HYDROXYZINE" "MECLIZINE" "PROMETHAZINE" "TRIPROLIDINE")
		then antihis=1;
	end;
	antidep=0;
	array meds2 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds2(i) in ("AMITRIPTYLINE" "AMOXAPINE" "CLOMIPRAMINE" "DESIPRAMINE" "DOXEPIN" "IMIPRAMINE" "NORTRIPTYLINE" "PAROXETINE" "PROTRIPTYLINE" "TRIMIPRAMINE")
		then antidep=1;
	end;
	antipsy_chol=0;
	array meds3 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds3(i) in ("CHLORPROMAZINE" "CLOZAPINE" "LOXAPINE" "OLANZAPINE" "PERPHENAZINE" "THIORIDAZINE" "TRIFLUOPERAZINE")
		then antipsy_chol=1;
	end;
	bam=0;
	array meds4 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds4(i) in ("DARIFENACIN" "FESOTERODINE" "FLAVOXATE" "OXYBUTYNIN" "SOLIFENACIN" "TOLTERODINE" "TROSPIUM")
		then bam=1;
	end;
	antispas=0;
	array meds5 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds5(i) in ("ATROPINE" "BELLADONNA" "CLIDINIUM-CHLORDIAZEPOXIDE" "DICYCLOMINE" "HOMATROPINE" "HYOSCYAINE" "PROPANTHELINE" "SCOPOLAMINE")
		then antispas=1;
	end;
	aed=0;
	array meds6 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds6(i) in ("ACETAZOLAMIDE" "BIVARACETAM" "CARBAMAZEPINE" "CLOBAZAM" "CLONAZEPAM" "DIAZEPAM" "DIVALPROEX SODIUM" "ESLICARBAZEPINE" "ETHOSUXIMIDE" 
			"ETHOTOIN" "EZOGABINE" "FELBAMATE" "FOSPHENYTOIN" "GABAPENTIN" "LACOSAMIDE" "LAMOTRIGINE" "LEVETIRACETAM" "LORAZEPAM" "MEPHOBARBITAL" "OXCARBAZEPINE" 
			"PERAMPANEL" "PHENOBARBITAL" "PHENYTOIN" "PREGABALIN" "PRIMIDONE" "RUFINAMIDE" "TIAGABINE" "TRIMETHADIONE" "TOPIRAMATE" "VALPROIC ACID" "VIGABATRIN" "ZONISAMIDE")
		then aed=1;
	end;
	achei=0;
	array meds7 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds7(i) in ("DONEPEZIL" "GALANTAMINE" "RIVASTIGMINE" "TACRINE")
		then achei=1;
	end;
	barb=0;
	array meds8 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds8(i) in ("AMOBARBITAL" "BUTABARBITAL" "BUTALBITAL" "MEPHOBARBITAL" "PENTOBARBITAL" "PHENOBARBITAL" "SECOBARBITAL")
		then barb=1;
	end;
	bzd=0;
	array meds9 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds9(i) in ("ALPRAZOLAM" "CHLORDIAZEPOXIDE" "CLOBAZAM" "CLONAZEPAM" "CLORAZEPATE" "DIAZEPAM" "ESTAZOLAM" "FLURAZEPAM" 
			"LORAZEPAM" "MIDAZOLAM" "OXAZEPAM" "QUAZEPAM" "TEMAZEPAM" "TRIAZOLAM")
		then bzd=1;
	end;
	cab=0;
	array meds10 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds10(i) in ("CLONIDINE" "GUANABENZ" "GUANFACINE" "METHYLDOPA" "RESERPINE")
		then cab=1;
	end;
	ster=0;
	array meds11 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds11(i) in ("CORTISONE" "DEXAMETHASONE" "HYDROCORTISONE" "METHYLPREDNISOLONE" "PREDNISOLONE" "PREDNISONE")
		then ster=1;
	end;
	h2ra=0;
	array meds12 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds12(i) in ("CIMETIDINE" "FAMOTIDINE" "NIZATIDINE" "RANITIDINE")
		then h2ra=1;
	end;
	opioid=0;
	array meds13 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds13(i) in ("ALFENTANIL" "BUPRENORPHINE" "BUTORPHANOL" "CODEINE" "FENTANYL" "HYDROCODONE" "HYDROMORPHONE" "LEVORPHANOL" 
			"MEPERIDINE" "METHADONE" "MORPHINE" "NALBUPHINE" "OPIUM" "OXYCODONE" "OXYMORPHONE" "PENTAZOCINE" "REMIFENTANIL" 
			"SUFENTANIL" "TAPENTADOL" "TRAMADOL")
		then opioid=1;
	end;
	ppi=0;
	array meds14 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds14(i) in ("DEXLANSOPRAZOLE" "ESOMEPRAZOLE" "LANSOPRAZOLE" "OMEPRAZOLE" "PANTOPRAZOLE" "RABEPRAZOLE")
		then ppi=1;
	end;
	smr2=0;
	array meds15 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds15(i) in ("CARISOPRODOL" "CHLORZOXAZONE" "CYCLOBENZAPRINE" "METAXALONE" "METHOCARBAMOL" "ORPHENADRINE")
		then smr2=1;
	end;
	ssri=0;
	array meds16 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds16(i) in ("CITALOPRAM" "ESCITALOPRAM" "FLUOXETINE" "FLUVOXAMINE" "PAROXETINE" "SERTRALINE")
		then ssri=1;
	end;
	tca=0;
	array meds17 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds17(i) in ("AMITRIPTYLINE" "CLOMIPRAMINE" "IMIPRAMINE" "TRIMIPRAMINE" "DOXEPIN")
		then tca=1;
	end;
	zdrug=0;
	array meds18 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds18(i) in ("ESZOPICLONE" "ZOLPIDEM" "ZALEPLON")
		then zdrug=1;
	end;
	pa1b=0;
	array meds19 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds19(i) in ("DOXAZOSIN" "PRAZOSIN" "TERAZOSIN")
		then pa1b=1;
	end;
	loop=0;
	array meds20 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds20(i) in ("BUMETANIDE" "ETHACRYNIC ACID" "FUROSEMIDE" "TORSEMIDE")
		then loop=1;
	end;
	cox2=0;
	array meds21 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds21(i) in ("CELECOXIB" "ROFECOXIB" "VALDECOXIB")
		then cox2=1;
	end;
	antipark=0;
	array meds22 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds22(i) in ("BENZTROPINE" "TRIHEXYPHENIDYL")
		then antipark=1;
	end;
	dipyridamole=0;
	array meds23 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds23(i) in ("DIPYRIDAMOLE")
		then dipyridamole=1;
	end;
	ticlodipine=0;
	array meds24 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds24(i) in ("TICLODIPINE")
		then ticlodipine=1;
	end;
	nitrofurantoin=0;
	array meds25 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds25(i) in ("NITROFURANTOIN")
		then nitrofurantoin=1;
	end;
	disopyramide=0;
	array meds26 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds26(i) in ("DISOPYRAMIDE")
		then disopyramide=1;
	end;
	dronedarone=0;
	array meds27 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds27(i) in ("DRONEDARONE")
		then dronedarone=1;
	end;
	digoxin=0;
	array meds28 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds28(i) in ("DIGOXIN")
		then digoxin=1;
	end;
	amiodarone=0;
	array meds29 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds29(i) in ("AMIODARONE")
		then amiodarone=1;
	end;
	meprobamate=0;
	array meds30 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds30(i) in ("MEPROBAMATE")
		then meprobamate=1;
	end;
	ergot=0;
	array meds31 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds31(i) in ("ERGOT")
		then ergot=1;
	end;
	isoxsuprine=0;
	array meds32 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds32(i) in ("ISOXSUPRINE")
		then isoxsuprine=1;
	end;
	testos=0;
	array meds33 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds33(i) in ("TESTOSTERONE" "METHYLTESTOSTERONE")
		then testos=1;
	end;
	thyroid=0;
	array meds34 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds34(i) in ("DESSICATED THYROID")
		then thyroid=1;
	end;
	megestrol=0;
	array meds35 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds35(i) in ("MEGESTROL")
		then megestrol=1;
	end;
	chlorpropamide=0;
	array meds36 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds36(i) in ("CHLORPROPAMIDE")
		then chlorpropamide=1;
	end;
	glyburide=0;
	array meds37 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds37(i) in ("GLYBURIDE")
		then glyburide=1;
	end;
	metoclopramide=0;
	array meds38 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds38(i) in ("METOCLOPRAMIDE")
		then metoclopramide=1;
	end;
	meperidine=0;
	array meds39 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds39(i) in ("MEPERIDINE")
		then meperidine=1;
	end;
	pentazocine=0;
	array meds&maxdrugs. {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds&maxdrugs.(i) in ("PENTAZOCINE")
		then pentazocine=1;
	end;
	desmopressin=0;
	array meds41 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds41(i) in ("DESMOPRESSIN")
		then desmopressin=1;
	end;
	ndhpccb=0;
	array meds42 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds42(i) in ("VERAPAMIL" "DILTIAZEM")
		then ndhpccb=1;
	end;
	tzd=0;
	array meds43 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds43(i) in ("ROSIGLITAZONE" "PIOGLITAZONE")
		then tzd=1;
	end;
	cilostazol=0;
	array meds44 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds44(i) in ("CILOSTAZOL")
		then cilostazol=1;
	end;
	bupropion=0;
	array meds45 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds45(i) in ("BUPROPION")
		then bupropion=1;
	end;
	chlorpromazine=0;
	array meds46 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds46(i) in ("CHLORPROMAZINE")
		then chlorpromazine=1;
	end;
	clozapine=0;
	array meds47 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds47(i) in ("CLOZAPINE")
		then clozapine=1;
	end;
	maprotiline=0;
	array meds48 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds48(i) in ("MAPROTILINE")
		then maprotiline=1;
	end;
	
	olanzapine=0;
	array meds49 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds49(i) in ("OLANZAPINE")
		then olanzapine=1;
	end;
	amphetamine=0;
	array meds50 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds50(i) in ("AMPHETAMINE")
		then amphetamine=1;
	end;
	asenapine=0;
	array meds51 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds51(i) in ("ASENAPINE")
		then asenapine=1;
	end;
	caffeine=0;
	array meds52 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds52(i) in ("CAFFEINE")
		then caffeine=1;
	end;
	fluphenazine=0;
	array meds53 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds53(i) in ("FLUPHENAZINE")
		then fluphenazine=1;
	end;
	haloperidol=0;
	array meds54 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds54(i) in ("HALOPERIDOL")
		then haloperidol=1;
	end;
	iloperidone=0;
	array meds55 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds55(i) in ("ILOPERIDONE")
		then iloperidone=1;
	end;
	loxapine=0;
	array meds56 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds56(i) in ("LOXAPINE")
		then loxapine=1;
	end;
	lurasidone=0;
	array meds57 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds57(i) in ("LURASIDONE")
		then lurasidone=1;
	end;
	maprotiline=0;
	array meds58 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds58(i) in ("MAPROTILINE")
		then maprotiline=1;
		end;
	methylphenidate=0;
		array meds59 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds59(i) in ("METHYLPHENIDATE")
			then methylphenidate=1;
		end;
	metoclopramide=0;
		array meds60 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds60(i) in ("METOCLOPRAMIDE")
			then metoclopramide=1;
		end;
	modafinil=0;
		array meds61 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds61(i) in ("MODAFINIL")
			then modafinil=1;
		end;
	paliperidone=0;
		array meds62 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds62(i) in ("PALIPERIDONE")
			then paliperidone=1;
		end;
	perphenazine=0;
		array meds63 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds63(i) in ("PERPHENAZINE")
			then perphenazine=1;
		end;
	phenylephrine=0;
		array meds64 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds64(i) in ("PHENYLEPHRINE")
			then phenylephrine=1;
		end;
	pimozide=0;
		array meds65 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds65(i) in ("PIMOZIDE")
			then pimozide=1;
		end;
	prochlorperazine=0;
		array meds66 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds66(i) in ("PROCHLORPERAZINE")
			then prochlorperazine=1;
		end;
	promethazine=0;
		array meds67 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds67(i) in ("PROMETHAZINE")
			then promethazine=1;
		end;
	pseudoephedrine=0;
		array meds68 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds68(i) in ("PSEUDOEPHEDRINE")
			then pseudoephedrine=1;
		end;
	risperidone=0;
		array meds69 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds69(i) in ("RISPERIDONE")
			then risperidone=1;
		end;
	theophylline=0;
		array meds70 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds70(i) in ("THEOPHYLLINE")
			then theophylline=1;
		end;
	thioridazine=0;
		array meds71 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds71(i) in ("THIORIDAZINE")
			then thioridazine=1;
		end;
	thiothixene=0;
		array meds72 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds72(i) in ("THIOTHIXENE")
			then thiothixene=1;
		end;
	tramadol=0;
		array meds73 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds73(i) in ("TRAMADOL")
			then tramadol=1;
		end;
	trifluoperazine=0;
		array meds74 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds74(i) in ("TRIFLUOPERAZINE")
			then trifluoperazine=1;
		end;
	ziprasidone=0;
		array meds75 {&maxdrugs.} Drug1--Drug&maxdrugs.;
		do i=1 to &maxdrugs.;
			if meds75(i) in ("ZIPRASIDONE")
			then ziprasidone=1;
		end;
	antichol=0;
	array meds76 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds76(i) in ("BROMPHENIRAINE" "CARBINOXAMINE" "CHLORPHENIRAMINE" "CLEMASTINE" "CYPROHEPTADINE" "DEXBROMPHENIRAMINE" "DEXCHLORPHENIRAMINE" 
			"DIMENHYDRINATE" "DIPHENHYDRAMINE" "DOXYLAMINE" "HYDROXYZINE" "MECLIZINE" "PROMETHAZINE" "TRIPROLIDINE" "BENZTROPINE" "TRIHEXYPHENIDYL" 
			"CYCLOBENZAPRINE" "ORPHENADRINE" "AMITRIPTYLINE" "AMOXAPINE" "CLOMIPRAMINE" "DESIPRAMINE" "DOXEPIN" "IMIPRAMINE" "NORTRIPTYLINE" "PAROXETINE" 
			"PROTRIPTYLINE" "TRIMIPRAMINE" "CHLORPROMAZINE" "CLOZAPINE" "LOXAPINE" "OLANZAPINE" "PERPHENAZINE" "THIORIDAZINE" "TRIFLUOPERAZINE" 
			"DISOPYRAMIDE" "DARIFENACIN" "FESOTERODINE" "FLAVOXATE" "OXYBUTYNIN" "SOLIFENACIN" "TOLTERODINE" "TROSPIUM" "ATROPINE" "BELLADONNA" 
			"CLIDINIUM-CHLORDIAZEPOXIDE" "DICYCLOMINE" "HOMATROPINE" "HYOSCYAINE" "PROPANTHELINE" "SCOPOLAMINE" "PROCHLORPERAZINE" "PROMETHAZINE")
		then antichol=antichol+1;
	end;
	cns=0;
	array meds77 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds77(i) in ("ARIPIPRAZOLE" "ASENAPINE" "CHLORIDAZEPOXIDE" "CHLORPROMAZINE" "CLOZAPINE" "FLUPHENAZINE" "HALOPERIDOL" "ILOPERIDONE" "LITHIUM" 
			"LOXAPINE" "LURASIDONE" "MESORIDAZINE" "METHOTRIMEPRAZINE" "MOLINDONE" "OLANZAPINE" "PALIPERIDONE" "PERPHENAZINE" "PIMOZIDE" "PROCHLORPERAZINE" 
			"PROMAZINE" "QUETIAPINE" "RISPERIDONE" "THIORIDAZINE" "THIOTHIXENE" "TRIFLUOPERAZINE" "TRIFLUPROMAZINE" "ZIPRASIDONE" "ALPRAZOLAM" "CHLORDIAZEPOXIDE" 
			"CLOBAZAM" "CLONAZEPAM" "CLORAZEPATE" "DIAZEPAM" "ESTAZOLAM" "FLURAZEPAM" "LORAZEPAM" "MIDAZOLAM" "OXAZEPAM" "QUAZEPAM" "TEMAZEPAM" "TRIAZOLAM" 
			"ESZOPICLONE" "ZOLPIDEM" "ZALEPLON" "AMITRIPTYLINE" "CLOMIPRAMINE" "IMIPRAMINE" "TRIMIPRAMINE" "DOXEPIN" "CITALOPRAM" "ESCITALOPRAM" "FLUOXETINE" 
			"FLUVOXAMINE" "PAROXETINE" "SERTRALINE" "ALFENTANIL" "BUPRENORPHINE" "BUTORPHANOL" "CODEINE" "FENTANYL" "HYDROCODONE" "HYDROMORPHONE" "LEVORPHANOL" 
			"MEPERIDINE" "METHADONE" "MORPHINE" "NALBUPHINE" "OPIUM" "OXYCODONE" "OXYMORPHONE" "PENTAZOCINE" "REMIFENTANIL" "SUFENTANIL" "TAPENTADOL" "TRAMADOL")
		then cns=cns+1;
	end;
	lithium=0;
	array meds78 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds78(i) in ("LITHIUM")
		then lithium=1;
	end;
	cimetidine=0;
	array meds79 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds79(i) in ("CIMETIDINE")
		then cimetidine=1;
	end;
	warfarin=0;
	array meds80 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
			if meds80(i) in ("WARFARIN")
		then warfarin=1;
	end;
	spir_epl=0;
	array meds81 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
			if meds81(i) in ("SPIRONOLACTONE" "EPLERENONE")
		then spir_epl=1;
	end;
	amil_triam=0;
	array meds82 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
			if meds82(i) in ("AMILORIDE" "TRIAMTERENE")
		then amil_triam=1;
	end;
	aspirin=0;
	array meds83 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
			if meds83(i) in ("ASPIRIN")
		then aspirin=1;
	end;
	antipsy_park=0;
	array meds84 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
			if meds84(i) in ("ARIPIPRAZOLE" "ASENAPINE" "CHLORIDAZEPOXIDE" "CHLORPROMAZINE" "FLUPHENAZINE" "HALOPERIDOL" "ILOPERIDONE" "LITHIUM" 
				"LOXAPINE" "LURASIDONE" "MESORIDAZINE" "METHOTRIMEPRAZINE" "MOLINDONE" "OLANZAPINE" "PALIPERIDONE" "PERPHENAZINE" "PIMOZIDE" 
				"PROCHLORPERAZINE" "PROMAZINE" "RISPERIDONE" "THIORIDAZINE" "THIOTHIXENE" "TRIFLUOPERAZINE" "TRIFLUPROMAZINE" "ZIPRASIDONE")
		then antipsy_park=1;
	end;
	phenothiazine=0;
	array meds85 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
			if meds85(i) in ("PHENOTHIAZINE")
		then phenothiazine=1;
	end;
	armodafinil=0;
	array meds86 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
			if meds86(i) in ("ARMODAFINIL")
		then armodafinil=1;
	end;
	antiplat=0;
	array meds87 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds87(i) in ("ABCIXIMAB" "EPTIFIBATIDE" "TIROFIBAN" "ASPIRIN" "CANGRELOR" "CILOSTAZOL" "CLOPIDOGREL" "DIPYRIDAMOLE" "PRASUGREL"
			"TICAGRELOR" "TICLODIPINE" "VORAPAXAR")
		then antiplat=1;
	end;
	glimepiride=0;
	array meds88 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds88(i) in ("GLIMEPIRIDE")
		then glimepiride=1;
	end;
	anticoag=0;
	array meds89 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds89(i) in: ("HEPARIN" "ENOXAPARIN" "DALTEPARIN" "DANAPAROID" "ARDEPARIN" "TINZAPARIN" "WARFARIN" "ANISINDIONE" "DICUMAROL" "LEPIRUDIN" "ARGATROBAN" "BIVALIRUDIN" "DESIRUDIN" "DABIGATRAN" "FONDAPARINUX" "RIVAROXABAN" "APIXABAN" "ASPIRIN" "DIPYRIDAMOLE" "TICLOPIDINE" "CLOPIDOGREL" "CILOSTAZOL" "PRASUGREL" "TICAGRELOR" "ABCIXIMAB" "TIROFIBAN" "EPTIFIBATIDE")
		then anticoag=1;
	end;
	nsaid=0;
	array meds90 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds90(i) in: ("IBUPROFEN" "NAPROXEN" "FENOPROFEN" "KETOPROFEN" "SULINDAC" "INDOMETHACIN" "TOLMETIN" "FLURBIPROFEN" "KETOROLAC" "MECLOFENAMATE" "MEFENAMIC" "NABUMETONE" "PHENYLBUTAZONE" "PIROXICAM" "DICLOFENAC" "ETODOLAC" "OXAPROZIN" "BROMFENAC" "DICLOFENAC-MISOPROSTOL" "MELOXICAM" "LANSOPRAZOLE-NAPROXEN" "ESOMEPRAZOLE-NAPROXEN" "FAMOTIDINE-IBUPROFEN")
		then nsaid=1;
	end;
	acei=0;
	array meds91 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds91(i) in: ("CAPTOPRIL" "ENALAPRIL" "FOSINOPRIL" "QUINAPRIL" "RAMIPRIL" "BENAZEPRIL" "LISINOPRIL" "MOEXIPRIL" "TRANDOLAPRIL" "PERINDOPRIL")
		then acei=1;
	end;
	arb=0;
	array meds92 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds92(i) in: 	("LOSARTAN" "VALSARTAN" "IRBESARTAN" "EPROSARTAN" "CANDESARTAN" "TELMISARTAN" "OLMESARTAN" "AZILSARTAN")
		then arb=1;
	end;
	antipsy_all=0;
	array meds93 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds93(i) in: 	("HALOPERIDOL" "LITHIUM" "MOLINDONE" "LOXAPINE" "PIMOZIDE" "AMITRIPTYLINE-CHLORDIAZEPOXIDE" "AMITRIPTYLINE-PERPHENAZINE" "PERPHENAZINE-AMITRIPTYLINE " "FLUOXETINE-OLANZAPINE" "CHLORPROMAZINE" "FLUPHENAZINE" "PROCHLORPERAZINE" "PROMAZINE" "THIORIDAZINE" "METHOTRIMEPRAZINE" "PERPHENAZINE" "MESORIDAZINE" "TRIFLUOPERAZINE" "TRIFLUPROMAZINE" "THIOTHIXENE" "CLOZAPINE" "RISPERIDONE" "OLANZAPINE" "QUETIAPINE" "ZIPRASIDONE" "ARIPIPRAZOLE" "PALIPERIDONE" "ILOPERIDONE" "ASENAPINE" "LURASIDONE")
		then antipsy_all=1;
	end;
	sed=0;
	array meds94 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds94(i) in: 	("AMOBARBITAL" "PENTOBARBITAL" "SECOBARBITAL" "MEPHOBARBITAL" "BUTABARBITAL" "BUTALBITAL" "AMOBARBITAL-SECOBARBITAL" "OXAZEPAM" "DIAZEPAM" "LORAZEPAM" "ALPRAZOLAM" "CHLORDIAZEPOXIDE" "CLONAZEPAM" "FLURAZEPAM" "MIDAZOLAM" "TEMAZEPAM" "TRIAZOLAM" "HALAZEPAM" "ESTAZOLAM" "QUAZEPAM" "CHLORAL" "BUSPIRONE" "DIPHENHYDRAMINE" "DOXEPIN" "ETHCHLORVYNOL" "MEPROBAMATE" "PYRILAMINE" "HYDROXYZINE" "CHLORMEZANONE" "ZOLPIDEM" "PARALDEHYDE" "ACETYLCARBROMAL" "PROPIOMAZINE" "DOXYLAMINE" "MELATONIN" "ZALEPLON" "DEXMEDETOMIDINE" "SODIUM" "ESZOPICLONE" "RAMELTEON")
		then sed=1;
	end;
	bb=0;
	array meds95 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds95(i) in:	("ATENOLOL" "ACEBUTOLOL" "METOPROLOL" "BETAXOLOL" "ESMOLOL" "BISOPROLOL" "NEBIVOLOL" "LABETALOL" "NADOLOL" "PROPRANOLOL" "PINDOLOL" "TIMOLOL" "PENBUTOLOL" "SOTALOL" "CARTEOLOL" "CARVEDILOL")
		then bb=1;
	end;
	ccb=0;
	array meds96 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds96(i) in:	("DILTIAZEM" "VERAPAMIL" "NIFEDIPINE" "FELODIPINE" "ISRADIPINE" "NICARDIPINE" "NIMODIPINE" "BEPRIDIL" "AMLODIPINE" "NISOLDIPINE" "MIBEFRADIL" "CLEVIDIPINEA")
		then ccb=1;
	end;
	diur=0;
	array meds97 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds97(i) in:	("FUROSEMIDE" "BUMETANIDE" "ETHACRYNIC" "TORSEMIDE" "AMILORIDE" "SPIRONOLACTONE" "TRIAMTERENE" "CHLOROTHIAZIDE" "HYDROCHLOROTHIAZIDE" "INDAPAMIDE" "METOLAZONE" "BENDROFLUMETHIAZIDE" "METHYCLOTHIAZIDE" "BENZTHIAZIDE" "HYDROFLUMETHIAZIDE" "TRICHLORMETHIAZIDE" "POLYTHIAZIDE" "ACETAZOLAMIDE" "DICHLORPHENAMIDE" "METHAZOLAMIDE" "MANNITOL" "PAMABROM" "UREA")
		then diur=1;
	end;
	estrogen=0;
	array meds98 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds98(i) in:	("CONJUGATED ESTROGENS" "ESTERIFIED ESTROGENS" "ESTRADIOL" "ESTROPIPATE" "DIETHYLSTILBESTROL" "QUINESTROL")
		then estrogen=1;
	end;
	est_proj=0;
	array meds99 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds99(i) in:	("DROSPIRENONE-ESTRADIOL" "ETHINYL ESTRADIOL" "ESTRADIOL-NORETHINDRONE" "ESTRADIOL-NORGESTIMATE" "CONJUGATED ESTROGENS")
		then est_proj=1;
	end;
	vasd=0;
	array meds100 {&maxdrugs.} Drug1--Drug&maxdrugs.;
	do i=1 to &maxdrugs.;
		if meds100(i) in:	("HYDRALAZINE" "MINOXIDIL" "NITROPRUSSIDE" "NITROGLYCERIN" "ALPROSTADIL" "NESIRITIDE")
		then vasd=1;
	end;
	drop i;
run;

data out.beers_final; set nacc_drugs;
	beers_pim=0;
		array medss {33} amiodarone antidep antihis antipark antipsy_all antispas barb bzd cab chlorpropamide desmopressin thyroid digoxin dipyridamole 
			disopyramide dronedarone ergot estrogen glyburide isoxsuprine megestrol meperidine meprobamate testos metoclopramide nitrofurantoin 
			nsaid pa1b pentazocine ppi smr2 ticlodipine zdrug;
		do i=1 to 33;
			if medss(i) = 1 then beers_pim=beers_pim+1;
		end;
		if (&schizo_var.=1 or &bipol_var.=1) and antipsy_all=1 then beers_pim=beers_pim-1; 
			else beers_pim=beers_pim; /* if have &schizo_var. or b&pd_var., antipsy are not inappropriate (only affects 8 people)*/
		drop i;
	beers_ddzi=0;
		array meds_hf {6} nsaid cox2 ndhpccb tzd cilostazol dronedarone;
		do i=1 to 6;
			if &chf_var.=1 and meds_hf(i)=1 then beers_ddzi=beers_ddzi+1;
		end;
		array meds_sz {8} bupropion chlorpromazine clozapine maprotiline olanzapine thioridazine thiothixene tramadol;
		do i=1 to 8;
			if &sz_var.=1 and meds_sz(i)=1 then beers_ddzi=beers_ddzi+1;
		end;
		array meds_dement {11} antihis antipark smr2 antidep antipsy_all digoxin bam antispas bzd h2ra zdrug;
		do i=1 to 11;
			if &dmta_var.=1 and meds_dement(i)=1 then beers_ddzi=beers_ddzi+1;
		end;
		array meds_&insom_var. {8} pseudoephedrine phenylephrine amphetamine armodafinil methylphenidate modafinil theophylline caffeine;
		do i=1 to 8;
			if &insom_var.n=1 and meds_&insom_var.(i)=1 then beers_ddzi=beers_ddzi+1;
		end;
		array meds_park {20} asenapine chlorpromazine fluphenazine haloperidol iloperidone loxapine lurasidone olanzapine paliperidone perphenazine
			pimozide prochlorperazine risperidone thioridazine thiothixene trifluoperazine ziprasidone metoclopramide prochlorperazine promethazine;
		do i=1 to 20;
			if &pd_var.=1 and meds_park(i)=1 then beers_ddzi=beers_ddzi+1;
		end;
		array meds_ui {2} estrogen pa1b;
		do i=1 to 2;
			if &sex_var. = 2 and &incontu_var. = 1 and meds_ui(i)=1 then beers_ddzi=beers_ddzi+1;
		end;
	beers_ddi=0;
		if acei=1 and amil_triam=1 then beers_ddi=beers_ddi+1;
		if antichol>1 then beers_ddi=beers_ddi+1;
		if (antidep=1 or antipsy_all=1 or bzd=1 or zdrug=1 or opioid=1) and cns>1 then beers_ddi=beers_ddi+1;
		if ster=1 and nsaid=1 then beers_ddi=beers_ddi+1;
		if lithium=1 and (acei=1 or loop=1) then beers_ddi=beers_ddi+1;
		if pa1b=1 and loop=1 then beers_ddi=beers_ddi+1;
		if theophylline=1 and cimetidine=1 then beers_ddi=beers_ddi+1;
		if warfarin=1 and nsaid=1 then beers_ddi=beers_ddi+1;
	beers_total=beers_pim + beers_ddzi + beers_ddi;
	beers_any = 0;
		if beers_total>0 then beers_any=1;		
run;

%mend;
