from numpy import NaN
import requests
from bs4 import BeautifulSoup
import pandas as pd
import re



def scrape_city_data():
    cities = []

    # Loop to input cities
    while True:
        city = input("Enter a city (or 'done' to finish): ").strip()
        if city.lower() == "done":
            break
        cities.append(city)

    # Lists to store city and population data
    population_list = []
    latitude_list = []
    longitude_list = []
    country_list = []
    elevation_list = []

    # Iterate through the list of cities
    for city in cities:
        # Construct Wikipedia URL for the city
        url = f"https://en.wikipedia.org/wiki/{city}"

        # Send a GET request to the Wikipedia page of the city
        response = requests.get(url)

        # Parse the HTML content of the page
        soup = BeautifulSoup(response.content, 'html.parser')

        # Find the infobox table containing city information
        infobox = soup.find("table", {"class": "infobox ib-settlement vcard"})

        if infobox:
            # Search for the header containing population information
            population_data = infobox.find(string="Population")

            # Extract the population value if found, format number and add to list
            if population_data:
                population = population_data.find_next("td").get_text().strip().replace(",", "")
                population_list.append(population)
            else:
                print(f"Population data not found for {city}.")

            # Search for coordinates, extract them and add to list
            latitude = infobox.find("span", {"class": "latitude"})
            longitude = infobox.find("span", {"class": "longitude"})

            if latitude and longitude:
                latitude_list.append(latitude.get_text())
                longitude_list.append(longitude.get_text())
            else:
                latitude_list.append(None)
                longitude_list.append(None)

            # Search for country of location, extract and add to list
            country = infobox.find("tr", {"class": "mergedtoprow"}).find_next("td", {"class": "infobox-data"})
            if country:
                country_list.append(country.get_text())
            else:
                country_list.append(None)

            # Search for elevation, extract and add to list
            elevation = infobox.find(string="Elevation")
            if elevation:
                elevation = elevation.find_next("td").get_text().strip()
                elevation = int(re.sub(r'\D', '', elevation[:5]))
                elevation_list.append(elevation)
            else:
                elevation_list.append(None)
        else:
            print(f"Infobox not found for {city}.")
            country_list.append("failed")
            population_list.append(NaN)
            latitude_list.append("failed")
            longitude_list.append("failed")
            elevation_list.append(NaN)
        

    # Create DataFrame from lists
    df = pd.DataFrame({"Country": country_list, "City": cities, "Population": population_list, "Lat": latitude_list, "Lon": longitude_list, "Elevation in m": elevation_list})
    
    return df

city_data = scrape_city_data()
city_data