# Sicherheitsrichtlinie

Dieses Repository enthält Docker- und Deployment-Konfigurationen. Es dürfen keine produktiven Zugangsdaten, Tokens, privaten Schlüssel, Zertifikate, Datenbank-Dumps oder Odoo-Laufzeitdaten eingecheckt werden.

## Zulässige Konfigurationsbeispiele

Für dokumentierte Variablen dürfen ausschließlich bereinigte Dateien mit dem Namen `.env.example` verwendet werden. Diese Dateien dürfen nur Platzhalter enthalten, zum Beispiel:

```env
POSTGRES_PASSWORD=CHANGE_ME
ODOO_ADMIN_PASSWORD=CHANGE_ME
```

## Vor jedem Commit prüfen

- keine `.env`- oder `.secrets.env`-Dateien
- keine Passwörter, Tokens oder API-Schlüssel
- keine privaten Schlüssel, Zertifikate oder `acme.json`
- keine Datenbank-Dumps, Backups oder Filestore-Daten
- keine produktiven Hostnamen oder internen IP-Adressen, sofern sie nicht ausdrücklich öffentlich dokumentiert werden sollen

## Falls ein Secret veröffentlicht wurde

1. Secret sofort beim jeweiligen Dienst widerrufen oder ändern.
2. Betroffene Container und Dienste mit den neuen Zugangsdaten aktualisieren.
3. Git-Verlauf prüfen und das Secret bei Bedarf aus der Historie entfernen.
4. Erst danach den bereinigten Stand erneut veröffentlichen.

Ein Löschen der Datei in einem späteren Commit reicht nicht aus, weil das Secret weiterhin in der Git-Historie enthalten sein kann.
