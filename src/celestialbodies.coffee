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
CelestialBody.Venus = Venus = new CelestialBody(4.86732e24, 6.0519e06, 2.09968e7, new Orbit(Sun, 1.0820893e08, 6.77323e-3, 3.39471, 76.68069, 54.85229, 0.8613), 89, 15900)

CelestialBody.Earth = Earth = new CelestialBody(5.97237e24, 6.371e06, 86141.1, new Orbit(Sun, 1.49597887e11, 0.01671022, 5e-5, 348.73936, 114.20783, 6.245), 1, 8500)
CelestialBody.Moon = Moon = new CelestialBody(7.3459e22, 1.7375e06, 236060, new Orbit(Earth, 3.844e8, 0.0554, 5.16, 125.08, 318.15, 2.105))

CelestialBody.Mars = Mars = new CelestialBody(6.41693e23, 3.386e06, 88642.7, new Orbit(Sun, 2.27936637e11, 0.09341233, 1.85061, 49.57854, 286.4623, 0.3334), 0.0063, 11100)
CelestialBody.Phobos = Phobos = new CelestialBody(1.072e16, 1.11e04, 27600, new Orbit(Mars, 9.376e6, 0.0151, 1.093, 164.931, 150.247, 3.14))
CelestialBody.Deimos = Deimos = new CelestialBody(1.5e15, 6.2e03, 109000, new Orbit(Mars, 2.34632e7, 3.3e-4, 0.93, 339.6, 290.496, 3.14))

CelestialBody.Ceres = Ceres = new CelestialBody(9.47e20, 4.762e05, 32760, new Orbit(Sun, 4.13781191e11, 0.0797602, 10.58671, 80.40696, 73.1507, 0.1175))
CelestialBody.Vesta = Vesta = new CelestialBody(2.59e20, 2.65e05, 19230, new Orbit(Sun, 3.53343625e11, 0.089358, 7.1338, 103.9184, 150.1801, 5.942))
CelestialBody.Pallas = Pallas = new CelestialBody(2.11e20, 2.66e05, 28128, new Orbit(Sun, 4.14635701e11, 0.2307588, 34.84183, 173.1358, 310.34482, 6.151))
CelestialBody.Juno = Juno = new CelestialBody(2.67e19, 1.1696e05, 25960, new Orbit(Sun, 3.99109789e11, 0.2580232, 12.97037, 170.12, 247.84199, 4.197))

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
