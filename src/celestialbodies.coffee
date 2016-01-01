G = 6.674e-11
TWO_PI = 2 * Math.PI
HALF_PI = 0.5 * Math.PI

(exports ? this).CelestialBody = class CelestialBody
  constructor: (@mass, @radius, @siderealRotation, @orbit, @atmPressure = 0, @atmScaleHeight = 0) ->
    @gravitationalParameter = G * @mass
    @sphereOfInfluence = @orbit.semiMajorAxis * Math.pow(@mass / @orbit.referenceBody.mass, 0.4) if @orbit?
    @atmRadius = -Math.log(1e-6) * @atmScaleHeight + @radius
  
  circularOrbitVelocity: (altitude) ->
    Math.sqrt(@gravitationalParameter / (altitude + @radius))
  
  siderealTimeAt: (longitude, time) ->
    result = ((time / @siderealRotation) * TWO_PI + HALF_PI + longitude) % TWO_PI
    if result < 0 then result + TWO_PI else result
  
  name: -> return k for k, v of CelestialBody when v == this
  
  children: ->
    result = {}
    result[k] = v for k, v of CelestialBody when v?.orbit?.referenceBody == this
    result

CelestialBody.fromJSON = (json) ->
  orbit = Orbit.fromJSON(json.orbit) if json.orbit?
  new CelestialBody(json.mass, json.radius, json.siderealRotation, orbit, json.atmPressure)
  
CelestialBody.Sun = Sun = new CelestialBody(1.988435e30, 6.955e08, 2164320, null)

CelestialBody.Mercury = Mercury = new CelestialBody(3.30104e23, 2.4397e06, 5067030, new Orbit(Sun, 5.7909176e07, 0.20563069, 7.00487, 48.33167, 29.1248, 3.015))
CelestialBody.Venus = Venus = new CelestialBody(4.86732e24, 6.0519e06, 2.09968e07, new Orbit(Sun, 1.0820893e08, 6.77323e-3, 3.39471, 76.68069, 54.85229, 0.8613), 89, 15900)

CelestialBody.Earth = Earth = new CelestialBody(5.97237e24, 6.371e06, 86141.1, new Orbit(Sun, 1.49597887e11, 0.01671022, 5e-5, 348.73936, 114.20783, 6.245), 1, 8500)
CelestialBody.Moon = Moon = new CelestialBody(7.3459e22, 1.7375e06, 236060, new Orbit(Earth, 3.844e08, 0.0554, 5.16, 125.08, 318.15, 2.105))

CelestialBody.Mars = Mars = new CelestialBody(6.41693e23, 3.386e06, 88642.7, new Orbit(Sun, 2.27936637e11, 0.09341233, 1.85061, 49.57854, 286.4623, 0.3334), 0.0063, 11100)
CelestialBody.Phobos = Phobos = new CelestialBody(1.072e16, 1.11e04, 27600, new Orbit(Mars, 9.376e06, 0.0151, 1.093, 164.931, 150.247, 3.14))
CelestialBody.Deimos = Deimos = new CelestialBody(1.5e15, 6.2e03, 109000, new Orbit(Mars, 2.34632e07, 3.3e-4, 0.93, 339.6, 290.496, 3.14))

CelestialBody.Vesta = Vesta = new CelestialBody(2.59e20, 2.65e05, 19230, new Orbit(Sun, 3.53343625e11, 0.089358, 7.1338, 103.9184, 150.1801, 5.942))
CelestialBody.Ceres = Ceres = new CelestialBody(9.47e20, 4.762e05, 32760, new Orbit(Sun, 4.13781191e11, 0.0797602, 10.58671, 80.40696, 73.1507, 0.1175))

CelestialBody.Jupiter = Jupiter = new CelestialBody(1.89813e27, 6.9173e07, 35730, new Orbit(Sun, 7.78412027e11, 0.048392660, 1.3053, 100.55615, -85.8023, 0.3466), 0.3, 27000)
CelestialBody.Amalthea = Amalthea = new CelestialBody(2.07e18, 8.345e04, 43000, new Orbit(Jupiter, 1.814e08, 0.0032, 0.38, 108.946, 155.873, 3.14))
CelestialBody.Io = Io = new CelestialBody(8.9298e22, 1.8216e06, 152800, new Orbit(Jupiter, 4.217e08, 0.0041, 0.036, 43.977, 84.129, 3.14))
CelestialBody.Europa = Europa = new CelestialBody(4.7987e22, 1.5608e06, 306800, new Orbit(Jupiter, 6.711e08, 0.0094, 0.466, 219.106, 88.97, 3.14))
CelestialBody.Ganymede = Ganymede = new CelestialBody(1.4815e23, 2.6312e06, 618200, new Orbit(Jupiter, 1.0704e09, 0.0013, 0.177, 63.522, 192.417, 3.14))
CelestialBody.Callisto = Callisto = new CelestialBody(1.0757e23, 2.4103e06, 1.442e06, new Orbit(Jupiter, 1.8827e09, 0.0074, 0.192, 298.848, 52.643, 3.14))
CelestialBody.Himalia = Himalia = new CelestialBody(6.7e18, 8.5e04, 35000, new Orbit(Jupiter, 1.1461e10, 0.1623, 27.496, 57.245, 331.995, 3.14))

