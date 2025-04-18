#!/usr/bin/env bash
# Script zum Anlegen der Tellonaut‑Projektstruktur

# -------- LIB -----------
mkdir -p lib/{core/{localization,theming,utils},data/drone,domain/drone/{models,value_objects},application/drone,presentation/{widgets,routes,screens},features/{live_control/{ui,domain,data},block_programming/{ui,domain,data}}}

# Hauptdateien mit Header
echo '// entry point – Tellonaut'            > lib/main.dart
echo '// impl. UDP + Video sockets'          > lib/data/drone/udp_client.dart
echo '// impl. Drone repository'             > lib/data/drone/drone_repository_impl.dart
echo '// interface for drone repository'     > lib/domain/drone/drone_repository.dart
echo '// connection state controller'        > lib/application/drone/connection_controller.dart
echo '// joystick input controller'          > lib/application/drone/joystick_controller.dart
echo '// telemetry stream controller'        > lib/application/drone/telemetry_controller.dart

# .gitkeep‑Platzhalter für leere Ordner
find lib -type d -empty -exec touch {}/.gitkeep \;

# -------- ASSETS ---------
mkdir -p assets/{blockly,l10n,images,fonts}
touch assets/blockly/{toolbox_default.xml,custom_blocks.json}

# -------- TEST ----------
mkdir -p test/{unit,integration_test,test_resources}
touch test/.gitkeep test/unit/.gitkeep test/integration_test/.gitkeep test/test_resources/.gitkeep

echo "✅ Ordner‑ und Placeholder‑Dateien für Tellonaut angelegt."
