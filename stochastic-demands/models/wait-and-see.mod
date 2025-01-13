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

dvar boolean s[1..3][1..NbSites];
dvar float+ x[1..3][1..NbClient][1..NbSites];
dvar float ObjectiveValue[1..3];
dvar float WaitAndSee;
minimize
  WaitAndSee;

subject to {
  
  forall(j in 1..NbSites, k in 1..3)
    sum(i in 1..NbClient) x[k][i][j] <= Capacities[j] * s[k][j];

  forall(i in 1..NbClient) {
    sum(j in 1..NbSites) x[1][i][j] == DemandsBase[i];
    sum(j in 1..NbSites) x[2][i][j] == DemandsLower[i];
    sum(j in 1..NbSites) x[3][i][j] == DemandsUpper[i];
  }
  // Objective Values
  forall(k in 1..3){
    ObjectiveValue[k] == sum(i in 1..NbClient, j in 1..NbSites) (CostSite[j] * s[k][j] - Revenues[i][j] * x[k][i][j]);
  }
  // Wait&See as the weighted average 
  WaitAndSee == sum(k in 1..3) Probabilities[k] * ObjectiveValue[k];
}

execute {
  var f=new IloOplOutputFile("../results/" + DataVersion + "-wait-and-see-results.txt");
  f.writeln("WaitAndSee:");
  f.writeln(WaitAndSee);
  
  f.writeln("\nScenario 1 (Base Demands):");
  f.writeln("Objective Value:");
  f.writeln(ObjectiveValue[1]);
  f.writeln("Selected Sites:");
  f.writeln(s[1]);
  f.writeln("Client-Site Allocations:");
  f.writeln(x[1]);

  f.writeln("\nScenario 2 (Low Demands):");
  f.writeln("Objective Value:");
  f.writeln(ObjectiveValue[2]);
  f.writeln("Selected Sites:");
  f.writeln(s[2]);
  f.writeln("Client-Site Allocations:");
  f.writeln(x[2]);

  f.writeln("\nScenario 3 (High Demands):");
  f.writeln("Objective Value:");
  f.writeln(ObjectiveValue[3]);
  f.writeln("Selected Sites:");
  f.writeln(s[3]);
  f.writeln("Client-Site Allocations:");
  f.writeln(x[3]);
  f.close();
}


