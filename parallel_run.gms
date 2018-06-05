

phi_min_res = min_res('scen%scen%') ;
ev_quant = number_ev('scen%scen%') ;
phi_pro_self = pro_selfcon('scen%scen%') ;
gas_demand = hydrogen_demand('scen%scen%');
heat_share = heat_level('scen%scen%');


solve DIETER using lp min Z ;



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

modelstat(superscen)
;
modelstat('scen%scen%') = dieter.modelStat  ;

if(dieter.modelStat eq 1,

         Portfolio_Generation(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,tech)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g) and sameas(scen,'scen%scen%')) , N_TECH.l('DE',tech) );

         Portfolio_Storages('Energy',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)  and sameas(scen,'scen%scen%')) , N_STO_E.l('DE',sto) );
         Portfolio_Storages('Power',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)  and sameas(scen,'scen%scen%')) , N_STO_P.l('DE',sto) );

         Portfolio_Hydrogen('P2G',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,p2g)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)  and sameas(scen,'scen%scen%')) , N_P2G.l('DE',p2g) );
         Portfolio_Hydrogen('G2P',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,p2g)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)  and sameas(scen,'scen%scen%')) , N_G2P.l('DE',p2g) );
         Portfolio_Hydrogen('Storage',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,p2g)  = sum(scen$(map(scen,loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g)  and sameas(scen,'scen%scen%')) , N_GS.l('DE',p2g) );

         Investment_Generation(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,tech) = c_i('DE',tech)*Portfolio_Generation(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,tech) ;
         Investment_Storages(loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto) = c_i_sto_e('DE',sto)**Portfolio_Storages('Energy',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto)
                                                                                             + c_i_sto_p('DE',sto)**Portfolio_Storages('Power',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,sto);

         Investment_Hydro('P2G',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,electrolyzer) = c_i_p2g('DE',electrolyzer)*Portfolio_Hydrogen('P2G',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,electrolyzer) ;
         Investment_Hydro('G2P',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,fuelcell) = c_i_p2g('DE',fuelcell)*Portfolio_Hydrogen('G2P',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,fuelcell) ;
         Investment_Hydro('Storage',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,gasstorage) = c_i_p2g('DE',gasstorage)*Portfolio_Hydrogen('Storage',loop_res_share,loop_ev,loop_prosumage,loop_heat,loop_p2g,gasstorage) ;
);

execute_unload "results/gdx/summary_scen%scen%",
Investment_Generation,
Investment_Storages,
Investment_Hydro,

Portfolio_Generation,
Portfolio_Storages,
Portfolio_Hydrogen,

modelstat
;




$stop
