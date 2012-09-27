within BrineProp.Examples;
model BrineProps2phase
//package Medium = Brine_Phillips;
//package Medium = Brine_Magri;
//package Medium = Brine_Driesner;
//package Medium = Brine_Duan;
//package Medium = Brine_Duan_Multi;
//package Medium = Brine_Duan_Multi_TwoPhase_N2;
//package Medium = Brine_Duan_Multi_TwoPhase_CO2;
//package Medium = Brine_Duan_Multi_TwoPhase_2gas;
//package Medium = Brine_Duan_Multi_TwoPhase_ngas_3(explicitVars="pT");
package Medium = BrineProp.Brine_5salts_TwoPhase_3gas;
/*  package Medium = MediaTwoPhaseMixture.Water_MixtureTwoPhase_pT;
  constant Modelica.SIunits.MassFraction Xi[:]=fill(1,0) 
    "{.225} Mass fractions";
*/
//  package Medium = Modelica.Media.Water.WaterIF97_ph;
  Medium.BaseProperties props(phase=0);

  Modelica.SIunits.Density d= props.d;  /**/

 /* Modelica.SIunits.Temperature T "= props.T";*/
//  Real q = props.state.q;
//  Modelica.SIunits.SpecificEnthalpy h = props.h;

/*  Medium.BaseProperties props2;
  Modelica.SIunits.Density d2 = props2.d;
  Modelica.SIunits.Temperature T2 = props2.T;lm
  Real q2 = props2.state.q;
*/
//  Modelica.SIunits.SpecificEntropy s;
/*Modelica.SIunits.DynamicViscosity eta = Medium.dynamicViscosity(props.state);
Modelica.SIunits.DynamicViscosity eta_Philips = PowerPlant.Media.Brine.Brine_Phillips.dynamicViscosity_pTX(props.p,props.T,props.X);
Modelica.SIunits.DynamicViscosity eta_Duan = PowerPlant.Media.Brine.Brine_Duan.dynamicViscosity_pTX(props.p,props.T,props.X);
*/
/*Modelica.SIunits.DynamicViscosity eta_l = Medium.dynamicViscosityLiquidPhase(props.state);
Modelica.SIunits.DynamicViscosity eta_g = Medium.dynamicViscosityGasPhase(props.state);
*/
//  constant Real MM[:] = Medium.MM;
// Real TDS = sum(props.Xi)*props.d;
//Real[:] Xi = {0.089190167,0.005198142,0.137663206,0.001453819,0.002621571, 7.85e-4};
//Medium.SaturationProperties sat(Tsat=props.T,psat=props.p,X=props.X);
//Modelica.SIunits.SurfaceTension sigma = Modelica.Media.Water.WaterIF97_base.surfaceTension(sat);
//  Modelica.SIunits.SurfaceTension sigma = Modelica.Media.Water.WaterIF97_base.surfaceTension(props.sat);

//  Real c_CO2=Partial_Gas_Data.solubility_CO2_pTX_Duan2003(props.p,props.T,props.X,Medium.MM_vec,props.p);
//  Real c_N2=Partial_Gas_Data.solubility_N2_pTX_Duan2006(props.p,props.T,props.X,Medium.MM_vec,props.p);
//  Real c=Partial_Gas_Data.solubility_CH4_pTX_Duan2006(props.p,props.T,props.X,Medium.MM_vec,props.p_gas[2]);

/*  Real k_CH4b=Partial_Gas_Data.HenryCoefficients_CH4(props.T); 
*/
/*    Modelica.SIunits.Pressure p_degas_CO2=Medium.degassingPressure_CO2_Duan2003(props.p,props.T,props.X,Medium.MM_vec);
  Modelica.SIunits.Pressure p_degas_N2=Medium.degassingPressure_N2_Duan2006(props.p,props.T,props.X,Medium.MM_vec);
  Modelica.SIunits.Pressure p_degas_CH4=Medium.degassingPressure_CH4_Duan2006(props.p,props.T,props.X,Medium.MM_vec);
  */
