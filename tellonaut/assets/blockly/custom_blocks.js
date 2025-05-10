/* custom_blocks.js – Tellonaut Drohnen‑Blöcke (erweitert) */
(function(){
  if (!window.Blockly) return;

  // ──────────────────────────────────────────────────────────
  // Farb‑Konstante (einheitliches Blau wie Vorlage)
  // ──────────────────────────────────────────────────────────
  const HUE = 210;

  // ─────────── Helper zum Anlegen von Block‑Typen ───────────
  /** Kommando ohne Parameter */
  function simple(id, label, cmd) {
    Blockly.Blocks[id] = {
      init() {
        this.appendDummyInput().appendField(label);
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.setColour(HUE);
      }
    };
    Blockly.Python.forBlock[id] = () => `tello.${cmd}()\n`;
  }

  /** Kommando mit genau **einem** numerischen Parameter (cm, ° …) */
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
    Blockly.Python.forBlock[id] = blk => {
      const v = blk.getFieldValue('VAL') || min;
      return `tello.${cmd}(${v})\n`;
    };
  }

  /** Kommando mit n numerischen Parametern (Go, Curve, RC …) */
  function multi(id, label, fields, fmt) {
    Blockly.Blocks[id] = {
      init() {
        const inp = this.appendDummyInput().appendField(label);
        fields.forEach(f => {
          inp.appendField(new Blockly.FieldNumber(f.def, f.min, f.max, 1), f.name)
             .appendField(f.unit || '');
        });
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.setColour(HUE);
      }
    };
    Blockly.Python.forBlock[id] = blk => {
      const vals = fields.map(f => blk.getFieldValue(f.name) || f.def);
      return fmt(vals) + '\n';
    };
  }

  /** Sensor‑Getter – gibt Number aus (kein Statement‑Block) */
  function sensor(id, label, cmd) {
    Blockly.Blocks[id] = {
      init() {
        this.appendDummyInput().appendField(label);
        this.setOutput(true, 'Number');
        this.setColour(HUE);
      }
    };
    Blockly.Python.forBlock[id] = () => `tello.${cmd}()\n`;
  }

  /** Drei‑Zahlen‑Block (RGB) */
  function triple(id, label, fields, cmdFmt) {
    Blockly.Blocks[id] = {
      init() {
        const inp = this.appendDummyInput().appendField(label);
        fields.forEach(f => {
          inp.appendField(new Blockly.FieldNumber(f.def, f.min, f.max, 1), f.name);
        });
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.setColour(HUE);
      }
    };
    Blockly.Python.forBlock[id] = blk => {
      const vals = fields.map(f => blk.getFieldValue(f.name) || f.def);
      return cmdFmt(vals) + '\n';
    };
  }

  // ──────────────────────────────────────────────────────────
  // 1) Basis‑Befehle (unverändert aus Vorlage)
  // ──────────────────────────────────────────────────────────
  simple('tn_sdk',       'SDK Mode',   'command');
  simple('tn_takeoff',   'Abheben',    'takeoff');
  simple('tn_land',      'Landen',     'land');
  simple('tn_emergency', 'Not-Stopp',  'emergency');
  simple('tn_throwfly',  'Throw-Fly',  'throwfly');
  simple('tn_stop',      'Halt',       'stop');
  simple('tn_flip_f',    'Front-Flip', 'flip_f');
  simple('tn_flip_b',    'Back-Flip',  'flip_b');
  simple('tn_flip_l',    'Links-Flip', 'flip_l');
  simple('tn_flip_r',    'Rechts-Flip','flip_r');

  // ──────────────────────────────────────────────────────────
  // 2) Bewegung & Stunts (unverändert)
  // ──────────────────────────────────────────────────────────
  ['up','down','left','right','forward','back']
    .forEach(dir => number(`tn_${dir}`, dir.charAt(0).toUpperCase()+dir.slice(1), 'cm', 20, 500, dir));
  number('tn_cw',  'Im UZ-Sinn',    '°', 1, 360, 'cw');
  number('tn_ccw', 'Gegen UZ-Sinn', '°', 1, 360, 'ccw');

  multi('tn_go', 'Gehe zu', [
    {name:'X', def:0, min:-500, max:500, unit:'cm'},
    {name:'Y', def:0, min:-500, max:500, unit:'cm'},
    {name:'Z', def:0, min:-500, max:500, unit:'cm'},
    {name:'S', def:10,min:10, max:100, unit:'cm/s'}
  ], v => `tello.go(${v.join(',')})`);

  multi('tn_curve', 'Kurve P1→P2', [
    {name:'X1',def:0,min:-500,max:500,unit:'cm'},
    {name:'Y1',def:0,min:-500,max:500,unit:'cm'},
    {name:'Z1',def:0,min:-500,max:500,unit:'cm'},
    {name:'X2',def:0,min:-500,max:500,unit:'cm'},
    {name:'Y2',def:0,min:-500,max:500,unit:'cm'},
    {name:'Z2',def:0,min:-500,max:500,unit:'cm'},
    {name:'S', def:10,min:10, max:60, unit:'cm/s'}
  ], v => `tello.curve(${v.join(',')})`);

  multi('tn_jump', 'Springe zu', [
    {name:'X', def:0,  min:-500, max:500, unit:'cm'},
    {name:'Y', def:0,  min:-500, max:500, unit:'cm'},
    {name:'Z', def:0,  min:0,   max:500, unit:'cm'},
    {name:'S', def:10, min:10,  max:100, unit:'cm/s'},
    {name:'YAW',def:0, min:-360,max:360, unit:'°'},
    {name:'M1',def:0,  min:-2,  max:100,unit:'mid'},
    {name:'M2',def:0,  min:-2,  max:100,unit:'mid'}
  ], v => `tello.jump(${v.join(',')})`);

  // ──────────────────────────────────────────────────────────
  // 3) Einstellungen & System (bestehend)
  // ──────────────────────────────────────────────────────────
  number('tn_speed',      'Geschwindigkeit', 'cm/s', 10,100,'speed');
  simple('tn_reboot',     'Reboot',          'reboot');
  simple('tn_mon',        'MissionPad ON',   'mon');
  simple('tn_moff',       'MissionPad OFF',  'moff');
  number('tn_mdirection','Pad-Richtung',    '', 0,2,'mdirection');

  multi('tn_rc','RC-Kanal', [
    {name:'A',def:0, min:-100,max:100,unit:''},
    {name:'B',def:0, min:-100,max:100,unit:''},
    {name:'C',def:0, min:-100,max:100,unit:''},
    {name:'D',def:0, min:-100,max:100,unit:''}
  ], v => `tello.rc(${v.join(',')})`);

  // Wi‑Fi
  Blockly.Blocks['tn_wifi'] = {
    init() {
      this.appendDummyInput()
          .appendField('WiFi SSID')
          .appendField(new Blockly.FieldTextInput('NETZ'), 'SSID')
          .appendField('Passwort')
          .appendField(new Blockly.FieldTextInput('PWD'), 'PASS');
      this.setPreviousStatement(true);
      this.setNextStatement(true);
      this.setColour(HUE);
    }
  };
  Blockly.Python.forBlock['tn_wifi'] = blk => `tello.wifi('${blk.getFieldValue('SSID')}', '${blk.getFieldValue('PASS')}')\n`;
  number('tn_wifisetchannel','WiFi-Kanal', '', 1,165,'wifisetchannel');

  // ──────────────────────────────────────────────────────────
  // 4) Sensoren & Daten (NEU – Output‑Blöcke)
  // ──────────────────────────────────────────────────────────
  sensor('tn_battery_q', 'Batterie (%)', 'battery_q');
  sensor('tn_height_q',  'Höhe (cm)',    'height_q');
  sensor('tn_tof_q',     'TOF (cm)',     'tof_q');
  sensor('tn_pitch_q',   'Pitch (°)',    'pitch_q');
  sensor('tn_roll_q',    'Roll (°)',     'roll_q');
  sensor('tn_yaw_q',     'Yaw (°)',      'yaw_q');

  // ──────────────────────────────────────────────────────────
  // 5) Licht & Matrix (NEU)
  // ──────────────────────────────────────────────────────────
  triple('tn_led_rgb', 'LED RGB', [
    {name:'R', def:255,min:0,max:255},
    {name:'G', def:0,  min:0,max:255},
    {name:'B', def:0,  min:0,max:255}
  ], v => `tello.EXT_led(${v.join(',')})`);

  Blockly.Blocks['tn_matrix_heart'] = {
    init() {
      this.appendDummyInput().appendField('Matrix Herz');
      this.setPreviousStatement(true);
      this.setNextStatement(true);
      this.setColour(HUE);
    }
  };
  Blockly.Python.forBlock['tn_matrix_heart'] = () => 'tello.EXT_mled("heart")\n';

  // ──────────────────────────────────────────────────────────
  // 6) Vision‑Platzhalter (QR / Bild) – TODO
  // ──────────────────────────────────────────────────────────
  simple('tn_vision_qr_on',  'Vision QR ON',  'qr_on');
  simple('tn_vision_qr_off', 'Vision QR OFF', 'qr_off');

})();
