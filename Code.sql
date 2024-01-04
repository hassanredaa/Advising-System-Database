create database Advising_Team;

GO
Create proc CreateAllTables
AS
create table Advisor(
advisor_id int primary key identity,
name varchar(40),
email varchar(40), 
office varchar(40), 
password varchar(40)
);

Create TABLE Student(
student_id int Primary Key IDENTITY, 
f_name varchar(40),
l_name varchar(40),
gpa DECIMAL,
faculty VARCHAR(40),
email VARCHAR(40),
major VARCHAR(40), 
password VARCHAR(40), 
financial_status bit, 
semester int,
acquired_hours INT,
assigned_hours INT,
advisor_id int,
FOREIGN KEY(advisor_id)REFERENCES Advisor(advisor_id)
);

Create table Student_Phone(
student_id int ,
phone_number varchar (40) ,
PRIMARY KEY(student_id, phone_number),
FOREIGN KEY(student_id) REFERENCES Student(student_id)
); 

create table Course(
course_id int primary key identity, 
name varchar(40),
major varchar(40),
is_offered bit,
credit_hours int,
semester int
);

create table PreqCourse_course(
prerequisite_course_id int,
course_id int,
primary key(prerequisite_course_id,course_id),
FOREIGN KEY (prerequisite_course_id) REFERENCES Course(course_id),
FOREIGN KEY (course_id) REFERENCES Course(course_id));

create table Instructor(
instructor_id int PRIMARY KEY identity,
name VARCHAR(40),
email VARCHAR(40), 
faculty VARCHAR(40), 
office VARCHAR(40));

create table Instructor_Course(
course_id int,
instructor_id int,
PRIMARY KEY(course_id,instructor_id),
FOREIGN KEY (course_id) references Course(course_id),
FOREIGN KEY (instructor_id) references Instructor(instructor_id) 
);

create table Student_Instructor_Course_Take( 
student_id int,
course_id int, 
instructor_id int,
semester_code varchar(40),
exam_type varchar(40) DEFAULT('Normal'),
grade varchar(40) default null,
primary key(student_id, course_id, semester_code),
FOREIGN KEY (student_id) references Student(student_id),
FOREIGN KEY (course_id) references Course(course_id),
FOREIGN KEY (instructor_id) references Instructor(instructor_id)
);

create table Semester(
semester_code varchar(40) primary key,
start_date date,
end_date date
);

create table Course_Semester(
course_id int, 
semester_code varchar(40)
primary key(course_id, semester_code)
FOREIGN KEY (course_id) REFERENCES Course (course_id),
FOREIGN KEY (semester_code) REFERENCES Semester (semester_code)
);


create table slot(
slot_id int primary key identity, 
day varchar(40), 
time varchar(40), 
location varchar(40),
course_id int,
instructor_id int,
FOREIGN KEY (course_id) REFERENCES Course (course_id),
FOREIGN KEY(instructor_id) REFERENCES Instructor (instructor_id)
);

create table Graduation_Plan(
plan_id INT identity, 
semester_code varchar(40),
semester_credit_hours INT,
expected_grad_semester date,
advisor_id INT,
student_id INT,
PRIMARY KEY (plan_id,semester_code),
FOREIGN KEY (student_id) REFERENCES Student(student_id),
FOREIGN KEY(advisor_id) REFERENCES Advisor(advisor_id)
); 

Create table GradPlan_Course(
plan_id INT, 
semester_code varchar(40), 
course_id INT,
PRIMARY KEY (plan_id,semester_code,course_id),
FOREIGN KEY (plan_id,semester_code) references Graduation_Plan(plan_id,semester_code),
FOREIGN KEY (course_id) REFERENCES Course(course_id),
);

create table Request(
request_id int primary key identity,
type varchar(40), 
comment varchar(40), 
status varchar(40) default ('pending'), 
credit_hours int, 
student_id int,
advisor_id int, 
course_id int,
FOREIGN KEY (student_id) REFERENCES Student (student_id),
FOREIGN KEY (advisor_id) REFERENCES Advisor (advisor_id)
);


create table MakeUp_Exam(
exam_id int primary key identity, 
date date, 
type varchar(40), 
course_id int,
FOREIGN KEY (course_id) REFERENCES Course (course_id)
);

