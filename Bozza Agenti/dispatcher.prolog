===========================
           Drone
===========================

%%% droni inizialmente in pausa
pause.

%%% attivazione da dispatcher
activateE :>
    retract(pause),
    messageA(dispatcher, Me, im_active(Me)),
    write("sto facendo il tour!").

%%% il drone trova un'emergenza
spot_fireE(Loc) :>
    reportA(Loc, fire).
spot_accidentE(Loc) :>
    reportA(Loc, ambulance).

%%% segnalazione eventi al dispatcher
report(Loc, Type) <:
    messageA(dispatcher, Me, report_emergency(Loc, Type)).

%%% Dispatcher chiede ricognizione
ask_recognitionE(Loc) :>
    write("vado a vedere cosa succede").

%%% risultato ricognizione random 
recognition_report(Loc, fire) :-
    ask_recognitionP(Loc),
    random(0, 100, N),
    N < 50.
recognition_report(Loc, ambulance) :-
    ask_recognitionP(Loc),
    random(0, 100, N),
    N >= 50.
recognition_reportI(Loc, Type) :>
    report(Loc, Type).

%%% battery management
battery_lowE :>
    go_baseA,
    messageA(dispatcher, Me, im_recharging(Me)),
    assert(pause),
    write("mi sto ricaricando").


===========================
        Dispatcher
===========================
:- dynamic drone/1
:- dynamic active/1

drone(droneA).
drone(droneB).


% avvio dispatcher
start.
start_drone_tour :- start
start_drone_tourI :> messageA(droneA, Me, activate)

% logica attivazione drone
im_activeE(Drone) :> assert(active(Drone))
im_rechargingE(Drone) :> retract(active(Drone))






callEmergencyE(Loc, fire)
callEmergencyE(Loc, ambulance)
callEmergencyE(Loc, unknown) 


