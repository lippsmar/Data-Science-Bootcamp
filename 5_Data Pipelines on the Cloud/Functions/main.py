import functions_framework
import pandas as pd
import requests
from bs4 import BeautifulSoup
import re
from datetime import datetime, timedelta
from sqlalchemy import create_engine, inspect, Float

@functions_framework.http
def insert(request):
  connection_string = connection()
  push_city_data_to_sql()
  push_weather_data_to_sql()
  push_cities_airports_to_sql()
  push_airport_data_to_sql()
  push_flights_datad_to_sql()
  return "successfully updated"


# def connection():
#   connection_name = "cogent-bison-417011:europe-west1:wbs-mysql-db"
#   db_user = "root"
#   db_password = "XXX"
#   schema_name = "gans"

#   driver_name = 'mysql+pymysql'
#   query_string = {"unix_socket": f"/cloudsql/{connection_name}"}

#   db = sqlalchemy.create_engine(
#       sqlalchemy.engine.url.URL(
#           drivername = driver_name,
#           username = db_user,
#           password = db_password,
#           database = schema_name,
#           query = query_string,
#       )
#   )
#   return db

def connection():
        schema = "gans"
        host = "23.251.142.169" # Change this to your instance's IP
        user = "root"
        password = "XXX" # Your database password goes here
        port = 3306
        connection_string =  f'mysql+pymysql://{user}:{password}@{host}:{port}/{schema}'
        return connection_string

def push_city_data_to_sql():

  API_key = "XXX"
  cities = ["Berlin", "München", "Hamburg", "Bremen"]
  country_code = "DE"
  cities_dict = {"city_id": [], "city": [], "country": [],"population": [], "lat": [], "lon": [], "elevation_[m]": []}

  for city in cities:

    url = f" https://api.openweathermap.org/data/2.5/forecast?q={city},{country_code}&appid={API_key}&units=metric"
    openweather_raw = requests.get(url).json()

    if openweather_raw["cod"] == "200":

      cities_dict["city_id"].append(openweather_raw["city"]["id"])
      cities_dict["city"].append(openweather_raw["city"]["name"])
      cities_dict["country"].append(openweather_raw["city"]["country"])
      cities_dict["lat"].append(openweather_raw["city"]["coord"]["lat"])
      cities_dict["lon"].append(openweather_raw["city"]["coord"]["lon"])

      #webscrape
      response = requests.get(f"https://en.wikipedia.org/wiki/{city}")
      soup = BeautifulSoup(response.content, 'html.parser')
      infobox = soup.find("table", {"class": "infobox ib-settlement vcard"})

      if infobox:
        # Search for the header containing population information
        population_data = infobox.find(string="Population")

        # Extract the population value if found, format number and add to list
        if population_data:
              population = population_data.find_next("td").get_text().strip().replace(",", "")
              cities_dict["population"].append(population)
        else:
              print(f"Population data not found for {city}.")

        # Search for elevation, extract and add to list
        elevation = infobox.find(string="Elevation")
        if elevation:
              elevation = elevation.find_next("td").get_text().strip()
              elevation = int(re.sub(r'\D', '', elevation[:5]))
              cities_dict["elevation_[m]"].append(elevation)
        else:
              cities_dict["elevation_[m]"].append(None)
      else:
        print(f"Infobox not found for {city}.")

    else: 
      print(f"error code {openweather_raw['cod']} in query for {city}")

  cities_df = pd.DataFrame(cities_dict)

  cities_df["population"].astype(int)

  engine = create_engine(connection())
  inspector = inspect(engine)
  if 'cities' in inspector.get_table_names():
    existing_data = pd.read_sql('cities', engine)
    cities_df = cities_df[~cities_df['city_id'].isin(existing_data['city_id'])]
  
  cities_df.to_sql('cities',
                con=engine,
                if_exists='append',
                index=False,
                dtype={'lat': Float, 'lon': Float}
                )
    
  return cities_df

def push_weather_data_to_sql():

  API_key = "XXX"
  cities = (pd.read_sql("cities", con=connection()))["city"]
  country_code = (pd.read_sql("cities", con=connection()))["country"]
  weather_dict = {
      "city_id": [],
      "temp_[°C]": [],
      "temp_(feels_like)_[°C]": [], 
      "main_weather": [], 
      "wind_speed_[m/s]": [], 
      "gust_speed_[m/s]": [], 
      "sight_distance_[m]": [], 
      "probability_of_precipitation_[%]": [], 
      "rain_last_3h_[mm]": [], 
      "snow_last_3h_[mm]": [], 
      "forecast_time": [], 
      "timestamp": [] }
    

  for city in cities:

    url = f" https://api.openweathermap.org/data/2.5/forecast?q={city},{country_code}&appid={API_key}&units=metric"
    openweather_raw = requests.get(url).json()
        
    if openweather_raw["cod"] == "200":

      for i in range(openweather_raw["cnt"]):
        weather_dict["city_id"].append(openweather_raw["city"]["id"])
        weather_dict["temp_[°C]"].append(openweather_raw["list"][i]["main"]["temp"])
        weather_dict["temp_(feels_like)_[°C]"].append(openweather_raw["list"][i]["main"]["feels_like"])
        weather_dict["main_weather"].append(openweather_raw["list"][i]["weather"][0]["main"])
        weather_dict["wind_speed_[m/s]"].append(openweather_raw["list"][i]["wind"]["speed"])
        weather_dict["gust_speed_[m/s]"].append(openweather_raw["list"][i]["wind"]["gust"])
        try:
          weather_dict["sight_distance_[m]"].append(openweather_raw["list"][i]["visibility"])
        except:
          weather_dict["sight_distance_[m]"].append(None)
        weather_dict["probability_of_precipitation_[%]"].append(openweather_raw["list"][i]["pop"]*100)
        try:
          weather_dict["rain_last_3h_[mm]"].append(openweather_raw["list"][i]["rain"]["3h"])
        except:
          weather_dict["rain_last_3h_[mm]"].append(0)
        try:
          weather_dict["snow_last_3h_[mm]"].append(openweather_raw["list"][i]["snow"]["3h"])
        except:
          weather_dict["snow_last_3h_[mm]"].append(0)
        weather_dict["forecast_time"].append(pd.to_datetime(openweather_raw["list"][i]["dt_txt"]))
        weather_dict["timestamp"].append(pd.to_datetime(datetime.now().replace(microsecond=0)))
      
    else: 
      print(f"error code {openweather_raw['cod']} in query for {city}")
                
  weather_df = pd.DataFrame(weather_dict)

  weather_df["snow_last_3h_[mm]"].astype(float)
  
  weather_df.to_sql('weather',
                if_exists='append',
                con=connection(),
                index=False)

  return weather_df

