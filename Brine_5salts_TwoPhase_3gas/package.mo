within BrineProp;
package Brine_5salts_TwoPhase_3gas "Aqueous Solution of NaCl, KCl, CaCl2, MgCl2, SrCl2, N2, CO2, CH4"

//  extends PartialBrine_Multi_TwoPhase_ngas(
//  extends PartialBrine_ngas_model(


  extends PartialBrine_ngas_Newton(
    redeclare package Salt_data = BrineProp.SaltData_Duan,
    final gasNames = {"carbondioxide","nitrogen","methane"},
    final saltNames = {"sodium chloride","potassium chloride","calcium chloride","magnesium chloride","strontium chloride"},
    final MM_gas = {M_CO2,M_N2,M_CH4},
    final nM_gas = {nM_CO2,nM_N2,nM_CH4},
    final MM_salt = Salt_data.MM_salt,
    final nM_salt = Salt_data.nM_salt);
//    final MM_salt = {Salt_data.M_NaCl, Salt_data.M_KCl, Salt_data.M_CaCl2, Salt_data.M_MgCl2, Salt_data.M_SrCl2});

//    explicitVars="pT"

//  extends Partial_Viscosity;

//  extends Partial_Gas_Data;

/*
  redeclare function extends massFractionsToMolalities 
    "is apparently needed so that array arguments in extend-call work"
  end massFractionsToMolalities;
*/


  redeclare function extends fugacity_pTX
  "solubility calculation of CO2 in seawater Duan,Sun(2003)"
  algorithm
    if substancename =="carbondioxide" then
      phi := BrineProp.PartialGasData.fugacity_CO2_Duan2006(
                                                    p,T);
    elseif substancename =="nitrogen" then
      phi := BrineProp.PartialGasData.fugacity_N2(
                                          p,T,X,MM);
    elseif substancename =="methane" then
      phi := BrineProp.PartialGasData.fugacity_CH4_Duan1992(
                                                    p,T,X,MM);
    elseif substancename =="water" then
      phi := BrineProp.PartialGasData.fugacity_H2O(
                                           p,T,X,MM);
    end if;
  end fugacity_pTX;


  redeclare function extends setState_pTX
  "is apparently needed so that array arguments work"
  end setState_pTX;


  redeclare function extends solubilities_pTX
  "solubility calculation of CO2 in seawater Duan, Sun(2003), returns gas concentration in kg/kg H2O"
  //  Modelica.SIunits.Temperature T_corr = T "max(273.16,min(400,T)) TODO";
  //  Modelica.SIunits.MassFraction c_min=1e-5;
  //  Modelica.SIunits.MassFraction[:] X_l_corr=cat(1,X_l[1:nX_salt],{max(X_l[nX_salt+1],c_min),max(X_l[nX_salt+2],c_min), max(X_l[nX_salt+3],c_min), X_l[end]});
  algorithm
  //  if gasname =="carbondioxide" then
      solu[1] := if X[nX_salt+1]>0 then solubility_CO2_pTX_Duan2003(p,T,X_l,MM_vec,p_gas[1]) else -1
    "aus Partial_Gas_Data, mol/kg_H2O -> kg_CO2/kg_H2O";
  //  elseif gasname =="nitrogen" then
      solu[2] := if X[nX_salt+2]>0 then solubility_N2_pTX_Duan2006(p,T,X_l,MM_vec,p_gas[2]) else -1
    "aus Partial_Gas_Data, mol/kg_H2O -> kg_N2/kg_H2O";
  //    solu[2] := if X[nX_salt+2]>0 then solubility_N2_pTX_Harting(p,T,X_l,MM_vec,p_gas[2]) else -1
  //  elseif gasname =="methane" then
      solu[3] := if X[nX_salt+3]>0 then solubility_CH4_pTX_Duan2006(p,T,X_l,MM_vec,p_gas[3]) else -1
    "aus Partial_Gas_Data, mol/kg_H2O -> kg_CH4/kg_H2O";
  //    solu[3] := if X[nX_salt+3]>0 then solubility_CH4_pTX_Harting(p,T,X_l,MM_vec,p_gas[3]) else -1
  //  end if;

  //  Modelica.Utilities.Streams.print("X_l="+vector2string(X_l[nX_salt+1:end]));
  //  Modelica.Utilities.Streams.print("p="+String(p)+" bar, T=("+String(T)+") (solubilities_pTX)");
  //  Modelica.Utilities.Streams.print("solu[2]("+String(X[1])+")="+String(solu[2]/M_N2)+", k[1]="+String(solu[2]/p_gas[2])+"} (solubilities_pTX)");
  //  Modelica.Utilities.Streams.print("p_gas={"+String(p_gas[1])+", "+String(p_gas[2])+", "+String(p_gas[3])+"} (solubilities_pTX)");
  //  Modelica.Utilities.Streams.print("c={"+String(X_l[1])+", "+String(X_l[nX_salt+2])+", "+String(X_l[nX_salt+3])+"} (solubilities_pTX)");
  //  Modelica.Utilities.Streams.print("c={"+String(X_l_corr[nX_salt+1])+", "+String(X_l_corr[nX_salt+2])+", "+String(X_l_corr[nX_salt+3])+"} (solubilities_pTX)");
  //  Modelica.Utilities.Streams.print("k={"+String(solu[1]/p_gas[1])+", "+String(solu[2]/p_gas[2])+", "+String(solu[3]/p_gas[3])+"}(solubilities_pTX)");
  //  Modelica.Utilities.Streams.print("solu={"+String(solu[1])+", "+String(solu[2])+", "+String(solu[3])+"}(solubilities_pTX)");
  //  solu:={2.03527e-008, 4.23495e-011, 6.42528e-011};
  end solubilities_pTX;


 redeclare function extends dynamicViscosity_pTX
