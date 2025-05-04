/* custom_blocks.js – 17 Tello-Blöcke mit richtiger Python-Erzeugung */
(function () {
  if (!window.Blockly) return;
  const HUE = 210;

  // 1) Helfer für Befehle ohne Parameter
  function simple(id, label, cmd) {
    Blockly.Blocks[id] = {
      init() {
        this.appendDummyInput().appendField(label);
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.setColour(HUE);
      }
    };
    // In den Python-Generator eintragen:
    Blockly.Python.forBlock[id] = function(block) {
      return `tello.${cmd}()` + '\\n';
    };
  }

  // 2) Helfer für Befehle mit einem Zahlenfeld (cm oder °)
  function number(id, label, unit, min, max, cmd) {
    Blockly.Blocks[id] = {
      init() {
        this.appendDummyInput()
            .appendField(label)
            .appendField(new Blockly.FieldNumber(min, min, max, 1), 'VAL')
            .appendField(unit);
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.setColour(HUE);
      }
    };
    Blockly.Python.forBlock[id] = function(block) {
      const val = block.getFieldValue('VAL') || min;
      return `tello.${cmd}(${val})` + '\\n';
    };
  }

  /* ---------- einfache Befehle ---------- */
  simple('tn_sdk',     'SDK Mode',   'command');
  simple('tn_takeoff', 'Abheben',    'takeoff');
  simple('tn_land',    'Landen',     'land');
  simple('tn_motoron', 'Motorstart', 'motoron');
  simple('tn_motoroff','Motor stopp','motoroff');
  simple('tn_stop',    'Halt',       'stop');
  simple('tn_flip_f',  'Front-Flip', 'flip f');
  simple('tn_flip_b',  'Back-Flip',  'flip b');
  simple('tn_flip_l',  'Links-Flip', 'flip l');
  simple('tn_flip_r',  'Rechts-Flip','flip r');

  /* ---------- Bewegungen (20 – 500 cm) ---------- */
  ['up','down','forward','back','left','right']
    .forEach(dir =>
      number(
        `tn_${dir}`,
        dir.charAt(0).toUpperCase() + dir.slice(1),
        'cm', 20, 500,
        dir
      )
    );

  /* ---------- Rotationen (1 – 360 °) ---------- */
  number('tn_cw',  'Im UZ-Sinn',    '°', 1, 360, 'cw');
  number('tn_ccw', 'Gegen UZ-Sinn', '°', 1, 360, 'ccw');
})();
