===========================
           Drone
===========================

%%% droni inizialmente in pausa

dispatcher(disp)
pause.

write('im sleeping)

%%% attivazione da dispatcher
activateE :>
        retract(pause),
        dispatcher(d)
        messageA(d, Me, im_active(Me)),
        write("sto facendo il tour!").

%%% il drone trova un'emergenza
spot_fireE(Loc) :>
        dispatcher(d)
        messageA(d, Me, report_emergency(Loc, fire)).

spot_accidentE(Loc) :>
        dispatcher(d)
        messageA(d, Me, report_emergency(Loc, ambulance)).

%%% Dispatcher chiede ricognizione
ask_recognitionE(Loc) :>
        write("vado a vedere cosa succede"),
        
%%% risultato ricognizione random 
recognition_report(Loc, fire) :-
        not(pause),
        ask_recognitionP(Loc),
        random(0, 100, N),
        N < 50.
recognition_report(Loc, ambulance) :-
        not(pause),
        ask_recognitionP(Loc),
        random(0, 100, N),
        N >= 50.
recognition_reportI(Loc, Type) :>
        dispatcher(d)
        messageA(d, Me, report_emergency(Loc, Type)).

%%% battery management
battery_lowE :>
        go_baseA,
        dispatcher(d)
        messageA(d, Me, im_recharging(Me)),
        assert(pause),
        write("mi sto ricaricando").


===========================
        Dispatcher
===========================
:- dynamic drone/1
:- dynamic active/1

drone(droneA).
drone(droneB).


% nella fase di avvio il dispatcher fa partire il drone
start.
start_drone_tour :- start
start_drone_tourI :> messageA(droneA, Me, activate)

% il drone dopo essersi avviato avvisa il dispatcher che aggiorna la sua KB
im_activeE(Drone) :> assert(active(Drone))

% quando un drone è in ricarica, avvisa il dispatcher che ne manda in ricognizione un altro
switch_to_drone(D2) :- im_rechargingN(D1), drone(D1), drone(D2)
switch_to_drone(D2)I :> retractall(active(_)), messageA(D2, activate)


% se viene segnalata un'emergenza non ben specificata
need_recognition(D, Loc) :- callEmergencyN(Loc, unknown), active(D), drone(D)
need_recognitionI(D, Loc) :> drone(D), messageA(D, Me, ask_recognition(Loc))



%% TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

% callEmergencyE(Loc, fire)
% callEmergencyE(Loc, ambulance)