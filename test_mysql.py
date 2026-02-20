import mysql.connector

# Establish connection
conn = mysql.connector.connect(
    host="localhost",
    user="opinix_user",
    password="MyStrongPass123!",  # change later for security
    database="opinix_db",
    port=3306
)

cur = conn.cursor()

# Check database + user + version
cur.execute("SELECT DATABASE(), USER(), VERSION();")
print("DB/User/Version:", cur.fetchone())

# Show tables
cur.execute("SHOW TABLES;")
print("Tables:", cur.fetchall())

# Close connection
cur.close()
conn.close()

print("✅ Connection OK")