
********************************************************************************
$ontext
The Dispatch and Investment Evaluation Tool with Endogenous Renewables (DIETER).
Version 1.0.0, February 2015.
Written by Alexander Zerrahn and Wolf-Peter Schill.
This work is licensed under the MIT License (MIT).
For more information on this license, visit http://opensource.org/licenses/mit-license.php.
Whenever you use this code, please refer to http://www.diw.de/dieter.
This version of the model is documented in Zerrahn, A., Schill, W.-P. (2015): A greenfield model to evaluate long-run power storage requirements for high shares of renewables. DIW Discussion Paper 1457. http://www.diw.de/documents/publikationen/73/diw_01.c.498475.de/dp1457.pdf
We are happy to receive feedback under azerrahn@diw.de and wschill@diw.de.
$offtext
********************************************************************************


*************************************************************
**** Fixes unneccessary or inadequate variables to zero  ****
*************************************************************


** No run-of-river **
g_l.fx('ror',h) = 0 ;
g_up.fx('ror',h) = 0 ;
g_do.fx('ror',h) = 0 ;
prov_resrv_con.fx(reserves,'ror',h) = 0 ;
N_con.fx('ror') = 0 ;

** No nuclear **
g_l.fx('nuc',h) = 0 ;
g_up.fx('nuc',h) = 0 ;
g_do.fx('nuc',h) = 0 ;
prov_resrv_con.fx(reserves,'nuc',h) = 0 ;
N_con.fx('nuc') = 0 ;

** No lignite **
g_l.fx('lig',h) = 0 ;
g_up.fx('lig',h) = 0 ;
g_do.fx('lig',h) = 0 ;
prov_resrv_con.fx(reserves,'lig',h) = 0 ;
N_con.fx('lig') = 0 ;

** No storage types 2, 3, 4 and 6 by default **
N_stoC.fx('Sto2') = 0 ;
N_stoE.fx('Sto2') = 0 ;
sto_in.fx('Sto2',h) = 0 ;
sto_out.fx('Sto2',h) = 0 ;
sto_lev.fx('Sto2',h) = 0 ;
prov_resrv_sto.fx(reserves,'Sto2',h) = 0 ;

N_stoC.fx('Sto3') = 0 ;
N_stoE.fx('Sto3') = 0 ;
sto_in.fx('Sto3',h) = 0 ;
sto_out.fx('Sto3',h) = 0 ;
sto_lev.fx('Sto3',h) = 0 ;
prov_resrv_sto.fx(reserves,'Sto3',h) = 0 ;

N_stoC.fx('Sto4') = 0 ;
N_stoE.fx('Sto4') = 0 ;
sto_in.fx('Sto4',h) = 0 ;
sto_out.fx('Sto4',h) = 0 ;
sto_lev.fx('Sto4',h) = 0 ;
prov_resrv_sto.fx(reserves,'Sto4',h) = 0 ;

N_stoC.fx('Sto6') = 0 ;
N_stoE.fx('Sto6') = 0 ;
sto_in.fx('Sto6',h) = 0 ;
sto_out.fx('Sto6',h) = 0 ;
sto_lev.fx('Sto6',h) = 0 ;
prov_resrv_sto.fx(reserves,'Sto6',h) = 0 ;

** E to P ratio of PHS free by default **
EtoP_max('Sto5') = 1000 ;

** No storage inflow in first period **
sto_in.fx(sto,'h1') = 0;


%DSM%$ontext
** No DSM in the first period **
         DSM_up.fx(dsm_shift,'h1') = 0;
         DSM_do.fx(dsm_shift,'h1',hh) = 0 ;
         DSM_do.fx(dsm_shift,h,'h1') = 0 ;
         DSM_up_demand.fx(dsm_shift,'h1') = 0 ;
         DSM_do_demand.fx(dsm_shift,'h1') = 0 ;

** No reserves provision by DSM in first period **
         prov_resrv_dsmLS.fx(reserves,dsm_shift,'h1') = 0;
         prov_resrv_dsmLC.fx('SRL_do',dsm_curt,h) = 0 ;
         prov_resrv_dsmLC.fx('MRL_do',dsm_curt,h) = 0 ;
         prov_resrv_dsmLC.fx('SRL_up',dsm_curt,'h1') = 0 ;
         prov_resrv_dsmLC.fx('MRL_up',dsm_curt,'h1') = 0 ;

** No provision of PRL and negative reserves by DSM load curtailmet **
         prov_resrv_dsmLC.fx('PRL',dsm_curt,h) = 0 ;
         prov_resrv_dsmLC.fx('SRL_do',dsm_curt,h) = 0 ;
         prov_resrv_dsmLC.fx('MRL_do',dsm_curt,h) = 0 ;
$ontext
$offtext
