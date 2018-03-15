
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


*********************************************
**** Defines and uploads parameters      ****
*********************************************


Parameters

***** Conventionals *****

*--- Generation and fixed ---*
con_eta(ct)              Efficiency of conventional technologies
con_carbon_content(ct)   CO2 emissions per fuel unit used
c_up(ct)                 Load change costs UP in EUR per MW
c_do(ct)                 Load change costs DOWN in EUR per MW
fix_con(ct)              Annual fixed costs per MW
var_OM_con(ct)           Variable O&M costs per MWh

*--- Investment ---*
inv_overnight(ct)        Investment costs: Overnight
inv_lifetime(ct)         Investment costs: technical lifetime
inv_recovery(ct)         Investment costs: Recovery period according to depreciation tables
inv_interest(ct)         Investment costs: Interest rate
M_con(ct)                Investment: maximum installable capacity per technology
M_con_ene(ct)            Investment: maximum installable energy in TWh per a

*--- Flexibility ---*
grad_per_min(ct)         Maximum load change per minute relative to installed capacity


***** Fuel and CO2 costs *****

con_fuelprice(ct)        Fuel price conventionals in Euro per MWth
con_CO2price             CO2 price


***** Renewables *****

*--- Generation and fixed costs ---*
c_curt(res)              Hourly Curtailment costs for renewables per MW
fix_res(res)             Annual fixed costs per MW
sigma_minRES             Upload parameter: Minimum required renewables generation

*--- Investment ---*
inv_overnight_res(res)   Investment costs: Overnight
inv_lifetime_res(res)    Investment costs: technical lifetime
inv_recovery_res(res)    Investment costs: Recovery period
inv_interest_res(res)    Investment costs: Interest rate
M_res(res)               Investment: maximum installable capacity
M_res_ene(res)           Investment: maximum installable energy in TWh per a


***** Time Data *****

D_y(year,h)              Demand hour h for cost minimization for different years
D(h)                     Demand hour h for cost minimization
price_data(h)            Spot market prices 2012
phi_res_y(year,res,h)    Renewables availability technology res in hour h for different years
phi_res(res,h)           Renewables availability technology res in hour h
phi_ror(h)               Run-of-river availability in hour h

upload_elasticity        Upload parameter for demand elasticity
elasticity               Demand elasticity
alpha(h)                 Reservation price hour h for elastic demand
beta(h)                  Slope on linear demand curve hour h


***** Storage *****

*--- Generation and fixed costs ---*
c_sm(sto)                Marginal costs of storing out
eta_sto(sto)             Storage efficiency
eta_sto_in(sto)          Storage loading efficiency
eta_sto_out(sto)         Storage discharging efficiency
sto_lev_start(sto)       Initial storage level
EtoP_max(sto)            Maximum E to P ratio of storage types
fix_sto(sto)             Annual fixed costs per MW

*--- Investment ---*
sto_overnight_MWh(sto)   Investment costs for storage energy in MWh: Overnight
sto_overnight_MW(sto)    Investment costs for storage capacity in MW: Overnight
sto_lifetime(sto)        Investment costs for storage: technical lifetime
sto_recovery(sto)        Investment costs for storage: Recovery period
sto_interest(sto)        Investment costs for storage: Interest rate
M_stoE(sto)              Investment into storage: maximum installable energy in MWh
M_stoC(sto)              Investment into storage: maximum installable capacity in MW


***** DSM *****

*--- Generation and fixed costs ---*
c_DSMlc(dsm_curt)        DSM: hourly costs of load curtailment
c_DSMls(dsm_shift)       DSM: costs for load shifting
fix_dsmLC(dsm_curt)      Annual fixed costs per MW load curtailment capacity
fix_dsmLS(dsm_shift)     Annual fixed costs per MW load shifting capacity

*--- Flexibility, efficiency, recovery ---*
dsm_durLC(dsm_curt)            DSM: Maximum duration load curtailment
dsm_offtimeLC(dsm_curt)        DSM: Minimum recovery time between two load curtailment instances

dsm_durLS(dsm_shift)           DSM: Maximum duration load shifting
dsm_offtimeLS(dsm_shift)       DSM: Minimum recovery time between two granular load upshift instances
eta_dsmLS(dsm_shift)           DSM: Efficiency of load shifting technologies