protected
   Modelica.SIunits.Temperature T_corr;
 algorithm
  if T<273.16 then
     Modelica.Utilities.Streams.print("T="+String(T)+" too low (<0�C), setting to 0�C in PartialBrine_ngas_Newton.quality_pTX()");
     T_corr:= max(273.16,T);
  end if;

  eta := Viscosities.dynamicViscosity_Duan_pTX(
     p,
     T_corr,
     X,
     MM_vec,
     Salt_data.saltConstants);
 end dynamicViscosity_pTX;


  redeclare function extends density_liquid_pTX
  //  PowerPlant.Media.Brine.Salt_Data_Duan.density_Duan2008_pTX;

  algorithm
  //    Modelica.Utilities.Streams.print("MM:"+String(size(MM,1))+" "+String(MM[1]));
    d := Densities.density_Duan2008_pTX(p,T,X,MM) "Defined in Salt_Data_Duan";
  //  d := Brine_Driesner.density_pTX(p,T,X[1:nX_salt],MM_salt);
  //  d := Modelica.Media.Water.WaterIF97_pT.density_pT(p,T)  "*(1+sum(X[1:nX_salt]))/X[end]";

  //   Modelica.Utilities.Streams.print("density_liquid_pTX: "+String(p*1e-5)+" bar,"+String(T)+" K->"+String(d)+"kg/m�");
  end density_liquid_pTX;


 redeclare function extends specificEnthalpy_liq_pTX
 // Partial_Units.Molality molalities = massFractionsToMoleFractions(X, MM_vec);
 //  Modelica.SIunits.SpecificEnthalpy h_H2O := Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT(p, T) "H2O";
 algorithm
 //    h_app[1] :=Brine_Driesner.specificEnthalpy_pTX(p,T,X) "NaCl";
 /*    h_app[1] :=apparentMolarEnthalpy_NaCl(p,T) "NaCl";
    h_app[2] := 0 "apparentMolarEnthalpy_KCl_Holmes1983(T)KCl";
    h_app[3] := 0 "apparentMolarEnthalpy_CaCl(p,T)CaCl2";
    h_app[4] := 0 "apparentMolarEnthalpy_MgCl2(p,T)MgCl2";
    h_app[5] := 0 "apparentMolarEnthalpy_SrCl2(p,T)0SrCl2";

    h := (h_H2O + h_app*molalities) * X[end];
*/

 //    h := SpecificEnthalpies.specificEnthalpy_pTX_Driesner(p,T,X);
     h := SpecificEnthalpies.specificEnthalpy_pTX_Francke_cp(p,T,X);

 //  Modelica.Utilities.Streams.print(String(p*1e-5)+" bar,"+String(T)+" K->"+String(h)+" J/kg (Brine_Duan_Multi_TwoPhase_ngas_3.specificEnthalpy_liq_pTX)");
 //Modelica.Utilities.Streams.print("h="+String(X[1])+"*"+String(h_vec[1])+"="+String(X[1:nX_salt]*h_vec));
 end specificEnthalpy_liq_pTX;


 redeclare function extends specificEnthalpy_gas_pTX
