-- Drop tables if they already exist to ensure a clean setup
DROP TABLE IF EXISTS COVERLETTER;
DROP TABLE IF EXISTS RESUME;
DROP TABLE IF EXISTS EDUCATION;
DROP TABLE IF EXISTS EMPLOYMENT;
DROP TABLE IF EXISTS DOCUMENT;
DROP TABLE IF EXISTS JOBDESCRIPTION;
DROP TABLE IF EXISTS JOBAPPLICATION;
DROP TABLE IF EXISTS EXPERIENCE;
DROP TABLE IF EXISTS USERS;

-- Create USERS table
CREATE TABLE USERS (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20),
    JobStatus ENUM('Employed', 'Student', 'Unemployed') NOT NULL,
    DateJoin DATE NOT NULL
) ENGINE=InnoDB;

-- Create JOBAPPLICATION table
CREATE TABLE JOBAPPLICATION (
    ApplicationID INT AUTO_INCREMENT PRIMARY KEY,
    Status ENUM('Not started', 'In progress', 'Applied', 'Interview Scheduled', 'Interview', 'Rejected', 'Accepted') NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES USERS(UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create JOBDESCRIPTION table
CREATE TABLE JOBDESCRIPTION (
    JobID INT AUTO_INCREMENT PRIMARY KEY,
    JobTitle VARCHAR(255) NOT NULL,
    Company VARCHAR(255) NOT NULL,
    JobDescription TEXT NOT NULL,
    ApplicationID INT NOT NULL UNIQUE,
    FOREIGN KEY (ApplicationID) REFERENCES JOBAPPLICATION(ApplicationID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create DOCUMENT table
CREATE TABLE DOCUMENT (
    DocumentID INT AUTO_INCREMENT PRIMARY KEY,
    DocumentType ENUM('Cover Letter', 'Resume') NOT NULL,
    ApplicationID INT NOT NULL UNIQUE,
    FOREIGN KEY (ApplicationID) REFERENCES JOBAPPLICATION(ApplicationID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create EXPERIENCE table
CREATE TABLE EXPERIENCE (
    ExperienceID INT AUTO_INCREMENT PRIMARY KEY,
    ExperienceType ENUM('Education', 'Employment') NOT NULL,
    OrganizationName VARCHAR(255) UNIQUE NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES USERS(UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create COVERLETTER table
CREATE TABLE COVERLETTER (
    CoverLetterBody TEXT NOT NULL,
    DocumentID INT PRIMARY KEY,
    FOREIGN KEY (DocumentID) REFERENCES DOCUMENT(DocumentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create RESUME table
CREATE TABLE RESUME (
    ResumeBody TEXT NOT NULL,
    DocumentID INT PRIMARY KEY,
    FOREIGN KEY (DocumentID) REFERENCES DOCUMENT(DocumentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create EDUCATION table
CREATE TABLE EDUCATION (
    Degree VARCHAR(100) NOT NULL,
    StudyField VARCHAR(50) NOT NULL,
    Grade FLOAT,
    StartDate DATE NOT NULL,
    EndDate DATE,
    ExperienceID INT PRIMARY KEY,
    FOREIGN KEY (ExperienceID) REFERENCES EXPERIENCE(ExperienceID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create EMPLOYMENT table
CREATE TABLE EMPLOYMENT (
    JobTitle VARCHAR(255) NOT NULL,
    JobDescription TEXT,
    StartDate DATE NOT NULL,
    EndDate DATE,
    ExperienceID INT PRIMARY KEY,
    FOREIGN KEY (ExperienceID) REFERENCES EXPERIENCE(ExperienceID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;


-- -- Insert dummy data
-- -- Insert into USERS
-- INSERT INTO USERS (Email, Password, FirstName, LastName, PhoneNumber, JobStatus, DateJoin) VALUES
-- ('john.doe@example.com', 'password123', 'John', 'Doe', '123-456-7890', 'Active', '2023-01-15'),
-- ('jane.smith@example.com', 'securepass', 'Jane', 'Smith', '234-567-8901', 'Active', '2023-02-20'),
-- ('alice.johnson@example.com', 'alicepwd', 'Alice', 'Johnson', '345-678-9012', 'Inactive', '2022-11-05'),
-- ('bob.brown@example.com', 'bobsecure', 'Bob', 'Brown', '456-789-0123', 'Active', '2023-03-10'),
-- ('carol.white@example.com', 'carolpass', 'Carol', 'White', '567-890-1234', 'Active', '2023-04-25'),
-- ('david.green@example.com', 'david123', 'David', 'Green', '678-901-2345', 'Inactive', '2022-10-30'),
-- ('eve.black@example.com', 'evepwd', 'Eve', 'Black', '789-012-3456', 'Active', '2023-05-18'),
-- ('frank.yellow@example.com', 'franksecure', 'Frank', 'Yellow', '890-123-4567', 'Active', '2023-06-22'),
-- ('grace.blue@example.com', 'gracepass', 'Grace', 'Blue', '901-234-5678', 'Active', '2023-07-14'),
-- ('henry.red@example.com', 'henrypwd', 'Henry', 'Red', '012-345-6789', 'Inactive', '2022-09-12');

-- -- Insert into JOBAPPLICATION
-- INSERT INTO JOBAPPLICATION (Status, UserID) VALUES
-- ('Applied', 1),
-- ('In Progress', 2),
-- ('Not Started', 3),
-- ('Interview Scheduled', 4),
-- ('Rejected', 5),
-- ('Accepted', 6),
-- ('Applied', 7),
-- ('In Progress', 8),
-- ('Applied', 9),
-- ('Not Started', 10);

-- -- Insert into JOBDESCRIPTION
-- INSERT INTO JOBDESCRIPTION (JobTitle, Company, JobDescription, ApplicationID) VALUES
-- ('Software Engineer', 'TechCorp', 'Develop and maintain software applications.', 1),
-- ('Data Analyst', 'DataSolutions', 'Analyze and interpret complex data sets.', 2),
-- ('Project Manager', 'BuildIt', 'Manage project timelines and deliverables.', 3),
-- ('UX Designer', 'CreativeApps', 'Design user-friendly interfaces.', 4),
-- ('Marketing Specialist', 'MarketGuru', 'Develop marketing strategies.', 5),
-- ('DevOps Engineer', 'CloudNet', 'Maintain CI/CD pipelines.', 6),
-- ('Product Manager', 'InnovateX', 'Oversee product development lifecycle.', 7),
-- ('Systems Administrator', 'NetSecure', 'Manage IT infrastructure.', 8),
-- ('Content Writer', 'WriteWell', 'Create engaging content for various platforms.', 9),
-- ('Quality Assurance', 'TestPro', 'Ensure product quality through testing.', 10);

-- -- Insert into DOCUMENT
-- INSERT INTO DOCUMENT (DocumentType, ApplicationID) VALUES
-- ('Resume', 1),
-- ('Cover Letter', 2),
-- ('Resume', 3),
-- ('Cover Letter', 4),
-- ('Resume', 5),
-- ('Cover Letter', 6),
-- ('Resume', 7),
-- ('Cover Letter', 8),
-- ('Resume', 9),
-- ('Cover Letter', 10);

-- -- Insert into EXPERIENCE
-- INSERT INTO EXPERIENCE (ExperienceType, OrganizationName, StartDate, EndDate, UserID) VALUES
-- ('Education', 'State University', '2018-09-01', '2022-06-30', 1),
-- ('Employment', 'TechCorp', '2022-07-01', NULL, 1),
-- ('Education', 'City College', '2015-09-01', '2019-05-30', 3),
-- ('Employment', 'DataSolutions', '2020-08-01', NULL, 4),
-- ('Education', 'Online University', '2017-01-10', '2019-12-20', 6),
-- ('Employment', 'BuildIt', '2021-02-01', NULL, 7),
-- ('Employment', 'CreativeApps', '2022-01-15', NULL, 9);


-- -- Insert into COVERLETTER
-- INSERT INTO COVERLETTER (CoverLetterBody, DocumentID) VALUES
-- ('Dear Hiring Manager, I am excited to apply for the Software Engineer position...', 2),
-- ('Dear DataSolutions Team, I am writing to express my interest in the Data Analyst role...', 4),
-- ('Dear Project Manager Hiring Committee, I am enthusiastic about the Project Manager position...', 6),
-- ('Dear CreativeApps Team, I am passionate about UX Design and would love to contribute...', 8),
-- ('Dear MarketGuru Recruiters, I am eager to apply for the Marketing Specialist position...', 10);

-- -- Insert into RESUME
-- INSERT INTO RESUME (ResumeBody, DocumentID) VALUES
-- ('John Doe Resume: Experienced Software Engineer with expertise in Java and Python...', 1),
-- ('Jane Smith Resume: Data Analyst skilled in SQL, Python, and data visualization...', 3),
-- ('Alice Johnson Resume: Project Manager with PMP certification and 5 years of experience...', 5),
-- ('Bob Brown Resume: UX Designer proficient in Adobe XD, Figma, and user research...', 7),
-- ('Carol White Resume: Marketing Specialist with a strong background in digital marketing...', 9);

-- -- Insert into EDUCATION
-- INSERT INTO EDUCATION (Degree, Grade, ExperienceID) VALUES
-- ('B.Sc. in Computer Science', 3.8, 1),
-- ('M.A. in Data Science', 3.6, 4),
-- ('B.A. in Project Management', 3.7, 10),
-- ('B.F.A. in UX Design', 3.9, 7),
-- ('B.B.A. in Marketing', 3.5, 8);

-- -- Insert into EMPLOYMENT
-- INSERT INTO EMPLOYMENT (JobTitle, JobDescription, ExperienceID) VALUES
-- ('Software Engineer', 'Developed backend services using Java and Spring Framework.', 2),
-- ('Data Analyst', 'Performed data cleaning and visualization using Python and Tableau.', 5),
-- ('Marketing Specialist', 'Implemented digital marketing campaigns to increase brand awareness.', 8);
