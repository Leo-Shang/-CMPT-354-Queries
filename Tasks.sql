-- a
alter table TechStaff
add constraint age_constraint check (age >= 10 and age <= 125)

alter table Soundtrack
add constraint song_constraint check ([duration(sec)] > 0)

-- b
alter table Actors
add fname char(255), lname char(255) -- add columns

create proc sp_fill_name
@name char(255)
as
begin
	declare @pos integer = charindex(',',@name) -- find the position of ','
	if(@pos != 0) -- if has last name
	begin
		update Actors set lname = substring(@name, 1, @pos-1) where name=@name
		update Actors set fname = substring(@name, @pos+1, len(@name)) where name=@name
	end
	else if(@pos = 0) -- if doesn't have last name
	begin
		update Actors set fname = @name where name=@name
		update Actors set lname = '' where name=@name
	end	
end

select Actors.name into #Ques_b_temp -- use temp table to store actor names, use one tuple each time and delete after that
from Actors
while exists(select * from #Ques_b_temp)
begin
	declare @tempName varchar(255)
	select top 1 @tempName = #Ques_b_temp.name
	from #Ques_b_temp
	execute sp_fill_name @tempName
	delete from #Ques_b_temp where @tempName = name
end
drop table #Ques_b_temp

-- c
create proc sp_fill_emp -- a store procedure update @stuID's employee number
@stuID integer
as
begin
	declare @count integer
	select @count = count(*)
	from TechStaff t
	where t.studioID = @stuID
	update Studio set employees = @count where studioID = @stuID
end

select s.studioID into #temp -- temp table store the ID of studio, delete after use
from Studio s
while exists(select * from #temp)
begin
	declare @parameter integer
	select top 1 @parameter = #temp.studioID
	from #temp
	execute sp_fill_emp @parameter
	delete from #temp where studioID = @parameter
end
drop table #temp

-- d
create trigger tr_insert_techstaff -- a trigger for insert staff
on TechStaff
after insert
as
begin
	declare @count integer
		select @count = count(*) -- count the techstaff who have same studioID attribute as the inserted one
		from TechStaff t, inserted
		where t.studioID = inserted.studioID
	update Studio set employees = @count from inserted where Studio.studioID = inserted.studioID
end

create trigger tr_delete_techstaff -- a trigger for deleting staff
on TechStaff
after delete
as
begin
	declare @count integer
		select @count = count(*)
		from TechStaff t, deleted
		where t.studioID = deleted.studioID
	update Studio set employees = @count from deleted where Studio.studioID = deleted.studioID
end

-- e
create trigger tr_delete_studio
on Studio
after delete
as
begin
	if(not exists( -- try to see weather this table already exist in database
		select*
		from INFORMATION_SCHEMA.TABLES
		where table_name = 'FoldedStudios'))
		begin
			create table FoldedStudios(
				studioName varchar(50),
				fired integer)
		end
	insert into FoldedStudios 
	select d.studioName, d.employees
	from deleted d
end

-- f
create proc spSearchString
@st varchar(20)
as
begin
	select m.title, year, genre,studioID
	from Movie m, Keywords k
	where m.title = k.title -- movie with corresponding keywords
	group by m.title, year, genre, studioID
	having count(*) = ( -- if the count of some movie = the count of that movie with keyword start with @st,
		select count(*) -- then this movie satisfies all its keyword starting with @st
		from Movie a, Keywords b
		where a.title = b.title and b.keyword like @st + '%' and m.title = a.title
		group by a.title)
end