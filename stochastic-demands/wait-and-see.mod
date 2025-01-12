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

minimize
  sum(j in 1..NbSites, k in 1..3) CostSite[j] * s[k][j]
  - sum(i in 1..NbClient, j in 1..NbSites, k in 1..3) Probabilities[k] * Revenues[i][j] * x[k][i][j];

subject to {
  
  forall(j in 1..NbSites, k in 1..3)
    sum(i in 1..NbClient) x[k][i][j] <= Capacities[j] * s[k][j];

  forall(i in 1..NbClient) {
    sum(j in 1..NbSites) x[1][i][j] == DemandsBase[i];
    sum(j in 1..NbSites) x[2][i][j] == DemandsLower[i];
    sum(j in 1..NbSites) x[3][i][j] == DemandsUpper[i];
  }
}

execute {
  var f=new IloOplOutputFile("wait-and-see-results.txt");
  f.writeln("Scenario 1 (Base Demands):");
  f.writeln("Selected Sites:");
  f.writeln(s[1]);
  f.writeln("Client-Site Allocations:");
  f.writeln(x[1]);

  f.writeln("Scenario 2 (Low Demands):");
  f.writeln("Selected Sites:");
  f.writeln(s[2]);
  f.writeln("Client-Site Allocations:");
  f.writeln(x[2]);

  f.writeln("Scenario 3 (High Demands):");
  f.writeln("Selected Sites:");
  f.writeln(s[3]);
  f.writeln("Client-Site Allocations:");
  f.writeln(x[3]);
  f.close();
}


