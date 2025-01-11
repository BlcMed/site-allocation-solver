import random

MIN_DEMAND = 10
MAX_DEMAND = 50
CAPACITY_RANGE = 100
MIN_CONSTRUCTION_COST = 1000
MAX_CONSTRUCTION_COST = 5000
MIN_REVENUE = 10
MAX_REVENUE = 100
DATA_PATH = "deterministic-demands/deterministic-demands.dat"


def generate_data(num_clients=6, num_sites=3, seed=None):
    """
    Generate random data for clients and sites.

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

    construction_costs = [
        random.randint(MIN_CONSTRUCTION_COST, MAX_CONSTRUCTION_COST)
        for _ in range(num_sites)
    ]
    demands = [random.randint(MIN_DEMAND, MAX_DEMAND) for _ in range(num_clients)]
    total_demand = sum(demands)
    min_total_capacity = int(total_demand / num_sites)
    capacities = []
    total_capacity = 0

    while total_capacity < total_demand:
        capacities = [
            random.randint(min_total_capacity, CAPACITY_RANGE) for _ in range(num_sites)
        ]
        total_capacity = sum(capacities)

    data = {
        "demands": demands,
        "capacities": capacities,
        "construction_costs": construction_costs,
        "revenues": revenues,
        "max_demands": total_capacity + 1,
    }

    return data


def save_as_dat(data, file_path):
    with open(file_path, "w") as file:
        file.write(f"NbClient = {len(data['demands'])};\n")
        file.write(f"NbSites = {len(data['capacities'])};\n")
        file.write(f"MaxDemands = {data['max_demands']} ;\n\n")

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


if __name__ == "__main__":
    data = generate_data(num_clients=6, num_sites=3, seed=42)
    print("Generated Data:")
    print(data)
    save_as_dat(data, file_path=DATA_PATH)
