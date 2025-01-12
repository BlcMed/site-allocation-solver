/*********************************************
 * OPL 22.1.1.0 Model
 * Author: cuphead
 * Creation Date: Jan 6, 2025 at 5:00:50 PM
 *********************************************/

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
dvar float+ x[1..NbClient][1..NbSites][1..3];

minimize 
  sum(j in 1..NbSites) CostSite[j] * s[j] 
  - sum(i in 1..NbClient, j in 1..NbSites, k in 1..3) Probabilities[k] * Revenues[i][j] * x[i][j][k];

subject to {
  
  forall(j in 1..NbSites)
    sum(i in 1..NbClient, k in 1..3) x[i][j][k] <= Capacities[j] * s[j];

  forall(i in 1..NbClient, k in 1..3) {
    if (k == 1)  // Base scenario
      sum(j in 1..NbSites) x[i][j][k] == DemandsBase[i];
    else if (k == 2)  // Lower demand scenario
      sum(j in 1..NbSites) x[i][j][k] == DemandsLower[i];
    else  // Upper demand scenario
      sum(j in 1..NbSites) x[i][j][k] == DemandsUpper[i];
  }

  sum(i in 1..NbClient) DemandsBase[i] <= sum(j in 1..NbSites) Capacities[j];
}