*--- Investment ---*
dsm_overnight_lc(dsm_curt)       Investment costs for DSM load curtailment: Overnight
dsm_overnight_ls(dsm_shift)      Investment costs for DSM load shifting: Overnight
dsm_recovery_lc(dsm_curt)        Investment costs for DSM load curtailment: Recovery period
dsm_recovery_ls(dsm_shift)       Investment costs for DSM load shifting: Recovery period
dsm_interest_lc(dsm_curt)        Investment costs for DSM load curtailment: Interest rate
dsm_interest_ls(dsm_shift)       Investment costs for DSM load shifting: Interest rate
M_dsmLC(dsm_curt)                DSM: Maximum installable capacity load curtailment
M_dsmLS(dsm_shift)               DSM: Maximum installable capacity load shifting



***** Reserves *****

reserves_share(reserves)                 Shares of SRL and MRL up and down
reserves_intercept(reserves)
reserves_slope(reserves,res)
reserves_active_y(year,reserves,h)       Hourly share of reserve provision that is actually activated
reserves_active(reserves,h)              Hourly share of reserve provision that is actually activated
reserves_fraction_PRL
;


********************************************************************************


$onecho >temp.tmp
par=con_eta              rng=Conventionals!c5:d12        rdim=1 cdim=0
par=con_carbon_content   rng=Conventionals!c15:d22       rdim=1 cdim=0
par=c_up                 rng=Conventionals!c105:d112     rdim=1 cdim=0
par=c_do                 rng=Conventionals!c115:d122     rdim=1 cdim=0
par=fix_con              rng=Conventionals!c25:d32       rdim=1 cdim=0
par=var_OM_con           rng=Conventionals!c35:d42       rdim=1 cdim=0
par=inv_overnight        rng=Conventionals!c45:d52       rdim=1 cdim=0
par=inv_lifetime         rng=Conventionals!c55:d62       rdim=1 cdim=0
par=inv_recovery         rng=Conventionals!c65:d72       rdim=1 cdim=0
par=inv_interest         rng=Conventionals!c75:d82       rdim=1 cdim=0
par=M_con                rng=Conventionals!c85:d92       rdim=1 cdim=0
par=M_con_ene            rng=Conventionals!c95:d102      rdim=1 cdim=0
par=grad_per_min         rng=Conventionals!c125:d132     rdim=1 cdim=0

par=c_curt               rng=Renewables!c4:d6            rdim=1 cdim=0
par=fix_res              rng=Renewables!c9:d11           rdim=1 cdim=0
par=sigma_minRES         rng=Renewables!d46:d46          rdim=0 cdim=0
par=inv_overnight_res    rng=Renewables!c15:d17          rdim=1 cdim=0
par=inv_lifetime_res     rng=Renewables!c20:d22          rdim=1 cdim=0
par=inv_recovery_res     rng=Renewables!c25:d27          rdim=1 cdim=0
par=inv_interest_res     rng=Renewables!c30:d32          rdim=1 cdim=0
par=M_res                rng=Renewables!c35:d37          rdim=1 cdim=0
par=M_res_ene            rng=Renewables!c40:d42          rdim=1 cdim=0

par=con_fuelprice        rng=Fuel_CO2!a4:b12             rdim=1 cdim=0
par=con_CO2price         rng=Fuel_CO2!b18:b18            rdim=0 cdim=0

par=upload_elasticity    rng=Time_Data!b34:c34           rdim=1 cdim=0
par=D_y                  rng=Time_Data!c48:lya52         rdim=1 cdim=1
par=price_data           rng=Time_Data!d12:lya13         rdim=0 cdim=1
par=phi_res_y            rng=Time_Data!b55:lya67         rdim=2 cdim=1
par=phi_ror              rng=Time_Data!d30:lya31         rdim=0 cdim=1

par=c_DSMls              rng=DSM!c10:d14         rdim=1 cdim=0
par=fix_dsmLS            rng=DSM!c20:d24         rdim=1 cdim=0
par=dsm_overnight_ls     rng=DSM!c33:d37         rdim=1 cdim=0
par=dsm_recovery_ls      rng=DSM!c43:d47         rdim=1 cdim=0
par=dsm_interest_ls      rng=DSM!c52:d56         rdim=1 cdim=0
par=M_dsmLS              rng=DSM!c64:d68         rdim=1 cdim=0
par=dsm_durLS            rng=DSM!c74:d78         rdim=1 cdim=0
par=dsm_offtimeLS        rng=DSM!c83:d87         rdim=1 cdim=0
par=eta_dsmLS            rng=DSM!c92:d96         rdim=1 cdim=0

