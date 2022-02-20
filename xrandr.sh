#!/bin/bash
SCREEN="Virtual-1"  # Display detected when using kvm/qemu

# Computing the modeline string for xrandr
GTF="$(gtf 1916 1036 60)"

MODELINE="$(echo "${GTF}" | grep -oP '(?<=Modeline ).+$' | tr -d '"')"
NEWMODE="$(echo "${MODELINE}" | awk '{print $1}')"

# Make the system recognise the new modeline
xrandr --newmode ${MODELINE}

# Adding the new mode to the display
xrandr --addmode ${SCREEN} ${NEWMODE}

# Applying the new resolution
xrandr --output ${SCREEN} --mode ${NEWMODE}
