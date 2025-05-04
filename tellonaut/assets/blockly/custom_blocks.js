/* custom_blocks.js – alle Tello-SDK-Befehle als Blockly-Blöcke */
(function(){
  if (!window.Blockly) return;
  const HUE = 210;

  // 1) Einfacher Befehl ohne Parameter
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

  // 2) Einfacher Befehl mit einem Zahlenfeld
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
    Blockly.Python.forBlock[id] = block => {
      const v = block.getFieldValue('VAL') || min;
      return `tello.${cmd}(${v})\n`;
    };
  }

  // 3) Mehrfeld-Blöcke für go / curve / jump
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
    Blockly.Python.forBlock[id] = block => {
      const vals = fields.map(f => block.getFieldValue(f.name) || f.def);
      return fmt(vals) + '\n';
    };
  }

  // ─── Basisbefehle ────────────────────────────────────────────────
  simple('tn_sdk',       'SDK Mode',   'command');
  simple('tn_takeoff',   'Abheben',    'takeoff');
  simple('tn_land',      'Landen',     'land');
  simple('tn_emergency', 'Not-Stopp',  'emergency');
  simple('tn_throwfly',  'Throw-Fly',  'throwfly');
  simple('tn_stop',      'Halt',       'stop');
  simple('tn_flip_f',    'Front-Flip', 'flip f');
  simple('tn_flip_b',    'Back-Flip',  'flip b');
  simple('tn_flip_l',    'Links-Flip','flip l');
  simple('tn_flip_r',    'Rechts-Flip','flip r');

  // ─── Bewegungen ─────────────────────────────────────────────────
  ['up','down','left','right','forward','back']
    .forEach(dir => number(
      `tn_${dir}`,
      dir.charAt(0).toUpperCase() + dir.slice(1),
      'cm', 20, 500,
      dir
    ));
  number('tn_cw',  'Im UZ-Sinn',    '°', 1, 360, 'cw');
  number('tn_ccw', 'Gegen UZ-Sinn', '°', 1, 360, 'ccw');

  // go x y z speed :contentReference[oaicite:0]{index=0}:contentReference[oaicite:1]{index=1}
  multi('tn_go', 'Gehe zu', [
    {name:'X', def:0, min:-500, max:500, unit:'cm'},
    {name:'Y', def:0, min:-500, max:500, unit:'cm'},
    {name:'Z', def:0, min:-500, max:500, unit:'cm'},
    {name:'S', def:10,min:10, max:100, unit:'cm/s'}
  ], vals => `tello.go(${vals.join(',')})`);

  // curve x1 y1 z1 x2 y2 z2 speed :contentReference[oaicite:2]{index=2}:contentReference[oaicite:3]{index=3}
  multi('tn_curve', 'Kurve P1→P2', [
    {name:'X1',def:0,min:-500,max:500,unit:'cm'},
    {name:'Y1',def:0,min:-500,max:500,unit:'cm'},
    {name:'Z1',def:0,min:-500,max:500,unit:'cm'},
    {name:'X2',def:0,min:-500,max:500,unit:'cm'},
    {name:'Y2',def:0,min:-500,max:500,unit:'cm'},
    {name:'Z2',def:0,min:-500,max:500,unit:'cm'},
    {name:'S', def:10,min:10, max:60, unit:'cm/s'}
  ], vals => `tello.curve(${vals.join(',')})`);

  // jump x y z speed yaw mid1 mid2 :contentReference[oaicite:4]{index=4}
  multi('tn_jump', 'Springe zu', [
    {name:'X', def:0,  min:-500, max:500, unit:'cm'},
    {name:'Y', def:0,  min:-500, max:500, unit:'cm'},
    {name:'Z', def:0,  min:0,   max:500, unit:'cm'},
    {name:'S', def:10, min:10,  max:100, unit:'cm/s'},
    {name:'YAW',def:0, min:-360,max:360, unit:'°'},
    {name:'M1',def:0,  min:-2,  max:100,unit:'mid'},
    {name:'M2',def:0,  min:-2,  max:100,unit:'mid'}
  ], vals => `tello.jump(${vals.join(',')})`);

  // ─── Setting-Befehle ────────────────────────────────────────────
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
  ], vals => `tello.rc(${vals.join(',')})`);
  // wifi ssid pass
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
  Blockly.Python.forBlock['tn_wifi'] = blk => {
    const ss = blk.getFieldValue('SSID'), pw = blk.getFieldValue('PASS');
    return `tello.wifi('${ss}','${pw}')\n`;
  };
  number('tn_wifisetchannel','WiFi-Kanal', '', 1,165,'wifisetchannel');

  // ─── Read-Befehle (Status-Abfrage) ───────────────────────────────
  ['battery?','time?','height?','tof?','baro?'].forEach(cmd => {
    Blockly.Blocks['tn_' + cmd.replace('?','q')] = {
      init() {
        this.appendDummyInput().appendField(cmd);
        this.setPreviousStatement(true);
        this.setNextStatement(true);
        this.setColour(HUE);
      }
    };
    Blockly.Python.forBlock['tn_' + cmd.replace('?','q')] = () =>
      `tello.${cmd}\n`;
  });
})();
