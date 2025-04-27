/* global Blockly */

// TAKEOFF
Blockly.Blocks['drone_takeoff'] = {
  init: function () {
    this.appendDummyInput().appendField('Starte Drohne');
    this.setColour(200);
    this.setNextStatement(true);
    this.setPreviousStatement(true);
  }
};
Blockly.Python['drone_takeoff'] = () => 'takeoff()\n';

// LAND
Blockly.Blocks['drone_land'] = {
  init: function () {
    this.appendDummyInput().appendField('Lande Drohne');
    this.setColour(200);
    this.setNextStatement(true);
    this.setPreviousStatement(true);
  }
};
Blockly.Python['drone_land'] = () => 'land()\n';