/*
  Modelica.SIunits.MassConcentration TDS= sum(props.X_l[1:Medium.nX_salt])*props.d_l;
  Modelica.SIunits.MassFraction[:] X_g=props.X-props.X_l*(1-props.x);
  Real[:] y=cat(1,props.p_gas,{props.p_H2O})/props.p 
    "volume fraction of gas phase";
//  Real[:] yy=y[2:3]./fill(1-y[4],2) "volume fraction of gas phase w/o H2O";
//  Real[:] yy=(props.p_gas/props.p./{.038,.829,.128}-{1,1,1});
  Real[:] xx=(X_g[6:8]-{5.87E-05,8.04E-04,7.14E-05})./{5.87E-05,8.04E-04,7.14E-05};
  Real[:] y_l=if not max(props.X_l[6:8])>0 then fill(0,Medium.nX_gas) else props.X_l[6:8]./Medium.MM_gas / sum(props.X_l[6:8]./Medium.MM_gas) 
    "mol fraction of dissolved gases";
  Real V_l = sum(props.X_l[6:8]./Medium.MM_gas)*22.4/props.X_l[end] 
    "Volume dissolved gas would have at standard conditions";
//  Real V_l = props.X_l[8]/Medium.MM_gas[3]/22.4*1000/props.X_l[end];
  Real[:] m=y[2:3]./fill(1-y[4],2) "mass fraction of gas in gas phase";

  Real m_t = sum(props.X[6:8]) "Total mass fraction of gases in fluid";
  Real m_g = if not max(props.X_l[6:8])>0 then 0 else sum(X_g[6:8])*props.x/sum(props.X[6:8]) 
    "Fraction of gas masses in gas phase";
//  Real b = props.X[1]/Medium.MM_salt[1]/props.X[end];
  Partial_Units.Molality[:] b=massFractionsToMolalities(props.X, Medium.MM_vec);

Real f=1;*/

/*  Modelica.SIunits.MassFraction X_N2(start=1e-5,min=0);
  Modelica.SIunits.MassFraction X_CH4(start=1e-5,min=0);*/
//  Modelica.SIunits.SpecificEnthalpy[:] h_salt_100(start={300500,0,0,0,0});
  Modelica.SIunits.SpecificEnthalpy h_Driesner= BrineProp.SpecificEnthalpies.specificEnthalpy_pTX_Driesner(
                                                                                                    props.p,props.T,sum(props.X[1:5]));
//  Real tt=(h_francke-props.h)/h_francke;
//  Modelica.SIunits.SpecificHeatCapacity c_p_brine= (Medium.specificEnthalpy_pTX(455e5,273.16+140,props.X)-Medium.specificEnthalpy_pTX(455e5,273.16+60,props.X))/(140-60);
//  Modelica.SIunits.SpecificHeatCapacity c_p_salt= (c_p_brine-4190*props.X[end])/props.X[1];
equation
//  h_francke =props.h;
//  h_salt_100[2:end]={0,0,0,0};

//  props.p = (40-time)*1e5;
//  props.p = 0e5 +time*1e5;
//  props.p = 29.6937843572662*1.01325e5 "0 mol 150�C 25atm";
//  props.p = 29.5346952874414*1.01325e5 "1 mol 150�C 25atm";
//  props.p = 28.9812681963977*1.01325e5 "5 mol 150�C 25atm";
//  props.p = 46055732 "1 mol 150�C 450atm+p_H2O";
//  props.p = 45998589 "5 mol 150�C 450atm+p_H2O";
//  props.p = 175*1.01325e5+Modelica.Media.Water.WaterIF97_base.saturationPressure(props.T) "1 mol 150�C";

  props.p = 15e5;
//  props.h = 379778;
//  props.p = (10+time)*1.01325e5 "STP";
 props.T = 273.16+30;
/*
  props.p = 9.13e5;
  props.T = 273.16+99.61;
 */

// props.n_g_start={.1,.1,.1,time};
//  mola_gas=Medium.solubility_N2_pTX_Duan2006(props.p,props.T,props.X,Medium.MM_vec,p_gas);
//  props.h =2e5 "+time*1e4";
//  props.h = 342686;
//  mola[:] = Medium.solubilities_pTX(props.p,props.T,props.X);
//d = Medium.density_liquid_pTX(props.p,props.T,props.X, Medium.MM_vec);
//1400000 = Medium.specificEnthalpy_pTX(1.01325e5,T,cat(1,Xi,{1-sum(Xi)}));
//T = Medium.temperature_phXqy(1.01325e5,800695,cat(1,Xi,{1-sum(Xi)}),.5,.5);
//T=props.T;

