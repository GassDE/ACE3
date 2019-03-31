#include "script_component.hpp"
/*
 * Author: Glowbal
 * Update the peripheral resistance
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 * 1: Time since last update <NUMBER>
 * 2: Sync value? <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_unit", "_deltaT", "_syncValue"];

private _peripheralResistanceAdjustment = 0;
private _adjustments = _unit getVariable [VAR_PERIPH_RES_ADJ, []];

if !(_adjustments isEqualTo []) then {
    {
        _x params ["_value", "_timeTillMaxEffect", "_maxTimeInSystem", "_timeInSystem"];
        if (_timeInSystem >= _maxTimeInSystem) then {
             _adjustments set [_forEachIndex, -1];
        } else {
            _timeInSystem = _timeInSystem + _deltaT;
            private _effectRatio = ((_timeInSystem / _timeTillMaxEffect) ^ 2) min 1;
            _peripheralResistanceAdjustment = _peripheralResistanceAdjustment + _value * _effectRatio * (_maxTimeInSystem - _timeInSystem) / _maxTimeInSystem;
            _x set [3, _timeInSystem];
        };
    } forEach _adjustments;

    _unit setVariable [VAR_PERIPH_RES_ADJ, _adjustments - [-1], _syncValue];

     // always sync on last run
    _unit setVariable [VAR_PERIPH_RES, 0 max (DEFAULT_PERIPH_RES + _peripheralResistanceAdjustment), _syncValue || {_adjustments isEqualTo []}];
};