CelestialBody.Saturn = Saturn = new CelestialBody(5.68319e26, 5.7136e07, 38362, new Orbit(Sun, 1.42672541e12, 0.0541506, 2.48446, 113.71504, -21.2831, 338.7169, 5.532), 0.4, 59500)
CelestialBody.Mimas = Mimas = new CelestialBody(3.791e19, 1.988e05, 81400, new Orbit(Saturn, 1.85540e08, 0.0196, 1.572, 153.152, 14.352, 3.14))
CelestialBody.Enceladus = Enceladus = new CelestialBody(1.08e20, 2.523e05, 118400, new Orbit(Saturn, 2.3804e08, 0.0047, 0.009, 93.204, 211.923, 3.14))
CelestialBody.Tethys = Tethys = new CelestialBody(6.175e20, 5.363e05, 163100, new Orbit(Saturn, 2.9467e08, 1e-4, 1.091, 330.882, 262.845, 3.14))
CelestialBody.Dione = Dione = new CelestialBody(1.0955e21, 5.625e05, 236500, new Orbit(Saturn, 3.7742e08, 0.0022, 0.028, 168.909, 168.82, 3.14))
CelestialBody.Rhea = Rhea = new CelestialBody(2.3084e21, 7.645e05, 390400, new Orbit(Saturn, 5.2707e08, 0.001, 0.331, 311.531, 256.609, 3.14))
CelestialBody.Titan = Titan = new CelestialBody(1.3452e23, 2.5755e06, 1.378e06, new Orbit(Saturn, 1.22187e09, 0.0288, 0.28, 24.502, 185.671, 3.14), 1.41, 40000)
CelestialBody.Hyperion = Hyperion = new CelestialBody(5.5e18, 1.33e05, 1.839e06, new Orbit(Saturn, 1.50088e09, 0.0274, 0.63, 264.022, 324.183, 3.14))
CelestialBody.Iapetus = Iapetus = new CelestialBody(1.8055e21, 7.345e05, 6.845e06, new Orbit(Saturn, 3.56084e09, 0.0283, 7.489, 75.831, 275.921, 3.14))
CelestialBody.Phoebe = Phoebe = new CelestialBody(8.287e18, 1.066e05, 35000, new Orbit(Saturn, 1.294778e10, 0.1635, 175.986, 241.57, 345.582, 3.14))  

CelestialBody.Uranus = Uranus = new CelestialBody(8.68103e25, 2.5266e07, 62064, new Orbit(Sun, 2.87097222e12, 0.04176771, 0.76986, 74.22988, 96.73436, 2.462), 1.2, 27700)
CelestialBody.Miranda = Miranda = new CelestialBody(6.6e19, 2.358e05, 122100, new Orbit(Uranus, 1.299e08, 0.0013, 4.338, 326.438, 68.312, 3.14))
CelestialBody.Ariel = Ariel = new CelestialBody(1.35e21, 5.789e05, 217700, new Orbit(Uranus, 1.909e08, 0.0012, 0.041, 22.394, 115.349, 3.14))
CelestialBody.Umbriel = Umbriel = new CelestialBody(1.17e21, 5.847e05, 358000, new Orbit(Uranus, 2.66e08, 0.0039, 0.128, 33.485, 84.709, 3.14))
CelestialBody.Titania = Titania = new CelestialBody(3.526e21, 7.889e05, 752200, new Orbit(Uranus, 4.363e08, 0.0011, 0.079, 99.771, 284.4, 3.14))
CelestialBody.Oberon = Oberon = new CelesialBody(3.013e21, 7.614e05, 1.163e06, new Orbit(Uranus, 5.835e08, 0.0014, 0.068, 279.771, 104.4, 3.14))

