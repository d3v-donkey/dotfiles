#!/bin/bash

MAIN_SCREEN="eDP1"
MAIN_MODE="1920x1080"

to_run=()
to_run_idx=0

queue_run() {
    echo "adding $1 to run_queue at index ${to_run_idx}"
    to_run[$to_run_idx]="$(echo $1|tr ' ' ' ')"
    to_run_idx=$((to_run_idx+1))
}

# Désactive les sorties déconnecter
for disconnect_out in $(xrandr|grep disconnected|cut -f1 -d' ') ; do
    queue_run "xrandr --output ${disconnect_out} --off"
done

# Active l'ecrans principal
queue_run "xrandr --output ${MAIN_SCREEN} --mode ${MAIN_MODE}"

CONNECTED=$(xrandr |grep " connected"|grep -v "${MAIN_SCREEN}"| cut -f1 -d' ')
echo "Connecter: ${CONNECTED}"

# Vous demande ce que vous voulez faire ?
for dpy in ${CONNECTED} ; do
    choices=""
    for dpy2 in ${CONNECTED} ${MAIN_SCREEN} ; do
        if [ "${dpy}" == "${dpy2}" ]; then
            echo "dpy (${dpy}) == dpy2 (${dpy})"
            continue
        fi
        for pos in "left-of" "right-of" ; do
            choices="${choices} ${pos} ${dpy2}"
        done
    done
    choices="${choices} disabled"
    ret=$(zenity --list --title "${dpy}" --text "Comment ${dpy} doit être configurer" --column "Modes" ${choices})
    if [ "${ret}" == "disabled" ]; then
        queue_run "xrandr --output ${dpy} --off"
    else
        queue_run "xrandr --output ${dpy} --${ret} --auto"
    fi
done

if (zenity --question --title "Appliquer Configuration ?" --text "Voulez-vous appliquer la configuration ?"); then
    idx=0
    for ((idx=0; idx<to_run_idx; idx++)); do 
        echo "==> ${to_run[$idx]}"
        ${to_run[$idx]}
    done
    if ( zenity --question --title "Redémarrer systeme ?" --text "Voulez-vous redémarrer ?" ) ; then
        reboot
    fi
fi

