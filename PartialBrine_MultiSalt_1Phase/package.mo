within BrineProp;
partial package PartialBrine_MultiSalt_1Phase "Template for one-phase (liquid) brine based on PartialMediaMixtureMedium"
  extends Modelica.Media.Interfaces.PartialMixtureMedium(
   final mediumName="TwoPhaseMixtureMedium",
   final substanceNames=cat(1,saltNames,{"water"}),
   final reducedX =  true,
   final singleState=false,
   reference_X=cat(1,fill(0,nX-1),{1}),
   fluidConstants = BrineConstants);

  constant FluidConstants[nS] BrineConstants(
     each chemicalFormula = "H2O+NaCl+KCl+CaCl2+MgCl2+SrCl2",
     each structureFormula="H2O+NaCl+KCl+CaCl2+MgCl2+SrCl2",
     each casRegistryNumber="007",
     each iupacName="Geothermal Brine",
     each molarMass=0.1,
     each criticalTemperature = 600,
     each criticalPressure = 300e5,
     each criticalMolarVolume = 1,
     each acentricFactor = 1,
     each triplePointTemperature = 273.15,
     each triplePointPressure = 1e5,
     each meltingPoint = 1,
     each normalBoilingPoint = 1,
     each dipoleMoment = 1);

  constant String explicitVars = "ph"
  "set of variables the model is explicit for, may be set to all combinations of ph or pT, setting pT should speed up the model in pT cases";


 replaceable package Salt_data = BrineProp.SaltData;

  import Partial_Units;

 constant Real[:] MM_salt;
 constant Integer[:] nM_salt "number of ions per molecule";

 constant Modelica.SIunits.MolarMass MM_vec = cat(1,MM_salt, {M_H2O});
 constant Modelica.SIunits.MolarMass nM_vec = cat(1,nM_salt, {1});

 constant String saltNames[:]={""};

  constant Integer nX_salt = size(saltNames, 1) "Number of salt components"   annotation(Evaluate=true);


redeclare record extends ThermodynamicState
  "a selection of variables that uniquely defines the thermodynamic state"
