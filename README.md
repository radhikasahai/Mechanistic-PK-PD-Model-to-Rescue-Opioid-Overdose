

# Modeling  Combinatorial Effects Between Pharmacological and Non-Pharmacological Interventions to Prevent Opioid-Induced Cardiac Arrest

R code to utilize mechanistic PK-PD model of opioid overdose with inclusion of rescue breathing to be published in: 

[Thrasher et al.]


# Authors
Bradlee Thrasher, John Mann, Anik Chaturbedi, Shilpa Chakravartula, Hamed Meshkin, Affan Fnu, Alexander Galluppi, Ji Young Kim, Nigar Karimli, Yue Han, Zachary Dezman, Jeffry Florian, and Zhihua Li

# Requirements

This code was developed with R version 4.4.1 and uses the following packages:
*	optparse
*	dplyr
*	ggplot2 
*	deSolve
*	grid
*	gridExtra 
*	stringr
*	scales
*	snowfall



## References
1.	Panchal AR, Bartos JA, Cabañas JG, et al. on behalf of the Adult Basic and Advanced Life Support Writing Group. Part 3: adult basic and advanced life support: 2020 American Heart Association Guidelines for Cardiopulmonary Resuscitation and Emergency Cardiovascular Care. Circulation. 2020;142(suppl 2):S366-S468. doi:10.1161/CIR.0000000000000916
2.	Lemmen Mv, Velzen Mv, Sarton EY, Dahan A, Niesters M, Schrier Rvd. Reversal of fentanyl-induced apnea: a randomized comparison between intramuscular (Zimhi) and intranasal naloxone (Narcan). Research Square. Preprint posted online January 01, 2025. doi:10.21203/rs.3.rs-5519093/v1
3.	Strauss DG, Li Z, Chaturbedi A, et al. Intranasal Naloxone Repeat Dosing Strategies and Fentanyl Overdose: A Simulation-Based Randomized Clinical Trial. JAMA Network Open. 2024;7(1):e2351839-e2351839. doi:10.1001/jamanetworkopen.2023.51839
4.	Payne ER, Stancliff S, Rowe K, Christie JA, Dailey MW. Comparison of Administration of 8-Milligram and 4-Milligram Intranasal Naloxone by Law Enforcement During Response to Suspected Opioid Overdose — New York, March 2022–August 2023. MMWR Morb Mortal Wkly Rep. 2024;73(5):110–113. doi:10.15585/mmwr.mm7305a4
5.	Skulberg AK, Tylleskär I, Valberg M, et al. Comparison of intranasal and intramuscular naloxone in opioid overdoses managed by ambulance staff: a double-dummy, randomised, controlled trial. Addiction. 2022;117(6):1658-1667. doi:10.1111/add.15806
6.	Chaturbedi A, Mann J, Chakravartula S, et al. Toward Developing Alternative Opioid Antagonists for Treating Community Overdose: A Model-Based Evaluation of Important Pharmacological Attributes. Clinical Pharmacology & Therapeutics. 2025;117(3):836-845. doi:10.1002/cpt.3527
7.	Mann J, Samieegohar M, Chaturbedi A, et al. Development of a Translational Model to Assess the Impact of Opioid Overdose and Naloxone Dosing on Respiratory Depression and Cardiac Arrest. Clin Pharmacol Ther. Nov 2022;112(5):1020-1032. doi:10.1002/cpt.2696
8.	SAMHSA. Overdose Prevention and Response Toolkit. https://library.samhsa.gov/sites/default/files/overdose-prevention-response-kit-pep23-03-00-001.pdf
9.	Paal P, Falk M, Sumann G, et al. Comparison of mouth-to-mouth, mouth-to-mask and mouth-to-face-shield ventilation by lay persons. Resuscitation. 2006/07/01/ 2006;70(1):117-123. doi:10.1016/j.resuscitation.2005.03.024
10.	Stallinger A, Wenzel V, Oroszy S, et al. The Effects of Different Mouth-to-Mouth Ventilation Tidal Volumes on Gas Exchange During Simulated Rescue Breathing. Anesthesia & Analgesia. 2001;93(5):1265-1269. doi:10.1097/00000539-200111000-00046
11.	Wenzel V, Idris AH, Banner MJ, Fuerst RS, Tucker KJ. The Composition of Gas Given by Mouth-to-Mouth Ventilation During CPR. Chest. 1994/12/01/ 1994;106(6):1806-1810. doi:10.1378/chest.106.6.1806
12.	Streisand JB, Varvel JR, Stanski DR, et al. Absorption and bioavailability of oral transmucosal fentanyl citrate. Anesthesiology. 1991;75(2):223-229. doi:10.1097/00000542-199108000-00009
13.	USFDA. KLOXXADOTM (naloxone hydrochloride) nasal spray. https://www.accessdata.fda.gov/drugsatfda_docs/label/2021/212045s000lbl.pdf
14.	USFDA. Naloxone Hydrochloride Injection Updated December, 2024. https://dailymed.nlm.nih.gov/dailymed/fda/fdaDrugXsl.cfm?setid=236349ef-2cb5-47ca-a3a5-99534c3a4996&type=display
15.	USFDA. NARCAN® (naloxone hydrochloride) nasal spray. https://www.accessdata.fda.gov/drugsatfda_docs/label/2015/208411lbl.pdf
16.	Algera MH, Olofsen E, Moss L, et al. Tolerance to Opioid-Induced Respiratory Depression in Chronic High-Dose Opioid Users: A Model-Based Comparison With Opioid-Naïve Individuals. Clinical Pharmacology & Therapeutics. 2021/03/01 2021;109(3):637-645. doi:https://doi.org/10.1002/cpt.2027
17.	USFDA. Actiq® (oral transmucosal fentanyl citrate). https://www.accessdata.fda.gov/drugsatfda_docs/label/1998/20747lbl.pdf
18.	Rzasa Lynn R, Galinkin J. Naloxone dosage for opioid reversal: current evidence and clinical implications. Therapeutic Advances in Drug Safety. 2018/01/01 2017;9(1):63-88. doi:10.1177/2042098617744161
19.	Palamar JJ, Ciccarone D, Rutherford C, Keyes KM, Carr TH, Cottler LB. Trends in seizures of powders and pills containing illicit fentanyl in the United States, 2018 through 2021. Drug and Alcohol Dependence. 2022/05/01/ 2022;234:109398. doi:https://doi.org/10.1016/j.drugalcdep.2022.109398
20.	Centers for Disease Control and Prevention. Polysubstance Overdose. Updated May 8, 2024. https://www.cdc.gov/overdose-prevention/about/polysubstance-overdose.html
21.	Becker LB, Berg RA, Pepe PE, et al. A Reappraisal of Mouth-to-Mouth Ventilation During Bystander-Initiated Cardiopulmonary Resuscitation. Circulation. 1997;96(6):2102-2112. doi:doi:10.1161/01.CIR.96.6.2102
22.	Kosten T, George T. The Neurobiology of Opioid Dependence: Implications for Treatment. Science &amp; Practice Perspectives. 2002;1(1):13-20. doi:10.1151/spp021113
23.	Farkas A, Lynch MJ, Westover R, et al. Pulmonary Complications of Opioid Overdose Treated With Naloxone. Annals of Emergency Medicine. 2020/01/01/ 2020;75(1):39-48. doi:https://doi.org/10.1016/j.annemergmed.2019.04.006
24.	Lameijer H, Azizi N, Ligtenberg JJM, Ter Maaten JC. Ventricular Tachycardia After Naloxone Administration: a Drug Related Complication? Case Report and Literature Review. Drug Safety - Case Reports. 2014/10/25 2014;1(1):2. doi:10.1007/s40800-014-0002-0
25.	Hill LG, Zagorski CM, Loera LJ. Increasingly powerful opioid antagonists are not necessary. International Journal of Drug Policy. 2022/01/01/ 2022;99:103457. doi:https://doi.org/10.1016/j.drugpo.2021.103457
26.	Infante AF, Elmes AT, Gimbar RP, Messmer SE, Neeb C, Jarrett JB. Stronger, longer, better opioid antagonists? Nalmefene is NOT a naloxone replacement. International Journal of Drug Policy. 2024;124:104323. doi:10.1016/j.drugpo.2024.104323