create table Exam_Student(
exam_id int, 
student_id int, 
course_id int
primary key(exam_id, student_id),
FOREIGN KEY (student_id) REFERENCES Student (student_id),
FOREIGN KEY (exam_id) REFERENCES MakeUp_Exam (exam_id)
);


Create Table Payment(
payment_id int Primary key identity,
amount int,
deadline datetime ,
n_installments int,
status varchar(40) default('notPaid'),
fund_percentage decimal,
start_date datetime,
student_id int,
semester_code Varchar(40),
FOREIGN KEY (student_id) references Student(student_id),
FOREIGN KEY (semester_code) references Semester(semester_code));

create table Installment(
payment_id int, 
deadline datetime, 
amount int, 
status varchar(40) default('notPaid'),
start_date datetime,
primary key(payment_id,deadline),
FOREIGN KEY (payment_id) REFERENCES Payment (payment_id)
);

GO


GO
Create proc DropAllTables
AS

drop table Request;
drop table Exam_Student;
drop table GradPlan_Course;
drop table Course_Semester;
drop table Graduation_Plan;
drop table MakeUp_Exam;
drop table Instructor_Course;
drop table PreqCourse_course;
drop table slot;
drop table Student_Instructor_Course_Take;
drop table Student_Phone;
drop table Installment;
drop table Payment;
drop table Instructor;
drop table Semester;
drop table Student;
drop table Advisor;
drop table Course;

go


GO
Create proc clearAllTables
AS
TRUNCATE TABLE GradPlan_Course;
TRUNCATE TABLE Request;
TRUNCATE TABLE Exam_Student;
TRUNCATE TABLE Installment;
TRUNCATE TABLE Student_Instructor_Course_Take;
TRUNCATE TABLE Course_Semester;
TRUNCATE TABLE Instructor_Course;
TRUNCATE TABLE PreqCourse_course;
TRUNCATE TABLE Student_Phone;
TRUNCATE TABLE SLOT;
DELETE FROM Payment; 
DELETE FROM Semester;
DELETE FROM Instructor;
DELETE FROM MakeUp_Exam;
DELETE FROM Graduation_Plan;
DELETE FROM Course;
DELETE FROM Student;
go

GO
CREATE view view_Students
AS
SELECT *
FROM Student
GO


GO
CREATE view view_Course_prerequisites
AS
SELECT C.*, pc.prerequisite_course_id
FROM Course as C LEFT OUTER JOIN PreqCourse_course as pc on C.course_id = pc.course_id
GO


GO
CREATE VIEW Instructors_AssignedCourses
AS
SELECT i.*, ic.course_id,c.credit_hours,c.is_offered,c.major,c.name as Course_Name,c.semester
FROM Instructor AS i INNER JOIN  Instructor_Course AS ic ON i.instructor_id = ic.instructor_id
INNER JOIN Course AS c ON ic.course_id = c.course_id
GO



GO
CREATE VIEW Student_Payment
AS
SELECT p.payment_id, p.amount,p.deadline,p.fund_percentage,p.n_installments,p.semester_code,p.start_date,p.status,S.*
FROM Payment as P INNER JOIN Student S ON p.student_id = S.student_id
WHERE P.status = 'notPaid'
GO


GO 
CREATE VIEW Courses_Slots_Instructor
AS
SELECT C.course_id AS CourseID, c.name AS Course_name, S.slot_id AS Slot_ID, s.day as Slot_Day, 
s.time AS Slot_Time, s.location AS Slot_Location, I.name AS Slots_Instructor_name
FROM (Course C LEFT OUTER JOIN SLOT S ON C.course_id=S.course_id) inner join Instructor I ON s.instructor_id=I.instructor_id
GO

GO 
CREATE VIEW Courses_MakeupExams 
AS
SELECT C.NAME AS Courses_name, C.semester AS Courses_semester, M.exam_id AS EXAM_ID, M.type AS EXAM_TYPE, M.date AS EXAM_DATE
FROM COURSE C LEFT OUTER JOIN MakeUp_Exam M ON C.course_id=M.course_id
GO

