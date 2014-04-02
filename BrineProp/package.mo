within ;
package BrineProp "Media models for p-h-T-rho-eta properties of aqueous solutions of multiple salts and gases"

 import SI = Modelica.SIunits;
 import Modelica.Utilities.Streams.print;

 constant Boolean debugmode = false "print messages in functions";
 constant Boolean ignoreLimitN2_T=true;
 constant Boolean ignoreLimitN2_p=true;
 constant Boolean ignoreLimit_h_KCl_Tmin=true
  "ignore Tmin in appMolarEnthalpy_KCl_White and appMolarHeatCapacity_KCl_White";
 constant Boolean ignoreLimit_h_CaCl2_Tmin=true
  "ignore Tmin in appMolarEnthalpy_CaCl2_White and appMolarHeatCapacity_CaCl2_White";
 constant Boolean[5] ignoreLimitSalt_p={false,true,true,false,false};
 constant Boolean[5] ignoreLimitSalt_T={false,false,false,false,false};
 constant Boolean[5] ignoreLimitSalt_visc={false,false,true,false,false};
 constant Integer outOfRangeMode=2
  "when out of validity range: 0-do nothing, 1-show warnings, 2-throw error";

  constant Integer NaCl=1 "reference number TODO: does not belong here";
  constant Integer KCl=2 "reference number";
  constant Integer CaCl2=3 "reference number";
  constant Integer MgCl2=4 "reference number";
  constant Integer SrCl2=5 "reference number";

  constant SI.MolarMass M_H2O = Modelica.Media.Water.waterConstants[1].molarMass
  "0.018015 [kg/mol]";



















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
<p><b>BrineProp</b> is a package that provides properties of a specified brine, i.e. an aqueous solution of salts and gases, with a potential gas phase, therefore including de/gassing and evaporation/condensation. It is based on an extension to and therefore largely compatible to the Modelica.Media library. This necessary extension is PartialMixtureTwoPhaseMedium (not included in this package). This package has been developed and tested in Dymola up to 2012 FD01. </p>
<p>All files in this library, including the C source files are released under the Modelica License 2. </p>
<p><b></font><font style=\"font-size: 12pt; \">Installation</b></p>
<p>Make sure the package directory is named BrineProp. This provided, the examples under <code>Examples</code> should work right away.</p>

<h4>Usage</h4>
<p>Check the (non-partial) Brine packages or </p>
<pre>Examples</pre>
<p>for instructions. </p>
<p>All calculated values are returned in SI-Units and are mass based. </p>
<p><i></font><font style=\"font-size: 10pt; \">Created by</i></p><p>Henning Francke</p><p>Helmholtz Centre Potsdam</p><p>GFZ German Research Centre for Geosciences</p><p>Telegrafenberg, D-14473 Potsdam</p><p>Germany</p>
<p><a href=\"mailto:francke@gfz-potsdam.de\">francke@gfz-potsdam.de</a> </p>
<h4>TODO:</h4>
<ul>
<li>Add apparent molar heat capacity/enthalpy for (NaCl,) MgCl2 and SrCl2</li>
</ul>
</html>", revisions="<html>

</html>"),
    version="0.2.0",
    versionDate="2014-04-02",
    uses(Modelica(version="3.2")));
end BrineProp;