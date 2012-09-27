within BrineProp.SpecificEnthalpies;
function specificEnthalpy_pTX_Driesner
  "enthalpy calculation according to Driesner 2007 et al: 0-1000�C; 0.1-500MPa (doi:10.1016/j.gca.2007.05.026)"
//Pressure limited to 100 MPa by Modelica Water property function
  input Modelica.SIunits.Pressure p;
  input Modelica.SIunits.Temp_K T;
  input Modelica.SIunits.MassFraction X_NaCl "mass fraction m_NaCl/m_Sol";
  output Modelica.SIunits.SpecificEnthalpy h;/**/
public
  constant Real M_NaCl=BrineProp.SaltData.M_NaCl "molar mass in [kg/mol]";
//  constant Real M_H2O =  PartialBrine.M_H2O "molar mass in [kg/mol] TODO";

//  Molality mola=X[1]/M_NaCl "molality b (mol_NaCl/kg_sol) ����";
protected
  Modelica.SIunits.Temp_C T_C = Modelica.SIunits.Conversions.to_degC(T);
  Modelica.SIunits.Temp_C T_Scale_h;
  Pressure_bar p_bar=Modelica.SIunits.Conversions.to_bar(p);
  Real q_21;
  Real q_22;
  Real q_20;
  Real q_23;
  Real q_2;
  Real q_11;
  Real q_10;
  Real q_12;
  Real q_1;
//  Modelica.Media.Water.WaterIF97_base.ThermodynamicState state_H2O;
  Real x_NaCl "mol fraction";
  Modelica.SIunits.MolarMass M_Solution "[kg/mol]";
//  Modelica.SIunits.Pressure p_check;
algorithm
  p_bar := Modelica.SIunits.Conversions.to_bar(p);
  assert(T_C>=0 and T_C<=1000, "T="+String(T-273.15)+", but must be between 0 and 1000�C");
  assert(p_bar>=1 and p_bar<=1000, "P="+String(p/1e5)+" bar, but must be between 1 and 1000 bar");
//  assert(mola>=.25 and mola<=5, "Molality must be between 0.25 and 5 mol/kg");

//Salinity conversion
//  if X[1]==0 then
  if X_NaCl==0 then
    x_NaCl := 0;
  else
//    x_NaCl := 1/(M_NaCl/M_H2O*(1/sum(X[1:5])-1)+1) "mol fraction";
    x_NaCl := 1/(M_NaCl/M_H2O*(1/X_NaCl-1)+1) "mol fraction";
  end if;
  M_Solution := x_NaCl*M_NaCl + (1-x_NaCl)* M_H2O;

//CALCULATION OF EQUIVALENT TEMPERATURE_h
  q_21 := -1.69513-4.52781E-4*p_bar-6.04279E-8*p_bar^2;
  q_22 := 0.0612567+1.88082E-5*p_bar;

  q_20 := 1-q_21*sqrt(q_22) "x_NaCl = 0 results in q_2=1";

  q_23 := -q_20-q_21*sqrt(1+q_22) + 0.241022 + 3.45087E-5*p_bar - 4.28356E-9*p_bar^2
    "x_NaCl = 1 is pure NaCl";
  q_2 := q_20+q_21*sqrt(x_NaCl+q_22)+q_23*x_NaCl;

  q_10 := 47.9048 - 9.36994E-3*p_bar + 6.51059E-6*p_bar^2;
  q_11 := -32.1724+0.0621255*p_bar;

  q_12 := -q_10 - q_11;
  //x_NaCl=0 results in q_1=0 / x_NaCl = 1 is pure NaCl
  q_1 := q_10 + q_11*(1-x_NaCl) + q_12*(1-x_NaCl)^2;

  T_Scale_h := T_C*q_2 + q_1;

//  p_check:=max(p, Modelica.Media.Water.WaterIF97_base.saturationPressure(T_Scale_h)) "To make sure its liquid";

  //END OF CALCULATION OF EQUIVALENT TEMPERATURE

/*  state_H2O := Modelica.Media.Water.WaterIF97_base.setState_pTX(p, Modelica.SIunits.Conversions.from_degC(T_Scale_h), fill(0,0));
  h := Modelica.Media.Water.WaterIF97_base.specificEnthalpy(state_H2O);*/
  h := Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT(p, Modelica.SIunits.Conversions.from_degC(T_Scale_h));

//  Modelica.Utilities.Streams.print("Brine_Driesner.specificEnthalpy_pTX: "+String(p*1e-5)+"bar."+String(T_Scale_h)+"�C->"+String(h)+" J/kg");
end specificEnthalpy_pTX_Driesner;