GO
CREATE VIEW Students_Courses_transcript 
AS
SELECT S.student_id AS Student_ID , Concat(S.f_name,' ', s.l_name) AS Student_Name, 
M.course_id AS Course_ID,C.name AS Course_name,M.exam_type AS Exam_type,M.grade AS Course_Grade,C.semester as Semester,I.name AS Instructor_name
FROM Student_Instructor_Course_Take AS M 
 LEFT OUTER JOIN Student S ON S.student_id=M.student_id
 LEFT OUTER JOIN Course C ON M.course_id=C.course_id
 LEFT OUTER JOIN Instructor I ON M.instructor_id=I.instructor_id
 GO

 GO 
 CREATE VIEW Semster_offered_Courses
 AS 
 SELECT C.course_id AS Course_ID, C.name AS Course_Name, S.Semester_code 
 from Course C 
 RIGHT OUTER JOIN Course_Semester S ON C.course_id=S.course_id
 GO

 GO
 CREATE VIEW Advisors_Graduation_Plan 
 AS
 Select G.plan_id,G.expected_grad_semester,G.semester_credit_hours,G.student_id,G.semester_code,G.advisor_id, A.name
 FROM Graduation_Plan G
 LEFT OUTER JOIN Advisor A ON G.advisor_id=A.advisor_id
 GO


GO
CREATE PROC Procedures_StudentRegistration
@first_name varchar (40), 
@last_name varchar (40),
@password varchar (40), 
@faculty varchar (40), 
@email varchar(40), 
@major varchar (40), 
@Semester int
AS
INSERT INTO Student(f_name,l_name,password,faculty,email,major,semester)
Values (@first_name,@last_name,@password,@faculty,@email,@major,@semester)
print(SCOPE_IDENTITY())
GO



GO
create proc Procedures_AdvisorRegistration
@advisor_name varchar(40), 
@password varchar(40),
@email varchar(40),
@office varchar(40)
AS
INSERT INTO Advisor(name,password,email,office)
VALUES(@advisor_name,@password,@email,@office)
PRINT(SCOPE_IDENTITY())
GO

GO
CREATE PROC Procedures_AdminListStudents
AS
SELECT *
FROM Student
GO

GO
CREATE PROC Procedures_AdminListAdvisors
AS
SELECT *
FROM Advisor
GO

GO 
CREATE PROC AdminListStudentsWithAdvisors
AS
SELECT*
FROM Student INNER JOIN Advisor ON Student.advisor_id = Advisor.advisor_id
GO

GO
CREATE PROC AdminAddingSemester
@start_date date, 
@end_date date,
@semester_code VARCHAR(40)
AS
INSERT INTO Semester(start_date,end_date,semester_code)
VALUES(@start_date,@end_date,@semester_code)
GO

GO
CREATE PROC Procedures_AdminAddingCourse
@major varchar (40), 
@semester int, 
@credit_hours int,
@course_name varchar (40), 
@offered bit
AS
INSERT INTO Course(major,semester,credit_hours,name,is_offered)
VALUES(@major,@semester,@credit_hours,@course_name,@offered)
GO

GO
CREATE PROC Procedures_AdminLinkInstructor
@InstructorId int, 
@courseId int,
@slotID int
AS
INSERT INTO Instructor_Course(instructor_id,course_id)
VALUES(@InstructorId,@courseId)

Update slot
Set course_id = @courseId,
instructor_id = @InstructorId
Where slot.slot_id = @slotID;
GO

GO
CREATE PROC Procedures_AdminLinkStudent
@InstructorId int, 
@studentID int, 
@courseID INT,
@semester_code varchar(40)
AS
INSERT INTO Student_Instructor_Course_Take(instructor_id,student_id,course_id,semester_code)
VALUES(@InstructorId,@studentID,@courseID,@semester_code)
GO

GO
CREATE PROC Procedures_AdminLinkStudentToAdvisor
@studentID int,
@advisorID int 
AS
UPDATE Student
SET advisor_id = @advisorID
WHERE Student.student_id = @studentID
GO

