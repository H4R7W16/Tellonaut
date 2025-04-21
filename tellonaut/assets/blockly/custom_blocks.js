Blockly.Blocks['takeoff'] = {
  init: function() {
    this.appendDummyInput()
        .appendField("takeoff");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(160);
  }
};
Blockly.Python['takeoff'] = function(block) {
  return 'drone.takeoff()\\n';   // später an deine API koppeln
};

Blockly.Blocks['land'] = {
  init: function() {
    this.appendDummyInput()
        .appendField("land");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(160);
  }
};
Blockly.Python['land'] = function(block) {
  return 'drone.land()\\n';
};
