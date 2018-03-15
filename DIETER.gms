
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


**************************
***** GLOBAL OPTIONS *****
**************************

* Set star to skip Excel upload and load data from gdx
$setglobal skip_Excel ""

* Set star to write Excel output file
$setglobal write_to_excel "*"

* Set star to activate options
$setglobal DSM "*"
$setglobal reserves "*"

* Set star to determine loops
$setglobal renewable_share "*"

* Set star to run test variant with each second hour
$setglobal second_hour ""

* Definition of strings for report parameters (Do not set stars)
$setglobal res_share ""
$setglobal em_share ""
$setglobal sec_hour "1"

%renewable_share%$ontext
$setglobal res_share ",loop_res_share"
$ontext
$offtext

%second_hour%$ontext
$setglobal sec_hour "8760/2208"
$ontext
$offtext

********************************************************************************

**************************
***** SOLVER OPTIONS *****
**************************

options
optcr = 0.00
reslim = 10000000
lp = cplex
;

option
dispwidth = 15,
limrow = 0,
limcol = 0,
solprint = off,
sysout = off ,
threads = 2 ;

********************************************************************************

Sets
year      yearly time data                       /2011, 2012, 2013, 2013_windonsmooth/
ct        Conventional Technologies              /ror, nuc, lig, hc, CCGT, OCGT_eff, OCGT_ineff, bio/
res       Renewable technologies                 /Wind_on, Wind_off, Solar/
sto       Storage technolgies                    /Sto1*Sto7/
dsm_shift DSM shifting technologies              /DSM_shift1*DSM_shift5/
dsm_curt  Set of load curtailment technologies   /DSM_curt1*DSM_curt3/
reserves  Set of reserve qualities               /PRL, SRL_up, SRL_do, MRL_up, MRL_do/
%second_hour%h  hour                             /h1*h8760/
%second_hour%$ontext
$include second_hour.gms
$ontext
$offtext

loop_res_share    Solution loop for different shares of renewables       /res_share_0, res_share_60, res_share_70, res_share_80, res_share_90, res_share_100/
loop_em_share     Solution loop for different shares of renewables       /conv_only, em_share_0, em_share_20, em_share_40, em_share_60, em_share_80, em_share_100/
;

Alias (h,hh) ;
alias (res,resres) ;

********************************************************************************

$include dataload.gms
*$stop

********************************************************************************

Variables
z                Value objective function
;

Positive Variables
g_l(ct,h)        Generation level
g_up(ct,h)       Generation upshift
g_do(ct,h)       Generation downshift

g_res(res,h)     Generation renewables type res in hour h
curt(res,h)      Renewables curtailment technology res in hour h

sto_in(sto,h)    Storage inflow technology sto hour h
sto_out(sto,h)   Storage outflow technology sto hour h
sto_lev(sto,h)   Storage level technology sto hour h

N_con(ct)        Units of conventional technology ct built
N_res(res)       Units of renewable technology built
N_stoE(sto)      Units of storage technology built - Energy in MWh
N_stoC(sto)      Units of storage inflow-outflow capacity built - Capacity in MW

DSM_lc(dsm_curt,h)       DSM: Load curtailment hour h
DSM_up(dsm_shift,h)      DSM: Load shifting up hour h technology dsm
DSM_do(dsm_shift,h,hh)   DSM: Load shifting down in hour hh to account for upshifts in hour h technology dsm

DSM_up_demand(dsm_shift,h)   DSM: Load shifting up active for wholesale demand hour h technology dsm
DSM_do_demand(dsm_shift,h)   DSM: Load shifting down active for wholesale demand hour h technology dsm

N_dsmLC(dsm_curt)        DSM: Load curtailment capacity
N_dsmLS(dsm_shift)       DSM: Load shifting capacity - Jaegerzaun

prov_resrv_con(reserves,ct,h)            Provision of reserves by conventionals
prov_resrv_res(reserves,res,h)           Provision of reserves by renewables
prov_resrv_sto(reserves,sto,h)           Provision of reserves by storage
prov_resrv_dsmLC(reserves,dsm_curt,h)    Provision of reserves by DSM load curtailment
prov_resrv_dsmLS(reserves,dsm_shift,h)   Provision of reserves by DSM load shifting
;

********************************************************************************


Equations
* Objective
obj                      Objective cost minimization

* Energy balance
con1a_bal                Supply Demand Balance in case of cost minimization

* Load change costs
con2a_loadlevel          Load change costs: Level
con2b_loadlevelstart     Load change costs: Level for first period

* Capacity contraints and flexibility constraints
con3a_maxprod_conv       Capacity Constraint conventionals
con3b_minprod_conv       Minimum production conventionals if reserves contracted

con3c_flex_SRL_up        Flexibility of conventionals - provision SRL up
con3d_flex_SRL_do        Flexibility of conventionals - provision SRL do
con3e_flex_MRL_up        Flexibility of conventionals - provision MRL up
con3f_flex_MRL_do        Flexibility of conventionals - provision MRL do
con3g_flex_PRL           Flexibility of conventionals - provision PRL

con3h_maxprod_ror        Capacity constraint Run-of-river
con3i_minprod_ror        Minimum production RoR if reserves contracted

con3j_maxprod_res        Capacity constraints renewables
con3k_minprod_res        Minimum production RES if reserves contracted

* Storage constraints
con4a_stolev_start        Storage Level Dynamics Initial Condition
con4b_stolev              Storage Level Dynamics

con4c_stolev_max          Storage Power Capacity
con4d_maxin_sto           Storage maximum inflow
con4e_maxout_sto          Storage maximum outflow
con4f_resrv_sto           Constraint on reserves (up)
con4g_resrv_sto           Constraint on reserves (down)

con4h_maxout_lev          Maximum storage outflow - no more than level of last period
con4i_maxin_lev           Maximum storage inflow - no more than ebergy capacity minus level of last period
con4j_ending              End level equal to initial level
con4k_PHS_EtoP            Maximum E to P ratio for PHS

* Quotas für renewables and biomass
con5a_minRES             Minimum yearly renewables requirement
con5b_maxBIO             Maximum yearly biomass energy

* DSM conditions: Load curtailment
con6a_DSMcurt_duration_max       Maximum curtailment energy budget per time
con6b_DSMcurt_max                Maximum curtailment per period

* DSM conditions: Load shifting
con7a_DSMshift_upanddown         Equalization of upshifts and downshifts in due time
con7b_DSMshift_granular_max      Maximum shifting in either direction per period
con7c_DSM_distrib_up             Distribution of upshifts between wholesale and reserves
con7d_DSM_distrib_do             Distribution of downshifts between wholesale and reserves
con7e_DSMshift_recovery          Recovery times

* Maximum installation conditions
con8a_maxI_con           Maximum installable capacity: Conventionals
con8b_maxI_res           Maximum installable capacity: Renewables
con8c_maxI_stoE          Maximum installable energy: Storage in MWh
con8d_maxI_stoC          Maximum installable capacity: Storage inflow-outflow in MW
con8e_maxI_dsmLC         Maximum installable capacity: DSM load curtailment
con8f_maxI_dsmLS_pos     Maximum installable capacity: DSM load shifting

* Reserves
con10a_reserve_prov      Reserve provision SRL and MRL
con10b_reserve_prov_PRL  Reserve provision PRL
;


********************************************************************************

* ---------------------------------------------------------------------------- *
***** Objective function *****
* ---------------------------------------------------------------------------- *

obj..
         z =E=
                 sum( (ct,h) , c_m(ct)*g_l(ct,h) )
                 + sum( (ct,h)$(ord(h)>1) , c_up(ct)*g_up(ct,h) )
                 + sum( (ct,h) , c_do(ct)*g_do(ct,h) )
                 + sum( (res,h) , c_curt(res)*curt(res,h) )
                 + sum( (sto,h) , 0.5 * c_sm(sto) * ( sto_out(sto,h) + sto_in(sto,h) ) )
%DSM%$ontext
                 + sum( (dsm_curt,h) , c_DSMlc(dsm_curt)*DSM_lc(dsm_curt,h) )
                 + sum( (dsm_shift,h) , 0.5 * c_DSMls(dsm_shift) * DSM_up_demand(dsm_shift,h) )
                 + sum( (dsm_shift,h) , 0.5 * c_DSMls(dsm_shift) * DSM_do_demand(dsm_shift,h) )
