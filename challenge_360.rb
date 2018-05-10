require 'net/http'
require 'json'

# Challenge from https://www.reddit.com/r/dailyprogrammer/comments/8i5zc3/20180509_challenge_360_intermediate_find_the/ 

EARTH_RAD = 6371
# Eifel Tower
LONGITUDE = 2.2945
LATTITUDE = 48.8584
# John F. Kennedy Airport
# LONGITUDE = -73.7781
# LATTITUDE = 40.6413


def printAirborne(airborne)
    # Geodesic distance
    # Callsign
    # Lattitude and Longitude
    # Geometric Altitude
    # Country of origin
    # ICAO24 ID
    geo_distance = airborne.last
    callsign = airborne[1]
    lattitude = airborne[6]
    longitude = airborne[5]
    geo_altitude = airborne[7]
    origin_country = airborne[2]
    icao24 = airborne[0]

    puts('Geodesic distance ' + geo_distance.to_s + 'km')
    puts('Callsign ' + callsign.to_s)
    puts('Lattitude and Longitude ' + lattitude.to_s + ' ' + longitude.to_s)
    puts('Geometric Altitude ' + geo_altitude.to_s)
    puts('Country of origin ' + origin_country.to_s)
    puts('ICAO24 ID ' + icao24.to_s)
end

def toRadians(degrees)
    return degrees*Math::PI/180
end

def getDistance(airborne)
    current_longitude = toRadians(LONGITUDE)
    current_lattitude = toRadians(LATTITUDE)
    airborne_longitude = toRadians(airborne[5].to_f)
    airborne_lattitude = toRadians(airborne[6].to_f)
    xrad = [airborne_longitude, airborne_lattitude]
    yrad = [current_longitude, current_lattitude]
    return EARTH_RAD*Math.acos(Math.sin(xrad[0])*Math.sin(yrad[0]) +
                                Math.cos(xrad[0])*Math.cos(yrad[0])*Math.cos((xrad[1] - yrad[1]).abs))
end

def getNearestAirborne(airbornesArray)
    firstLoop = true
    lastMinorDistance = 0
    nearestAirborne = nil
    for airborne in airbornesArray
        distance = getDistance(airborne)
        if distance < lastMinorDistance || firstLoop
            nearestAirborne = airborne
            lastMinorDistance = distance
            firstLoop = false
        end
    end

    nearestAirborne << lastMinorDistance

    return nearestAirborne
end

uri = URI('https://opensky-network.org/api/states/all')
airbornesArray = JSON.parse(Net::HTTP.get(uri))['states']
nearestAirbone = getNearestAirborne(airbornesArray)
printAirborne(nearestAirbone)

