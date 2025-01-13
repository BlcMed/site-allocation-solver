# Location Allocation Optimization  

This repository implements a stochastic optimization problem using the **Stochastic Programs with Recourse** formulation. The goal is to analyze and solve the problem under different demand variances using various models.

## Repository Structure

```
.
├── data_generator.py            # Script to generate demand data
├── deterministic-demands        # Deterministic model and results
│   ├── deterministic-demands.dat
│   ├── deterministic-demands.mod
│   └── results.txt
├── README.md                    # Project documentation
└── stochastic-demands           # Stochastic models, data, and results
    ├── data                    # Demand datasets with different variances
    │   ├── high-var-demands.dat
    │   ├── low-var-demands.dat
    │   └── stochastic-demands.dat
    ├── models                  # OPL models for different approaches
    │   ├── deterministic-equivalent.mod
    │   ├── expected-value-problem.mod
    │   └── wait-and-see.mod
    └── results                # Result files for each scenario and model
        ├── stochastic-demands-deterministic-equivalent-results.txt
        ├── ...
        └── stochastic-demands-wait-and-see-results.txt
```

## Models Description

### 1. **Deterministic Equivalent Model** (`deterministic-equivalent.mod`)
- Provides the **PDE (Primal Deterministic Equivalent)** formulation of the stochastic problem.
- Incorporates all demand scenarios into a single model.

### 2. **Wait-and-See Model** (`wait-and-see.mod`)
- Calculates the **Wait-and-See (W&S)** solution.
- Evaluates the objective function in each scenario assuming perfect foresight of demand.

### 3. **Expected Value Problem** (`expected-value-problem.mod`)

**Approximation by Estimated Values**  
The optimal solution of the Expected Value Problem (EVP) assumes that the uncertain parameters take their average values. This result represents the objective function value when using this solution.  

**Expectation of Expected Value (EEV)**  
To evaluate the quality of the solution from the EVP, the expected objective value is calculated by considering all possible scenarios of the uncertain parameters while keeping the same solution.


## Demand Scenarios

The models are tested under three demand scenarios with varying levels of uncertainty:

1. **Low Variance Demand** (`low-var-demands.dat`)
2. **High Variance Demand** (`high-var-demands.dat`)
3. **Base Stochastic Demand** (`stochastic-demands.dat`)

## Results

All models generate their results in the `stochastic-demands/results/` folder with descriptive filenames:

- **Deterministic Equivalent Results:** `*-deterministic-equivalent-results.txt`
- **Expected Value Problem Results:** `*-EEV-results.txt`
- **Wait-and-See Results:** `*-wait-and-see-results.txt`

## How to Run

1. **Generate Data (if needed):**
   ```bash
   python data_generator.py
   ```

2. **Solve Models in IBM ILOG CPLEX Optimization Studio:**
   - Open the desired model (`.mod`) and corresponding data (`.dat`).
   - Run the model to generate results in the `results/` folder.

## Metrics Explained

- **Deterministic Equivalent Solution (PDE):** Optimal solution that incorporates all possible scenarios of uncertainty into a single model.  
- **Wait-and-See (W&S):** Solution obtained with perfect knowledge of future demand, representing the best possible outcome.  
- **Expected Value (EV):** Solution derived by solving the problem using the average demand values.  
- **Estimation of Expected Value (EEV):** Expected performance of the EV solution across all scenarios.

## Dependencies

- IBM ILOG CPLEX Optimization Studio (for running `.mod` models)
- Python 3.x (for `data_generator.py`)

## Getting Started  

1. Clone the repository:  
   ```bash  
   git clone https://github.com/BlcMed/site-allocation-solver.git
   cd site-allocation-solver/
   ```  

## Documentation

Refer to the [Wiki](https://github.com/BlcMed/site-allocation-solver/wiki) for detailed theory and mathematical modeling.  

## License

This project is for educational and research purposes.
