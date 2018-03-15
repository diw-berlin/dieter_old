
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


*************************************************************************************
**** Clears all variables and equations after each run to speed up calculations  ****
*************************************************************************************


* Clear all variables
option clear = z ;
option clear = g_l ;
option clear = g_up ;
option clear = g_do ;

option clear = g_res ;
option clear = curt ;

option clear = sto_in ;
option clear = sto_out ;
option clear = sto_lev ;

option clear = N_con ;
option clear = N_res ;
option clear = N_stoE ;
option clear = N_stoC ;

option clear = DSM_lc ;
option clear = DSM_up ;
option clear = DSM_do ;
option clear = DSM_up_demand ;
option clear = DSM_do_demand ;

option clear = N_dsmLC ;
option clear = N_dsmLS ;

option clear = prov_resrv_con ;
option clear = prov_resrv_res ;
option clear = prov_resrv_sto ;
option clear = prov_resrv_dsmLC ;
option clear = prov_resrv_dsmLS ;


* Clear all equations
option clear = obj ;
option clear = con1a_bal ;
option clear = con2a_loadlevel ;
option clear = con2b_loadlevelstart ;

option clear = con3a_maxprod_conv ;
option clear = con3h_maxprod_ror ;
option clear = con3j_maxprod_res ;

option clear = con4a_stolev_start ;
option clear = con4b_stolev ;
option clear = con4c_stolev_max ;
option clear = con4d_maxin_sto ;
option clear = con4e_maxout_sto ;
option clear = con4h_maxout_lev ;
option clear = con4i_maxin_lev ;
option clear = con4j_ending ;
option clear = con4k_PHS_EtoP ;

option clear = con5a_minRES ;
option clear = con5b_maxBIO ;

option clear = con8a_maxI_con ;
option clear = con8b_maxI_res ;
option clear = con8c_maxI_stoE ;
option clear = con8d_maxI_stoC ;

%DSM%$ontext
option clear = con6a_DSMcurt_duration_max ;
option clear = con6b_DSMcurt_max ;

option clear = con7a_DSMshift_upanddown ;
option clear = con7b_DSMshift_granular_max ;
option clear = con7c_DSM_distrib_up ;
option clear = con7d_DSM_distrib_do ;
*option clear =  con_7e_DSMshift_recovery ;

option clear = con8e_maxI_dsmLC ;
option clear = con8f_maxI_dsmLS_pos ;
$ontext
$offtext

%reserves%$ontext
option clear = con3b_minprod_conv ;
option clear = con3c_flex_SRL_up ;
option clear = con3d_flex_SRL_do ;
option clear = con3e_flex_MRL_up ;
option clear = con3f_flex_MRL_do ;
option clear = con3g_flex_PRL ;
option clear = con3i_minprod_ror ;
option clear = con3k_minprod_res ;

option clear = con4f_resrv_sto ;
option clear = con4g_resrv_sto ;

option clear = con10a_reserve_prov ;
option clear = con10b_reserve_prov_PRL ;
$ontext
$offtext
