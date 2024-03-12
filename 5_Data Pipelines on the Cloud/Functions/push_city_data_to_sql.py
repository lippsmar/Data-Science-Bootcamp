def push_city_data_to_sql():

   import pandas as pd
   import requests
   from bs4 import BeautifulSoup
   import re
   from sqlalchemy import create_engine, inspect, Float

   API_key = "81f1a5b752c4569a954655d748508db5"
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

   schema = "gans"
   host = "127.0.0.1"
   user = "root"
   password = "MySQLjau"
   port = 3306
   connection_string = f'mysql+pymysql://{user}:{password}@{host}:{port}/{schema}'

   engine = create_engine(connection_string)
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