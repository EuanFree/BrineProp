within BrineProp.Examples;
model BrineProps2phase

  //package Medium = BrineProp.Brine_5salts_TwoPhase_3gas;
    package Medium = BrineProp.Brine_5salts_TwoPhase_3gas(input_dT=true);
  //package Medium = BrineProp.Brine_5salts_TwoPhase_3gas(explicitVars="pT");
  //package Medium = MediaTwoPhaseMixture.Water_MixtureTwoPhase_pT;

  Medium.BaseProperties props(phase=0,n_g_norm_start=fill(0.5,Medium.nX_gas+1));

// SI.Temperature T = props.T;
//  SI.SpecificEnthalpy h = props.h;
  SI.Density d= props.d;
  //SI.Density d = Medium.density_liquid_pTX(props.p,props.T,props.X_l, Medium.MM_vec);

// VISCOSITY
  SI.DynamicViscosity eta_l = Medium.dynamicViscosity_liq(props.state)
    "liquid viscosity";
  SI.DynamicViscosity eta_g = Medium.dynamicViscosity_gas(props.state)
    "gas viscosity";

//SPECIFIC HEAT CAPACITY
  SI.SpecificHeatCapacity c_p_brine= Medium.specificHeatCapacityCp(props.state);
//  SI.SpecificHeatCapacity c_p_brine2=(Medium.specificEnthalpy_pTX(props.p,props.T+.1,props.X)-Medium.specificEnthalpy_pTX(props.p,props.T-.1,props.X))/.2;
//  SI.SpecificEnthalpy h_Driesner= BrineProp.SpecificEnthalpies.specificEnthalpy_pTX_Driesner(props.p,props.T,sum(props.X[1:5]));
//  SI.SpecificHeatCapacity c_p_Driesner= SpecificEnthalpies.specificHeatCapacity_pTX_Driesner(props.p,props.T,sum(props.X[1:5]));
//    SI.SpecificHeatCapacity c_p_liq=Medium.specificHeatCapacityCp_liq(props.state);
//  SI.SpecificHeatCapacity c_p_gas=Medium.specificHeatCapacityCp_gas(props.state);

//THERMAL EXPANSION COEFFICIENT
  //Real beta=(props.d-Medium.density_liquid_pTX(props.p,props.T-1,props.X));
  //Real beta=Medium.isobaricExpansionCoefficient_liq(props.state,props.d_l);

  //EXTRACT MOLAR WEIGHTS
 constant Real MM[:] = Medium.MM_vec;

   //RATIO GAS-LIQUID
 Real ratioGasLiquid = props.GVF/(1-props.GVF) "at given conditions";
 /*
   Real V_l = sum(props.X_l[6:8]./Medium.MM_gas)*22.4/props.X_l[end] 
    "Liter of dissolved gas per kg_brine would have after complete degassing at standard conditions";
  Real ratioGasLiquid = V_l*props.d_l/1000;
  */

 //Medium.SaturationProperties sat(Tsat=props.T,psat=props.p,X=props.X);
//SI.SurfaceTension sigma = Modelica.Media.Water.WaterIF97_base.surfaceTension(sat);
//  SI.SurfaceTension sigma = Modelica.Media.Water.WaterIF97_base.surfaceTension(props.sat);

//  Real c_CO2=Partial_Gas_Data.solubility_CO2_pTX_Duan2003(props.p,props.T,props.X,Medium.MM_vec,props.p);
//  Real c_N2=Partial_Gas_Data.solubility_N2_pTX_Duan2006(props.p,props.T,props.X,Medium.MM_vec,props.p);
//  Real c=Partial_Gas_Data.solubility_CH4_pTX_Duan2006(props.p,props.T,props.X,Medium.MM_vec,props.p_gas[2]);

/*    SI.Pressure p_degas_CO2=Medium.degassingPressure_CO2_Duan2003(props.p,props.T,props.X,Medium.MM_vec);
  SI.Pressure p_degas_N2=Medium.degassingPressure_N2_Duan2006(props.p,props.T,props.X,Medium.MM_vec);
  SI.Pressure p_degas_CH4=Medium.degassingPressure_CH4_Duan2006(props.p,props.T,props.X,Medium.MM_vec);
  */

  /*  SI.MassConcentration TDS= sum(props.X_l[1:Medium.nX_salt])*props.d_l;
  SI.MassFraction[:] X_g=props.X-props.X_l*(1-props.x);*/
//  Real[:] yy=y[2:3]./fill(1-y[4],2) "volume fraction of gas phase w/o H2O";
//  Real[:] yy=(props.p_gas/props.p./{.038,.829,.128}-{1,1,1});
//  Real[:] xx=(X_g[6:8]-{5.87E-05,8.04E-04,7.14E-05})./{5.87E-05,8.04E-04,7.14E-05};