//props.Xi = 257.681;
//0-Gas
//  props.Xi = {257.681,0,0,0,0}/d;
//  props.Xi = {0.0982,0.0056,0.1505,0.0017,0.0035} "NaCl, c_KCl, c_CaCl2, c_MgCl2, c_SrCl2";
//  props.Xi = {97.331,5.673,150.229,1.587,0}/d     "g/l NaCl, c_KCl, c_CaCl2, c_MgCl2, c_SrCl2";
//  props.Xi = {0.089190167,0.005198142,0.137663206,0.001453819,0.002621571} "NaCl, c_KCl, c_CaCl2, c_MgCl2, c_SrCl2";

//1-GAS
//  props.Xi = {0,0,0,0,0,3.07582E-05} "NaCl, c_KCl, c_CaCl2, c_MgCl2, c_SrCl2, CO2/N2";
//  props.Xi = {0.089190167,0.005198142,0.137663206,0.001453819,0.002621571, 7.85e-4} "NaCl, c_KCl, c_CaCl2, c_MgCl2, c_SrCl2, CO2/N2";
//  props.Xi = {97.331,5.673,150.229,1.587,0.0}/props.d

//2-GAS
//  props.Xi = {0,0,0,0,0,3.07582E-05,0} "c_NaCl, c_KCl, c_CaCl2, c_MgCl2, c_SrCl2, CO2/N2";
//  props.Xi = {0,0,0,0,0,0,3.076e-5} "NaCl, c_KCl, c_CaCl2, c_MgCl2, c_SrCl2, N2, CO2";
//  props.Xi = {0.089190167,0.005198142,0.137663206,0.001453819,0.002621571, 7.85e-4,  5.73e-5};

//3-GAS
//  props.Xi = {0.089190167,0.005198142,0.137663206,0.001453819,0.002621571, 7.85e-4,  5.73e-5, 6.98e-5}  "NaCl, KCl, CaCl2, MgCl2, SrCl2, CO2, N2, CH4";
//  props.Xi = {0*.225+5*Medium.Salt_data.M_NaCl/(1+5*Medium.Salt_data.M_NaCl),0,0,0,0,0,tt*50*0.000218855,(1-tt)*50*0.000125332}     "x mol NaCl";
//  props.Xi = {0.089190167,0.005198142,0.137663206,0*0.001453819,0*0.002621571, 5.87e-5, 8.04e-4,  7.14e-5}     "Messwerte aus STR04/16 direkt";
//  f=.978235 "-> 265 g/l";
//   props.Xi = f*{0.089182812,0.005197713,0.137651853,0.001453699,0.002621355,1.6015e-4,8.07e-4,7.209e-5}     "Entsprechend STR04/16 bei GG mit d_l=1091.37 kg/m� - X_g stimmt";
   props.Xi = {    0.081109,   0.0047275,     0.12519,   0*0.0013225,  0*0.0023842,  0*0.00016889,  0*0.00073464, 0*6.5657e-005}
    "Entsprechend STR04/16 bei GG mit d_l=1199.48 kg/m� - X_g stimmt";
//  props.Xi = {6*Salt_Data.M_NaCl/(1+6*Salt_Data.M_NaCl),0,0,0,0, 0,0,0} "NaCl, KCl, CaCl2, MgCl2, SrCl2, CO2, N2, CH4";

/*  props.Xi[1:5] = {0.089190167,0.005198142,0.137663206,0*0.001453819,0*0.002621571};
  X_g[6:8]={8.05e-4,  5.87e-5, 7.15e-5}; GEHT NICHT WEIL ER X<0 ausprobiert und das wird in PartialMedium abgefangen
*/

//  h = Medium.dewEnthalpy(props.sat);

//  d = Medium.density(props.state);

//  s = Medium.specificEntropy(props.state);
//  s = props.state.s;
//  eta = Medium.dynamicViscosity(props.state);

algorithm
//  Modelica.Utilities.Streams.print("rho="+String(d)+" kg/m�, TDS = " + String(TDS) + " g/l -> "+ String(f*265/TDS));
//  Modelica.Utilities.Streams.print("sum(X_l)="+String(sum(props.state.X_l)-1)+"");
end BrineProps2phase;