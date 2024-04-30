import datetime
import time
import json
from faker import Faker

fake = Faker()

def main():
    for i in range(1000):
        rec = {
            '__time': int(time.time()) * 1000,
            'uid': '{:04d}'.format(i),
            'profile': fake.simple_profile()
        }
        # format the birth data as a string
        rec['profile']['birthdate'] = rec['profile']['birthdate'].strftime('%Y-%m-%d')
        print(json.dumps(rec))

if __name__ == "__main__":
    main()