$ontext
$offtext
                 + sum( ct , c_i(ct)*N_con(ct) )
                 + sum( ct , fix_con(ct)*N_con(ct) )

                 + sum( res , c_ri(res)*N_res(res) )
                 + sum( res , fix_res(res)*N_res(res) )

                 + sum( sto , c_siE(sto)*N_stoE(sto) )
                 + sum( sto , fix_sto(sto)/2*(N_stoC(sto)+N_stoE(sto)) )
                 + sum( sto , c_siC(sto)*N_stoC(sto) )
%DSM%$ontext
                 + sum( dsm_curt , c_DSMiLC(dsm_curt)*N_dsmlc(dsm_curt) )
                 + sum( dsm_curt , fix_dsmLC(dsm_curt)*N_dsmlc(dsm_curt) )
                 + sum( dsm_shift , c_DSMiLS(dsm_shift)*N_dsmLS(dsm_shift) )
                 + sum( dsm_shift , fix_dsmLS(dsm_shift)*N_dsmLS(dsm_shift) )
$ontext
$offtext
%reserves%$ontext
                + 0.5 * sum( (reserves,sto,h) , prov_resrv_sto(reserves,sto,h) * reserves_active(reserves,h) * c_sm(sto) )
$ontext
$offtext
%DSM%$ontext
%reserves%$ontext
                + sum( (dsm_curt,h) , prov_resrv_dsmLC('SRL_up',dsm_curt,h) * reserves_active('SRL_up',h) * c_DSMlc(dsm_curt) )
                + sum( (dsm_curt,h) , prov_resrv_dsmLC('MRL_up',dsm_curt,h) * reserves_active('MRL_up',h) * c_DSMlc(dsm_curt) )
                + 0.5 * sum( (reserves,dsm_shift,h) , prov_resrv_dsmLS(reserves,dsm_shift,h) * reserves_active(reserves,h) * c_DSMls(dsm_shift) )
$ontext
$offtext
;


* ---------------------------------------------------------------------------- *
***** Energy balance and load levels *****
* ---------------------------------------------------------------------------- *

* Energy balance
con1a_bal(hh)..
         D(hh) + sum( sto , sto_in(sto,hh) )
%DSM%$ontext
         + sum( dsm_shift , DSM_up_demand(dsm_shift,hh) )
$ontext
$offtext
         =E=
         sum( ct , g_l(ct,hh)) + sum( res , g_res(res,hh)) + sum( sto , sto_out(sto,hh) )
%reserves%$ontext
* Balancing Correction Factor
        + sum( ct ,
        - prov_resrv_con('SRL_up',ct,hh) * reserves_active('SRL_up',hh)
        - prov_resrv_con('MRL_up',ct,hh) * reserves_active('MRL_up',hh)
        + prov_resrv_con('SRL_do',ct,hh) * reserves_active('SRL_do',hh)
        + prov_resrv_con('MRL_do',ct,hh) * reserves_active('MRL_do',hh) )
$ontext
$offtext
%DSM%$ontext
         + sum(dsm_curt, DSM_lc(dsm_curt,hh))
         + sum(dsm_shift, DSM_do_demand(dsm_shift,hh))
$ontext
$offtext
;

con2a_loadlevel(ct,h)$(ord(h) > 1)..
        g_l(ct,h) =E= g_l(ct,h-1) + g_up(ct,h) - g_do(ct,h)
;

con2b_loadlevelstart(ct,'h1')..
         g_l(ct,'h1') =E= g_up(ct,'h1')
;


* ---------------------------------------------------------------------------- *
***** Hourly maximum generation caps and constraints related to reserves   *****
* ---------------------------------------------------------------------------- *

con3a_maxprod_conv(ct,h)$(ord(ct)>1 )..
        g_l(ct,h)
%reserves%$ontext
        + prov_resrv_con('PRL',ct,h)
        + prov_resrv_con('SRL_up',ct,h)
        + prov_resrv_con('MRL_up',ct,h)
* Balancing Correction Factor
        - prov_resrv_con('SRL_up',ct,h) * reserves_active('SRL_up',h)
        - prov_resrv_con('MRL_up',ct,h) * reserves_active('MRL_up',h)
        + prov_resrv_con('SRL_do',ct,h) * reserves_active('SRL_do',h)
        + prov_resrv_con('MRL_do',ct,h) * reserves_active('MRL_do',h)
$ontext
$offtext
        =L= N_con(ct)
;

con3b_minprod_conv(ct,h)..
        prov_resrv_con('PRL',ct,h)
        + prov_resrv_con('SRL_do',ct,h)
        + prov_resrv_con('MRL_do',ct,h)
        =L= g_l(ct,h)
* Balancing Correction Factor
        - prov_resrv_con('SRL_up',ct,h) * reserves_active('SRL_up',h)
        - prov_resrv_con('MRL_up',ct,h) * reserves_active('MRL_up',h)
        + prov_resrv_con('SRL_do',ct,h) * reserves_active('SRL_do',h)
        + prov_resrv_con('MRL_do',ct,h) * reserves_active('MRL_do',h)
;

con3c_flex_SRL_up(ct,h)$(ord(ct)>1 )..
        prov_resrv_con('SRL_up',ct,h)
        =L= grad_per_min(ct) * 5 * ( g_l(ct,h)
* Balancing Correction Factor
        - prov_resrv_con('SRL_up',ct,h) * reserves_active('SRL_up',h)
        - prov_resrv_con('MRL_up',ct,h) * reserves_active('MRL_up',h)
        + prov_resrv_con('SRL_do',ct,h) * reserves_active('SRL_do',h)
        + prov_resrv_con('MRL_do',ct,h) * reserves_active('MRL_do',h) )
;

con3d_flex_SRL_do(ct,h)$(ord(ct)>1 )..
        prov_resrv_con('SRL_do',ct,h)
        =L= grad_per_min(ct) * 5 * ( g_l(ct,h)
* Balancing Correction Factor
        - prov_resrv_con('SRL_up',ct,h) * reserves_active('SRL_up',h)
        - prov_resrv_con('MRL_up',ct,h) * reserves_active('MRL_up',h)
        + prov_resrv_con('SRL_do',ct,h) * reserves_active('SRL_do',h)
        + prov_resrv_con('MRL_do',ct,h) * reserves_active('MRL_do',h) )
;

con3e_flex_MRL_up(ct,h)$(ord(ct)>1 )..
        prov_resrv_con('MRL_up',ct,h)
        =L= grad_per_min(ct) * 15 * ( g_l(ct,h)
* Balancing Correction Factor
        - prov_resrv_con('SRL_up',ct,h) * reserves_active('SRL_up',h)
        - prov_resrv_con('MRL_up',ct,h) * reserves_active('MRL_up',h)
        + prov_resrv_con('SRL_do',ct,h) * reserves_active('SRL_do',h)
        + prov_resrv_con('MRL_do',ct,h) * reserves_active('MRL_do',h) )
;

con3f_flex_MRL_do(ct,h)$(ord(ct)>1 )..
        prov_resrv_con('MRL_do',ct,h)
        =L= grad_per_min(ct) * 15 * ( g_l(ct,h)
* Balancing Correction Factor
        - prov_resrv_con('SRL_up',ct,h) * reserves_active('SRL_up',h)
        - prov_resrv_con('MRL_up',ct,h) * reserves_active('MRL_up',h)
        + prov_resrv_con('SRL_do',ct,h) * reserves_active('SRL_do',h)
        + prov_resrv_con('MRL_do',ct,h) * reserves_active('MRL_do',h) )
;

con3g_flex_PRL(ct,h)$(ord(ct)>1 )..
        prov_resrv_con('PRL',ct,h)
        =L= grad_per_min(ct) * 0.5 * ( g_l(ct,h)
* Balancing Correction Factor
        - prov_resrv_con('SRL_up',ct,h) * reserves_active('SRL_up',h)
        - prov_resrv_con('MRL_up',ct,h) * reserves_active('MRL_up',h)
        + prov_resrv_con('SRL_do',ct,h) * reserves_active('SRL_do',h)
        + prov_resrv_con('MRL_do',ct,h) * reserves_active('MRL_do',h) )
