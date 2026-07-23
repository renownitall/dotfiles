function tamagotchi_mood
    # System Metrics
    # - Battery (defaults to safe values if no battery is found)
    set -l has_battery false
    set -l bat_cap 100
    set -l bat_stat Unknown
    set -l min_cap 100
    set -l has_discharging false
    set -l has_charging false
    set -l has_full false

    for bat in /sys/class/power_supply/BAT*
        if test -f "$bat/capacity"; and test -f "$bat/status"
            set -l cap (string trim (cat "$bat/capacity"))
            set -l stat (string trim (cat "$bat/status"))

            if not string match -qr '^[0-9]+$' -- "$cap"
                continue
            end

            set has_battery true
            if test "$cap" -lt "$min_cap"
                set min_cap "$cap"
            end

            switch "$stat"
                case Discharging
                    set has_discharging true
                case Charging
                    set has_charging true
                case Full
                    set has_full true
            end
        end
    end

    if test "$has_battery" = true
        set bat_cap "$min_cap"
        if test "$has_discharging" = true
            set bat_stat Discharging
        else if test "$has_charging" = true
            set bat_stat Charging
        else if test "$has_full" = true
            set bat_stat Full
        else
            set bat_stat "Not charging"
        end
    end

    # - CPU Load (threshold = 80% of total cores)
    set -l cores (nproc)
    set -l load_threshold (math --scale=1 "$cores * 0.8")
    set -l sys_load (awk '{print $1}' /proc/loadavg)
    set -l is_high_load 0
    set is_high_load (awk -v sys_load="$sys_load" -v thresh="$load_threshold" 'BEGIN { print (sys_load > thresh) ? 1 : 0 }')

    set -l hour (date +%H)
    set -l mood ""
    set -l kaomoji ""

    # Hierarchy 1: Critical System States
    set -l battery_handled false
    if test "$has_battery" = true
        if test "$bat_cap" -lt 10; and test "$bat_stat" = Discharging
            set mood critical_battery
            set kaomoji (random choice "(x_x;)" "(;´д`)")
            set battery_handled true
        else if test "$bat_cap" -lt 20; and test "$bat_stat" = Discharging
            set mood low_battery
            set kaomoji (random choice "(o_o;)" "(・_・;)" "(´-`;)")
            set battery_handled true
        else if test "$bat_stat" = Full; or test "$bat_cap" -eq 100 -a "$bat_stat" != Discharging
            set mood full_battery
            set kaomoji (random choice "(`▽´)" "( ˘ω˘ )" "(￣ー￣)")
            set battery_handled true
        end
    end

    if not test "$battery_handled" = true
        # Hierarchy 2: High Load
        if test $is_high_load -eq 1
            set mood high_load
            set kaomoji (random choice "(；一_一)" "(￣ロ￣;)" "(=_=)")

            # Hierarchy 3: Time of Day (Baseline)
        else if test $hour -ge 1 -a $hour -lt 5
            set mood late_night
            set kaomoji (random choice "(¬_¬)" "(=_=)" "(￣︿￣)")
        else if test $hour -ge 5 -a $hour -lt 12
            set mood morning
            set kaomoji (random choice "(￣ー￣)" "( ´-`)" "(・_・)")
        else if test $hour -ge 12 -a $hour -lt 17
            set mood afternoon
            set kaomoji (random choice "(`▽´)" "(・ω・)" "(￣ー￣)b")
        else if test $hour -ge 17 -a $hour -lt 21
            set mood evening
            set kaomoji (random choice "(´-ω-`)" "(~_~)" "( ˘ω˘ )")
        else
            set mood night
            set kaomoji (random choice "(-.-)zzz" "(￣ω￣)" "(∪｡∪)")
        end
    end

    # Output mood and kaomoji; '::' for simpler parsing
    echo "$mood::$kaomoji"
end
