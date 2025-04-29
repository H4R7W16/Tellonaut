/*  custom_blocks.js – 17 Tello-Blöcke (gefixt)  */
(function () {
  if (!window.Blockly) return;
  const HUE = 210;

  /* ---------- Helfer ---------- */
  function simple(id, label, cmd) {
    Blockly.Blocks[id] = {
      init() {
        this.appendDummyInput().appendField(label);
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.setColour(HUE);
      }
    };
    Blockly.Python[id] = () => `${cmd}\n`;
  }

  function number(id, label, unit, min, max, cmd) {
    Blockly.Blocks[id] = {
      init() {
        this.appendDummyInput()
            .appendField(label)
            .appendField(
              new Blockly.FieldNumber(min, min, max, 1), 'VAL')
            .appendField(unit);
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.setColour(HUE);
      }
    };
    Blockly.Python[id] = blk =>
      `${cmd} ${blk.getFieldValue('VAL') || min}\n`;
  }

  /* ---------- einfache Befehle ---------- */
  simple('tn_takeoff',  'Abheben',      'takeoff');
  simple('tn_land',     'Landen',       'land');
  simple('tn_motoron',  'Motorstart',   'motoron');
  simple('tn_motoroff', 'Motor stopp',  'motoroff');
  simple('tn_stop',     'Halt',         'stop');
  simple('tn_flip_f',   'Front-Flip',   'flip f');
  simple('tn_flip_b',   'Back-Flip',    'flip b');
  simple('tn_flip_l',   'Links-Flip',   'flip l');
  simple('tn_flip_r',   'Rechts-Flip',  'flip r');

  /* ---------- Bewegungen (20-500 cm) ---------- */
  ['up','down','forward','back','left','right']
    .forEach(id => number(
        `tn_${id}`,
        id.charAt(0).toUpperCase() + id.slice(1),
        'cm', 20, 500,
        id));

  /* ---------- Rotationen (1-360 °) ---------- */
  number('tn_cw',  'Im UZ-Sinn',    '°', 1, 360, 'cw');
  number('tn_ccw', 'Gegen UZ-Sinn', '°', 1, 360, 'ccw');
})();