GO
CREATE PROC Procedures_AdminAddExam
@Type varchar (40), 
@date datetime, 
@courseID int
AS
INSERT INTO MakeUp_Exam(type,date,course_id)
VALUES(@Type,@date,@courseID)
GO

GO
CREATE PROC Procedures_AdminIssueInstallment
@payment_ID int
AS
DECLARE @startdate datetime
DECLARE @deadline datetime
DECLARE @duartion int
DECLARE @amount int
DECLARE @InsNumber INT = 1;


Select @duartion = DATEDIFF(month,p.start_date,p.deadline), @amount = P.amount/@duartion, @startdate = P.start_date 
from Payment P
where p.payment_id = @payment_ID

set @deadline = DATEADD(month,1,@startdate)

insert into Installment(payment_id,deadline,amount,start_date)
values(@payment_ID,@deadline,@amount,@startdate)

While @InsNumber < @duartion
BEGIN
    SET @InsNumber += 1;
    set @startdate = DATEADD(month,1,@startdate)
    set @deadline = DATEADD(month,1,@startdate)

    insert into Installment(payment_id,deadline,amount,start_date)
    values(@payment_ID,@deadline,@amount,@startdate)
END;
GO

GO
CREATE PROC Procedures_AdminDeleteCourse
@courseID int
AS
delete from Course where course_id = @courseID
delete from slot where course_id = @courseID
delete from Instructor_Course where course_id = @courseID
delete from PreqCourse_course where course_id = @courseID
delete from Student_Instructor_Course_Take where course_id = @courseID
delete from Course_Semester where course_id = @courseID
delete from GradPlan_Course where course_id = @courseID
delete from Request where course_id = @courseID
delete from MakeUp_Exam where course_id = @courseID
delete from Exam_Student where course_id = @courseID
GO

GO
CREATE PROC Procedure_AdminUpdateStudentStatus
@StudentID INT
AS
update student
set financial_status =
    CASE
        WHEN current_timestamp > 
        (SELECT TOP 1 i.deadline 
        FROM Installment i inner join Payment p on p.payment_id = i.payment_id 
        WHERE i.status = 'notPaid' and p.student_id = @StudentID) 
        THEN 1 
        ELSE 0 
    END
WHERE Student.student_id = @StudentID
GO

GO 
CREATE VIEW all_Pending_Requests
AS
SELECT r.comment,r.course_id,r.credit_hours,r.request_id,r.status,r.type,S.f_name, s.l_name,a.name
FROM Request r INNER JOIN Student S ON R.student_id = S.student_id
INNER JOIN Advisor A ON R.advisor_id = A.advisor_id
WHERE R.status = 'Pending'
GO

GO
CREATE PROC Procedures_AdminDeleteSlots
@current_semester varchar(40)
AS
DELETE FROM slot where exists(
select c.course_id
from Course c inner join Course_Semester cs on c.course_id = cs.course_id
where c.is_offered = 0 and cs.semester_code <> @current_semester)
GO

CREATE FUNCTION FN_AdvisorLogin
(@ID int, @password varchar(40))
RETURNS BIT
AS
BEGIN
DECLARE @SUCCESS BIT = 0
IF EXISTS (SELECT * FROM Advisor WHERE advisor_id = @ID AND password = @password)
BEGIN
SET @SUCCESS = 1
END
RETURN @SUCCESS
END


GO
CREATE PROC Procedures_AdvisorCreateGP
@Semester_code varchar(40),
@expected_graduation_date date, 
@sem_credit_hours int,
@advisor_id int, 
@student_id int
AS
DECLARE @expec varchar(40);
DECLARE @st_ac int;
select @st_ac = acquired_hours from Student where student_id = @student_id
select @expec = semester_code from Semester where @expected_graduation_date = Semester.end_date
if (@st_ac > 157)
begin
INSERT INTO Graduation_Plan(semester_code,semester_credit_hours,expected_grad_semester,advisor_id,student_id)
VALUES(@Semester_code,@sem_credit_hours,@expec,@advisor_id,@student_id)
end
GO



GO
CREATE PROC Procedures_AdvisorAddCourseGP
@student_id int, 
@Semester_code varchar (40), 
@course_name varchar (40)
AS
DECLARE @planid int;
DECLARE @courseid int;
select @planid = plan_id from Graduation_Plan where @student_id = student_id
select @courseid = course_id from Course where @course_name = name
INSERT INTO GradPlan_Course
VALUES(@planid,@Semester_code,@courseid)
GO


