/*********************************************
 * OPL 22.1.1.0 Model
 * Author: cuphead
 * Creation Date: Jan 6, 2025 at 5:00:50 PM
 *********************************************/

string DataVersion = ...;

int NbClient = ...; 
int NbSites = ...;

float Revenues[1..NbClient][1..NbSites] = ...;  

int CostSite[1..NbSites] = ...;

// Demand values scenarios for each client
float DemandsBase[1..NbClient] = ...;
float DemandsLower[1..NbClient] = ...;
float DemandsUpper[1..NbClient] = ...;

float Probabilities[1..3] = ...;

int Capacities[1..NbSites] = ...;

dvar boolean s[1..NbSites];
dvar float+ x[1..3][1..NbClient][1..NbSites];
dvar float ObjectiveValue;


minimize 
  ObjectiveValue;

subject to {
  
  forall(j in 1..NbSites)
    sum(i in 1..NbClient, k in 1..3) x[k][i][j] <= Capacities[j] * s[j];

  forall(i in 1..NbClient) {
    sum(j in 1..NbSites) x[1][i][j] == DemandsBase[i];
    sum(j in 1..NbSites) x[2][i][j] == DemandsLower[i];
    sum(j in 1..NbSites) x[3][i][j] == DemandsUpper[i];
  }
  // Objective Value definition put in a variable to export it later
  ObjectiveValue == sum(j in 1..NbSites) CostSite[j] * s[j]-sum(i in 1..NbClient, j in 1..NbSites, k in 1..3) Probabilities[k] * Revenues[i][j] * x[k][i][j];
  
    
}

execute {

  var f=new IloOplOutputFile("../results/" + DataVersion + "-deterministic-equivalent-results.txt");
  f.writeln("Objective Value:");
  f.writeln(ObjectiveValue);
  f.writeln("\nSelected Sites:");
  f.writeln(s);

  f.writeln("\nClient-Site Allocations:");
  f.writeln("Scenario 1 (Base Demands):");
  f.writeln(x[1]);

  f.writeln("Scenario 2 (Low Demands):");
  f.writeln(x[2]);

  f.writeln("Scenario 3 (High Demands):");
  f.writeln(x[3]);
  f.close();
}
