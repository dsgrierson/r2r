% Firgelli feedback pot calculations

stroke_length = 50 % mm
R_per_mm = 2750 % ohms per mm of stroke
R_tol = .3 % Tolerance Percentage of feedback resistor

RStroke_Nom = stroke_length * R_per_mm % Nominal Full Stroke Resistance
RStroke_min = RStroke_Nom*(1-R_tol)
RStroke_max = RStroke_Nom*(1+R_tol)