;

* Constraints on run of river
con3h_maxprod_ror(h)..
        g_l('ror',h)
%reserves%$ontext
        + prov_resrv_con('PRL','ror',h)
        + prov_resrv_con('SRL_up','ror',h)
        + prov_resrv_con('MRL_up','ror',h)
* Balancing Correction Factor
        - prov_resrv_con('SRL_up','ror',h) * reserves_active('SRL_up',h)
        - prov_resrv_con('MRL_up','ror',h) * reserves_active('MRL_up',h)
        + prov_resrv_con('SRL_do','ror',h) * reserves_active('SRL_do',h)
        + prov_resrv_con('MRL_do','ror',h) * reserves_active('MRL_do',h)
$ontext
$offtext
        =L= phi_ror(h)*N_con('ror')
;

con3i_minprod_ror(h)..
        prov_resrv_con('PRL','ror',h)
        + prov_resrv_con('SRL_do','ror',h)
        + prov_resrv_con('MRL_do','ror',h)
        =L= g_l('ror',h)
;

* Constraints on renewables
con3j_maxprod_res(res,h)..
        g_res(res,h) + curt(res,h)
%reserves%$ontext
        + prov_resrv_res('PRL',res,h)
        + prov_resrv_res('SRL_up',res,h)
        + prov_resrv_res('MRL_up',res,h)
$ontext
$offtext
        =E= phi_res(res,h)*N_res(res)
;

con3k_minprod_res(res,h)..
        prov_resrv_res('PRL',res,h)
        + prov_resrv_res('SRL_do',res,h)
        + prov_resrv_res('MRL_do',res,h)
        =L= g_res(res,h)
;


* ---------------------------------------------------------------------------- *
***** Storage constraints *****
* ---------------------------------------------------------------------------- *

con4a_stolev_start(sto,'h1')..
        sto_lev(sto,'h1') =E= sto_lev_start(sto) * N_stoE(sto) + sto_in(sto,'h1')*(1+eta_sto(sto))/2 - sto_out(sto,'h1')/(1+eta_sto(sto))*2
;

con4b_stolev(sto,h)$( (ord(h)>1) )..
         sto_lev(sto,h) =E= sto_lev(sto,h-1) + sto_in(sto,h)*(1+eta_sto(sto))/2 - sto_out(sto,h)/(1+eta_sto(sto))*2
%reserves%$ontext
        + ( prov_resrv_sto('SRL_do',sto,h) * reserves_active('SRL_do',h) + prov_resrv_sto('MRL_do',sto,h) * reserves_active('MRL_do',h) )*(1+eta_sto(sto))/2
        - ( prov_resrv_sto('SRL_up',sto,h) * reserves_active('SRL_up',h) + prov_resrv_sto('MRL_up',sto,h) * reserves_active('MRL_up',h) )/(1+eta_sto(sto))*2
$ontext
$offtext
;

con4c_stolev_max(sto,h)..
        sto_lev(sto,h) =L= N_stoE(sto)
;

con4d_maxin_sto(sto,h)..
        sto_in(sto,h)
%reserves%$ontext
        + prov_resrv_sto('PRL',sto,h) + prov_resrv_sto('SRL_do',sto,h) + prov_resrv_sto('MRL_do',sto,h)
$ontext
$offtext
        =L= N_stoC(sto)
;

con4e_maxout_sto(sto,h)..
        sto_out(sto,h)
%reserves%$ontext
        + prov_resrv_sto('PRL',sto,h) + prov_resrv_sto('SRL_up',sto,h) + prov_resrv_sto('MRL_up',sto,h)
$ontext
$offtext
        =L= N_stoC(sto)
;

con4f_resrv_sto(sto,h)..
        prov_resrv_sto('PRL',sto,h) + prov_resrv_sto('SRL_up',sto,h) + prov_resrv_sto('MRL_up',sto,h)
        =L= sto_in(sto,h) + N_stoC(sto)
;

con4g_resrv_sto(sto,h)..
        prov_resrv_sto('PRL',sto,h) + prov_resrv_sto('SRL_do',sto,h) + prov_resrv_sto('MRL_do',sto,h)
        =L= sto_out(sto,h) + N_stoC(sto)
;

con4h_maxout_lev(sto,h)..
        sto_out(sto,h)
%reserves%$ontext
        + prov_resrv_sto('PRL',sto,h) + prov_resrv_sto('SRL_up',sto,h) + prov_resrv_sto('MRL_up',sto,h)
$ontext
$offtext
        =L= sto_lev(sto,h-1)
;

con4i_maxin_lev(sto,h)..
        sto_in(sto,h)
%reserves%$ontext
        + prov_resrv_sto('PRL',sto,h) + prov_resrv_sto('SRL_do',sto,h) + prov_resrv_sto('MRL_do',sto,h)
$ontext
$offtext
        =L= N_stoE(sto) - sto_lev(sto,h-1)
;

con4j_ending(sto,h)$( ord(h) = card(h) )..
         sto_lev(sto,h) =E= sto_lev_start(sto) * N_stoE(sto)
;

con4k_PHS_EtoP('Sto5')..
        N_stoE('Sto5') =L= EtoP_max('Sto5') * N_stoC('Sto5')
;


* ---------------------------------------------------------------------------- *
***** Quotas for renewables and biomass *****
* ---------------------------------------------------------------------------- *

con5a_minRES..
sum( ct$(ord(ct) < card(ct)) , sum( h , g_l(ct,h) ) )
        =L= (1-sigma_minRES) * sum( h , D(h) + sum( (sto) , sto_in(sto,h) - sto_out(sto,h) )
%DSM%$ontext
         - sum( dsm_curt , DSM_lc(dsm_curt,h) )
$ontext
$offtext
%reserves%$ontext
        + mean_reserves_call('SRL_up') *( 1000 * reserves_share('SRL_up') * (reserves_intercept('SRL_up') + sum( res , reserves_slope('SRL_up',res) * N_res(res)/1000 ) ) )
        + mean_reserves_call('MRL_up') *( 1000 * reserves_share('MRL_up') * (reserves_intercept('MRL_up') + sum( res , reserves_slope('MRL_up',res) * N_res(res)/1000 ) ) )
        - mean_reserves_call('SRL_do') *( 1000 * reserves_share('SRL_do') * (reserves_intercept('SRL_do') + sum( res , reserves_slope('SRL_do',res) * N_res(res)/1000 ) ) )
        - mean_reserves_call('MRL_do') *( 1000 * reserves_share('MRL_do') * (reserves_intercept('MRL_do') + sum( res , reserves_slope('MRL_do',res) * N_res(res)/1000 ) ) )

       + sum( sto ,
       + prov_resrv_sto('SRL_do',sto,h) * reserves_active('SRL_do',h) + prov_resrv_sto('MRL_do',sto,h) * reserves_active('MRL_do',h)
       - prov_resrv_sto('SRL_up',sto,h) * reserves_active('SRL_up',h) - prov_resrv_sto('MRL_up',sto,h) * reserves_active('MRL_up',h) )
%DSM%$ontext
%reserves%$ontext
       - sum( dsm_curt , prov_resrv_dsmLC('SRL_up',dsm_curt,h) * reserves_active('SRL_up',h) )
       - sum( dsm_curt , prov_resrv_dsmLC('MRL_up',dsm_curt,h) * reserves_active('MRL_up',h) )
$ontext
$offtext
)
;

con5b_maxBIO..
         sum( h , g_l('bio',h) ) =L= M_con_ene('bio')
;

* ---------------------------------------------------------------------------- *
***** DSM constraints - curtailment *****
* ---------------------------------------------------------------------------- *

con6a_DSMcurt_duration_max(dsm_curt,h)..
         sum( hh$( ord(hh) >= ord(h) AND ord(hh) < ord(h) + dsm_offtimeLC(dsm_curt) ) , DSM_lc(dsm_curt,hh)
%reserves%$ontext
         + prov_resrv_dsmLC('SRL_up',dsm_curt,hh) * reserves_active('SRL_up',hh)
         + prov_resrv_dsmLC('MRL_up',dsm_curt,hh) * reserves_active('MRL_up',hh)
$ontext
$offtext
         )
         =L= N_dsmLC(dsm_curt) * dsm_durLC(dsm_curt)
