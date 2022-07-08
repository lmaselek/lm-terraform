#!/bin/sh

rm -rf xmpp-client/node_modules
npm install simple-xmpp
#npm install @xmpp/client
mv node_modules xmpp-client/
rm package-lock.json