GO
CREATE PROC Procedures_AdvisorUpdateGP
@expected_grad_semster date,
@studentID int
AS
update Graduation_Plan
SET expected_grad_semester = @expected_grad_semster
where student_id = @studentID
GO

GO
CREATE PROC Procedures_AdvisorDeleteFromGP
@studentID int, 
@semester_code varchar (40),  
@courseID INT
AS
DECLARE @pid int;
select plan_id from graduation_plan where @studentID = student_id
DELETE FROM GradPlan_Course where @courseID = course_id and @semester_code = semester_code and @pid = plan_id
GO

CREATE FUNCTION FN_Advisors_Requests
(@advisorID int)
RETURNS TABLE
AS
RETURN SELECT r.* FROM Advisor a inner join Request r on a.advisor_id = r.advisor_id WHERE a.advisor_id = @advisorID


GO
CREATE PROC Procedures_AdvisorApproveRejectCHRequest
@RequestID int, 
@Current_semester_code varchar(40)
AS
declare @sid int;
declare @sgpa decimal;
declare @ah int
declare @reqch int;
declare @reqtype varchar(40);
declare @pid int;
declare @deadline datetime;
select @reqtype = type from Request where request_id = @RequestID
select @reqch = credit_hours from Request where request_id = @RequestID
select @sid = student_id from Request where request_id = @RequestID
select @sgpa = gpa from Student where student_id = @sid
select @ah = assigned_hours from Student where student_id = @sid
(SELECT TOP 1 @deadline = i.deadline , @pid = i.payment_id
        FROM Installment i inner join Payment p on p.payment_id = i.payment_id 
        WHERE i.status = 'notPaid' and p.student_id = @sid)

IF (EXISTS (SELECT 1 FROM Student_Instructor_Course_Take WHERE student_id = @sid AND semester_code = @current_semester_code))
begin
if (@sgpa < 3.7 and @ah <= 31 and @reqch <= 3 and @reqtype = 'credit_hours')
begin

update Request
set status = 'approved'
where request_id = @RequestID

update Student
set assigned_hours = assigned_hours + @reqch
where student_id = @sid

update Payment
set amount = amount + (1000*@reqch)
where student_id = @sid

update Installment
set amount = amount + (1000*@reqch)
where @deadline = deadline and payment_id = @pid

end
else 
begin
update Request
set status = 'rejected'
where request_id = @RequestID
end
end
GO


GO
CREATE PROC Procedures_AdvisorViewAssignedStudents
@AdvisorID int ,
@major varchar (40)
AS
select s.student_id ,S.f_name, s.l_name, s.major , c.name
from Student s inner join Advisor a on a.advisor_id = s.advisor_id inner join Student_Instructor_Course_Take st on s.student_id = st.student_id inner join Course c on st.course_id = c.course_id
where s.advisor_id = @AdvisorID and s.major = @major 
GO


GO 
CREATE PROC Procedures_AdvisorApproveRejectCourseRequest
@RequestID int, 
@current_semester_code varchar(40)
AS
DECLARE @sid int
DECLARE @courseid int
DECLARE @s_assigned int
DECLARE @ch int
DECLARE @reqtype varchar(40)

select @sid = r.student_id , @courseid = r.course_id , @s_assigned = s.assigned_hours , @ch = r.credit_hours , @reqtype = r.type
from Request r inner join Student s on r.student_id = s.student_id
where @RequestID = r.request_id

if((@reqtype != 'course') and (@s_assigned + @ch > 34) or exists (
select p.prerequisite_course_id
from PreqCourse_course p
where not exists(
select *
from Student_Instructor_Course_Take si 
where si.course_id = @courseid and si.student_id = @sid and si.grade <> null)
or not exists (select 1 from Course_Semester where @courseid = course_id and semester_code = @current_semester_code)))

begin
    update Request
    set status = 'rejected'
    where request_id = @RequestID