;

con6b_DSMcurt_max(dsm_curt,h)..
        DSM_lc(dsm_curt,h)
%reserves%$ontext
        + prov_resrv_dsmLC('SRL_up',dsm_curt,h)
        + prov_resrv_dsmLC('MRL_up',dsm_curt,h)
$ontext
$offtext
          =L= N_dsmLC(dsm_curt)
;


* ---------------------------------------------------------------------------- *
***** DSM constraints - shifting *****
* ---------------------------------------------------------------------------- *

con7a_DSMshift_upanddown(dsm_shift,h)..
         DSM_up(dsm_shift,h) * eta_dsmLS(dsm_shift) =E= sum( hh$( ord(hh) >= ord(h) - dsm_durLS(dsm_shift) AND ord(hh) <= ord(h) + dsm_durLS(dsm_shift) ) , DSM_do(dsm_shift,h,hh) )
;

con7b_DSMshift_granular_max(dsm_shift,h)..
         DSM_up_demand(dsm_shift,h) + DSM_do_demand(dsm_shift,h)
%reserves%$ontext
         + sum( reserves$(ord(reserves) > 1) , prov_resrv_dsmLS(reserves,dsm_shift,h) )
$ontext
$offtext
         =L= N_dsmLS(dsm_shift)
;

con7c_DSM_distrib_up(dsm_shift,h)..
         DSM_up(dsm_shift,h) =E= DSM_up_demand(dsm_shift,h)
%reserves%$ontext
         + prov_resrv_dsmLS('SRL_do',dsm_shift,h) * reserves_active('SRL_do',h)
         + prov_resrv_dsmLS('MRL_do',dsm_shift,h) * reserves_active('MRL_do',h)
$ontext
$offtext
;

con7d_DSM_distrib_do(dsm_shift,h)..
         sum( hh$( ord(hh) >= ord(h) - dsm_durLS(dsm_shift) AND ord(hh) <= ord(h) + dsm_durLS(dsm_shift) ) , DSM_do(dsm_shift,hh,h) )
                 =E=
         DSM_do_demand(dsm_shift,h)
%reserves%$ontext
         + prov_resrv_dsmLS('SRL_up',dsm_shift,h) * reserves_active('SRL_up',h)
         + prov_resrv_dsmLS('MRL_up',dsm_shift,h) * reserves_active('MRL_up',h)
$ontext
$offtext
;

con7e_DSMshift_recovery(dsm_shift,h)..
         sum( hh$( ord(hh) >= ord(h) AND ord(hh) < ord(h) + dsm_offtimeLS(dsm_shift) ) , DSM_up(dsm_shift,hh))
         =L= N_dsmLS(dsm_shift) * dsm_durLS(dsm_shift)
;


* ---------------------------------------------------------------------------- *
***** Maximum installation constraints *****
* ---------------------------------------------------------------------------- *

con8a_maxI_con(ct)..
         N_con(ct) =L= M_con(ct)
;

con8b_maxI_res(res)..
         N_res(res) =L= M_res(res)
;

con8c_maxI_stoE(sto)..
         N_stoE(sto) =L= M_stoE(sto)
;

con8d_maxI_stoC(sto)..
         N_stoC(sto) =L= M_stoC(sto)
;

con8e_maxI_dsmLC(dsm_curt)..
         N_dsmLC(dsm_curt) =L= M_dsmLC(dsm_curt)
;

con8f_maxI_dsmLS_pos(dsm_shift)..
         N_dsmLS(dsm_shift) =L= M_dsmLS(dsm_shift)
;

* ---------------------------------------------------------------------------- *
***** Reserve constraints *****
* ---------------------------------------------------------------------------- *

con10a_reserve_prov(reserves,h)$( ord(reserves) > 1)..
        sum(ct, prov_resrv_con(reserves,ct,h))
        + sum(res, prov_resrv_res(reserves,res,h))
        + sum(sto, prov_resrv_sto(reserves,sto,h))
%DSM%$ontext
        + sum(dsm_curt, prov_resrv_dsmLC(reserves,dsm_curt,h))$( ord(reserves) = 2 OR ord(reserves) = 4 )
        + sum(dsm_shift , prov_resrv_dsmLS(reserves,dsm_shift,h) )
$ontext
$offtext
        =E= (
            1000 * reserves_share(reserves) * (
            reserves_intercept(reserves) + sum( res , reserves_slope(reserves,res) * N_res(res)/1000 ) ) )$(ord(h) > 1)
;

con10b_reserve_prov_PRL(h)..
        sum(ct, prov_resrv_con('PRL',ct,h))
        + sum(res, prov_resrv_res('PRL',res,h))
        + sum(sto, prov_resrv_sto('PRL',sto,h))
         =E= reserves_fraction_PRL *
                 sum( reserves$( ord(reserves) > 1) , 1000 * reserves_share(reserves) * (
            reserves_intercept(reserves) + sum( res , reserves_slope(reserves,res) * N_res(res)/1000 ) ) )$(ord(h) > 1)
;


********************************************************************************
***** MODEL *****
********************************************************************************

model DIETER /
obj

con1a_bal
con2a_loadlevel
con2b_loadlevelstart

con3a_maxprod_conv
con3h_maxprod_ror
con3j_maxprod_res

con4a_stolev_start
con4b_stolev
con4c_stolev_max
con4d_maxin_sto
con4e_maxout_sto
con4h_maxout_lev
con4i_maxin_lev
con4j_ending
con4k_PHS_EtoP

con5a_minRES
con5b_maxBIO

con8a_maxI_con
con8b_maxI_res
con8c_maxI_stoE
con8d_maxI_stoC

%DSM%$ontext
con6a_DSMcurt_duration_max
con6b_DSMcurt_max

con7a_DSMshift_upanddown
con7b_DSMshift_granular_max
con7c_DSM_distrib_up
con7d_DSM_distrib_do
* con_7e_DSMshift_recovery

con8e_maxI_dsmLC
con8f_maxI_dsmLS_pos
$ontext
$offtext

%reserves%$ontext
con3b_minprod_conv
con3c_flex_SRL_up
con3d_flex_SRL_do
con3e_flex_MRL_up
con3f_flex_MRL_do
con3g_flex_PRL
con3i_minprod_ror
con3k_minprod_res

con4f_resrv_sto
con4g_resrv_sto

con10a_reserve_prov
con10b_reserve_prov_PRL
$ontext
$offtext
/;


********************************************************************************
***** Options, fixings, report preparation *****
********************************************************************************

* Solver options
$onecho > cplex.opt
lpmethod 4
threads 2
parallelmode -1
$offecho

dieter.OptFile = 1;
dieter.holdFixed = 1 ;

* Fixings
$include fix.gms

* Parameters for the report file
parameter
corr_fac_con
corr_fac_res
corr_fac_sto
corr_fac_dsmLC
corr_fac_dsmLS
gross_energy_demand
calc_maxprice
calc_minprice
report
report_tech
report_tech_hours
report_hours
report_reserves
report_reserves_hours
report_reserves_tech
report_reserves_tech_hours
;

* Min and max for prices
calc_maxprice = 0 ;
calc_minprice = 1000 ;

* Parameters for default base year
D(h) = D_y('2013',h) ;
phi_res(res,h) = phi_res_y('2013',res,h) ;
reserves_active(reserves,h) = reserves_active_y('2013',reserves,h) ;
mean_reserves_call(reserves) = mean_reserves_call_y('2013',reserves) ;

*Include scenario
$include Scenario.gms


********************************************************************************
***** Solve *****
********************************************************************************

* Default 100% RES if no loop over RES shares
%renewable_share%sigma_minRES = 1 ;
%renewable_share%$goto skip_loop_res_share

