/*********************************************
 * OPL 22.1.1.0 Model
 * Author: cuphead
 * Creation Date: Jan 2, 2025 at 11:04:26 PM
 *********************************************/

int   NbClient = ...;
int   NbSites = ...;

range Clients = 1..NbClient;
range Sites = 1..NbSites;


float Demands[Clients] = ...;
float Capacities[Clients] = ...;
float CostSite[Sites] = ...;
float Revenues[Clients][Sites] = ...;

dvar int+ s[Sites];
dvar int+ x[Clients][Sites];
dvar float ObjectiveValue;

minimize 
    ObjectiveValue;

subject to {
  forall(j in Sites)
    ct1:
        sum(i in Clients) x[i][j] <= Capacities[j] * s[j];
    
  forall(i in Clients)
    ct2:
        sum(j in Sites) x[i][j] == Demands[i];
  ObjectiveValue == sum(j in Sites) CostSite[j] * s[j] - sum(i in Clients, j in Sites) x[i][j] * Revenues[i][j] ;
  
}

execute {
  var f=new IloOplOutputFile("results.txt");
  f.writeln("Objective Value:");
  f.writeln(ObjectiveValue);
  f.writeln("\nSelected Sites:");
  f.writeln(s);
  f.writeln("\nClient-Site Allocations:");
  f.writeln(x);
  f.close();
}

