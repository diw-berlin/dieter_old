
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

*****************************************
**** Scenario file                   ****
**** only restrictions on parameters ****
*****************************************

* For example, PV costs decrease by 50%
*c_ri('Solar') = 0.5 * c_ri('Solar') ;

* Without V2G:
*EV_DISCHARGE.fx(ev,h) = 0 ;

* Electric vehicles do not provide reserves (G2V and/or V2G):
*RP_EV_G2V.fx(reserves,ev,h) = 0 ;
*RP_EV_V2G.fx(reserves,ev,h) = 0 ;

