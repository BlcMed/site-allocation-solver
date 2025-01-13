string DataVersion = ...;

int   NbClient = ...;
int   NbSites = ...;

range Clients = 1..NbClient;
range Sites = 1..NbSites;


float DemandsBase[1..NbClient] = ...;
float DemandsLower[1..NbClient] = ...;
float DemandsUpper[1..NbClient] = ...;
float Probabilities[1..3] = ...;
float ExpectedDemands[1..NbClient];

// Loop over all clients to compute their expected demand
execute {
  for(var i=1; i<=NbClient; i++)
  	ExpectedDemands[i] = Probabilities[1]*DemandsBase[i] + 
                       Probabilities[2]*DemandsLower[i] + 
                       Probabilities[3]*DemandsUpper[i];
}


float Capacities[Clients] = ...;
float CostSite[Sites] = ...;
float Revenues[Clients][Sites] = ...;

dvar int+ s[Sites];
dvar int+ x[Clients][Sites];
dvar float ObjectiveValue;
dvar float EEV;

minimize 
    ObjectiveValue;

subject to {
  forall(j in Sites)
    ct1:
        sum(i in Clients) x[i][j] <= Capacities[j] * s[j];
    
  forall(i in Clients)
    ct2:
        sum(j in Sites) x[i][j] == ExpectedDemands[i];
  ObjectiveValue == sum(j in Sites) CostSite[j] * s[j] - sum(i in Clients, j in Sites) x[i][j] * Revenues[i][j] ;
  EEV == sum(j in Sites) CostSite[j] * s[j] - sum(i in Clients, j in Sites, k in 1..3) Probabilities[k] * Revenues[i][j] * x[i][j];
}

execute {
  var f=new IloOplOutputFile(DataVersion + "-EEV-results.txt");
  f.writeln("Objective Value, EV:");
  f.writeln(ObjectiveValue);

  f.writeln("\nEEV:");
  f.writeln(EEV);

  f.writeln("\nSelected Sites:");
  f.writeln(s);
  f.writeln("\nClient-Site Allocations:");
  f.writeln(x);
  f.close();
}

