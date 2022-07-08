// Lambda function code
const xmpp = require("simple-xmpp");
var user = "no name";

xmpp.on("online", data => {
        console.log("Hey you are online")
        console.log(`Connected as ${data.jid.user}`)
        const date = Date.now();
        const now = new Date(date);
        xmpp.send("lukasz@localhost/example", `hi! ${now.toUTCString()} from ` + user)
        xmpp.send("admin@localhost", `hi! ${now.toUTCString()} from ` + user)
})

xmpp.on("error", error => console.log(`Something went wrong! ${error}`))

xmpp.on("chat", (from, message) => {
        console.log(`Got a message! ${message} from ${from}`)
})

function delay(time) {
  return new Promise(resolve => setTimeout(resolve, time));
}

module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let responseMessage = 'Hello, World!';

  if (event.queryStringParameters && event.queryStringParameters['Name']) {
    responseMessage = 'Hello, ' + event.queryStringParameters['Name'] + '!';
    user = event.queryStringParameters['Name'];
  }

  console.log('load balancer url = ' + process.env.load_balancer_url)

  await xmpp.connect({
            "jid": "lambda@localhost",
            "password": "password",
            "host": process.env.load_balancer_url,
            "port": "5222"
            })

  await delay(1000).then(() => console.log('ran after 1 second'));

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  }
}
