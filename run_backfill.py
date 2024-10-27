import os
import glob
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
        return None

def connect_to_database(host, user, password, database, port=3306):
    """Establishes a connection to the MySQL database using PyMySQL."""
    try:
        connection = pymysql.connect(
            host=host,
            user=user,
            password=password,
            database=database,
            port=port,
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=False
        )
        print("Connected to the database.")
        return connection
    except MySQLError as e:
        print(f"Error while connecting to MySQL: {e}")
        return None

def execute_sql_scripts(connection, folder_path):
    """Executes all SQL scripts in the specified folder."""
    try:
        with connection.cursor() as cursor:
            sql_files = glob.glob(os.path.join(folder_path, "*.sql"))
            sql_files.sort()  # Optional: ensure scripts are executed in order

            for sql_file in sql_files:
                print(f"Executing script: {sql_file}")
                try:
                    with open(sql_file, 'r') as file:
                        sql_script = file.read()
                        # Split the script into individual statements
                        statements = sql_script.strip().split(';')
                        for statement in statements:
                            if statement.strip():
                                cursor.execute(statement)
                        connection.commit()
                        print(f"Successfully executed {sql_file}")
                except Exception as e:
                    print(f"Error executing {sql_file}: {e}")
                    connection.rollback()
    except MySQLError as e:
        print(f"Database error: {e}")
    finally:
        connection.close()
        print("Database connection closed.")

def main():
    # Path to your terraform.tfvars file
    tfvars_path = 'terraform.tfvars'

    # Read variables from tfvars file
    tfvars = read_tfvars(tfvars_path)
    if tfvars is None:
        return

    # Extract required variables
    host = tfvars.get('public_ip_address', '127.0.0.1')
    user = tfvars.get('db_user')
    password = tfvars.get('db_password')
    database = tfvars.get('database_name')
    port = 3306  # Default MySQL port

    if not all([user, password, database]):
        print("Database credentials are missing in terraform.tfvars.")
        return

    # Connect to the database
    connection = connect_to_database(host, user, password, database, port)
    if connection is None:
        return

    # Path to the backfill folder
    backfill_folder = 'backfill'

    # Execute SQL scripts
    execute_sql_scripts(connection, backfill_folder)

if __name__ == '__main__':
    main()
