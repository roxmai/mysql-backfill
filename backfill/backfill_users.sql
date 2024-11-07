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


-- Insert dummy data

-- Insert into USERS
INSERT INTO USERS (Email, Password, FirstName, LastName, PhoneNumber, JobStatus, DateJoin) VALUES
('john.doe@example.com', 'password123', 'John', 'Doe', '123-456-7890', 'Employed', '2023-01-15'),
('jane.smith@example.com', 'securepass', 'Jane', 'Smith', '234-567-8901', 'Employed', '2023-02-20'),
('alice.johnson@example.com', 'alicepwd', 'Alice', 'Johnson', '345-678-9012', 'Unemployed', '2022-11-05'),
('bob.brown@example.com', 'bobsecure', 'Bob', 'Brown', '456-789-0123', 'Employed', '2023-03-10'),
('carol.white@example.com', 'carolpass', 'Carol', 'White', '567-890-1234', 'Employed', '2023-04-25'),
('david.green@example.com', 'david123', 'David', 'Green', '678-901-2345', 'Unemployed', '2022-10-30'),
('eve.black@example.com', 'evepwd', 'Eve', 'Black', '789-012-3456', 'Employed', '2023-05-18'),
('frank.yellow@example.com', 'franksecure', 'Frank', 'Yellow', '890-123-4567', 'Employed', '2023-06-22'),
('grace.blue@example.com', 'gracepass', 'Grace', 'Blue', '901-234-5678', 'Employed', '2023-07-14'),
('henry.red@example.com', 'henrypwd', 'Henry', 'Red', '012-345-6789', 'Unemployed', '2022-09-12');

-- Insert into JOBAPPLICATION
INSERT INTO JOBAPPLICATION (Status, UserID) VALUES
('Applied', 1),
('In progress', 2),
('Not started', 3),
('Interview Scheduled', 4),
('Rejected', 5),
('Accepted', 6),
('Applied', 7),
('In progress', 8),
('Applied', 9),
('Not started', 10);

-- Insert into JOBDESCRIPTION
INSERT INTO JOBDESCRIPTION (JobTitle, Company, JobDescription, ApplicationID) VALUES
('Software Engineer', 'TechCorp', 'Develop and maintain software applications.', 1),
('Data Analyst', 'DataSolutions', 'Analyze and interpret complex data sets.', 2),
('Project Manager', 'BuildIt', 'Manage project timelines and deliverables.', 3),
('UX Designer', 'CreativeApps', 'Design user-friendly interfaces.', 4),
('Marketing Specialist', 'MarketGuru', 'Develop marketing strategies.', 5),
('DevOps Engineer', 'CloudNet', 'Maintain CI/CD pipelines.', 6),
('Product Manager', 'InnovateX', 'Oversee product development lifecycle.', 7),
('Systems Administrator', 'NetSecure', 'Manage IT infrastructure.', 8),
('Content Writer', 'WriteWell', 'Create engaging content for various platforms.', 9),
('Quality Assurance', 'TestPro', 'Ensure product quality through testing.', 10);

-- Insert into DOCUMENT
INSERT INTO DOCUMENT (DocumentType, ApplicationID) VALUES
('Resume', 1),
('Cover Letter', 2),
('Resume', 3),
('Cover Letter', 4),
('Resume', 5),
('Cover Letter', 6),
('Resume', 7),
('Cover Letter', 8),
('Resume', 9),
('Cover Letter', 10);

-- Insert into EXPERIENCE
INSERT INTO EXPERIENCE (ExperienceType, OrganizationName, UserID) VALUES
('Education', 'State University', 1),
('Employment', 'TechCorp', 1),
('Education', 'City College', 3),
('Employment', 'DataSolutions', 4),
('Education', 'Online University', 6),
('Employment', 'BuildIt', 7),
('Employment', 'CreativeApps', 9);

-- Insert into EDUCATION
-- Assuming ExperienceID values based on the above EXPERIENCE inserts:
-- ExperienceID 1: State University
-- ExperienceID 3: City College
-- ExperienceID 5: Online University

INSERT INTO EDUCATION (Degree, StudyField, Grade, StartDate, EndDate, ExperienceID) VALUES
('B.Sc. in Computer Science', 'Computer Science', 3.8, '2018-09-01', '2022-06-30', 1),
('B.A. in Project Management', 'Project Management', 3.7, '2015-09-01', '2019-05-30', 3),
('B.B.A. in Marketing', 'Marketing', 3.5, '2017-01-10', '2019-12-20', 5);

-- Insert into EMPLOYMENT
-- Assuming ExperienceID values based on the above EXPERIENCE inserts:
-- ExperienceID 2: TechCorp
-- ExperienceID 4: DataSolutions
-- ExperienceID 6: BuildIt
-- ExperienceID 7: CreativeApps

INSERT INTO EMPLOYMENT (JobTitle, JobDescription, StartDate, EndDate, ExperienceID) VALUES
('Software Engineer', 'Developed backend services using Java and Spring Framework.', '2022-07-01', NULL, 2),
('Data Analyst', 'Performed data cleaning and visualization using Python and Tableau.', '2020-08-01', NULL, 4),
('BuildIt Specialist', 'Managed construction projects and coordinated teams.', '2021-02-01', NULL, 6),
('UX Designer', 'Proficient in Adobe XD, Figma, and user research.', '2022-01-15', NULL, 7);

-- Insert into COVERLETTER
-- DocumentIDs corresponding to 'Cover Letter' entries in DOCUMENT table: 2,4,6,8,10

INSERT INTO COVERLETTER (CoverLetterBody, DocumentID) VALUES
('Dear Hiring Manager, I am excited to apply for the Data Analyst position...', 2),
('Dear Hiring Manager, I am enthusiastic about the Project Manager position...', 4),
('Dear Hiring Manager, I am passionate about DevOps Engineering and would love to contribute...', 6),
('Dear Hiring Manager, I am eager to apply for the UX Designer position...', 8),
('Dear Hiring Manager, I am interested in the Quality Assurance role and believe I am a strong fit...', 10);

-- Insert into RESUME
-- DocumentIDs corresponding to 'Resume' entries in DOCUMENT table: 1,3,5,7,9

INSERT INTO RESUME (ResumeBody, DocumentID) VALUES
('John Doe Resume: Experienced Software Engineer with expertise in Java and Python...', 1),
('Alice Johnson Resume: Project Manager with PMP certification and 5 years of experience...', 3),
('Carol White Resume: Marketing Specialist with a strong background in digital marketing...', 5),
('Eve Black Resume: DevOps Engineer proficient in AWS, Docker, and Kubernetes...', 7),
('Grace Blue Resume: Content Writer skilled in SEO, copywriting, and content strategy...', 9);