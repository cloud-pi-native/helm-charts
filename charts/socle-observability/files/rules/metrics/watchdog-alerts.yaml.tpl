groups:
  - name: DSO_Watchdog
    rules:
      - alert: Watchdog
        annotations:
          message: Always-firing alert proving that the rules > ruler > Alertmanager > notification chain is alive.
          summary: Watchdog (dead-man switch), must always be firing
        expr: vector(1)
        labels:
          severity: none
          purpose: watchdog
