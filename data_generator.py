import random

MIN_DEMAND = 10
MAX_DEMAND = 50
CAPACITY_RANGE = 100
MIN_COST = 1000
MAX_COST = 5000
MIN_REVENUE = 10
MAX_REVENUE = 100
MIN_CAPACITY, MAX_CAPACITY = 150, 300
DETERMINISTIC_DATA_PATH = "deterministic-demands/deterministic-demands.dat"
STOCHASTIC_DATA_PATH = "stochastic-demands/stochastic-demands.dat"


def generate_deterministic_data(num_clients=6, num_sites=3, seed=None):
    """
    Generate random deteministic data for clients and sites.

    Args:
        num_clients (int): Number of clients.
        num_sites (int): Number of potential sites.
        seed (int, optional): Random seed for reproducibility.

    Returns:
        dict: A dictionary containing client demands, site capacities,
              construction costs, and revenues between clients and sites.
    """
    if seed is not None:
        random.seed(seed)

    revenues = [
        [random.randint(MIN_REVENUE, MAX_REVENUE) for _ in range(num_sites)]
        for _ in range(num_clients)
    ]

    construction_costs = [random.randint(MIN_COST, MAX_COST) for _ in range(num_sites)]
    demands = [random.randint(MIN_DEMAND, MAX_DEMAND) for _ in range(num_clients)]
    total_demand = sum(demands)
    min_capacity = int(total_demand / num_sites)
    capacities = []
    total_capacity = 0

    # To ensure feasibility
    while total_capacity < total_demand:
        capacities = [
            random.randint(min_capacity, CAPACITY_RANGE) for _ in range(num_sites)
        ]
        total_capacity = sum(capacities)

    data = {
        "demands": demands,
        "capacities": capacities,
        "construction_costs": construction_costs,
        "revenues": revenues,
    }

    return data


def generate_stochastic_data(num_clients, num_sites, delta=0.2, seed=None):
    if seed is not None:
        random.seed(seed)
    revenue = [
        [random.randint(MIN_REVENUE, MAX_REVENUE) for _ in range(num_sites)]
        for _ in range(num_clients)
    ]

    construction_cost = [random.randint(MIN_COST, MAX_COST) for _ in range(num_sites)]

    base_demand = [random.randint(MIN_DEMAND, MAX_DEMAND) for _ in range(num_clients)]
    # Demand scenarios with delta variation
    demand_scenarios = {
        "base": base_demand,
        "low": [int(d * (1 - delta)) for d in base_demand],
        "high": [int(d * (1 + delta)) for d in base_demand],
    }

    # Site capacities q_j
    capacities = [random.randint(MIN_CAPACITY, MAX_CAPACITY) for _ in range(num_sites)]

    data = {
        "num_clients": num_clients,
        "num_sites": num_sites,
        "revenue": revenue,
        "construction_cost": construction_cost,
        "demand_scenarios": demand_scenarios,
        "probabilities": [0.2, 0.45, 0.35],
        "capacities": capacities,
    }

    return data


def save_deterministic_as_dat(data, file_path=DETERMINISTIC_DATA_PATH):
    with open(file_path, "w") as file:
        file.write(f"NbClient = {len(data['demands'])};\n")
        file.write(f"NbSites = {len(data['capacities'])};\n")

        file.write("Demands = [ " + ", ".join(map(str, data["demands"])) + " ];\n")

        file.write(
            "Capacities = [ " + ", ".join(map(str, data["capacities"])) + " ];\n"
        )

        file.write(
            "CostSite = [ " + ", ".join(map(str, data["construction_costs"])) + " ];\n"
        )

        file.write("Revenues = [\n")
        for revenue_row in data["revenues"]:
            file.write("  [ " + ", ".join(map(str, revenue_row)) + " ],\n")
        file.write("];\n")

    print(f"Data saved to {file_path}")


def save_stochastic_as_dat(data, file_path=STOCHASTIC_DATA_PATH):
    with open(file_path, "w") as file:
        file.write(f"NbClient = {data['num_clients']};\n")
        file.write(f"NbSites = {data['num_sites']};\n")

        file.write("Revenues = [\n")
        for row in data["revenue"]:
            file.write("  [ " + ", ".join(map(str, row)) + " ],\n")
        file.write("];\n\n")

        file.write(
            "CostSite = [ " + ", ".join(map(str, data["construction_cost"])) + " ];\n\n"
        )

        file.write(
            "DemandsBase = [ "
            + ", ".join(map(str, data["demand_scenarios"]["base"]))
            + " ];\n"
        )
        file.write(
            "DemandsLower = [ "
            + ", ".join(map(str, data["demand_scenarios"]["low"]))
            + " ];\n"
        )
        file.write(
            "DemandsUpper = [ "
            + ", ".join(map(str, data["demand_scenarios"]["high"]))
            + " ];\n\n"
        )

        file.write(
            "Probabilities = [ " + ", ".join(map(str, data["probabilities"])) + " ];\n"
        )

        file.write(
            "Capacities = [ " + ", ".join(map(str, data["capacities"])) + " ];\n"
        )


if __name__ == "__main__":
    deterministic_data = generate_deterministic_data(
        num_clients=6, num_sites=3, seed=42
    )
    print("Generated Deterministic Data:")
    print(deterministic_data)
    save_deterministic_as_dat(deterministic_data)

    stochastic_data = generate_stochastic_data(num_clients=6, num_sites=3, delta=0.2)
    print("Generated Stochastic Data:")
    print(stochastic_data)
    save_stochastic_as_dat(stochastic_data)