* Loop over res shares
loop( loop_res_share$(ord(loop_res_share)=1) ,
        sigma_minRES = 0$(ord(loop_res_share) = 1)
         + 0.6$(ord(loop_res_share) = 2)
         + 0.7$(ord(loop_res_share) = 3)
         + 0.8$(ord(loop_res_share) = 4)
         + 0.9$(ord(loop_res_share) = 5)
         + 1$(ord(loop_res_share) = 6) ;
$label skip_loop_res_share

* Fix again within each loop
$include fix.gms

* Solve model
        solve DIETER using lp minimizing z ;

* Assign default correction factors
corr_fac_con(ct,h) = 0 ;
corr_fac_res(res,h) = 0 ;
corr_fac_sto(sto,h) = 0 ;
corr_fac_dsmLC(dsm_curt,h) = 0 ;
corr_fac_dsmLS(dsm_shift,h) = 0 ;

* Define gross energy demand for reporting, egual to equation 5a
gross_energy_demand = sum( h , D(h) + sum( (sto) , sto_in.l(sto,h) - sto_out.l(sto,h) )
%DSM%$ontext
         - sum( dsm_curt , DSM_lc.l(dsm_curt,h) )
$ontext
$offtext
%reserves%$ontext
        + mean_reserves_call('SRL_up') *( 1000 * reserves_share('SRL_up') * (reserves_intercept('SRL_up') + sum( res , reserves_slope('SRL_up',res) * N_res.l(res)/1000 ) ) )
        + mean_reserves_call('MRL_up') *( 1000 * reserves_share('MRL_up') * (reserves_intercept('MRL_up') + sum( res , reserves_slope('MRL_up',res) * N_res.l(res)/1000 ) ) )
        - mean_reserves_call('SRL_do') *( 1000 * reserves_share('SRL_do') * (reserves_intercept('SRL_do') + sum( res , reserves_slope('SRL_do',res) * N_res.l(res)/1000 ) ) )
        - mean_reserves_call('MRL_do') *( 1000 * reserves_share('MRL_do') * (reserves_intercept('MRL_do') + sum( res , reserves_slope('MRL_do',res) * N_res.l(res)/1000 ) ) )

       + sum( sto ,
       + prov_resrv_sto.l('SRL_do',sto,h)*reserves_active('SRL_do',h) + prov_resrv_sto.l('MRL_do',sto,h)*reserves_active('MRL_do',h)
       - prov_resrv_sto.l('SRL_up',sto,h)*reserves_active('SRL_up',h) - prov_resrv_sto.l('MRL_up',sto,h)*reserves_active('MRL_up',h) )
$ontext
$offtext
%DSM%$ontext
%reserves%$ontext
       - sum( dsm_curt , prov_resrv_dsmLC.l('SRL_up',dsm_curt,h) * reserves_active('SRL_up',h) )
       - sum( dsm_curt , prov_resrv_dsmLC.l('MRL_up',dsm_curt,h) * reserves_active('MRL_up',h) )
$ontext
$offtext
)
;

* Determine correction factors
%reserves%$ontext
        corr_fac_con(ct,h) =
        - prov_resrv_con.l('SRL_up',ct,h) * reserves_active('SRL_up',h)
        - prov_resrv_con.l('MRL_up',ct,h) * reserves_active('MRL_up',h)
        + prov_resrv_con.l('SRL_do',ct,h) * reserves_active('SRL_do',h)
        + prov_resrv_con.l('MRL_do',ct,h) * reserves_active('MRL_do',h)
;
        corr_fac_res(res,h) =
        - prov_resrv_res.l('SRL_up',res,h) * reserves_active('SRL_up',h)
        - prov_resrv_res.l('MRL_up',res,h) * reserves_active('MRL_up',h)
        + prov_resrv_res.l('SRL_do',res,h) * reserves_active('SRL_do',h)
        + prov_resrv_res.l('MRL_do',res,h) * reserves_active('MRL_do',h)
;
        corr_fac_sto(sto,h) =
        - (prov_resrv_sto.l('SRL_up',sto,h) * reserves_active('SRL_up',h) )
        - (prov_resrv_sto.l('MRL_up',sto,h) * reserves_active('MRL_up',h) )
        + (prov_resrv_sto.l('SRL_do',sto,h) * reserves_active('SRL_do',h) )
        + (prov_resrv_sto.l('MRL_do',sto,h) * reserves_active('MRL_do',h) )
;
%DSM%$ontext
        corr_fac_dsmLC(dsm_curt,h) =
        - prov_resrv_dsmLC.l('SRL_up',dsm_curt,h) * reserves_active('SRL_up',h)
        - prov_resrv_dsmLC.l('MRL_up',dsm_curt,h) * reserves_active('MRL_up',h)
;
        corr_fac_dsmLS(dsm_shift,h) =
        - prov_resrv_dsmLS.l('SRL_up',dsm_shift,h) * reserves_active('SRL_up',h)
        - prov_resrv_dsmLS.l('MRL_up',dsm_shift,h) * reserves_active('MRL_up',h)
        + prov_resrv_dsmLS.l('SRL_do',dsm_shift,h) * reserves_active('SRL_do',h)
        + prov_resrv_dsmLS.l('MRL_do',dsm_shift,h) * reserves_active('MRL_do',h)
;
$ontext
$offtext

* Report files
        report('model status'%res_share%%em_share%) = DIETER.modelstat ;
        report('solve time'%res_share%%em_share%) = DIETER.resUsd ;
        report('obj value'%res_share%%em_share%) = z.l * %sec_hour% ;
        report_tech('capacities conventional'%res_share%%em_share%,ct)$(not ord(ct)=card(ct)) =  N_con.l(ct) ;
        report_tech('capacities renewable'%res_share%%em_share%,res) =  N_res.l(res) ;
        report_tech('capacities renewable'%res_share%%em_share%,'bio') =  N_con.l('bio') ;
        report_tech('capacities storage MW'%res_share%%em_share%,sto) =  N_stoC.l(sto) ;
        report_tech('capacities storage MWh'%res_share%%em_share%,sto) =  N_stoE.l(sto) * %sec_hour% ;
        report_tech('conshares'%res_share%%em_share%,ct)$(not ord(ct)=card(ct)) = sum( h, g_l.l(ct,h) ) / gross_energy_demand ;
        report('conshare total'%res_share%%em_share%) = sum(ct, report_tech('conshares'%res_share%%em_share%,ct) ) ;
        report_tech('renshares'%res_share%%em_share%,res) = sum( h, g_res.l(res,h) - corr_fac_res(res,h))/ gross_energy_demand ;
        report_tech('renshares'%res_share%%em_share%,'bio') = sum( h, g_l.l('bio',h) ) / gross_energy_demand ;
        report('renshare total'%res_share%%em_share%) = sum(res,report_tech('renshares'%res_share%%em_share%,res)) + report_tech('renshares'%res_share%%em_share%,'bio') ;
        report_tech('res curtailment absolute'%res_share%%em_share%,res) =  sum(h,curt.l(res,h)) * %sec_hour% ;
        report_tech('res curtailment relative'%res_share%%em_share%,res)$report_tech('res curtailment absolute'%res_share%%em_share%,res) =  sum(h,curt.l(res,h))/( sum(h,g_res.l(res,h) - corr_fac_res(res,h) ) + sum(h,curt.l(res,h)) ) ;
        report_tech_hours('generation conventional'%res_share%%em_share%,ct,h) =  g_l.l(ct,h) + corr_fac_con(ct,h) ;
        report_tech_hours('generation renewable'%res_share%%em_share%,res,h) = g_res.l(res,h) ;
        report_tech_hours('res curtailment'%res_share%%em_share%,res,h) =  curt.l(res,h) ;
        report_tech_hours('generation storage'%res_share%%em_share%,sto,h) =  sto_out.l(sto,h) ;
        report_tech_hours('storage loading'%res_share%%em_share%,sto,h) =  sto_in.l(sto,h) ;
        report_tech_hours('storage level'%res_share%%em_share%,sto,h) =  sto_lev.l(sto,h) ;
*        report_hours('demand'%res_share%%em_share%,h) = D(h) ;
        report('res curtailment absolute'%res_share%%em_share%) = sum((res,h),curt.l(res,h)) * %sec_hour% ;
        report('res curtailment relative'%res_share%%em_share%)$report('res curtailment absolute'%res_share%%em_share%) = sum((res,h),curt.l(res,h))/( sum((res,h),g_res.l(res,h) - corr_fac_res(res,h) ) + sum((res,h),curt.l(res,h)) ) ;
        report('bio not utilized absolute'%res_share%%em_share%)$(M_con_ene('bio')) = (M_con_ene('bio') - sum(h,g_l.l('bio',h))) * %sec_hour% ;
        report('bio not utilized relative'%res_share%%em_share%)$(M_con_ene('bio')) = (M_con_ene('bio') - sum(h,g_l.l('bio',h)))/M_con_ene('bio') ;

        report_hours('price'%res_share%%em_share%,h) = -con1a_bal.m(h) ;
        loop(h,
                if(-con1a_bal.m(h) > calc_maxprice,
                calc_maxprice = -con1a_bal.m(h) ;);
                report('max price'%res_share%%em_share%) = calc_maxprice ;
        );
        report('mean price'%res_share%%em_share%) = -sum(h,con1a_bal.m(h))/card(h) ;
        loop(h,
                if(-con1a_bal.m(h) < calc_minprice,
                calc_minprice = -con1a_bal.m(h) ;);
                report('min price'%res_share%%em_share%) = calc_minprice ;
        );
        report('Capacity total'%res_share%%em_share%) = sum( ct , N_con.l(ct) ) + sum( res , N_res.l(res) ) + sum( sto , N_stoC.l(sto) )
%DSM%$ontext
        + sum( dsm_curt , N_dsmLC.l(dsm_curt) ) + sum( dsm_shift , N_dsmLS.l(dsm_shift) )
$ontext
$offtext
;
        report_tech('Capacity share'%res_share%%em_share%,ct) = N_con.l(ct) / report('Capacity total'%res_share%%em_share%) + 1e-9 ;
        report_tech('Capacity share'%res_share%%em_share%,res) = N_res.l(res) / report('Capacity total'%res_share%%em_share%) + 1e-9 ;
        report_tech('Capacity share'%res_share%%em_share%,sto) = N_stoC.l(sto) / report('Capacity total'%res_share%%em_share%) + 1e-9 ;
        report('Energy total'%res_share%%em_share%) = (sum( h , D(h) ) + sum( (sto,h) , sto_in.l(sto,h) )) * %sec_hour%
%DSM%$ontext
        + sum( (dsm_shift,h) , DSM_up_demand.l(dsm_shift,h) ) * %sec_hour%
$ontext
$offtext
%reserves%$ontext
       + sum( h$(ord(h) > 1) , 1000 * reserves_share('SRL_up') * ( reserves_intercept('SRL_up') + sum( res , reserves_slope('SRL_up',res) * N_res.l(res)/1000 ) ) * reserves_active('SRL_up',h) )
       + sum( h$(ord(h) > 1) , 1000 * reserves_share('MRL_up') * ( reserves_intercept('MRL_up') + sum( res , reserves_slope('MRL_up',res) * N_res.l(res)/1000 ) ) * reserves_active('MRL_up',h) )
       - sum( h$(ord(h) > 1) , 1000 * reserves_share('SRL_do') * ( reserves_intercept('SRL_do') + sum( res , reserves_slope('SRL_do',res) * N_res.l(res)/1000 ) ) * reserves_active('SRL_do',h) )
       - sum( h$(ord(h) > 1) , 1000 * reserves_share('MRL_do') * ( reserves_intercept('MRL_do') + sum( res , reserves_slope('MRL_do',res) * N_res.l(res)/1000 ) ) * reserves_active('MRL_do',h) )
$ontext
$offtext
;
        report_tech('Energy share'%res_share%%em_share%,ct) = sum( h , g_l.l(ct,h) ) / report('Energy total'%res_share%%em_share%) * %sec_hour% + 1e-9 ;
        report_tech('Energy share'%res_share%%em_share%,res) = sum( h , g_res.l(res,h) - corr_fac_res(res,h) ) / report('Energy total'%res_share%%em_share%) * %sec_hour% + 1e-9 ;
        report_tech('Energy share'%res_share%%em_share%,sto) = sum( h , sto_out.l(sto,h) - corr_fac_sto(sto,h) ) / report('Energy total'%res_share%%em_share%) * %sec_hour% + 1e-9 ;
        report_tech('Storage out total wholesale'%res_share%%em_share%,sto) = sum(h, report_tech_hours('generation storage'%res_share%%em_share%,sto,h) ) * %sec_hour% ;
        report_tech('Storage in total wholesale'%res_share%%em_share%,sto) = sum(h, report_tech_hours('storage loading'%res_share%%em_share%,sto,h) ) * %sec_hour% ;
%reserves%$ontext
        report_tech('Storage out total reserves'%res_share%%em_share%,sto) = sum(h, prov_resrv_sto.l('SRL_up',sto,h) * reserves_active('SRL_up',h) + prov_resrv_sto.l('MRL_up',sto,h) * reserves_active('MRL_up',h) ) * %sec_hour% ;
        report_tech('Storage in total reserves'%res_share%%em_share%,sto) = sum(h, prov_resrv_sto.l('SRL_do',sto,h) * reserves_active('SRL_do',h) + prov_resrv_sto.l('MRL_do',sto,h) * reserves_active('MRL_do',h) ) * %sec_hour% ;
        report_tech('Storage out total'%res_share%%em_share%,sto) = report_tech('Storage out total wholesale'%res_share%%em_share%,sto) + report_tech('Storage out total reserves'%res_share%%em_share%,sto) ;
        report_tech('Storage in total'%res_share%%em_share%,sto) = report_tech('Storage in total wholesale'%res_share%%em_share%,sto) + report_tech('Storage in total reserves'%res_share%%em_share%,sto) ;
$ontext
$offtext
%reserves%        report_tech('Storage FLH'%res_share%%em_share%,sto)$N_stoC.l(sto) = report_tech('Storage out total wholesale'%res_share%%em_share%,sto) / N_stoC.l(sto) ;
%reserves%        report_tech('Storage cycles'%res_share%%em_share%,sto)$N_stoE.l(sto) = report_tech('Storage out total wholesale'%res_share%%em_share%,sto) / N_stoE.l(sto) / %sec_hour% ;
%reserves%$ontext
        report_tech('Storage FLH'%res_share%%em_share%,sto)$N_stoC.l(sto) = report_tech('Storage out total'%res_share%%em_share%,sto) / N_stoC.l(sto) ;
        report_tech('Storage cycles'%res_share%%em_share%,sto)$N_stoE.l(sto) = report_tech('Storage out total'%res_share%%em_share%,sto) / N_stoE.l(sto) / %sec_hour% ;
$ontext
$offtext
        report_tech('Storage EP-ratio'%res_share%%em_share%,sto)$N_stoC.l(sto) = N_stoE.l(sto) * %sec_hour% / N_stoC.l(sto) ;
*        report_tech('Marginals'%res_share%%em_share%,ct)$N_con.l(ct) = -con8a_maxI_con.m(ct) ;
        report_tech('Marginals'%res_share%%em_share%,res)$N_res.l(res) = -con8b_maxI_res.m(res) ;
        report_tech('Marginals'%res_share%%em_share%,sto)$N_stoE.l(sto) = -con8c_maxI_stoE.m(sto) ;

%reserves%$ontext
         report_reserves_tech('Reserves provision ratio'%res_share%%em_share%,reserves,ct)$(N_con.l(ct) AND (ord(reserves) = 2 OR ord(reserves) = 4)) = sum(h ,  prov_resrv_con.l(reserves,ct,h) ) / sum(h , g_l.l(ct,h)) ;
         report_reserves_tech('Reserves provision ratio'%res_share%%em_share%,reserves,ct)$(N_con.l(ct) AND (ord(reserves) = 3 OR ord(reserves) = 5)) = sum(h ,  prov_resrv_con.l(reserves,ct,h) ) / sum(h , g_l.l(ct,h)  + corr_fac_con(ct,h) ) ;
         report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,reserves,ct)$(N_con.l(ct) AND (ord(reserves) = 2 OR ord(reserves) = 4)) = sum(h ,  prov_resrv_con.l(reserves,ct,h) * reserves_active(reserves,h)) / sum(h , g_l.l(ct,h)) ;
         report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,reserves,ct)$(N_con.l(ct) AND (ord(reserves) = 3 OR ord(reserves) = 5)) = sum(h ,  prov_resrv_con.l(reserves,ct,h) * reserves_active(reserves,h)) / sum(h , g_l.l(ct,h)  + corr_fac_con(ct,h) ) ;

         report_reserves_tech('Reserves provision ratio'%res_share%%em_share%,reserves,res)$(N_res.l(res) AND (ord(reserves) = 2 OR ord(reserves) = 4)) = sum(h ,  prov_resrv_res.l(reserves,res,h) ) / sum(h , g_res.l(res,h)) ;
         report_reserves_tech('Reserves provision ratio'%res_share%%em_share%,reserves,res)$(N_res.l(res) AND (ord(reserves) = 3 OR ord(reserves) = 5)) = sum(h ,  prov_resrv_res.l(reserves,res,h) ) / sum(h , g_res.l(res,h)  + corr_fac_res(res,h) ) ;
         report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,reserves,res)$(N_res.l(res) AND (ord(reserves) = 2 OR ord(reserves) = 4)) = sum(h ,  prov_resrv_res.l(reserves,res,h) * reserves_active(reserves,h)) / sum(h , g_res.l(res,h)) ;
         report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,reserves,res)$(N_res.l(res) AND (ord(reserves) = 3 OR ord(reserves) = 5)) = sum(h ,  prov_resrv_res.l(reserves,res,h) * reserves_active(reserves,h)) / sum(h , g_res.l(res,h) - corr_fac_res(res,h) ) ;

         report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,'Up - Pos reserve',sto)$N_stoC.l(sto) = sum( (h,reserves)$( (ord(reserves) = 2 OR ord(reserves) = 4 ) AND sto_in.l(sto,h) ) , prov_resrv_sto.l(reserves,sto,h) * reserves_active(reserves,h) ) / sum( h , sto_in.l(sto,h))  ;
         report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,'Up - Neg reserve',sto)$N_stoC.l(sto) = sum( (h,reserves)$( (ord(reserves) = 3 OR ord(reserves) = 5 ) AND sto_in.l(sto,h) ) , prov_resrv_sto.l(reserves,sto,h) * reserves_active(reserves,h) ) / sum( h , sto_in.l(sto,h) + sum( reserves , prov_resrv_sto.l(reserves,sto,h) * reserves_active(reserves,h)) ) ;
         report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,'Do - Pos reserve',sto)$N_stoC.l(sto) = sum( (h,reserves)$( (ord(reserves) = 2 OR ord(reserves) = 4 ) AND sto_out.l(sto,h) ) , prov_resrv_sto.l(reserves,sto,h) * reserves_active(reserves,h) ) / sum( h , sto_out.l(sto,h) + sum( reserves , prov_resrv_sto.l(reserves,sto,h) * reserves_active(reserves,h)) ) ;
         report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,'Do - Neg reserve',sto)$N_stoC.l(sto) = sum( (h,reserves)$( (ord(reserves) = 3 OR ord(reserves) = 5 ) AND sto_out.l(sto,h) ) , prov_resrv_sto.l(reserves,sto,h) * reserves_active(reserves,h) ) / sum( h , sto_out.l(sto,h) )  ;
