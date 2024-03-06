use gans;

drop table if exists cities;

create table Cities (
City_id int auto_increment,
City varchar(255) not null,
primary key (City_id)
);


create table City_data (
Id int auto_increment,
Country varchar (255) not null,
Population int,
Lat varchar (255) not null,
Lon varchar (255) not null,
Elevation_in_m float,
City_id int,
primary key (id),
foreign key (City_id) references cities(City_id)
);