import math, random
import json
from datetime import date, datetime, timedelta
from faker import Faker

ROWSPERSEC = 1000
NUMSCHEMA = 10

dim_list = ['dim' + str(i) for i in range(10)]

def datetimerange(start_date):
    for n in range(7 * 24 * 60 * 60): # 1 week, 1 record per second
        yield start_date + timedelta(seconds=n)


def main():

    fake = Faker()
    fake.set_arguments('w', {'nb':2})

    spec = []
    for n in range(NUMSCHEMA):
        fields = fake.words(nb = 5, ext_word_list = dim_list) 
        spec.append({ f : fake.word(ext_word_list = ['pyint', 'word', 'pyfloat']) for f in fields })

    start_date = datetime(2022, 1, 1)
    for ts in datetimerange(start_date):
        this_dt = ts.strftime("%Y-%m-%dT%H:%M:%SZ")
        for i in range(ROWSPERSEC):
            obj = json.loads(fake.json(data_columns=spec[fake.random_int(0, NUMSCHEMA-1)], num_rows=1))
            row = dict([("ts", this_dt)]) | obj
            print(json.dumps(row))


if __name__ == "__main__":
    main()
