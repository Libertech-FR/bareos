# Relay SMTP 

## docker-compose.yml
ervices:
  smtp:
    #image: rapidfort/postfix-ib:latest
    build: .
    container_name: smtp
    ports:
      - "25:25"
    environment:
      - POSTFIX_RELAYHOST_PORT=25
      - POSTFIX_RELAYHOST=MONRELAY 
      - POSTFIX_TLS=true
      - POSTFIX_MYNETWORKS=10.0.0.0/8
      - POSTFIX_TLS=true
      - POSTFIX_SASL_AUTH=USERNAME:PASSWORD

## Variables d'environements

* POSTFIX_RELAYHOST_PORT = Port du relay SMTP
* POSTFIX_RELAYHOST = FDQN ou IP du relay SMTP
* POSTFIX_MYNETWORKS = Reseaux autorisés à poster
* POSTFIX_TLS = Connection au relay en TLS
* POSTFIX_SASL_AUTH = Credentials du relay sous la forme username:password 
i¨ 