end
else
begin
    update Request
    set status = 'accepted'
    where request_id = @RequestID 
    
    update Student
    set assigned_hours = assigned_hours + @ch
    where student_id = @sid

    insert into Student_Instructor_Course_Take(student_id,course_id,semester_code)
    values(@sid,@courseid,@current_semester_code)
    end
GO

GO
CREATE PROCEDURE Procedures_AdvisorViewPendingRequests
    @AdvisorID INT 
    AS
    select R.*
    FROM Request R INNER JOIN Student S ON R.student_id = S.student_id
    WHERE S.advisor_id = @AdvisorID AND R.Status = 'pending';

GO
CREATE FUNCTION FN_StudentLogin
    (@StudentID INT,@Password VARCHAR(40))
RETURNS BIT
AS
BEGIN
    DECLARE @Success BIT = 0;
    IF EXISTS (SELECT * FROM Student WHERE student_id = @StudentID AND password = @Password)
    BEGIN
        SET @Success = 1;
    END

    RETURN @Success;
END;

GO
CREATE PROCEDURE Procedures_StudentAddMobile
    @StudentID INT,
    @MobileNumber VARCHAR(40)
AS
INSERT INTO Student_Phone (phone_number,student_id)
VALUES (@MobileNumber,@StudentID);

GO
CREATE FUNCTION FN_SemesterAvailableCourses
    (@SemesterCode VARCHAR(40))
RETURNS TABLE
AS
RETURN
(
    SELECT C.* 
    FROM Course C INNER JOIN Course_Semester CS ON C.course_id = CS.course_id
    WHERE CS.semester_code = @SemesterCode and c.is_offered = 1
);

GO
CREATE PROCEDURE Procedures_StudentSendingCourseRequest
    @StudentID INT,
    @CourseID INT,
    @Type VARCHAR(40),
    @Comment VARCHAR(40)
AS

    INSERT INTO Request (student_id, course_id, type, comment)
    VALUES (@StudentID, @CourseID, @Type, @Comment);
GO

GO
CREATE PROCEDURE Procedures_StudentSendingCHRequest
    @StudentID INT,
    @CreditHours INT,
    @Type VARCHAR(40),
    @Comment VARCHAR(40)
AS
    INSERT INTO Request (student_id, credit_hours, type, comment)
    VALUES (@StudentID, @CreditHours, @Type, @Comment);

GO
CREATE FUNCTION FN_StudentViewGP 
(@student_ID int)
RETURNS Table
AS
Return (Select S.student_id, S.f_name, S.l_name , GP.plan_id , GC.course_id 
, C.name , GC.semester_code , sem.end_date, GP.semester_credit_hours , GP.advisor_id
From Student S 
inner join Graduation_Plan GP ON S.student_id = GP.student_id 
inner join GradPlan_Course GC ON GP.plan_id = GC.plan_id
inner join Course C ON GC.course_id = C.course_id
inner join Semester sem on gp.semester_code = sem.semester_code
Where S.student_id=@student_ID);
GO

GO
CREATE FUNCTION FN_StudentUpcoming_installment
(@student_id int)
Returns date
AS
Begin
    Declare @fnp date
    Select TOP 1 @fnp=I.deadline 
    From Payment P 
    inner join Installment I ON P.payment_id = I.payment_id
    where I.status='notPaid' And P.student_id = @student_id

    Return @fnp
END
GO

GO
CREATE FUNCTION FN_StudentViewSlot
    (@CourseID INT,@InstructorID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT S.slot_id, S.location, S.time,S.day,C.name as Course_name ,I.name as Ins_name
    FROM Slot S INNER JOIN Course C ON S.course_id = C.course_id
    INNER JOIN Instructor I ON S.instructor_id = I.instructor_id
    WHERE
        S.course_id = @CourseID AND S.instructor_id = @InstructorID
);

GO
CREATE PROC Procedures_StudentRegisterFirstMakeup
    @StudentID int,
    @courseID int,
    @studentCurrentsemester varchar(40)