$ontext
$offtext

%DSM%$ontext
        report('load curtailment absolute (non-reserves)'%res_share%%em_share%) =  sum((dsm_curt,h), DSM_lc.l(dsm_curt,h)) * %sec_hour% ;
        report('load shift pos absolute (non-reserves)'%res_share%%em_share%) =  sum((dsm_shift,h), DSM_up_demand.l(dsm_shift,h)) * %sec_hour% ;
        report('load shift neg absolute (non-reserves)'%res_share%%em_share%) =  sum((dsm_shift,h), DSM_do_demand.l(dsm_shift,h)) * %sec_hour% ;
        report_tech('capacities load curtailment'%res_share%%em_share%,dsm_curt) =  N_dsmLC.l(dsm_curt) ;
        report_tech('capacities load shift'%res_share%%em_share%,dsm_shift) =  N_dsmLS.l(dsm_shift) ;
        report_tech_hours('load curtailment (non-reserves)'%res_share%%em_share%,dsm_curt,h) = DSM_lc.l(dsm_curt,h) ;
        report_tech_hours('load shift pos (non-reserves)'%res_share%%em_share%,dsm_shift,h) = DSM_up_demand.l(dsm_shift,h) ;
        report_tech_hours('load shift neg (non-reserves)'%res_share%%em_share%,dsm_shift,h) = DSM_do_demand.l(dsm_shift,h) ;
        report_tech('Capacity share'%res_share%%em_share%,dsm_curt) = N_dsmLC.l(dsm_curt) / report('Capacity total'%res_share%%em_share%) + 1e-9 ;
        report_tech('Capacity share'%res_share%%em_share%,dsm_shift) = N_dsmLS.l(dsm_shift) / report('Capacity total'%res_share%%em_share%) + 1e-9 ;
        report_tech('Energy share'%res_share%%em_share%,dsm_curt) = sum( h , DSM_lc.l(dsm_curt,h) - corr_fac_dsmLC(dsm_curt,h) )  / report('Energy total'%res_share%%em_share%) * %sec_hour% + 1e-9 ;
        report_tech('Energy share'%res_share%%em_share%,dsm_shift) = sum( h , DSM_do_demand.l(dsm_shift,h) - corr_fac_dsmLS(dsm_shift,h) ) / report('Energy total'%res_share%%em_share%) * %sec_hour% + 1e-9 ;
