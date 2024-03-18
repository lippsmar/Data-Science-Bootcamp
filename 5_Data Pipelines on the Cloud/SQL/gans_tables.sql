use gans;

drop table if exists flights;

CREATE TABLE cities (
    city_id INT,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    population INT,
    lat FLOAT(10 , 6 ),
    lon FLOAT(10 , 6 ),
    `elevation_[m]` INT,
    PRIMARY KEY (city_id)
);


CREATE TABLE weather (
    id INT AUTO_INCREMENT,
    city_id INT,
    temp_[°C] FLOAT,
    temp_(feels_like)_[°C] FLOAT,
    main_weather VARCHAR(255) NOT NULL,
    wind_speed_[m/s] FLOAT,
    gust_speed_[m/s] FLOAT,
    sight_distance_[m] INT,
    probability_of_precipitation_[%] FLOAT,
    rain_last_3h_[mm] FLOAT,
    snow_last_3h_[mm] FLOAT,
    forecast_time DATETIME,
    timestamp DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (city_id)
        REFERENCES cities (city_id)
)
 
CREATE TABLE airports (
    icao VARCHAR(255) NOT NULL,
    iata VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    shortName VARCHAR(255) NOT NULL,
    municipalityName VARCHAR(255) NOT NULL,
    countryCode VARCHAR(255) NOT NULL,
    `location.lat` FLOAT,
    `location.lon` FLOAT,
    PRIMARY KEY (iata)
)

CREATE TABLE cities_airports (
    city_id INT,
    iata VARCHAR(255) NOT NULL,
    FOREIGN KEY (city_id)
        REFERENCES cities (city_id),
    FOREIGN KEY (iata)
        REFERENCES airports (iata)
)

CREATE TABLE flights (
    flight_num VARCHAR(255) NOT NULL,
    departure_iata VARCHAR(255) NOT NULL,
    arrival_iata VARCHAR(255) NOT NULL,
    arrival_time DATETIME,
    PRIMARY KEY (flight_num),
    FOREIGN KEY (arrival_iata)
        REFERENCES cities_airports (iata)
)