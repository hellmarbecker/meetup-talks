import random
from datetime import date, timedelta

MAXUSERS = 10000

def daterange(start_date, end_date):
    for n in range(int((end_date - start_date).days)):
        yield start_date + timedelta(n)

def main():

    start_date = date(2022, 1, 1)
    end_date = date(2022, 2, 1)
    for single_date in daterange(start_date, end_date):
        print(single_date.strftime("%Y-%m-%d") + ",u" + "{:04d}".format(random.randrange(MAXUSERS)))


if __name__ == "__main__":
    main()
