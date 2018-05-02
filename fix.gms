
********************************************************************************
$ontext
The Dispatch and Investment Evaluation Tool with Endogenous Renewables (DIETER).
Version 1.1.0, February 2016.
Written by Alexander Zerrahn and Wolf-Peter Schill. Moritz Niemeyer contributed to electric vehicle modeling.
This work is licensed under the MIT License (MIT).
For more information on this license, visit http://opensource.org/licenses/mit-license.php.
Whenever you use this code, please refer to http://www.diw.de/dieter.
We are happy to receive feedback under azerrahn@diw.de and wschill@diw.de.
$offtext
********************************************************************************


*************************************************************
**** Fixes unneccessary or inadequate variables to zero  ****
*************************************************************


** Run-of-river **
* If $setglobal ror_parameter "*": choose appropriate value for N_CON.fx('ror') (but no reserve provision):
%ror_variable%N_CON.fx('ror') = 4200 ;
%ror_variable%G_L.fx('ror',h) = N_CON.l('ror')*phi_ror(h) ;
%ror_variable%RP_CON.fx(reserves,'ror',h) = 0 ;
* Fix everything to zero in case no ROR option is selected:
%ror_parameter%%ror_variable%N_CON.fx('ror') = 0 ;
%ror_parameter%%ror_variable%G_L.fx('ror',h) = 0 ;
%ror_parameter%%ror_variable%G_UP.fx('ror',h) = 0 ;
%ror_parameter%%ror_variable%G_DO.fx('ror',h) = 0 ;
%ror_parameter%%ror_variable%RP_CON.fx(reserves,'ror',h) = 0 ;

** No nuclear **
G_L.fx('nuc',h) = 0 ;
G_UP.fx('nuc',h) = 0 ;
G_DO.fx('nuc',h) = 0 ;
RP_CON.fx(reserves,'nuc',h) = 0 ;
N_CON.fx('nuc') = 0 ;

** No storage types 1, 2, 3, 4, 6 and 7 by default **

N_STO_P.fx('Sto1') = 0 ;
N_STO_E.fx('Sto1') = 0 ;
STO_IN.fx('Sto1',h) = 0 ;
STO_OUT.fx('Sto1',h) = 0 ;
STO_L.fx('Sto1',h) = 0 ;
RP_STO_IN.fx(reserves,'Sto1',h) = 0 ;
RP_STO_OUT.fx(reserves,'Sto1',h) = 0 ;

N_STO_P.fx('Sto2') = 0 ;
N_STO_E.fx('Sto2') = 0 ;
STO_IN.fx('Sto2',h) = 0 ;
STO_OUT.fx('Sto2',h) = 0 ;
STO_L.fx('Sto2',h) = 0 ;
RP_STO_IN.fx(reserves,'Sto2',h) = 0 ;
RP_STO_OUT.fx(reserves,'Sto2',h) = 0 ;

N_STO_P.fx('Sto3') = 0 ;
N_STO_E.fx('Sto3') = 0 ;
STO_IN.fx('Sto3',h) = 0 ;
STO_OUT.fx('Sto3',h) = 0 ;
STO_L.fx('Sto3',h) = 0 ;
RP_STO_IN.fx(reserves,'Sto3',h) = 0 ;
RP_STO_OUT.fx(reserves,'Sto3',h) = 0 ;

N_STO_P.fx('Sto4') = 0 ;
N_STO_E.fx('Sto4') = 0 ;
STO_IN.fx('Sto4',h) = 0 ;
STO_OUT.fx('Sto4',h) = 0 ;
STO_L.fx('Sto4',h) = 0 ;
RP_STO_IN.fx(reserves,'Sto4',h) = 0 ;
RP_STO_OUT.fx(reserves,'Sto4',h) = 0 ;

N_STO_P.fx('Sto6') = 0 ;
N_STO_E.fx('Sto6') = 0 ;
STO_IN.fx('Sto6',h) = 0 ;
STO_OUT.fx('Sto6',h) = 0 ;
STO_L.fx('Sto6',h) = 0 ;
RP_STO_IN.fx(reserves,'Sto6',h) = 0 ;
RP_STO_OUT.fx(reserves,'Sto6',h) = 0 ;

N_STO_P.fx('Sto7') = 0 ;
N_STO_E.fx('Sto7') = 0 ;
STO_IN.fx('Sto7',h) = 0 ;
STO_OUT.fx('Sto7',h) = 0 ;
STO_L.fx('Sto7',h) = 0 ;
RP_STO_IN.fx(reserves,'Sto7',h) = 0 ;
RP_STO_OUT.fx(reserves,'Sto7',h) = 0 ;

** E to P ratio of PHS free by default **
etop_max('Sto5') = 1000 ;

** No storage inflow in first period **
STO_IN.fx(sto,'h1') = 0;


%DSM%$ontext
** No DSM in the first period **
         DSM_UP.fx(dsm_shift,'h1') = 0;
         DSM_DO.fx(dsm_shift,'h1',hh) = 0 ;
         DSM_DO.fx(dsm_shift,h,'h1') = 0 ;
         DSM_UP_DEMAND.fx(dsm_shift,'h1') = 0 ;
         DSM_DO_DEMAND.fx(dsm_shift,'h1') = 0 ;

** No reserves provision by DSM in first period **
         RP_DSM_SHIFT.fx(reserves,dsm_shift,'h1') = 0;
         RP_DSM_CU.fx('SR_up',dsm_curt,'h1') = 0 ;
         RP_DSM_CU.fx('MR_up',dsm_curt,'h1') = 0 ;

** No provision of PRL and negative reserves by DSM load curtailment **
         RP_DSM_CU.fx('PR_up',dsm_curt,h) = 0 ;
         RP_DSM_CU.fx('PR_do',dsm_curt,h) = 0 ;
         RP_DSM_CU.fx('SR_do',dsm_curt,h) = 0 ;
         RP_DSM_CU.fx('MR_do',dsm_curt,h) = 0 ;
$ontext
$offtext


** Conventionals in the baseline scenario 2035 (fixed to optimal levels of charging strategy "controlled vehicle loading only") **

N_CON.fx('bio') = 8400;
N_CON.fx('lig') = 9100;
N_CON.fx('hc') = 11000;
N_CON.fx('CCGT') = 15719.4898589427 ;
N_CON.fx('OCGT_eff') = 0;
N_CON.fx('OCGT_ineff') = 24980.5101410573 ;


** DSM in the baseline scenario 2035 (fixed to optimal levels of charging strategy "controlled vehicle loading only") **
N_DSM_CU.fx(dsm_curt) = 0 ;
N_DSM_SHIFT.fx(dsm_shift) = 0 ;
N_DSM_SHIFT.fx('DSM_shift3') = 1385 ;
N_DSM_SHIFT.fx('DSM_shift5') = 1050 ;

** Renewables in the baseline scenario 2035 **

N_RES.fx('Wind_on') = 88800;
N_RES.fx('Wind_off') = 18500;
N_RES.fx('Solar') = 59900;

** Storage in the baseline scenario 2035 **

N_STO_P.fx('Sto5')= 12700;
N_STO_E.fx('Sto5')= 12700*7;
