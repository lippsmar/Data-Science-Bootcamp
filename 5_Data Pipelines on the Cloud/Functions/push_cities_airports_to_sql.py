def push_cities_airports_to_sql():

    import pandas as pd
    from sqlalchemy import create_engine, inspect
    

    schema = "gans"
    host = "127.0.0.1"
    user = "root"
    password = "XXX"
    port = 3306
    connection_string = f'mysql+pymysql://{user}:{password}@{host}:{port}/{schema}'

    cities_df = pd.read_sql("cities", con=connection_string)
    airports_df = pd.read_sql("airports", con=connection_string)

    cities_airports_df = (pd.merge(cities_df, airports_df, left_on="city", right_on="municipalityName", how="left"))[["city_id","iata"]]
    cities_airports_df

    engine = create_engine(connection_string)
    inspector = inspect(engine)
    if 'cities_airports' in inspector.get_table_names():
        existing_data = pd.read_sql('cities_airports', engine)
        cities_airports_df = cities_airports_df[~cities_airports_df['city_id'].isin(existing_data['city_id'])]

    cities_airports_df.to_sql('cities_airports',
            if_exists='append',
            con=connection_string,
            index=False)
    
    return cities_airports_df