protected
   Modelica.SIunits.SpecificEnthalpy h_H2O_sat=Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.hv_p(p);
   Modelica.SIunits.SpecificEnthalpy h_H2O=max(h_H2O_sat, Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT(p,T))
    "damit es auch wirklich dampff�rmig ist";
   Modelica.SIunits.SpecificEnthalpy h_CO2=Modelica.Media.IdealGases.SingleGases.CO2.h_T(Modelica.Media.IdealGases.SingleGases.CO2.data,T);
   Modelica.SIunits.SpecificEnthalpy h_N2=Modelica.Media.IdealGases.SingleGases.N2.h_T(Modelica.Media.IdealGases.SingleGases.N2.data,T);
   Modelica.SIunits.SpecificEnthalpy h_CH4=Modelica.Media.IdealGases.SingleGases.CH4.h_T(Modelica.Media.IdealGases.SingleGases.CH4.data,T);
   Modelica.SIunits.SpecificEnthalpy[:] h_gas={h_CO2,h_N2,h_CH4,h_H2O};
 algorithm
 // h:=  X[end-1]*h_CO2 + X[end]*h_H2O;
   h:=h_gas*X[end-nX_gas:end];
 // Modelica.Utilities.Streams.print(String(p*1e-5)+" bar,"+String(T)+" K->"+String(h)+" J/kg (Brine_Duan_Multi_TwoPhase_ngas_3.specificEnthalpy_gas_pTX)");
 end specificEnthalpy_gas_pTX;


 redeclare function extends dynamicViscosity_liq
 algorithm
  eta := Partial_Viscosity.dynamicViscosity_Duan_pTX(
     state.p,
     state.T,
     state.X_l,
     MM_vec,
     Salt_data.saltConstants);
 end dynamicViscosity_liq;


 redeclare function extends dynamicViscosity_gas
 //TODO: andere Gase ber�cksichtigen, nicht nur Wasserdampf
 algorithm
 //  eta  := dynamicViscosity_Phillips_pTX(p,T,X,MM_vec,Salt_data.saltConstants);
 //  eta  := Modelica.Media.Water.WaterIF97_base.dynamicViscosity(state);
 eta  := Modelica.Media.Water.IF97_Utilities.dynamicViscosity(state.d_g, state.T, Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(state.T)-1, state.phase)
    "Viskosit�t von gasf�rmigem Wasser";
 //  eta  := Modelica.Media.Water.IF97_Utilities.dynamicViscosity(state.d_g, state.T, state.p, state.phase) "Viskosit�t von gasf�rmigem Wasser";
 //eta  := 0;
 end dynamicViscosity_gas;


  redeclare function extends saturationPressures
  algorithm
  //  Modelica.Utilities.Streams.print("saturationPressures("+String(p)+","+String(T)+")");

  //  if gasname =="carbondioxide" then
      p_sat[1] := if X[nX_salt+1]>0 then degassingPressure_CO2_Duan2003(p,T,X,MM_vec) else 0
    "aus Partial_Gas_Data";
  //  elseif gasname =="nitrogen" then
      p_sat[2] := if X[nX_salt+2]>0 then degassingPressure_N2_Duan2006(p,T,X,MM_vec) else 0
    "aus Partial_Gas_Data";
  //  elseif gasname =="methane" then
      p_sat[3] := if X[nX_salt+3]>0 then degassingPressure_CH4_Duan2006(p,T,X,MM_vec) else 0
    "aus Partial_Gas_Data";
  //  end if;
  end saturationPressures;


  redeclare function extends thermalConductivity
  "Thermal conductivity of water TODO"
  algorithm
    lambda := Modelica.Media.Water.IF97_Utilities.thermalConductivity(
        state.d,
        state.T,
        state.p,
        state.phase);
  end thermalConductivity;


  redeclare function extends specificHeatCapacityCp
  "specific heat capacity at constant pressure of water"

  algorithm
      cp := Modelica.Media.Water.IF97_Utilities.cp_pT(state.p, state.T) "TODO";
      annotation (Documentation(info="<html>
                                <p>In the two phase region this function returns the interpolated heat capacity between the
                                liquid and vapour state heat capacities.</p>
                                </html>"));
  end specificHeatCapacityCp;


  redeclare function extends surfaceTension
  algorithm
     sigma:=Modelica.Media.Water.WaterIF97_base.surfaceTension(sat) "TODO";
  end surfaceTension;


  annotation (Documentation(info="<html>
<p><b>Brine_Duan_Multi_TwoPhase_ngas_3</b> is a package that, based on Brine.PartialBrine_ngas_Newton, defines a brine property model with five salts (NaCl, KCl, CaCl2, MgCl2, SrCl2) and 3 gases (CO2, N2, CH4), which are the main constituents of the geofluid in Gross Schoenebeck, Germany. </p>
<p><b></font><font style=\"font-size: 12pt; \">Usage</b></p>
<p>As it is based on Modelica.Media, the usage differs little from the usage of the two-phase water model:</p>
<p>Create an Instance of the Medium: </p>
<pre>  package Medium = Brine_Duan_Multi_TwoPhase_ngas_3;</pre>
<p>Create an Instance of Medium.Baseproperties: </p>
<pre>  Medium.BaseProperties props;</pre>
<p>You can then use the BaseProperties model to define the actual brine composition(Xi or X), to define the thermodynamic state and calculate the corresponding properties. </p>
<pre>  props.p = 1e5;
  props.T = 300;
  props.Xi = {0.08, 0.004, 0.12, 0.001, 0.002, 1-4, 7e-4, 6e-005} &QUOT;NaCl, KCl, CaCl2, MgCl2, SrCl2, CO2, N2, CH4&QUOT;
  d = props.d;</pre>
<p>Pressure and temperature as well as pressure and specific enthalpy can be used to define a thermodynamic state.</p>
<p>All calculated values are returned in SI-Units and are mass based. </p>
<p><b></font><font style=\"font-size: 10pt; \">Details</b></p>
<p>Brine is a mixture of components and, if gases are involved, potentially has two phases. As this is not possible with the components provided in Modelica.Media a new Medium template had to be created by merging Modelica.Media.Interfaces.PartialMixtureMedium and Modelica.Media.Interfaces.PartialTwoPhaseMedium of the Modelica Standard Library 3.1. </p>
<p>The model is explicit for p and T, but for h(p,T) the inverse function T(p,h) is defined. T(p,h) is inverts h(p,T) numerically by bisection, stopping at a given tolerance.</p>
<p>In order to calculate h(p,T), the vapour-liquid-equilibrium (VLE) is determined, i.e. the gas mass fraction q and the compositions of the liquid phases X_l. Only h is returned, due to the limitation of DYMOLA/Modelica not allowing inverse functions of functions that are returning an array. As x (gas mass fraction) and X_l (composition of liquid phase) are of interest themselves and required to calculate density and viscosity, the VLE calculation is conducted one more time, this time with T known. This additional calculation doubles the workload when p,h are given. When p,T are given, however, it adds only one more calculation to the multiple iterations of the bisection algorithm. </p>
<p><b>Specific Enthalpy:</b></p>
<p>The enthalpy is calculated as a mass fraction weighted average of the enthalpies of the two phases. </p>
<p><h4>Specific Enthalpy of gas phase:</h4></p>
<p>Enthalpy of the gas phase is modelled as the enthalpy of an ideal mixture of ideal gases, i.e. it is calculated as the mass weighted average of the individual gas enthalpies including water. </p>
<p align=\"center\">h&QUOT;=sum(h&QUOT;<sub>i</sub>&middot;X&QUOT;<sub>i</sub>)</p>
<p>The individual gas enthalpies are calculated using the functions for ideal gases in Modelica.Media.IdealGases.SingleGases .</p>
<p><b>Specific Enthalpy of liquid phase:</b> </p>
<p>Enthalpy of the liquid phase is assembled from the enthalpy of a NaCl-solution (Driesner) and the apparent molar enthalpies of the salts multiplied by their respective molalities</p>
<p align=\"center\">h&apos;=h<sub>Driesner</sub>+sum(H<sub>i</sub><sup>app</sup>&middot;b<sub>i</sub>)</p>
<p>The apparent molar enthalpies of KCl and CaCl2 are calculated from apparent molar heat capacities which are calculated from a 2D fit for data from literature. The contributions of MgCl2 and SrCl2 are neglected, due to their small influence in the GrSbk fluid. </p>
<p><b>Density:</b></p>
<p>The total density of the fluid is calculated by combining the densities of both phases according to their volume fractions.  Density of the liquid phase is calculated by combining the densities of solutions of single salts, while gas density is calculated using the ideal gas law.</p>
<p><b>Density of liquid phase:</b> </p>
<p>The density model by Duan for single salt solutions is adapted for multi-salt solutions, resulting in an approach with apparent molar volumes analogous to the mixing rule for enthalpy.</p>
<p><h4>Created by</h4><br>
Henning Francke<br>
Helmholtz Centre Potsdam<br>
GFZ German Research Centre for Geosciences<br>
Telegrafenberg, D-14473 Potsdam<br>
Germany
<p><a href=\"mailto:francke@gfz-potsdam.de\">francke@gfz-potsdam.de</a> </p>
</html>",
 revisions="<html>

</html>"));
end Brine_5salts_TwoPhase_3gas;