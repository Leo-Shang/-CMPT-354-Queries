create table Studio(
	studioID integer,
	studioName char(50) not null,
	employees integer,
	budget money,
	est integer,
	primary key (studioID)
);

create table Movie(
	title char(255),
	year integer,
	genre char(50),
	studioID integer,
	foreign key (studioID) references Studio on delete set null on update cascade,
	primary key (title)
);

create table Actors(
	name char(255),
	salary money,
	primary key (name)
);

create table TechStaff(
	sin integer,
	fname char(255),
	lname char(255) not null,
	age integer,
	salary money,
	studioID integer,
	foreign key (studioID) references Studio on delete set null on update cascade,
	primary key (sin)
);

create table ActedIn(
	name char(255),
	title char(255),
	foreign key (name) references Actors on delete cascade on update no action,
	foreign key (title) references Movie on delete cascade on update cascade,
	primary key (name,title)
);

create table Soundtrack(
	songID char(10),
	duration integer,
	rank real,
	title char(255),
	foreign key (title) references Movie on delete cascade on update cascade,
	primary key (songID)
);

create table Keywords(
	keyword char(50),
	title char(255),
	foreign key (title) references Movie on delete cascade on update cascade
);