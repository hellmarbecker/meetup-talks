import math, random
import json
from datetime import date, datetime, timedelta

MAXUSERS = 10000
COHORTS = 100
ROWSPERHOUR = 1000000
PARETO_K = 1.5

def genUsers():

    users = []
    for u in range(MAXUSERS):
        cohorts = []
        for c in range(COHORTS):
            if random.random() < PARETO_K / math.pow(c + 1, PARETO_K + 1):    # 0.5 * math.exp(-c / (2.0 * COHORTS)):
                cohorts.append("c" + "{:04d}".format(c))
        users.append({
            "user": "u" + "{:04d}".format(u),
            "cohort": cohorts
        })
    return users
 

def datetimerange(start_date):
    for n in range(24):
        yield start_date + timedelta(hours=n)


def main():

    users = genUsers()

    start_date = datetime(2022, 1, 1)
    for ts in datetimerange(start_date):
        this_dt = ts.strftime("%Y-%m-%dT%H:%M:%SZ")
        for i in range(ROWSPERHOUR):
            uid = random.randrange(MAXUSERS)
            row = dict([("ts", this_dt)]) | users[uid]
            print(json.dumps(row))


if __name__ == "__main__":
    main()