/*  Real[:] y_l=if not max(props.X_l[6:8])>0 then fill(0,Medium.nX_gas) else props.X_l[6:8]./Medium.MM_gas / sum(props.X_l[6:8]./Medium.MM_gas) 
    "mol fraction of dissolved gases";

*/
/*
  Real[:] m=y[2:3]./fill(1-y[4],2) "mass fraction of gas in gas phase";

  Real m_t = sum(props.X[6:8]) "Total mass fraction of gases in fluid";
  Real m_g = if not max(props.X_l[6:8])>0 then 0 else sum(X_g[6:8])*props.x/sum(props.X[6:8]) 
    "Fraction of gas masses in gas phase";
//  Real b = props.X[1]/Medium.MM_salt[1]/props.X[end];
  Partial_Units.Molality[:] b_l=massFractionsToMolalities(props.X_l, Medium.MM_vec);
*/
Real g=1 "gas content multiplier";

equation
  //DEFINE STATE (define 2 variables pT, ph or Td)
  props.p = 20*1.01325e5;
//  props.p = 435e5;

  props.T = 273.15+20+time*100;
// props.T = 273.16+144;

// props.d = 1124.93;

 //  props.h =2e5 "+time*1e4";
//  props.h = (10-time)*1e5;

//DEFINE BRINE COMPOSITION (NaCl, KCl, CaCl2, MgCl2, SrCl2, CO2, N2, CH4)
  // props.Xi = fill(0,8) "pure water";
  //  props.Xi = {1*SaltData.M_NaCl/(1+1*SaltData.M_NaCl),0,0,0,0, 0*1.035e-3,0*5e-4,0}  "1-molar KCl solution";
  //  props.Xi = {0,SaltData.M_KCl/(1+SaltData.M_KCl),0,0,0,0,0,0} "1-molar KCl solution";
//  props.Xi = {0,0,SaltData.M_CaCl2/(1+SaltData.M_CaCl2),0,0,0,0,0};
  //  props.Xi = {0.089190167,0.005198142,0.137663206,0*0.001453819,0*0.002621571, 5.87e-5, 8.04e-4,  7.14e-5}     "Messwerte aus STR04/16 direkt";
  //  props.Xi = {    0.081109,   0.0047275,     0.12519,   0*0.0013225,  0*0.0023842,  0*0.00016889,  0*0.00073464, 0*6.5657e-005}     "Entsprechend STR04/16 bei GG mit d_l=1199.48 kg/m� - X_g stimmt";
/*  props.Xi[1:5] = {0.089190167,0.005198142,0.137663206,0*0.001453819,0*0.002621571};
  X_g[6:8]={8.05e-4,  5.87e-5, 7.15e-5}; GEHT NICHT, WEIL ER X<0 ausprobiert und das wird in PartialMedium abgefangen
*/
//props.Xi = {     0.08214,   0.0053126,     0.11052,   0*0.0011094,   0*0.0019676,  0.00018083,  0.00074452,  6.661e-005}     "Elvira 9/11";
//    props.Xi = {0.083945671051201,0.00253479771131107,0.122842299461699,0*0.000612116692496665,0*0.00214041137028575,  0.00016883,  0.00073459, 6.5652e-005}     "Elvira 2-2013 1.1775g/ml";
    props.Xi = {0.0839077010751,0.00253365118988,0.122786737978,0,0,g*7.2426359111e-05,g*0.000689505657647,g*6.14906384726e-05}
    "Elvira 2-2013 1.1775g/ml V2";

  //SET DIFFERENT INITIAL VALUE FOR VLE ALGORITHM (componentwise mass distribution, default=0.5)
  //props.n_g_norm_start={.1,.1,.1,time};

//  mola_gas=Medium.solubility_N2_pTX_Duan2006(props.p,props.T,props.X,Medium.MM_vec,p_gas);
//  mola[:] = Medium.solubilities_pTX(props.p,props.T,props.X);

algorithm
//  print("rho="+String(d)+" kg/m�, TDS = " + String(TDS) + " g/l -> "+ String(f*265/TDS));
//  print("sum(X_l)="+String(sum(props.state.X_l)-1)+"");
//  print(Modelica.Math.Matrices.toString(transpose([props.Xi])));
//  print("k="+Modelica.Math.Matrices.toString(transpose([Brine_5salts_TwoPhase_3gas.solubilities_pTX(props.p, props.T, props.X_l, props.X, props.p_gas[1:3]) ./ props.p_gas[1:3]])));
end BrineProps2phase;