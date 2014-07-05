within ;
package BrineProp "Media models for p-h-T-rho-eta properties of aqueous solutions of multiple salts and gases"

 import SI = Modelica.SIunits;
 import Modelica.Utilities.Streams.print;

 constant Boolean debugmode = false "print messages in functions";
 constant Integer outOfRangeMode=2
  "when out of validity range: 0-do nothing, 1-show warnings, 2-throw error";
 constant Boolean ignoreLimitN2_T=true;
 constant Boolean ignoreLimitN2_p=true;
 constant Boolean ignoreLimit_h_KCl_Tmin=true
  "ignore Tmin in appMolarEnthalpy_KCl_White and appMolarHeatCapacity_KCl_White";
 constant Boolean ignoreLimit_h_CaCl2_Tmin=true
  "ignore Tmin in appMolarEnthalpy_CaCl2_White and appMolarHeatCapacity_CaCl2_White";
 constant Boolean[5] ignoreLimitSalt_p={false,false,false,false,false}
  "ignore pressure limits";
 constant Boolean[5] ignoreLimitSalt_T={false,false,false,false,false}
  "ignore temperature limits";
 constant Boolean[5] ignoreLimitSalt_b={false,false,false,false,false}
  "ignore salinity limits";
// constant Boolean[5] ignoreLimitSalt_visc={false,false,false,false,false};

  constant SI.MolarMass M_H2O = Modelica.Media.Water.waterConstants[1].molarMass
  "0.018015 [kg/mol]";

constant Modelica.Media.Interfaces.PartialTwoPhaseMedium.FluidConstants[nS] BrineConstants(
     each chemicalFormula = "H2O+NaCl+KCl+CaCl2+MgCl2+SrCl2+CO2+N2+CH4",
     each structureFormula="H2O+NaCl+KCl+CaCl2+MgCl2+SrCl2+CO2+N2+CH4",
     each casRegistryNumber="007",
     each iupacName="Geothermal Brine",
     each molarMass=0.1,
     each criticalTemperature = 600,
     each criticalPressure = 300e5,
     each criticalMolarVolume = 1,
     each acentricFactor = 1,
     each meltingPoint = 1,
     each normalBoilingPoint = 1,
     each dipoleMoment = 1);


  function massFractionsToMolalities
  "Calculate molalities (mole_i per kg H2O) from mass fractions X"
    extends Modelica.Icons.Function;
    input SI.MassFraction X[:] "Mass fractions of mixture";
    input SI.MolarMass MM_vec[:] "molar masses of components";
    output Partial_Units.Molality molalities[size(X, 1)]
    "Molalities moles/m_H2O";

  algorithm
   assert(size(X, 1)==size(MM_vec, 1), "Inconsistent vectors for mass fraction("+String(size(X, 1))+") and molar masses("+String(size(MM_vec, 1))+")");

    if X[end]>0 then
      for i in 1:size(X, 1) loop
        molalities[i] := if X[i]<1e-6 then 0 else X[i]/(MM_vec[i]*X[end])
        "numerical errors my create X[i]>0, this prevents it";
      end for;
    else
       molalities:=fill(-1, size(X, 1));
    end if;
    annotation(smoothOrder=5);
  end massFractionsToMolalities;


  function massFractionsToMoleFractions
  "Return mole_i/sum(mole_i) from mass fractions X"
    extends Modelica.Icons.Function;
    input SI.MassFraction X[:] "Mass fractions of mixture";
    input SI.MolarMass MM_vec[:] "molar masses of components";
    output Partial_Units.Molality molefractions[size(X, 1)] "Molalities";
    output Partial_Units.Molality molalities[size(X, 1)]
    "Molalities moles/m_H2O";