CelestialBody.Neptune = Neptune = new CelestialBody(1.0241e26, 2.4553e07, 57996, new Orbit(Sun, 4.49825291e12, 0.00858587, 1.76917, 131.72169, 273.24966, 4.471), 1, 19700)
CelestialBody.Proteus = Proteus = new CelestialBody(5.03e19, 2.10e05, 96940, new Orbit(Neptune, 1.17647e08, 5e-4, 0.026, 162.69, 301.706, 3.14))
CelestialBody.Triton = Triton = new CelestialBody(2.1394e22, 1.3534e06, 507800, new Orbit(Neptune, 3.548e08, 0, 156.834, 172.431, 344.046, 3.14))
CelestialBody.Nereid = Nereid = new CelestialBody(3.09e19, 1.70e05, 3.1116e07, new Orbit(Neptune, 5.5134e09, 0.7512, 7.232, 334.762, 280.83, 3.14))

CelestialBody.Pluto_Charon_Barycentric = Pluto_Charon_Barycentric = new CelestialBody(1.471e22, 1, 1, new Orbit(Sun, 5.906376272e12, 0.24880766, 17.14175, 110.30347, 113.76329, 0.2616))
CelestialBody.Pluto = Pluto = new CelestialBody(1.309e22, 1.185e06, 551800, new Orbit(Pluto_Charon_Barycentric, 2.035e06, 0.0022, 0.001, 223.049, 165.053, 0))
CelestialBody.Charon = Charon = new CelestialBody(1.62e21, 5.93e05, 551800, new Orbit(Pluto_Charon_Barycentric, 1.7536e07, 0.0022, 0.001, 223.049, 165.053, 3.14))

###
CelestialBody.Moho = Moho = new CelestialBody(2.5263617e21, 250000, 1210000, new Orbit(Kerbol, 5263138304, 0.2, 7.0, 70.0, 15.0, 3.14))
CelestialBody.Eve = Eve = new CelestialBody(1.2244127e23, 700000, 80500, new Orbit(Kerbol, 9832684544, 0.01, 2.1, 15.0, 0, 3.14), 5, 7000)
CelestialBody.Gilly = Gilly = new CelestialBody(1.2420512e17, 13000, 28255, new Orbit(Eve, 31500000, 0.55, 12.0, 80.0, 10.0, 0.9))
CelestialBody.Kerbin = Kerbin = new CelestialBody(5.2915793e22, 600000, 21600, new Orbit(Kerbol, 13599840256, 0.0, 0, 0, 0, 3.14), 1, 5000)
CelestialBody.Mun = Mun = new CelestialBody(9.7600236e20, 200000, 138984.38, new Orbit(Kerbin, 12000000, 0.0, 0, 0, 0, 1.7))
CelestialBody.Minmus = Minmus = new CelestialBody(2.6457897e19, 60000, 40400, new Orbit(Kerbin, 47000000, 0.0, 6.0, 78.0, 38.0, 0.9))
CelestialBody.Duna = Duna = new CelestialBody(4.5154812e21, 320000, 65517.859, new Orbit(Kerbol, 20726155264, 0.051, 0.06, 135.5, 0, 3.14), 0.2, 3000)
CelestialBody.Ike = Ike = new CelestialBody(2.7821949e20, 130000, 65517.862, new Orbit(Duna, 3200000, 0.03, 0.2, 0, 0, 1.7))
CelestialBody.Dres = Dres = new CelestialBody(3.2191322e20, 138000, 34800, new Orbit(Kerbol, 40839348203, 0.145, 5.0, 280.0, 90.0, 3.14))
CelestialBody.Jool = Jool = new CelestialBody(4.2332635e24, 6000000, 36000, new Orbit(Kerbol, 68773560320, 0.05, 1.304, 52.0, 0, 0.1), 15, 10000)
CelestialBody.Laythe = Laythe = new CelestialBody(2.9397663e22, 500000, 52980.879, new Orbit(Jool, 27184000, 0, 0, 0, 0, 3.14), 0.8, 4000)
CelestialBody.Vall = Vall = new CelestialBody(3.1088028e21, 300000, 105962.09, new Orbit(Jool, 43152000, 0, 0, 0, 0, 0.9))
CelestialBody.Tylo = Tylo = new CelestialBody(4.2332635e22, 600000, 211926.36, new Orbit(Jool, 68500000, 0, 0.025, 0, 0, 3.14))
CelestialBody.Bop = Bop = new CelestialBody(3.7261536e19, 65000, 544507.4, new Orbit(Jool, 128500000, 0.235, 15.0, 10.0, 25.0, 0.9))
CelestialBody.Pol = Pol = new CelestialBody(1.0813636e19, 44000, 901902.62, new Orbit(Jool, 179890000, 0.17085, 4.25, 2.0, 15.0, 0.9))
CelestialBody.Eeloo = Eeloo = new CelestialBody(1.1149358e21, 210000, 19460,new Orbit(Kerbol, 90118820000, 0.26, 6.15, 50.0, 260.0, 3.14))
###
