"""
Database Setup Script for Fake News Detection System
Run this script once to create all necessary database tables
"""

import MySQLdb
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# MySQL configuration
MYSQL_HOST = os.getenv('MYSQL_HOST', 'localhost')
MYSQL_USER = os.getenv('MYSQL_USER', 'root')
MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD', '')

DB_NAME = 'fake_news_detection'

# SQL commands to create database and tables
CREATE_DATABASE = f"CREATE DATABASE IF NOT EXISTS {DB_NAME};"

CREATE_USERS_TABLE = """
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
"""

CREATE_PREDICTIONS_TABLE = """
CREATE TABLE IF NOT EXISTS predictions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    text LONGTEXT,
    url VARCHAR(500),
    source VARCHAR(255),
    result VARCHAR(10),
    confidence FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
);
"""

def setup_database():
    """Create database and tables"""
    try:
        # Connect to MySQL without specifying a database
        print(f"Connecting to MySQL at {MYSQL_HOST}...")
        conn = MySQLdb.connect(
            host=MYSQL_HOST,
            user=MYSQL_USER,
            passwd=MYSQL_PASSWORD
        )
        cursor = conn.cursor()
        
        # Create database
        print(f"Creating database: {DB_NAME}...")
        cursor.execute(CREATE_DATABASE)
        print("✓ Database created successfully")
        
        # Select the database
        cursor.execute(f"USE {DB_NAME};")
        
        # Create users table
        print("Creating users table...")
        cursor.execute(CREATE_USERS_TABLE)
        print("✓ Users table created successfully")
        
        # Create predictions table
        print("Creating predictions table...")
        cursor.execute(CREATE_PREDICTIONS_TABLE)
        print("✓ Predictions table created successfully")
        
        # Commit changes
        conn.commit()
        print("\n" + "=" * 60)
        print("✅ DATABASE SETUP COMPLETE!")
        print("=" * 60)
        print(f"Database: {DB_NAME}")
        print("Tables created: users, predictions")
        print("\nAdmin user creation (optional):")
        print("Run the following command to add an admin user:")
        print("python -c \"from werkzeug.security import generate_password_hash; print(generate_password_hash('admin123'))\"")
        print("\nThen insert into users table:")
        print("INSERT INTO users (username, email, password, role) VALUES ('admin', 'admin@example.com', '<hashed_password>', 'admin');")
        
        cursor.close()
        conn.close()
        
    except MySQLdb.Error as e:
        print(f"❌ MySQL Error: {e}")
        print("\nTroubleshooting:")
        print("1. Make sure MySQL is running")
        print("2. Check MySQL credentials in .env file")
        print("3. Verify MySQL user has required permissions")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False
    
    return True

if __name__ == '__main__':
    print("\n" + "=" * 60)
    print("FAKE NEWS DETECTION - DATABASE SETUP")
    print("=" * 60 + "\n")
    
    if setup_database():
        print("\n✅ Setup completed successfully!")
    else:
        print("\n❌ Setup failed. Please check the errors above.")
