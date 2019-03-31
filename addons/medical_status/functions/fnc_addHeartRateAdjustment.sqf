#include "script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Adds a heart rate adjustment that will take effect over time.
 *
 * Arguments:
 * 0: The Unit                                            <OBJECT>
 * 1: Heart rate change                                   <NUMBER>
 * 2: Time in system for the adjustment to reach its peak <NUMBER>
 * 3: Duration the adjustment will have an effect         <NUMVER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 10, 60, 120] call ace_medical_status_fnc_addHeartRateAdjustment
 */

params ["_unit", "_change", "_timeToMaxEffect", "_maxTimeInSystem"];

if (_change == 0) exitWith { WARNING_1("bad value for _change - %1",_this); };
if (_maxTimeInSystem <= 0) exitWith { WARNING_1("bad value for _maxTimeInSystem - %1",_this); };
_timeToMaxEffect = _timeToMaxEffect max 1;

TRACE_4("addHeartRateAdjustment",_unit,_change,_timeToMaxEffect,_maxTimeInSystem);

private _adjustments = _unit getVariable [VAR_HEART_RATE_ADJ,[]];
// The last number indicates the time the adjustment is already in the system
_adjustments pushBack [_change, _timeToMaxEffect, _maxTimeInSystem, 0];
_unit setVariable [VAR_HEART_RATE_ADJ, _adjustments];
