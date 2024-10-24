def get_weather_data():

    import json
    import pandas as pd
    from datetime import datetime
    import requests

    API_key = "XXX"
    cities = ["Berlin", "München"]
    country_code = "DE"
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
                weather_dict["sight_distance_[m]"].append(openweather_raw["list"][i]["visibility"])
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
    return weather_df