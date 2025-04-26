/* global Blockly */

// ---------- TAKEOFF ----------
Blockly.Blocks['drone_takeoff'] = {
  init: function() {
    this.appendDummyInput()
        .appendField('Starte Drohne');
    this.setPreviousStatement(false);
    this.setNextStatement(false);
    this.setColour(200);
    this.setTooltip('Startet die Drohne (Take-off).');
    this.setHelpUrl('');
  }
};
Blockly.Python['drone_takeoff'] = function(block) {
  return 'takeoff()\n';
};

// ---------- LAND ----------
Blockly.Blocks['drone_land'] = {
  init: function() {
    this.appendDummyInput()
        .appendField('Lande Drohne');
    this.setPreviousStatement(false);
    this.setNextStatement(false);
    this.setColour(200);
    this.setTooltip('Landet die Drohne.');
    this.setHelpUrl('');
  }
};
Blockly.Python['drone_land'] = function(block) {
  return 'land()\n';
};
