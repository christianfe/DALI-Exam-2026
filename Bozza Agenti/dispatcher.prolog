===========================
	   Drone
===========================


spot_fireE(Loc) :> messageA(dispatcher, send_message(report_emergency(Loc, fire), Me))
spot_accidentE(Loc), -waiting :> messageA(dispatcher, send_message(report_emergency(Loc, ambulance), Me))

% Dispatcher c
ask_recognitionE :> recognitionA
recognition <: 

battery_lowE :> go_baseA, messageA(droneB, send_message(activate, Me)) , assert(pause), rechargeA

activateE :> retract(pause), moveA


===========================
        Dispatcher
===========================