protected
    Real n_total;
    Integer n=size(X, 1);
  algorithm
   assert(n==size(MM_vec, 1), "Inconsistent vectors for mass fraction("+String(n)+") and molar masses("+String(size(MM_vec, 1))+")");
  // print(String(size(X,1))+" "+String(X[end]));
  //  printVector(MM);
    for i in 1:n loop
  // print("MMX["+String(i)+"]="+String(MMX[i]));
      molalities[i] := if X[end]>0 then X[i]/(MM_vec[i]*X[end]) else -1;
  //    n[i] := X[i]/MMX[i];
    end for;
    n_total :=sum(molalities);
    for i in 1:n loop
      molefractions[i] := molalities[i]/n_total;
    end for;
    annotation(smoothOrder=5);
  end massFractionsToMoleFractions;


  replaceable function Xi2X "calculates the full mass vector X from Xi"
    extends Modelica.Icons.Function;
    input SI.MassFraction Xi[:] "Mass fractions of mixture";
    output SI.MassFraction X[size(Xi,1)+1] "Mass fractions of mixture";
  algorithm
    X:=cat(
      1,
      Xi,
      {1 - sum(Xi)});

  end Xi2X;


  annotation (Documentation(info="<html>
<p><b>BrineProp</b> is a modelica package that calculates the thermodynamic properties of a specified brine, i.e. an aqueous solution of salts and gases, with a potential gas phase, including degassing/evaporation and solution/condensation.</p>
<p>It was developed as a part of a PhD projected, documented in the thesis &QUOT;<a href=\"http://nbn-resolving.de/urn:nbn:de:kobv:83-opus4-47126\">Thermo-hydraulic model of the two-phase flow in the brine circuit of a geothermal power plant</a>&QUOT;. </p>
<p>This package contains an extension of the Modelica.Media interfaces for two-phase mixtures (<a href=\"BrineProp.PartialMixtureTwoPhaseMedium\">PartialMixtureTwoPhaseMedium</a>), the generic brine template with the vapour-liquid-equilibrium calculation (<a href=\"BrineProp.PartialBrine_ngas_Newton\">PartialBrine_ngas_Newton</a>), as well specific brine models for NaCl, KCl, CaCl2, [MgCl2, SrCl2 partially supported] (1-phase: <a href=\"BrineProp.Brine_5salts\">Brine_5salts</a>) and CO2, N2 and CH4 (2-phase: <a href=\"BrineProp.Brine_5salts_TwoPhase_3gas\">Brine_5salts_TwoPhase_3gas</a>).</p>
<p>This package has been developed and tested in Dymola up to 2014 FD01.</p>
<p><b>Licensed by the </b>Helmholtz Centre Potsdam, GFZ German Research Centre for Geosciences<b> under the Modelica License 2</b></p>
<p>Copyright &copy; 2009-2014 Henning Francke.</p>
<p><br/><i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\">http://www.modelica.org/licenses/ModelicaLicense2</a>.</i> </p>
<p><h4>Usage</h4></p>
<p>Check the (non-partial) Brine packages (<a href=\"BrineProp.Brine_5salts\">Brine_5salts</a>, <a href=\"BrineProp.BrineGas_3Gas\">BrineGas_3Gas</a> or <a href=\"BrineProp.Brine_5salts_TwoPhase_3gas\">Brine_5salts_TwoPhase_3gas</a>) for instructions or run models from <code>BrineProp/Examples</code>. </p>
<p>All calculated values are returned in SI-Units and are mass based. </p>
<p><h4>Known issues:</h4></p>
<p><ul>
<li>no differentials implemented</li>
<li>1phase-transient calculation does not compile, supposedly due to missing derivatives</li>
<li>Does not compile in JModelica/OpenModelica</li>
</ul></p>
<p><h4>TODO:</h4></p>
<p><ul>
<li>implement differentials</li>
<li>remove <font style=\"color: #006400; \">argument <code>MM_vec</font></code> in property functions</li>
<li>implement limit ignore switches consistently (preferrably as parameter in the Medium package to be changed on declaration)</li>
<li>Add apparent molar heat capacity/enthalpy for (NaCl,) MgCl2 and SrCl2</li>
</ul></p>
<p><h5>Created by</h5></p>
<p>Henning Francke</p>
<p>Helmholtz Centre Potsdam GFZ German Research Centre for Geosciences</p>
<p>Telegrafenberg, D-14473 Potsdam</p>
<p>Germany</p>
<p><a href=\"mailto:info@xrg-simulation.de\">francke@gfz-potsdam.de</a></p>
</html>", revisions="<html>

</html>"),
    version="0.3.0",
    versionDate="2014-04-02",
    uses(                         DataFiles(version="1.0"), Modelica(version=
          "3.2.1")));
end BrineProp;