/*  AbsolutePressure p "Absolute pressure of medium";
  Temperature T(unit="K") "Temperature of medium";*/
  Density d(start=300) "density";
 /* SpecificEnthalpy h "Specific enthalpy";
  SpecificEntropy s "Specific entropy";
*/

   annotation (Documentation(info="<html>

</html>"));
end ThermodynamicState;


  redeclare function extends dynamicViscosity "viscosity calculation"
  algorithm
    eta:=dynamicViscosity_pTXd(
      state.p,
      state.T,
      state.X,
      state.d) "d for Zhang equation";
  end dynamicViscosity;


  replaceable function dynamicViscosity_pTXd "viscosity calculation"
    input Modelica.SIunits.Pressure p;
    input Modelica.SIunits.Temp_K T;
    input MassFraction X[:] "mass fraction m_NaCl/m_Sol";
    input Modelica.SIunits.Density d "solution density";
    output Modelica.SIunits.DynamicViscosity eta;
  //  constant Real M_NaCl=0.058443 "molar mass in [kg/mol]";
  end dynamicViscosity_pTXd;


 redeclare model extends BaseProperties "Base properties of medium"

    //    PowerPlant.Media.TableLookup Table;
    //  protected
    /*     constant Modelica.SIunits.MolarMass M_H2O = PartialBrine.M_H2O "[kg/mol]";
     constant Modelica.SIunits.MolarMass M_NaCl = PartialBrine.M_NaCl 
        "[kg/mol]";*/
   Real y_vec[:]=massFractionsToMoleFractions(X,MM_vec);
 equation
   d = density_pTX(p,T,X);
   h = specificEnthalpy_pTX(p,T,X);
 //  T = temperature_phX(p,h,X);
   u = 1 "h - p/d";
   MM = y_vec*MM_vec;
   R  = 8.3144/MM;

   state.p = p;
   state.T = T;
   state.d = d;
   state.X = X;

 //  state.s = 0 "specificEntropy_phX(p,h,X)";
 //  state.h = h;
 //  state.d = d;

   annotation (Documentation(revisions="<html>

</html>"));
 end BaseProperties;


  redeclare replaceable partial function density_pTX
  "Return density from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] "Mass fractions";
    input Modelica.SIunits.MolarMass MM[:]={1} "molar masses of components";
    output Density d "Density";
    annotation(Documentation(info="<html></html>"));
  end density_pTX;


  redeclare replaceable function specificEnthalpy_pTX
     input Modelica.SIunits.Pressure p;
    input Modelica.SIunits.Temp_K T;
    input MassFraction X[:] "mass fraction m_NaCl/m_Sol";
    output Modelica.SIunits.SpecificEnthalpy h;

  /*algorithm 
  h := 4*T;
*/
  end specificEnthalpy_pTX;


  redeclare function temperature_phX
  "iterative inversion of specificEnthalpy_pTX by regula falsi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input Real[nX_gas + 1] n_g_start=fill(.5,nX_gas+1)
    "start value, all gas in gas phase, all water liquid";
    output Temperature T "Temperature";
protected
    Modelica.SIunits.SpecificHeatCapacity c_p;
    Modelica.SIunits.Temperature T_a=273.16;
  //  Modelica.SIunits.Temperature T0_a=273.16;
    Modelica.SIunits.Temperature T_b=400;
  //  Modelica.SIunits.Temperature T0_b=400 "limit of N2 solubility";
  //  Modelica.SIunits.Temperature T_neu;
    Modelica.SIunits.SpecificEnthalpy h_a;
    Modelica.SIunits.SpecificEnthalpy h_b;/**/
    Modelica.SIunits.SpecificEnthalpy h_T;
    Integer z=0 "Loop counter";
  algorithm
    if debugmode then
       Modelica.Utilities.Streams.print("\ntemperature_phX("+String(p)+","+String(h)+")");
    end if;
    //Find temperature with h above given h ->T_b
    assert(h>specificEnthalpy_pTX(p,T_a,X),"h="+String(h/1e3)+" kJ/kg -> Enthalpy too low (< 0�C) (Brine.PartialBrine_ngas_Newton.temperature_phX)");
    while true loop
      h_T:=specificEnthalpy_pTX(p,T_b,X);
  // Modelica.Utilities.Streams.print(String(p)+","+String(T_b)+" K->"+String(h_T)+" J/kg (PartialBrine_ngas_Newton.temperature_phX)");
      if h>h_T then
        T_a := T_b;
        T_b := T_b + 50;
      else
        break;
      end if;
    end while;

  //BISECTION - is schneller, braucht 13 Iterationen
    while (T_b-T_a)>1e-2 and abs(h-h_T/h)>1e-5 loop   //stop when temperatures or enthalpy are close
  //  while abs(h-h_T/h)>1e-5 loop
  //    Modelica.Utilities.Streams.print("T_b-T_a="+String(T_b-T_a)+", abs(h-h_T)/h="+String(abs(h-h_T)/h));
      T:=(T_a+T_b)/2 "Halbieren";
  //    Modelica.Utilities.Streams.print("T_neu="+String(T)+"K");
      h_T:=specificEnthalpy_pTX(p,T,X);
      if h_T > h then
        T_b:=T;
  //      Modelica.Utilities.Streams.print("T_b="+String(T)+"K -> h="+String(h_T-h));
      else
        T_a:=T;
  //      Modelica.Utilities.Streams.print("T_a="+String(T)+"K -> h="+String(h_T-h));
      end if;
      z:=z+1;
  //    Modelica.Utilities.Streams.print(String(z)+": "+String(T_a)+" K & "+String(T_b)+" K -> "+String((h-h_T)/h)+"(PartialBrine_Multi_TwoPhase_ngas.temperature_phX)\n");
  //    Modelica.Utilities.Streams.print("h("+String(T_a)+")="+String(h_a-h)+" J/kg & h("+String(T_b)+")="+String(h_b-h)+" J/kg");
      assert(z<100,"Maximum number of iteration reached for temperature calculation. Something's wrong here. Cancelling...(PartialBrine_Multi_TwoPhase_ngas.temperature_phX)");
    end while;
  // Modelica.Utilities.Streams.print("BISECTION " + String(z)+": "+String(T));

  /*
//REGULA FALSI - is langsamer, braucht 19 Iterationen
  z:=0;
  T_a:=T0_a;
  T_b:=T0_b "limit of N2 solubility";
  h_a := specificEnthalpy_pTX(p,T_a,X);
  h_b := specificEnthalpy_pTX(p,T_b,X);
  while abs(T_b-T_a)>1e-2 and abs(h_T-h)/h>1e-5 loop
//  while abs(T_b-T_a)/T_l>1e-4 loop
    Modelica.Utilities.Streams.print("h_a("+String(T_a)+")="+String(h_a)+" / h_b("+String(T_b)+")="+String(h_b));
    T:=max(T0_a,min(T0_b,T_a-(T_b-T_a)/(h_b-h_a)*(h_a-h))) "Regula falsi";
    h_T:=specificEnthalpy_pTX(p,T,X);
    Modelica.Utilities.Streams.print("T_neu="+String(T)+"K");
    if h_T > h then
      T_b:=T;
      h_b:=h_T;
    else
      T_a:=T;
      h_a:=h_T;
//      Modelica.Utilities.Streams.print("T_a="+String(T)+"K -> h="+String(h_T-h));
    end if;
    z:=z+1;
//    Modelica.Utilities.Streams.print(String(z)+": "+String(T_a)+" K & "+String(T_b)+" K -> "+String((h-h_T)/h)+"(PartialBrine_Multi_TwoPhase_ngas.temperature_phX)\n");
//    Modelica.Utilities.Streams.print("h("+String(T_a)+")="+String(h_a-h)+" J/kg & h("+String(T_b)+")="+String(h_b-h)+" J/kg");
    assert(z<100,"Maximum number of iteration reached for temperature calculation. Something's wrong here. Cancelling...(PartialBrine_Multi_TwoPhase_ngas.temperature_phX)");
  end while;
 Modelica.Utilities.Streams.print("REGULA FALSI " + String(z)+": "+String(T));
*/

  end temperature_phX;


redeclare replaceable partial function extends setState_phX
  "Calculates medium properties from p,h,X"
//      input String fluidnames;
algorithm
  if debugmode then
    Modelica.Utilities.Streams.print("Running setState_phX("+String(p/1e5)+" bar,"+String(h)+" J/kg,X)...");
  end if;
  state := setState_pTX(p,temperature_phX(p,h,X,phase),X,phase) ",fluidnames)";
end setState_phX;


  replaceable partial function surfaceTension_T
  "Return surface tension sigma in the two phase region"
  //standard function in MSL.Media takes sat-properties
    extends Modelica.Icons.Function;
    input SI.Temperature T "saturation property record";
    output SurfaceTension sigma "Surface tension sigma in the two phase region";
    annotation(Documentation(info="<html></html>"));
  end surfaceTension_T;


  replaceable function dynamicViscosity_pTX "viscosity calculation"
    input Modelica.SIunits.Pressure p;
    input Modelica.SIunits.Temp_K T;
    input MassFraction X[:] "mass fraction m_NaCl/m_Sol";
    output Modelica.SIunits.DynamicViscosity eta;
  //  constant Real M_NaCl=0.058443 "molar mass in [kg/mol]";
  end dynamicViscosity_pTX;
end PartialBrine_MultiSalt_1Phase;