def push_cities_airports_to_sql():

  cities_df = pd.read_sql("cities", con=connection())
  airports_df = pd.read_sql("airports", con=connection())

  cities_airports_df = (pd.merge(cities_df, airports_df, left_on="city", right_on="municipalityName", how="left"))[["city_id","iata"]]

  engine = create_engine(connection())
  inspector = inspect(engine)
  if 'cities_airports' in inspector.get_table_names():
      existing_data = pd.read_sql('cities_airports', engine)
      cities_airports_df = cities_airports_df[~cities_airports_df['city_id'].isin(existing_data['city_id'])]

  cities_airports_df.to_sql('cities_airports',
          if_exists='append',
          con=connection(),
          index=False)
  
  return cities_airports_df


def push_airport_data_to_sql():

  #assert len(latitudes) == len(longitudes)
    
  latitudes = (pd.read_sql("cities", con=connection()))["lat"]
  longitudes = (pd.read_sql("cities", con=connection()))["lon"]

  list_for_df = []

  for index, value in enumerate(latitudes):

    url = f"https://aerodatabox.p.rapidapi.com/airports/search/location/{value}/{longitudes[index]}/km/50/10"

    querystring = {"withFlightInfoOnly":"true"}

    headers = {
    "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
    "X-RapidAPI-Key": "XXX"
    }

    response = requests.request("GET", url, headers=headers, params=querystring)

    list_for_df.append(pd.json_normalize(response.json()['items']))

    airports_df = pd.concat(list_for_df, ignore_index=True)

    engine = create_engine(connection())
    inspector = inspect(engine)
    if 'airports' in inspector.get_table_names():
      existing_data = pd.read_sql('airports', engine)
      airports_df = airports_df[~airports_df['iata'].isin(existing_data['iata'])]

    airports_df.to_sql('airports',
              if_exists='append',
              con=connection(),
              index=False)

  return airports_df

def push_flights_datad_to_sql():

	iata_list = (pd.read_sql("cities_airports", con=connection()))["iata"]

	tomorrow_date = datetime.now() + timedelta(days=1)
	start_time_morning = datetime(tomorrow_date.year, tomorrow_date.month, tomorrow_date.day, 0, 0).strftime("%Y-%m-%dT%H:%M")
	end_time_morning = datetime(tomorrow_date.year, tomorrow_date.month, tomorrow_date.day, 12, 0).strftime("%Y-%m-%dT%H:%M")
	start_time_afternoon = datetime(tomorrow_date.year, tomorrow_date.month, tomorrow_date.day, 12, 0).strftime("%Y-%m-%dT%H:%M")
	end_time_afternoon = datetime(tomorrow_date.year, tomorrow_date.month, tomorrow_date.day, 23, 59, 59).strftime("%Y-%m-%dT%H:%M")
	
	querystring = {"withLeg":"false","direction":"Arrival","withCancelled":"false","withCodeshared":"false", "withCargo":"false","withPrivate":"false","withLocation":"false"}

	headers = {
		"X-RapidAPI-Key": "XXX",
		"X-RapidAPI-Host": "aerodatabox.p.rapidapi.com"
	}

	flights_dict = {
		"flight_num": [],
		"departure_iata": [], 
		"arrival_iata": [], 
		"arrival_time": []}

	for iata in iata_list:
		for start_time, end_time in [(start_time_morning, end_time_morning), (start_time_afternoon, end_time_afternoon)]:
		
			url = f"https://aerodatabox.p.rapidapi.com/flights/airports/iata/{iata}/{start_time}/{end_time}"
			flight_data_raw = requests.get(url, headers=headers, params=querystring).json()

			for arrival in flight_data_raw["arrivals"]:
				departure_iata = arrival["movement"]["airport"].get("iata", "Unknown")
				arrival_time = arrival["movement"].get("revisedTime", {}).get("local") or arrival["movement"]["scheduledTime"]["local"]
				flights_dict["flight_num"].append(arrival["number"])
				flights_dict["departure_iata"].append(departure_iata)
				flights_dict["arrival_iata"].append(iata)
				flights_dict["arrival_time"].append(datetime.strptime(arrival_time, "%Y-%m-%d %H:%M%z").strftime("%Y-%m-%d %H:%M:%S"))

	flights_df = pd.DataFrame(flights_dict)

	engine = create_engine(connection())
	inspector = inspect(engine)

	if 'flights' in inspector.get_table_names():
		existing_data = pd.read_sql('flights', engine)
		flights_df = flights_df[~flights_df['flight_num'].isin(existing_data['flight_num'])]

	flights_df.to_sql('flights',
					con=engine,
					if_exists='append',
					index=False
					)
	return flights_df