*        report_tech('Load shift pos absolute'%res_share%%em_share%,dsm_shift) = sum( h , DSM_up.l(dsm_shift,h) ) ;
*        report_tech('Load shift neg absolute'%res_share%%em_share%,dsm_shift) = sum( (h,hh) , DSM_do.l(dsm_shift,h,hh) ) ;
        report_tech('Load shift pos absolute (non-reserves)'%res_share%%em_share%,dsm_shift) = sum( h , DSM_up_demand.l(dsm_shift,h) ) ;
        report_tech('Load shift neg absolute (non-reserves)'%res_share%%em_share%,dsm_shift) = sum( h , DSM_do_demand.l(dsm_shift,h) ) ;
        report_tech('Marginals'%res_share%%em_share%,dsm_curt)$N_dsmLC.l(dsm_curt) = -con8e_maxI_dsmLC.m(dsm_curt) ;
        report_tech('Marginals'%res_share%%em_share%,dsm_shift)$N_dsmLS.l(dsm_shift) = -con8f_maxI_dsmLS_pos.m(dsm_shift) ;
$ontext
$offtext

%reserves%$ontext
        report_reserves('reserve provision requirements'%res_share%%em_share%,'PRL') = reserves_fraction_PRL * sum( reserves$( ord(reserves) > 1 ) ,  (1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ) ;
        report_reserves('reserve provision requirements'%res_share%%em_share%,reserves)$(ord(reserves) > 1) = 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) ) ;

        report_reserves_tech('reserve provision shares'%res_share%%em_share%,'PRL',ct) = sum( h , prov_resrv_con.l('PRL',ct,h)) / (reserves_fraction_PRL * sum( reserves$( ord(reserves) > 1 ) ,  (card(h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) )) ;
        report_reserves_tech('reserve provision shares'%res_share%%em_share%,'PRL',res) = sum( h , prov_resrv_res.l('PRL',res,h)) / (reserves_fraction_PRL * sum( reserves$( ord(reserves) > 1 ) ,  (card(h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) )) ;
        report_reserves_tech('reserve provision shares'%res_share%%em_share%,'PRL',sto) = sum( h , prov_resrv_sto.l('PRL',sto,h)) / (reserves_fraction_PRL * sum( reserves$( ord(reserves) > 1 ) ,  (card(h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ));

        report_reserves_tech('reserve provision shares'%res_share%%em_share%,reserves,ct)$( ord(reserves) > 1 ) = sum( h , prov_resrv_con.l(reserves,ct,h)) / (card(h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) ) ) ;
        report_reserves_tech('reserve provision shares'%res_share%%em_share%,reserves,res)$( ord(reserves) > 1 ) = sum( h , prov_resrv_res.l(reserves,res,h)) / (card(h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;
        report_reserves_tech('reserve provision shares'%res_share%%em_share%,reserves,sto)$( ord(reserves) > 1 ) = sum( h , prov_resrv_sto.l(reserves,sto,h)) / (card(h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;

        report_reserves_tech('reserve activation shares'%res_share%%em_share%,reserves,ct)$( ord(reserves) > 1 ) = sum(h,prov_resrv_con.l(reserves,ct,h)*reserves_active(reserves,h)) / sum( h , reserves_active(reserves,h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;
        report_reserves_tech('reserve activation shares'%res_share%%em_share%,reserves,res)$( ord(reserves) > 1 ) = sum(h,prov_resrv_res.l(reserves,res,h)*reserves_active(reserves,h)) / sum( h , reserves_active(reserves,h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;
        report_reserves_tech('reserve activation shares'%res_share%%em_share%,reserves,sto)$( ord(reserves) > 1 ) = sum(h,prov_resrv_sto.l(reserves,sto,h)*reserves_active(reserves,h)) / sum( h , reserves_active(reserves,h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;

        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,'PRL','required',h) = report_reserves('reserve provision requirements'%res_share%%em_share%,'PRL') ;
        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,reserves,'required',h)$(ord(reserves) > 1) = report_reserves('reserve provision requirements'%res_share%%em_share%,reserves) ;
        report_reserves_tech_hours('Reserves activation'%res_share%%em_share%,reserves,'required',h)$(ord(reserves) > 1) = reserves_active(reserves,h) * report_reserves('reserve provision requirements'%res_share%%em_share%,reserves) ;

        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,'PRL',ct,h) = prov_resrv_con.l('PRL',ct,h) ;
        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,reserves,ct,h)$(ord(reserves) > 1) = prov_resrv_con.l(reserves,ct,h) ;
        report_reserves_tech_hours('Reserves activation'%res_share%%em_share%,reserves,ct,h)$(ord(reserves) > 1) = prov_resrv_con.l(reserves,ct,h)*reserves_active(reserves,h) ;

        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,'PRL',res,h) = prov_resrv_res.l('PRL',res,h) ;
        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,reserves,res,h)$(ord(reserves) > 1) = prov_resrv_res.l(reserves,res,h) ;
        report_reserves_tech_hours('Reserves activation'%res_share%%em_share%,reserves,res,h)$(ord(reserves) > 1) = prov_resrv_res.l(reserves,res,h)*reserves_active(reserves,h) ;

        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,'PRL',sto,h) = prov_resrv_sto.l('PRL',sto,h) ;
        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,reserves,sto,h)$(ord(reserves) > 1) = prov_resrv_sto.l(reserves,sto,h) ;
        report_reserves_tech_hours('Reserves activation'%res_share%%em_share%,reserves,sto,h)$(ord(reserves) > 1) = prov_resrv_sto.l(reserves,sto,h)*reserves_active(reserves,h) ;
$ontext
$offtext

%DSM%$ontext
%reserves%$ontext
        report_reserves_tech('reserve provision shares'%res_share%%em_share%,reserves,dsm_curt)$( ord(reserves) > 1 ) = sum( h , prov_resrv_dsmLC.l(reserves,dsm_curt,h)) / ( card(h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;
        report_reserves_tech('reserve provision shares'%res_share%%em_share%,reserves,dsm_shift)$( ord(reserves) > 1 ) = sum( h , prov_resrv_dsmLS.l(reserves,dsm_shift,h)) / ( card(h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;
        report_reserves_tech('reserve activation shares'%res_share%%em_share%,reserves,dsm_curt)$( ord(reserves) > 1 ) = sum( h , prov_resrv_dsmLC.l(reserves,dsm_curt,h)*reserves_active(reserves,h)) / sum( h , reserves_active(reserves,h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;
        report_reserves_tech('reserve activation shares'%res_share%%em_share%,reserves,dsm_shift)$( ord(reserves) > 1 ) = sum( h , prov_resrv_dsmLS.l(reserves,dsm_shift,h) * reserves_active(reserves,h)) / sum( h , reserves_active(reserves,h) * 1000 * reserves_share(reserves) * (reserves_intercept(reserves) + sum(resres,reserves_slope(reserves,resres) * N_res.l(resres)/1000) )) ;

        report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,reserves,dsm_curt)$(N_dsmLC.l(dsm_curt) AND (ord(reserves) = 2 OR ord(reserves) = 4)) = sum(h ,  prov_resrv_dsmLC.l(reserves,dsm_curt,h) * reserves_active(reserves,h)) / sum(h , DSM_lc.l(dsm_curt,h) - corr_fac_dsmLC(dsm_curt,h) ) ;

        report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,'Up - Pos reserve',dsm_shift)$(N_dsmLS.l(dsm_shift)) = sum( (h,reserves)$( (ord(reserves) = 2 OR ord(reserves) = 4 ) AND DSM_up_demand.l(dsm_shift,h) ) , prov_resrv_dsmLS.l(reserves,dsm_shift,h) * reserves_active(reserves,h) ) / sum( h , DSM_up_demand.l(dsm_shift,h))  ;
        report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,'Up - Neg reserve',dsm_shift)$(N_dsmLS.l(dsm_shift)) = sum( (h,reserves)$( (ord(reserves) = 3 OR ord(reserves) = 5 ) AND DSM_up.l(dsm_shift,h) ) , prov_resrv_dsmLS.l(reserves,dsm_shift,h) * reserves_active(reserves,h) ) / sum( h , DSM_up.l(dsm_shift,h))  ;
        report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,'Do - Pos reserve',dsm_shift)$(N_dsmLS.l(dsm_shift)) = sum( (h,reserves)$( (ord(reserves) = 2 OR ord(reserves) = 4 ) AND sum(hh , DSM_do.l(dsm_shift,hh,h)) ) , prov_resrv_dsmLS.l(reserves,dsm_shift,h) * reserves_active(reserves,h) ) / sum( (h,hh) , DSM_do.l(dsm_shift,h,hh))  ;
        report_reserves_tech('Reserves activation ratio'%res_share%%em_share%,'Do - Neg reserve',dsm_shift)$(N_dsmLS.l(dsm_shift)) = sum( (h,reserves)$( (ord(reserves) = 3 OR ord(reserves) = 5 ) AND DSM_do_demand.l(dsm_shift,h) ) , prov_resrv_dsmLS.l(reserves,dsm_shift,h) * reserves_active(reserves,h) ) / sum( (h,hh) , DSM_do_demand.l(dsm_shift,h))  ;

        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,reserves,dsm_shift,h)$(ord(reserves) > 1) = prov_resrv_dsmLS.l(reserves,dsm_shift,h) ;
        report_reserves_tech_hours('Reserves activation'%res_share%%em_share%,reserves,dsm_shift,h)$(ord(reserves) > 1) = prov_resrv_dsmLS.l(reserves,dsm_shift,h)*reserves_active(reserves,h) ;
        report_reserves_tech_hours('Reserves provision'%res_share%%em_share%,reserves,dsm_curt,h)$(ord(reserves) > 1) = prov_resrv_dsmLC.l(reserves,dsm_curt,h) ;
        report_reserves_tech_hours('Reserves activation'%res_share%%em_share%,reserves,dsm_curt,h)$(ord(reserves) > 1) = prov_resrv_dsmLC.l(reserves,dsm_curt,h)*reserves_active(reserves,h) ;
$ontext
$offtext

* Clear variables and equations to speed up calculation
$include clear.gms

* Close loop_res_share
%renewable_share%$ontext
);
$ontext
$offtext

* Read out solutions
%reserves%execute_unload "results", report, report_tech, report_tech_hours, report_hours ;
%reserves%$ontext
execute_unload "results", report, report_tech, report_tech_hours, report_hours, report_reserves, report_reserves_tech, report_reserves_tech_hours ;
$ontext
$offtext

%write_to_excel%$ontext
$include report_to_excel
$ontext
$offtext


* ---------------------------------------------------------------------------- *
* ---------------------------------------------------------------------------- *
* ---------------------------------------------------------------------------- *
