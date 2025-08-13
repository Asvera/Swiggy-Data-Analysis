import sqlite3
import csv

# Path to your CSV file
csv_file_path = 'Swiggy.csv'

# Name of the SQLite database file
sqlite_db = 'data.db'

# Connect to SQLite database (or create it if it doesn't exist)
conn = sqlite3.connect(sqlite_db)
cursor = conn.cursor()

# Create table with appropriate schema
cursor.execute('''
CREATE TABLE IF NOT EXISTS restaurants (
    restaurant_no INTEGER,
    restaurant_name TEXT,
    city TEXT,
    address TEXT,
    rating REAL,
    cost_per_person REAL,
    cuisine TEXT,
    restaurant_link TEXT,
    menu_category TEXT,
    item TEXT,
    price REAL,
    veg_or_non_veg TEXT
)
''')

# Open the CSV file and read the data
with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    
    for row in reader:
        cursor.execute('''
            INSERT INTO restaurants (
                restaurant_no,
                restaurant_name,
                city,
                address,
                rating,
                cost_per_person,
                cuisine,
                restaurant_link,
                menu_category,
                item,
                price,
                veg_or_non_veg
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            int(row['restaurant_no']),
            row['restaurant_name'],
            row['city'],
            row['address'],
            float(row['rating']) if row['rating'] else None,
            float(row['cost_per_person']) if row['cost_per_person'] else None,
            row['cuisine'],
            row['restaurant_link'],
            row['menu_category'],
            row['item'],
            float(row['price']) if row['price'] else None,
            row['veg_or_non-veg']
        ))

# Commit changes and close connection
conn.commit()
conn.close()

print("Data inserted successfully into SQLite database.")
