create table Instructor(
	eid char(10),
	start date,
	fname char(20),
	lname char(20),
	area char(20),
	type char(20),
	numbers integer,
	primary key (eid))

create table Grad_Student(
	lname char(20),
	sid char(10),
	area char(20),
	fname char(20)
	primary key (sid))

create table Agent(
	id char(10),
	fname char(20),
	lname char(20),
	phone char(10)
	primary key (id))

create table Course(
	code char(10),
	credit integer,
	taught_by char(10) NOT NULL, -- the name of instructor, to save 'teach' table
	foreign key (taught_by) references Instructor,
	primary key (code))

create table Section(
	section integer,
	average float,
	semester char(20),
	enroll integer,
	code char(10),
	primary key (section, code),
	foreign key (code) references Course on delete cascade)

create table Designer(
	company char(20),
	lname char(20),
	sin char(10),
	fname char(20)
	primary key (sin))

-- end of entity sets

create table Supervise(
	emp_id char(10),
	stu_id char(10),
	funding float,
	primary key (emp_id,stu_id),
	foreign key (emp_id) references Instructor,
	foreign key (stu_id) references Grad_student)

create table Assigned(
	emp_id char(10),
	stu_id char(10),
	agt_id char(10),
	primary key (emp_id, stu_id),
	foreign key (emp_id) references Instructor,
	foreign key (stu_id) references Grad_Student,
	foreign key (agt_id) references Agent)

create table Designs(
	code char(10),
	des_sin char(10),
	income float,
	primary key(code, des_sin),
	foreign key (code) references Course,
	foreign key (des_sin) references Designer)


-- 1. course can be designed by at least one designer cannot be modeled.
-- 2. instructor can supervise at least one graduate student cannot be 
--		modeled with only create table.
-- 3. graduate student can have more than one instructor cannot be modeled.
-- 4. agent can be assigned to more than one instructor-student relationship,
--		which cannot be modeled by only using create table.