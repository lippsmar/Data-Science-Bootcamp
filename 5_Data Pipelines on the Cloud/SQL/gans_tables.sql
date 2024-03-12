use gans;

drop table if exists flights;

CREATE TABLE cities (
    city_id int,
    city varchar(255) not null,
    country varchar(255) not null,
    population int,
    lat float(10, 6),
    lon float(10, 6),
    `elevation_[m]` int,
    primary key (city_id)
);


CREATE TABLE weather (
    id int AUTO_INCREMENT,
    city_id int,
    `temp_[°C]` float,
    `temp_(feels_like)_[°C]` float,
    main_weather varchar(255) not null,
    `wind_speed_[m/s]` float,
    `gust_speed_[m/s]` float,
    `sight_distance_[m]` int,
    `probability_of_precipitation_[%]` float,
    `rain_last_3h_[mm]` float,
    `snow_last_3h_[mm]` float,
    forecast_time datetime,
    `timestamp` datetime,
    primary key (id),
	foreign key (city_id) references cities(city_id)
    );
    
    CREATE TABLE airports (
    icao varchar(255) not null,
    iata varchar(255) not null,
    `name` varchar(255) not null,
    shortName varchar(255) not null,
    municipalityName varchar(255) not null,
    countryCode varchar(255) not null,
    `location.lat` float,
    `location.lon` float,
    primary key (iata)
);

CREATE TABLE cities_airports (
city_id INT,
iata varchar(255) not null,
foreign key (city_id) references cities(city_id),
foreign key (iata) references airports(iata)
);

CREATE TABLE flights (
flight_num varchar(255) not null,
departure_iata varchar(255) not null,
arrival_iata varchar(255) not null,
arrival_time datetime,
primary key (flight_num),
foreign key (arrival_iata) references cities_airports(iata)
);