par=c_DSMlc              rng=DSM!c5:d7           rdim=1 cdim=0
par=fix_dsmLC            rng=DSM!c17:d19         rdim=1 cdim=0
par=dsm_overnight_lc     rng=DSM!c28:d30         rdim=1 cdim=0
par=dsm_recovery_lc      rng=DSM!c40:d42         rdim=1 cdim=0
par=dsm_interest_lc      rng=DSM!c49:d51         rdim=1 cdim=0
par=M_dsmLC              rng=DSM!c59:d61         rdim=1 cdim=0
par=dsm_durLC            rng=DSM!c71:d73         rdim=1 cdim=0
par=dsm_offtimeLC        rng=DSM!c80:d82         rdim=1 cdim=0

par=c_sm                 rng=Storage!c4:d10       rdim=1 cdim=0
par=eta_sto              rng=Storage!c13:d19      rdim=1 cdim=0
par=fix_sto              rng=Storage!c22:d28     rdim=1 cdim=0
par=sto_overnight_MWh    rng=Storage!c31:d37     rdim=1 cdim=0
par=sto_overnight_MW     rng=Storage!c40:d46     rdim=1 cdim=0
par=sto_lifetime         rng=Storage!c48:d54     rdim=1 cdim=0
*par=sto_recovery         rng=Storage!c32:d34     rdim=1 cdim=0
par=sto_interest         rng=Storage!c60:d66     rdim=1 cdim=0
par=M_stoE               rng=Storage!c69:d75     rdim=1 cdim=0
par=M_stoC               rng=Storage!c77:d83     rdim=1 cdim=0
par=sto_lev_start        rng=Storage!c85:d91     rdim=1 cdim=0
par=EtoP_max             rng=Storage!c93:d99     rdim=1 cdim=0

par=reserves_share       rng=Reserves!e13:f16    rdim=1 cdim=0
par=reserves_intercept   rng=Reserves!e2:f5      rdim=1 cdim=0
par=reserves_slope       rng=Reserves!d6:g10     rdim=1 cdim=1
*par=reserves_active      rng=Reserves!c32:lya36 rdim=1 cdim=1
par=reserves_active_y    rng=Reserves!b44:lya60  rdim=2 cdim=1
par=reserves_fraction_PRL rng=Reserves!d75:d75   rdim=0 cdim=0
$offecho

%skip_Excel%$call "gdxxrw Data_Input.xlsx @temp.tmp o=Data_input";

$GDXin Data_input.gdx
$load D_y price_data phi_ror phi_res_y
$load con_eta con_carbon_content c_up c_do fix_con var_OM_con inv_overnight inv_lifetime inv_recovery inv_interest M_con M_con_ene grad_per_min
$load con_fuelprice con_CO2price
$load c_curt fix_res sigma_minRES inv_overnight_res inv_lifetime_res inv_recovery_res inv_interest_res M_res M_res_ene
$load c_sm eta_sto fix_sto sto_overnight_MWh sto_overnight_MW sto_lifetime sto_interest M_stoE M_stoC sto_lev_start EtoP_max
$load c_DSMls fix_dsmLS dsm_overnight_ls dsm_recovery_ls dsm_interest_ls M_dsmLS dsm_durLS eta_dsmLS dsm_offtimeLS
$load c_DSMlc fix_dsmLC dsm_overnight_lc dsm_recovery_lc dsm_interest_lc M_dsmLC dsm_durLC dsm_offtimeLC
$load reserves_share reserves_intercept reserves_slope reserves_active_y reserves_fraction_PRL
;


********************************************************************************


Parameters
c_m(ct)        Marginal production costs for conventional plants including variable O and M costs
c_i(ct)        Annualized investment costs by conventioanl plant per MW

c_ri(res)      Annualized investment costs by renewable plant per MW

c_siE(sto)     Annualized investment costs storage energy per MWh
c_siC(sto)     Annualized investment costs storage capacity per MW

