USER_CSV = "CSV/users.csv"
import csv

class DataGen:
  def __init__(self):
    self.output = None

  def generate_users(self):
    self.output = USER_CSV
    names = ["Alice", "Bob", "Charlie", "David", "Emily", "Frank", "Grace", "Henry", "Isabel", "John",
         "Kate", "Liam", "Molly", "Nathan", "Olivia", "Paul", "Quinn", "Rachel", "Samuel", "Taylor",
         "Victoria", "William", "Xander", "Yara", "Zachary"]
    
    data = [[name] for name in names]
    
    with open(self.output, 'w') as csv_file:
      csv_writer = csv.writer(csv_file)
      csv_writer.writerow(['name'])
      csv_writer.writerows(data)
    

if __name__ == "__main__":
  gen = DataGen()
  gen.generate_users()