#!/usr/bin/env bash

# Batteriedaten per tlp-stat abfragen

function bat0_charge {
        sudo tlp-stat -b | head -n 21 | tail -1 | tr -d -c "[:digit:],." | cut -f
 1 -d "%" | tr . ,
}

function bat0_charge_for_total {
        sudo tlp-stat -b | head -n 21 | tail -1 | tr -d -c "[:digit:],." | cut -f
 1 -d "%"
}

function bat0_status {
        sudo tlp-stat -b | head -n 15 | tail -1 | cut -f 2 -d "=" | sed "s/ //g"
}

function bat1_charge {
        sudo tlp-stat -b | head -n 38 | tail -1 | tr -d -c "[:digit:],." | cut -f
 1 -d "%" | tr . ,
}

function bat1_charge_for_total {
        sudo tlp-stat -b | head -n 38 | tail -1 | tr -d -c "[:digit:],." | cut -f
 1 -d "%"
}

function bat1_status {
        sudo tlp-stat -b | head -n 32 | tail -1 | cut -f 2 -d "=" | sed "s/ //g"
}

# Berechnung Batteriestand
function total_charge {
        bc -l <<< "scale=4; ($(bat0_charge_for_total)+$(bat1_charge_for_total))/2
" | tr . ,
}

# Konvertierung Batteriestand

function total_charge_convert {
        printf "%.*f\n" 0 $(total_charge)
}

# Farbdefinitionen

if [ $(bat0_status) = 'Charging' ]
then
        bat0_color='#519f50'
elif [ $(bat0_status) = 'Discharging' ]
then
        bat0_color='#da4939'
else
        bat0_color='#e6e6e6'
fi

if [ $(bat1_status) = 'Charging' ]
then
        bat1_color='#519f50'
elif [ $(bat1_status) = 'Discharging' ]
then
        bat1_color='#da4939'
else
        bat1_color='#e6e6e6'
fi


if [ $(bat0_status) = 'Charging' ] || [ $(bat1_status) = 'Charging' ]
then
        total_color='#519f50'
elif [ $(bat0_status) = 'Discharging' ] || [ $(bat1_status) = 'Discharging' ]
then
        total_color='#da4939'
else
        total_color='#e6e6e6'
fi
# Reaktion auf CLI Parameter

case "$1" in
        --bat0)
                (echo "%{F$bat0_color}BAT0 "; printf "%.*f\n" 0 $(bat0_charge); e
cho "%%{F-}") | tr -d "\n"

                ;;
        --bat1)
                (echo "%{F$bat1_color}BAT1 "; printf "%.*f\n" 0 $(bat1_charge); e
cho "%%{F-}") | tr -d "\n"
                ;;
        *)
                if [ $(total_charge_convert) -lt 10 ]
                then
                        (echo "%{F#3a3a3a}B%{F-}%{O3}%{F#181818}00%{F-}%{F$total_
color}"; printf "%.*f\n" 0 $(total_charge); echo "%%{F-}") | tr -d "\n"
                elif [ $(total_charge_convert) -lt 100 ]
                then
                        (echo "%{F#3a3a3a}B%{F-}%{O3}%{F#181819}0%{F-}%{F$total_c
olor}"; printf "%.*f\n" 0 $(total_charge); echo "%%{F-}") | tr -d "\n"
                else
                        (echo "%{F#3a3a3a}B%{F-}%{O3}%{F$total_color}"; printf "%
.*f\n" 0 $(total_charge); echo "%%{F-}") | tr -d "\n"
                fi
                ;;
esac
