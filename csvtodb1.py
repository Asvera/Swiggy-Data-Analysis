import sqlite3
import csv

# Path to your CSV file
csv_file_path = 'Swiggy.csv'
sqlite_db = 'data.db'

conn = sqlite3.connect(sqlite_db)
cursor = conn.cursor()

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

# Helper function to check if a value is cleanly numeric
def is_clean_number(val):
    if not val:
        return False
    try:
        float(val)
        return True
    except ValueError:
        return False

with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    reader.fieldnames = [h.strip() for h in reader.fieldnames]

    skipped_rows = 0
    inserted_rows = 0

    for row in reader:
        price = row['price'].strip()
        cost = row['cost_per_person'].strip()

        # Skip row if price or cost is not a clean number
        if not is_clean_number(price) or not is_clean_number(cost):
            skipped_rows += 1
            continue

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
            float(row['rating']) if is_clean_number(row['rating']) else None,
            float(cost),
            row['cuisine'],
            row['restaurant_link'],
            row['menu_category'],
            row['item'],
            float(price),
            row['veg_or_non-veg']
        ))
        inserted_rows += 1

conn.commit()
conn.close()

print(f"Done! Inserted: {inserted_rows} rows, Skipped: {skipped_rows} rows with invalid price or cost.")
