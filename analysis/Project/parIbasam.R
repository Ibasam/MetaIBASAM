#set.seed(666) # R‘s random number generator. Use the set.seed function when running simulations to ensure all results, figures, etc are reproducible.

#_________________ PARAMETERS _________________#
pop = 15 # population to simulate
npop = 3
nYears = 50
rPROP = .5

#_________________ SCENARIOS _________________#
# Fishing:
fish.state=TRUE # TRUE If fishing applied
fish.stage=TRUE # fishing on life stages (1SW/MSW) if TRUE, on Sizes ("small","med","big") otherwise
frates=c(.15,.15,.15) # Fishing rates

# 3 scenarios (iSIMUL) for STAT:
#grilse: 0.15 / MSW: 0.15 => "Control"
#grilse: 0.3 / MSW: 0 => "1SW"
#grilse: 0. / MSW: 0.3 => "MSW"

# 5 scenarios (iSIMUL) for TAILLE:
# small: 0.15 / med: 0.15 / big: 0.15 => "Control"
# small: 0.6 / med: 0 / big: 0 => "Small"
# small: 0 / med: 0.3 / big: 0 = "Med"
# small: 0 / med: 0 / big: 0.6 => "Big"
# small: 0.3 / med: 0 / big: 0.3 => "Big small"


# Connectivity conditions:
scenarioConnect=1 #scenario 1 pour h=1.00, scenario 2 pour h=0.942, scenario 3 pour h=0.80

# Environmental conditions:
scenarioEnvi=1 #scenario 1 pour absence de CC, scenario 2 pour CC
#Temp=0 # Water Temperature (T° increase / Years; keep constant if 0)
#Amp=1 # Flow amplitude (keep constant if 1)
#Sea=1 # decreasing growth condition at sea (keep constant if 1)