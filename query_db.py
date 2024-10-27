import os
import pymysql
from pymysql.err import MySQLError
import hcl2

def read_tfvars(tfvars_path):
    """Reads variables from a terraform.tfvars file."""
    try:
        with open(tfvars_path, 'r') as file:
            tfvars = hcl2.load(file)
            return tfvars
    except Exception as e:
        print(f"Error reading tfvars file: {e}")
        return {}

def get_connection_details():
    """Retrieves connection details from tfvars file or environment variables."""
    # Try to read from terraform.tfvars
    tfvars = read_tfvars('terraform.tfvars')

    # Extract variables from tfvars or environment variables
    host = tfvars.get('host') or tfvars.get('public_ip_address') or os.getenv('DB_HOST')
    port = tfvars.get('port') or os.getenv('DB_PORT')
    user = tfvars.get('db_user') or os.getenv('DB_USER')
    password = tfvars.get('db_password') or os.getenv('DB_PASSWORD')
    database = tfvars.get('database_name') or os.getenv('DB_NAME')

    # Set defaults if necessary
    host = host or '127.0.0.1'
    port = int(port) if port else 3306

    return host, port, user, password, database

def connect_to_server(host, user, password, port=3306, database=None):
    """Connect to the MySQL server."""
    try:
        connection = pymysql.connect(
            host=host,
            user=user,
            password=password,
            port=port,
            database=database,  # Connect to the specific database if provided
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=True
        )
        print("Connected to MySQL server.")
        return connection
    except MySQLError as e:
        print(f"Error connecting to MySQL server: {e}")
        return None

def list_databases(connection):
    """List all databases on the server."""
    try:
        with connection.cursor() as cursor:
            cursor.execute("SHOW DATABASES;")
            databases = cursor.fetchall()
            print("\nAvailable Databases:")
            for idx, db in enumerate(databases, start=1):
                print(f"{idx}. {db['Database']}")
            return [db['Database'] for db in databases]
    except MySQLError as e:
        print(f"Error listing databases: {e}")
        return []

def select_database(databases, selected_db=None):
    """Selects the database to use."""
    if selected_db and selected_db in databases:
        return selected_db
    else:
        # Prompt the user to select a database
        while True:
            try:
                choice = int(input("\nEnter the number of the database to connect: "))
                if 1 <= choice <= len(databases):
                    return databases[choice - 1]
                else:
                    print("Invalid choice. Please select a valid number.")
            except ValueError:
                print("Invalid input. Please enter a number.")

def list_tables(connection):
    """List all tables in the current database."""
    try:
        with connection.cursor() as cursor:
            cursor.execute("SHOW TABLES;")
            tables = cursor.fetchall()
            print(f"\nTables in '{connection.db.decode()}':")
            for idx, table in enumerate(tables, start=1):
                table_name = list(table.values())[0]
                print(f"{idx}. {table_name}")
            return [list(table.values())[0] for table in tables]
    except MySQLError as e:
        print(f"Error listing tables: {e}")
        return []

def show_table_head(connection, table_name):
    """Display column names and first 5 rows of the table."""
    try:
        with connection.cursor() as cursor:
            cursor.execute(f"DESCRIBE `{table_name}`;")
            columns = cursor.fetchall()
            column_names = [col['Field'] for col in columns]
            print(f"\nColumn Names in '{table_name}':")
            print(", ".join(column_names))

            cursor.execute(f"SELECT * FROM `{table_name}` LIMIT 5;")
            rows = cursor.fetchall()
            print(f"\nFirst 5 Rows of '{table_name}':")
            for row in rows:
                print(row)
    except MySQLError as e:
        print(f"Error retrieving data from '{table_name}': {e}")

def execute_query(connection, query):
    """Execute a user-provided SQL query and return the first 50 rows."""
    try:
        with connection.cursor() as cursor:
            cursor.execute(query)
            rows = cursor.fetchmany(size=50)
            print(f"\nQuery Result (up to 50 rows):")
            for row in rows:
                print(row)
    except MySQLError as e:
        print(f"Error executing query: {e}")

def main():
    print("MySQL Database Query Tool")

    # Get connection details
    host, port, user, password, selected_db = get_connection_details()

    if not all([host, user, password]):
        print("Database connection details are missing. Please check your tfvars file or environment variables.")
        return

    # Connect to the MySQL server
    connection = connect_to_server(host, user, password, port, database=selected_db)
    if not connection:
        return

    # If no specific database was provided, list databases and ask the user to select one
    if not selected_db:
        databases = list_databases(connection)
        if not databases:
            connection.close()
            return

        selected_db = select_database(databases)
        print(f"\nConnecting to database '{selected_db}'...")

        # Switch to the selected database
        try:
            connection.select_db(selected_db)
        except MySQLError as e:
            print(f"Error selecting database '{selected_db}': {e}")
            connection.close()
            return

    # List tables in the selected database
    tables = list_tables(connection)
    if not tables:
        connection.close()
        return

    print("\nYou can:")
    print("- Enter `head 'table_name'` to view column names and first 5 rows of a table.")
    print("- Enter a SQL query to execute (results limited to 50 rows).")
    print("- Enter `exit` to quit.")

    while True:
        user_input = input("\nEnter command or SQL query: ").strip()
        if user_input.lower() == 'exit':
            break
        elif user_input.lower().startswith("head"):
            parts = user_input.split()
            if len(parts) >= 2:
                table_name = ' '.join(parts[1:]).strip("'\"")
                if table_name in tables:
                    show_table_head(connection, table_name)
                else:
                    print(f"Table '{table_name}' does not exist in database '{selected_db}'.")
            else:
                print("Usage: head 'table_name'")
        else:
            execute_query(connection, user_input)

    connection.close()
    print("\nDisconnected from the server.")

if __name__ == "__main__":
    main()