AS 
declare @examid int;
if not exists(
select 1
from Student_Instructor_Course_Take 
where @StudentID = student_id and @courseID = course_id and (exam_type = 'First MakeUp' or exam_type = 'Second MakeUp'))
and exists(
select course_id
from Student_Instructor_Course_Take 
where @StudentID = student_id  and @courseID = course_id and exam_type = 'Normal' and (grade = 'F' or grade = 'FF' or grade = null )
)
begin
select @examid = exam_id
from MakeUp_Exam
where type = 'First MakeUp' and @courseID = course_id

INSERT INTO Exam_Student
Values(@examid,@StudentID,@courseID)
insert into Student_Instructor_Course_Take(student_id,course_id,semester_code,exam_type)
values(@StudentID,@courseID,@StudentCurrentSemester,'First MakeUp')
end
GO


GO
CREATE FUNCTION FN_StudentCheckSMEligiability
( @CourseID int, @StudentID int)
RETURNS BIT
AS
Begin
declare @eligible bit = 0
if not exists(
select COUNT(course_id)
from Student_Instructor_Course_Take 
where @StudentID = student_id  and @courseID <> course_id
having COUNT(course_id) > 2)
and exists(
select course_id
from Student_Instructor_Course_Take 
where @StudentID = student_id and @courseID = course_id and exam_type = 'First MakeUp' and (grade = 'F' or grade = 'FF' or grade = 'FA'))
begin
set @eligible = 1
end
return @eligible
end


GO
CREATE PROC Procedures_StudentRegisterSecondMakeup
@StudentID int, 
@courseID int, 
@StudentCurrentSemester Varchar(40)
AS
declare @examid int;
DECLARE @elgible Bit;
set @elgible = dbo.FN_StudentCheckSMEligiability(@courseID,@StudentID)

if @elgible = 1
begin
select @examid = exam_id
from MakeUp_Exam
where type = 'Second MakeUp' and @courseID = course_id
INSERT INTO Exam_Student
Values(@examid,@StudentID,@courseID)

insert into Student_Instructor_Course_Take(student_id,course_id,semester_code,exam_type)
values(@StudentID,@courseID,@StudentCurrentSemester,'Second MakeUp')
end
go


GO
CREATE PROC Procedures_ViewRequiredCourses
@StudentID int, 
@Currentsemestercode Varchar(40)
AS
select c.*
from Student_Instructor_Course_Take si inner join Course_Semester cs on cs.course_id = si.course_id
inner join Course c on c.course_id = si.course_id
where si.student_id = @StudentID 
and (( si.grade = 'F' or si.grade = 'FF' or si.grade = 'FA') 
or dbo.FN_StudentCheckSMEligiability(si.course_id,@StudentID) = 0) 
and  cs.semester_code = @Currentsemestercode
union 
select c.*
from Course c inner join Course_Semester cs on c.course_id = cs.course_id , Student s
where s.semester > c.semester and s.student_id = @StudentID and c.major = s.major and cs.semester_code = @Currentsemestercode 
and not exists(select * from Student_Instructor_Course_Take si where si.student_id = @StudentID and c.course_id = si.course_id)  
GO

GO
CREATE PROC Procedures_ViewOptionalCourse
@Student_id INT,
@Current_semester_code VARCHAR(40)
AS
select c.*
from Course c inner join Course_Semester cs on c.course_id = cs.course_id , Student s
where s.semester <= c.semester and s.student_id = @Student_id and c.major = s.major and cs.semester_code = @Current_semester_code 
and not exists(select * from Student_Instructor_Course_Take si where si.student_id = @Student_id and c.course_id = si.course_id)  
and not exists(select pc.prerequisite_course_id from PreqCourse_course pc where pc.course_id = c.course_id
except select course_id from Student_Instructor_Course_Take where student_id = @Student_id)                  
GO


GO
CREATE PROC Procedures_ViewMS
@StudentID int
AS
select C.*
from Course c ,student s
where c.major = s.major and not exists(select * from Student_Instructor_Course_Take si where si.student_id = @StudentID)
GO


GO
CREATE PROC Procedures_ChooseInstructor
@StudentID int ,
@InstructorID int ,
@CourseID int,
@current_semester_code varchar(40)
AS
update Student_Instructor_Course_Take
set instructor_id = @InstructorID
where student_id = @StudentID and course_id = @CourseID and semester_code = @current_semester_code
GO
