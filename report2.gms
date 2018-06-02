
execute_unload "results/raw_results",
marginal_con5a,
marginal_con1a,
marginal_con9a,
marginal_con9b,

* Basic
lev_Z,
lev_G_L,
lev_G_UP,
lev_G_DO,
lev_G_RES,
lev_CU,
lev_STO_IN,
lev_STO_OUT,
lev_STO_L,
lev_N_TECH,
lev_N_STO_E,
lev_N_STO_P,
lev_NTC,
lev_F,
lev_RSVR_OUT,
lev_RSVR_L,
lev_N_RSVR_E,
lev_N_RSVR_P,

* EV
lev_EV_CHARGE,
lev_EV_DISCHARGE,
lev_EV_L,
lev_EV_PHEVFUEL,
lev_EV_GED,

* DSM
lev_DSM_CU,
lev_DSM_UP,
lev_DSM_DO,
lev_DSM_UP_DEMAND,
lev_DSM_DO_DEMAND,
lev_N_DSM_CU,
lev_N_DSM_SHIFT,

* Reserves
lev_RP_DIS,
lev_RP_NONDIS,
lev_RP_STO_IN,
lev_RP_STO_OUT,
lev_RP_RSVR,

* EV & reserves
lev_RP_EV_V2G,
lev_RP_EV_G2V,

* DSM $ reserves
lev_RP_DSM_CU,
lev_RP_DSM_SHIFT,

* Prosumage
lev_CU_PRO,
lev_G_MARKET_PRO2M,
lev_G_MARKET_M2PRO,
lev_G_RES_PRO,
lev_STO_IN_PRO2PRO,
lev_STO_IN_PRO2M,
lev_STO_IN_M2PRO,
lev_STO_IN_M2M,
lev_STO_OUT_PRO2PRO,
lev_STO_OUT_PRO2M,
lev_STO_OUT_M2PRO,
lev_STO_OUT_M2M,
lev_STO_L_PRO2PRO,
lev_STO_L_PRO2M,
lev_STO_L_M2PRO,
lev_STO_L_M2M,
lev_N_STO_E_PRO,
lev_N_STO_P_PRO,
lev_STO_L_PRO,
lev_N_RES_PRO,

* Heat
lev_H_DIR,
lev_H_SETS_LEV,
lev_H_SETS_IN,
lev_H_SETS_OUT,
lev_H_HP_IN,
lev_H_STO_LEV,
lev_H_STO_IN_HP,
lev_H_STO_IN_ELECTRIC,
lev_H_ELECTRIC_IN,
lev_H_STO_IN_FOSSIL,
lev_H_STO_OUT,

lev_H_DHW_STO,
lev_H_DHW_STO_OUT,
lev_H_DHW_DIR,

lev_H_DHW_AUX_ELEC_IN,
lev_H_DHW_AUX_LEV,
lev_H_DHW_AUX_OUT,


lev_RP_SETS,
lev_RP_HP,
lev_RP_H_ELEC,
lev_RP_SETS_AUX,

* P2G
lev_G_P2G,
lev_G_G2P,
lev_GS_STO_IN,
lev_GS_STO_OUT,
lev_GS_STO_L,
lev_N_GS,
lev_N_P2G,
lev_N_G2P,

* Infeasibility
lev_G_INFES,
lev_G_P2G_INFEAS ;



Parameter
Investment_Generation(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,tech)
Investment_Storages(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto)
Investment_Hydro(*,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,p2g)

Portfolio_Generation(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,tech)
Portfolio_Storages(*,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto)
Portfolio_Hydrogen(*,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,p2g)

Electricity_generated
EE_Curtailment
FullLoadHours
;

Portfolio_Generation(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,tech)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)) , lev_N_TECH(scen,'DE',tech) );

Portfolio_Storages('Energy',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)) , lev_N_STO_E(scen,'DE',sto) );
Portfolio_Storages('Power',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)) , lev_N_STO_P(scen,'DE',sto) );

Portfolio_Hydrogen('P2G',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,p2g)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)) , lev_N_P2G(scen,'DE',p2g) );
Portfolio_Hydrogen('G2P',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,p2g)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)) , lev_N_G2P(scen,'DE',p2g) );
Portfolio_Hydrogen('Storage',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,p2g)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)) , lev_N_GS(scen,'DE',p2g) );

Investment_Generation(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,tech) = c_i('DE',tech)*Portfolio_Generation(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,tech) ;
Investment_Storages(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto) = c_i_sto_e('DE',sto)**Portfolio_Storages('Energy',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto)
                                                                                    + c_i_sto_p('DE',sto)**Portfolio_Storages('Power',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto);

Investment_Hydro('P2G',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,electrolyzer) = c_i_p2g('DE',electrolyzer)*Portfolio_Hydrogen('P2G',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,electrolyzer) ;
Investment_Hydro('G2P',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,fuelcell) = c_i_p2g('DE',fuelcell)*Portfolio_Hydrogen('G2P',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,fuelcell) ;
Investment_Hydro('Storage',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,gasstorage) = c_i_p2g('DE',gasstorage)*Portfolio_Hydrogen('Storage',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,gasstorage) ;


execute_unload "results/summary",
Investment_Generation,
Investment_Storages,
Investment_Hydro,

Portfolio_Generation,
Portfolio_Storages,
Portfolio_Hydrogen

*Electricity_generated  ,
*EE_Curtailment,
*FullLoadHours
;
