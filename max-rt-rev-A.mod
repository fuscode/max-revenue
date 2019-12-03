# Declaration of parameters
# Unchangeable
param ti := 1; param tf;
param ti_part; param tf_part;
param te_storage default 0; param rev_storage default 0;
param p {t in ti..tf};
param multiplier default -1;

# Changeable
param mwh := 1;
param mw := 1;
param n := 1; #0.985
param SOC_max = 1; param SOC_min = 0;
param c_b = 100e3 * multiplier * 0;# range from 0 to 7
param eol = 0.65 * 0;
param f_bb = 3.37e-5 * 1 * 0;

# Declaration of variables
var E_to {t in ti_part..tf_part};
var E_from {t in (ti_part-1)..tf_part};
var E_p {t in ti_part..tf_part} = E_to[t]/n;
var E_s {t in ti_part..tf_part} = E_from[t]*n;
var SOC {t in (ti_part-1)..tf_part} >=0 ;
var te_part = sum {t in ti_part..tf_part} (E_from[t]);

var te {t in ti_part..tf_part} = sum {i in (ti_part-1)..t} (E_from[i]);
# var te_24 {t in ti_part..(tf_part/24)} = sum {i in (24*(t-1) + 1)..24*t} (E_from[i]);
var q_rem {t in ti_part..tf_part} = 1 - f_bb*te[t]/mwh;
var c {t in ti_part..tf_part} = (f_bb*E_from[t])/(SOC_max-SOC_min) * c_b/(1-eol);

# Objective function
maximize revenue: sum {t in ti_part..tf_part} (p[t]*(E_s[t]-E_p[t]) - c[t]);

#Constraints
subject to c_xmin {t in ti_part..tf_part}: 0 <= E_to[t] <= mw;
subject to c_xmax {t in ti_part..tf_part}: 0 <= E_from[t] <= mw;

# State of Charge inicial final e instantaneo
subject to c_init : SOC[ti_part-1] = mwh/2;
subject to c_final : SOC[tf_part] = mwh/2;
subject to c_cons {t in ti_part..tf_part}: SOC[t] = SOC[t-1] - E_from[t] + E_to[t];

subject to te_init: E_from[ti_part-1] = te_storage;

# SOC_range depende da carga remanescente e do range de operacao
subject to SOC_range_max {t in ti_part..tf_part}: SOC[t] <= q_rem[t] * mwh * SOC_max;
subject to SOC_range_min {t in ti_part..tf_part}: SOC[t] >= q_rem[t] * mwh * SOC_min;

# EOL criterion
# subject to EOL {t in ti_part..tf_part}: q_rem[t] >= eol;

# # Limite de ciclos de carga por dia
# subject to b_max {t in ti..(tf/24)}: te_24[t] <= ciclos_dia * mwh;

# # Limite de 2 mil ciclos de carga-descarga
# subject to b_life {t in ti..tf}: te[tf]/mwh <= ciclos_total;
