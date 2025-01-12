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

dvar boolean s[1..NbSites][1..3];
dvar float+ x[1..NbClient][1..NbSites][1..3];

minimize 
  sum(j in 1..NbSites, k in 1..3) CostSite[j] * s[j][k] 
  - sum(i in 1..NbClient, j in 1..NbSites, k in 1..3) Probabilities[k] * Revenues[i][j] * x[i][j][k];

subject to {
  
  forall(j in 1..NbSites, k in 1..3)
    sum(i in 1..NbClient) x[i][j][k] <= Capacities[j] * s[j][k];

  forall(i in 1..NbClient) {
    sum(j in 1..NbSites) x[i][j][1] == DemandsBase[i];
    sum(j in 1..NbSites) x[i][j][2] == DemandsLower[i];
    sum(j in 1..NbSites) x[i][j][3] == DemandsUpper[i];
  }
}


