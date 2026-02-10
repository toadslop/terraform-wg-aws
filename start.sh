#!/bin/bash

function genkeys {

  #Generate keys for Peer 1 (P1) which will be considered as the server
  P1_PRIVKEY_DER=$(openssl genpkey -algorithm x25519 -outform der | base64)
  P1_PRIVKEY=$(echo -n "$P1_PRIVKEY_DER" | base64 -d | tail -c 32 | base64)

  P1_PUBKEY_DER=$(base64 -d <<< "${P1_PRIVKEY_DER}" | openssl pkey -inform der -pubout -outform der | base64)  
  P1_PUBKEY=$(echo -n "$P1_PUBKEY_DER" | base64 -d | tail -c 32 | base64)

  #Generate keys for Peer 2 (P2)
  P2_PRIVKEY_DER=$(openssl genpkey -algorithm x25519 -outform der | base64)
  P2_PRIVKEY=$(echo -n "$P2_PRIVKEY_DER" | base64 -d | tail -c 32 | base64)

  P2_PUBKEY_DER=$(base64 -d <<< "${P2_PRIVKEY_DER}" | openssl pkey -inform der -pubout -outform der | base64)  
  P2_PUBKEY=$(echo -n "$P2_PUBKEY_DER" | base64 -d | tail -c 32 | base64)

  #Generate the Pre-Shared key for an extra layer of security
  PSK=$(openssl rand -base64 32)
  
  terraform apply -auto-approve \
    -var="p1_private_key=$P1_PRIVKEY" \
    -var="p1_public_key=$P1_PUBKEY" \
    -var="p2_private_key=$P2_PRIVKEY" \
    -var="p2_public_key=$P2_PUBKEY" \
    -var="wg_ps_key=$PSK"
}

genkeys
