def push_airport_data_to_sql():

  #assert len(latitudes) == len(longitudes)
    
    import pandas as pd
    import requests
    from sqlalchemy import create_engine, inspect

    schema = "gans"
    host = "127.0.0.1"
    user = "root"
    password = "MySQLjau"
    port = 3306
    connection_string = f'mysql+pymysql://{user}:{password}@{host}:{port}/{schema}'

    
    latitudes = (pd.read_sql("cities", con=connection_string))["lat"]
    longitudes = (pd.read_sql("cities", con=connection_string))["lon"]

    list_for_df = []

    for index, value in enumerate(latitudes):

        url = f"https://aerodatabox.p.rapidapi.com/airports/search/location/{value}/{longitudes[index]}/km/50/10"

        querystring = {"withFlightInfoOnly":"true"}

        headers = {
        "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
        "X-RapidAPI-Key": "14a44098c8mshe4536a007985112p1e3b4bjsn8fd805eb6bd4"
        }

        response = requests.request("GET", url, headers=headers, params=querystring)

        list_for_df.append(pd.json_normalize(response.json()['items']))

        airports_df = pd.concat(list_for_df, ignore_index=True)

        engine = create_engine(connection_string)
        inspector = inspect(engine)
        if 'airports' in inspector.get_table_names():
          existing_data = pd.read_sql('airports', engine)
          airports_df = airports_df[~airports_df['iata'].isin(existing_data['iata'])]

        airports_df.to_sql('airports',
                  if_exists='append',
                  con=connection_string,
                  index=False)

    return airports_df