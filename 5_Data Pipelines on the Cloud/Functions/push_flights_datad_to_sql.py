def push_flights_datad_to_sql():

	import requests
	from datetime import datetime, timedelta
	from sqlalchemy import create_engine, inspect
	import pandas as pd

	schema = "gans"
	host = "127.0.0.1"
	user = "root"
	password = "MySQLjau"
	port = 3306
	connection_string = f'mysql+pymysql://{user}:{password}@{host}:{port}/{schema}'

	iata_list = (pd.read_sql("cities_airports", con=connection_string))["iata"]

	tomorrow_date = datetime.now() + timedelta(days=1)
	start_time_morning = datetime(tomorrow_date.year, tomorrow_date.month, tomorrow_date.day, 0, 0).strftime("%Y-%m-%dT%H:%M")
	end_time_morning = datetime(tomorrow_date.year, tomorrow_date.month, tomorrow_date.day, 12, 0).strftime("%Y-%m-%dT%H:%M")
	start_time_afternoon = datetime(tomorrow_date.year, tomorrow_date.month, tomorrow_date.day, 12, 0).strftime("%Y-%m-%dT%H:%M")
	end_time_afternoon = datetime(tomorrow_date.year, tomorrow_date.month, tomorrow_date.day, 23, 59, 59).strftime("%Y-%m-%dT%H:%M")
	
	querystring = {"withLeg":"false","direction":"Arrival","withCancelled":"false","withCodeshared":"false", "withCargo":"false","withPrivate":"false","withLocation":"false"}

	headers = {
		"X-RapidAPI-Key": "14a44098c8mshe4536a007985112p1e3b4bjsn8fd805eb6bd4",
		"X-RapidAPI-Host": "aerodatabox.p.rapidapi.com"
	}

	flights_dict = {
		"flight_num": [],
		"departure_iata": [], 
		"arrival_iata": [], 
		"arrival_time": []}

	for iata in iata_list:
		for start_time, end_time in [(start_time_morning, end_time_morning), 
                                     (start_time_afternoon, end_time_afternoon)]:
		
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

	engine = create_engine(connection_string)
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