c_DSMiLC(dsm_curt)     DSM: Investment costs load curtailment
c_DSMiLS(dsm_shift)    DSM: Investment costs load shifting
;

c_m(ct) = con_fuelprice(ct)/con_eta(ct) + con_carbon_content(ct)/con_eta(ct)*con_CO2price + var_OM_con(ct)   ;
c_i(ct) = inv_overnight(ct)*( inv_interest(ct) * (1+inv_interest(ct))**(inv_lifetime(ct)) )
                 / ( (1+inv_interest(ct))**(inv_lifetime(ct))-1 )       ;

c_ri(res) = inv_overnight_res(res)*( inv_interest_res(res) * (1+inv_interest_res(res))**(inv_lifetime_res(res)) )
                 / ( (1+inv_interest_res(res))**(inv_lifetime_res(res))-1 )       ;

c_siE(sto) = sto_overnight_MWh(sto)*( sto_interest(sto) * (1+sto_interest(sto))**(sto_lifetime(sto)) )
                 / ( (1+sto_interest(sto))**(sto_lifetime(sto))-1 )       ;
c_siC(sto) = sto_overnight_MW(sto)*( sto_interest(sto) * (1+sto_interest(sto))**(sto_lifetime(sto)) )
                 / ( (1+sto_interest(sto))**(sto_lifetime(sto))-1 )       ;

c_DSMiLC(dsm_curt) = dsm_overnight_lc(dsm_curt)*( dsm_interest_lc(dsm_curt) * (1+dsm_interest_lc(dsm_curt))**(dsm_recovery_lc(dsm_curt)) )
                 / ( (1+dsm_interest_lc(dsm_curt))**(dsm_recovery_lc(dsm_curt))-1 )       ;
c_DSMiLS(dsm_shift) = dsm_overnight_ls(dsm_shift)*( dsm_interest_ls(dsm_shift) * (1+dsm_interest_ls(dsm_shift))**(dsm_recovery_ls(dsm_shift)) )
                 / ( (1+dsm_interest_ls(dsm_shift))**(dsm_recovery_ls(dsm_shift))-1 )       ;



* Adjust investment costs on model's hourly basis

c_i(ct) = c_i(ct)*card(h)/8760 ;
c_ri(res) = c_ri(res)*card(h)/8760 ;
%second_hour%c_siE(sto) = c_siE(sto)*card(h)/8760 ;
c_siC(sto) = c_siC(sto)*card(h)/8760 ;
c_DSMiLC(dsm_curt) = c_DSMiLC(dsm_curt)*card(h)/8760 ;
c_DSMiLS(dsm_shift) = c_DSMiLS(dsm_shift)*card(h)/8760 ;
%second_hour%$ontext
c_siE(sto) = c_siE(sto)*card(h)/8760 * 2 ;
dsm_durLC(dsm_curt) = dsm_durLC(dsm_curt) / 2 ;
dsm_offtimeLC(dsm_curt) = dsm_offtimeLC(dsm_curt) / 2 ;
dsm_durLS(dsm_shift)$(ord(dsm_shift)=2 or ord(dsm_shift)=4 or ord(dsm_shift)=5) = dsm_durLS(dsm_shift) / 2 ;
dsm_durLS(dsm_shift)$(ord(dsm_shift)=1 or ord(dsm_shift)=3) = 2 ;
$ontext
$offtext

fix_con(ct) = fix_con(ct)*card(h)/8760 ;
fix_res(res) = fix_res(res)*card(h)/8760 ;
fix_sto(sto) = fix_sto(sto)*card(h)/8760 ;
fix_dsmLC(dsm_curt) = fix_dsmLC(dsm_curt)*card(h)/8760 ;
fix_dsmLS(dsm_shift) = fix_dsmLS(dsm_shift)*card(h)/8760 ;

M_con_ene('bio') = M_con_ene('bio')*card(h)/8760 ;

eta_sto_in(sto) = 0.5*eta_sto(sto);
eta_sto_out(sto) = 0.5*eta_sto(sto);

parameter mean_reserves_call, mean_reserves_call_y ;
mean_reserves_call_y(year,reserves) = sum(h, reserves_active_y(year,reserves,h) ) / card(h) + eps ;



